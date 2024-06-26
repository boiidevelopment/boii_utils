--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|
                              | |
                              |_|
]]

--- Player connection functions.
--- @script server/connections.lua

--- @section Queries

local CREATE_TABLE = [[
    CREATE TABLE IF NOT EXISTS `user_accounts` (
        `id` int NOT NULL AUTO_INCREMENT,
        `name` varchar(255) NOT NULL,
        `unique_id` varchar(255) NOT NULL,
        `rank` varchar(255) NOT NULL DEFAULT 'civ',
        `vip` int(1) NOT NULL DEFAULT 0,
        `priority` int(11) NOT NULL DEFAULT 0,
        `character_slots` int(11) NOT NULL DEFAULT 2,
        `license` varchar(255) NOT NULL,
        `discord` varchar(255),
        `tokens` json NOT NULL,
        `ip` varchar(255) NOT NULL,
        `banned` boolean DEFAULT false,
        `banned_by` varchar(255) NOT NULL DEFAULT 'auto_ban',
        `reason` text DEFAULT NULL,
        `created` timestamp NOT NULL DEFAULT current_timestamp(),
        PRIMARY KEY (`unique_id`),
        KEY (`license`),
        KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;
]]

--- @section Tables

--- Temporary table to store connected users before they are fully processed
temp_connected_users = {}

--- Table to store fully connected users
connected_users = {}

--- @section Database tables

--- Creates a new table for user accounts in the database if it doesn't already exist.
local function create_users_table()
    utils.debug.info("Creating users table if not exists...")
    MySQL.update(CREATE_TABLE, {})
end
create_users_table()

--- @section Local functions

--- Gets all users currently connected to the server.
--- @return A table of all connected users.
local function get_users()
    local users = {}
    for _, user in pairs(connected_users) do
        users[#users+1] = user
    end
    return users
end

exports('connections_get_users', get_users)
utils.connections.get_users = get_users

--- Retrieves user data based on the player's server ID.
--- @param _src Server ID of the player.
--- @return The user data if available, nil otherwise.
local function get_user(_src)
    return connected_users[_src] or nil
end

exports('connections_get_user', get_user)
utils.connections.get_user = get_user

--- Creates a new user account in the database.
--- @param Various parameters required for creating a new user (name, unique_id, etc.).
--- @return The result of the database insertion.
local function create_user(name, unique_id, license, discord, tokens, ip)
    local query = 'INSERT INTO user_accounts (name, unique_id, license, discord, tokens, ip) VALUES (?, ?, ?, ?, ?, ?)'
    local params = {name, unique_id, license, discord, json.encode(tokens), ip}
    return MySQL.prepare.await(query, params)
end

exports('connections_create_user', create_user)
utils.connections.create_user = create_user

--- Checks if user data exists for a given license.
--- @param license The player's license to check.
--- @return User data if it exists, empty otherwise.
local function check_if_user_data_exists(license)
    local query = 'SELECT * FROM user_accounts WHERE license = ?'
    local params = {license}
    return MySQL.query.await(query, params)
end

exports('connections_check_if_user_data_exists', check_if_user_data_exists)
utils.connections.check_if_user_data_exists = check_if_user_data_exists

--- Get a player's identifier by source and identifier type.
--- @param _src number: Player's source.
--- @param id_type string: The type of identifier to search for.
--- @return string: The player's identifier or nil if not found.
local function get_identifier(_src, id_type)
    local identifiers = GetPlayerIdentifiers(_src)
    for _, id in pairs(identifiers) do
        if string.find(id, id_type) then
            return id
        end
    end
    return nil
end

exports('connections_get_identifier', get_identifier)
utils.connections.get_identifier = get_identifier

--- Get a player's unique ID by their license.
--- @param license string: The player's license.
--- @return string: The unique ID or nil if not found.
local function get_unique_id(license)
    local query = 'SELECT unique_id FROM user_accounts WHERE license = ?'
    local params = { license }
    local result = MySQL.query.await(query, params)
    if result[1] ~= nil then
        return result[1].unique_id
    end
end

exports('connections_get_unique_id', get_unique_id)
utils.connections.get_unique_id = get_unique_id

--- Handles the process when a player is connecting to the server.
--- This includes identifier checks, user data creation, and ban checks.
--- @param name Player's name.
--- @param kick Function to kick the player.
--- @param deferrals Deferral system for asynchronous handling of the connection process.
local function on_player_connect(name, kick, deferrals)
    local _src = source
    local ids = GetPlayerIdentifiers(_src)
    local tokens = GetPlayerTokens(_src)
    local unique_id = utils.db.generate_unique_id('BOII_', 5, 'user_accounts', 'unique_id')
    deferrals.defer()
    Wait(0)
    deferrals.update(('Hello %s! We are checking your identifiers, please hang tight!'):format(name))
    Wait(100)
    local license, discord, ip = nil, nil, nil
    for k, v in ipairs(ids) do
        if string.match(v, 'license') then
            license = v
        elseif string.match(v, 'discord') then
            discord = v
        elseif string.match(v, 'ip') then
            ip = v
        end
    end
    Wait(2500)
    deferrals.update('Your identifiers have been checked! Checking for existing user data..')
    Wait(2500)
    local result = check_if_user_data_exists(license)
    if result[1] then
        deferrals.update('Your user data has been found, we are now checking if you are banned..')
        if result[1].banned == true then
            deferrals.done(('You are banned.. join our discord and open a ticket with your unique ID to appeal! Unique ID: {%s}'):format(name, result[1].unique_id))
        else
            deferrals.update(('All checks have been completed! Welcome back %s!'):format(name))
            Wait(2500)
            deferrals.done()
            temp_connected_users[_src] = { 
                unique_id = result[1].unique_id,
                rank = result[1].rank
            }
        end
    else
        deferrals.update(('It looks like your user data does not exist! Creating user data..'):format(name))
        Wait(2500)
        create_user(name, unique_id, license, discord, tokens, ip)
        deferrals.update(('User data has been created, welcome to the community %s! Have fun!'):format(name))
        Wait(1500)
        deferrals.done()
        temp_connected_users[_src] = { 
            unique_id = unique_id,
            rank = 'civ' 
        }
    end
end
AddEventHandler('playerConnecting', on_player_connect)

--- Handles the process when a player has fully joined the server.
--- Moves the player from the temporary connected users table to the fully connected users table.
local function on_player_joining()
    local _src = source
    for temp, data in pairs(temp_connected_users) do
        if data.unique_id and data.rank then
            connected_users[_src] = data
            temp_connected_users[temp] = nil
            break
        end
    end
end
AddEventHandler('playerJoining', on_player_joining)

--- Handles the process when a player disconnects from the server.
--- Removes the player from the connected users tables.
--- @param reason The reason for the player's disconnection.
local function on_player_drop(reason)
    local _src = source
    connected_users[_src] = nil
    temp_connected_users[_src] = nil
end
AddEventHandler('playerDropped', on_player_drop)
