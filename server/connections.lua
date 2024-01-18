----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    PLAYER CONNECTIONS
]]

temp_connected_users = {}
connected_users = {}

--[[
    FUNCTIONS
]]

local function create_users_table()
    utils.debug.info("Creating users table if not exists...")
    local query = [[CREATE TABLE IF NOT EXISTS `user_accounts` (
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
    ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;]]
    MySQL.update(query, {})
end
create_users_table()

-- Function to get all users
local function get_users()
    local users = {}
    for _, user in pairs(connected_users) do
        users[#users+1] = user
    end
    return users
end

-- Function to get user by source
local function get_user(_src)
    return connected_users[_src] or nil
end

-- Function to create a new user
local function create_user(name, unique_id, license, discord, tokens, ip)
    local query = 'INSERT INTO user_accounts (name, unique_id, license, discord, tokens, ip) VALUES (?, ?, ?, ?, ?, ?)'
    local params = {name, unique_id, license, discord, json.encode(tokens), ip}
    return MySQL.prepare.await(query, params)
end

-- Function to check if a user exists by license, tokens or both
local function check_if_user_data_exists(license)
    local query = 'SELECT * FROM user_accounts WHERE license = ?'
    local params = {license}
    return MySQL.query.await(query, params)
end

-- Function to handle player connections
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

-- Function to handle player fully joining
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


-- Function to handle player drops
local function on_player_drop(reason)
    local _src = source
    connected_users[_src] = nil
    temp_connected_users[_src] = nil
end
AddEventHandler('playerDropped', on_player_drop)

--[[
    ASSIGN LOCALS
]]

utils.connections = utils.connections or {}

utils.connections.get_users = get_users
utils.connections.get_user = get_user
