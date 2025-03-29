--- @section Convars

--- Deferals
local deferals_updates_enabled = GetConvar("utils:deferals_updates", "true") == "true"

--- Unique IDs
local unique_id_prefix = GetConvar("utils:unique_id_prefix", "USER_")
local unique_id_digits = tonumber(GetConvar("utils:unique_id_digits", "5"))

--- @section Constants

--- Constants for identifier types.
local IDENTIFIERS = { LICENSE = "license2", DISCORD = "discord", IP = "ip" }

--- @section User Tables

local temp_connected_users = {}
connected_users = {}

--- @section Utility Functions

--- Retrieve player identifiers for the given source.
--- @param source number: The players source identifier.
--- @return table: A table containing the players license, discord, and IP identifiers.
function get_identifiers(source)
    local identifiers = { license = nil, discord = nil, ip = nil }
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.match(id, IDENTIFIERS.LICENSE) then
            identifiers.license = id
        elseif string.match(id, IDENTIFIERS.DISCORD) then
            identifiers.discord = id
        elseif string.match(id, IDENTIFIERS.IP) then
            identifiers.ip = id
        end
    end
    return identifiers
end

--- Generates a unique ID by concatenating a prefix with a randomly generated string of specified length.
--- If a JSON path is provided, it checks within the JSON structure in the specified column.
--- @param prefix A string prefix for the ID (e.g., "CAR", "MOTO").
--- @param length The length of the numeric part of the ID.
--- @param table_name The name of the database table for uniqueness check.
--- @param column_name The name of the database column for uniqueness check.
--- @param json_path (Optional) The JSON path if the ID is within a JSON structure.
--- @return A unique ID string.
function generate_unique_id(prefix, length, table_name, column_name, json_path)
    local charset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local id
    local function create_id()
        local new_id = prefix
        for i = 1, length do
            local random_index = math.random(1, #charset)
            new_id = new_id .. charset:sub(random_index, random_index)
        end
        return new_id
    end
    local function id_exists(new_id)
        local query
        if json_path then
            query = string.format("SELECT COUNT(*) as count FROM %s WHERE JSON_EXTRACT(%s, '$.%s') = ?", table_name, column_name, json_path)
        else
            query = string.format("SELECT COUNT(*) as count FROM %s WHERE %s = ?", table_name, column_name)
        end
        local result = MySQL.query.await(query, { new_id })
        return result and result[1] and result[1].count > 0
    end
    repeat
        id = create_id()
    until not id_exists(id)
    return id
end

--- Check if a players user data exists in the database.
--- @param license string: The players license identifier.
--- @return table|nil: The user data if it exists, or nil if not found.
function check_if_user_data_exists(license)
    local query = "SELECT * FROM utils_users WHERE license = ?"
    return MySQL.query.await(query, { license })
end

--- Create a new user account in the database.
--- @param name string: The players name.
--- @param unique_id string: The generated unique ID for the player.
--- @param license string: The players license identifier.
--- @param discord string|nil: The players Discord identifier.
--- @param tokens table: The players session tokens.
--- @param ip string: The players IP address.
function create_user(name, unique_id, license, discord, tokens, ip)
    local query = "INSERT INTO utils_users (name, unique_id, license, discord, tokens, ip) VALUES (?, ?, ?, ?, ?, ?)"
    MySQL.prepare.await(query, { name, unique_id, license, discord, json.encode(tokens), ip })
end

--- Check if a player is banned and handle the deferral.
--- @param user_data table: The users account data retrieved from the database.
--- @param deferrals table: The deferral object used to communicate with the client.
--- @return boolean: True if the player is banned, false otherwise.
function is_player_banned(user_data, deferrals)
    if user_data.banned then
        deferrals.done(("You are banned. Appeal with your unique ID: %s"):format(user_data.unique_id))
        return true
    end
    return false
end

--- Update the deferral message and optionally wait for a delay.
--- @param deferrals table: The deferral object used to communicate with the client.
--- @param message string: The message to display to the player.
--- @param delay number|nil: Optional delay in milliseconds before proceeding.
local function update_deferral(deferrals, message, delay)
    if deferals_updates_enabled then
        deferrals.update(message)
    end
    if delay then Wait(delay) end
end

--- Retrieves all connected users.
--- @return table: A list of all connected users.
function get_users()
    return connected_users
end

--- Retrieve user data by source ID.
--- @param source number: The players source identifier.
--- @return table|nil: The user data if found, or nil if not.
function get_user(source)
    return connected_users[source] or nil
end

--- @section Event Handlers

--- Handle player connection, validate identifiers, check bans, and create user data if necessary.
--- @param name string: The players name.
--- @param kick function: The function to kick the player.
--- @param deferrals table: The deferral object used to communicate with the client.
local function on_player_connect(name, kick, deferrals)
    local source = source
    local ids = get_identifiers(source)
    if not ids.license then
        kick("No valid license found.")
        return
    end
    local unique_id = generate_unique_id(unique_id_prefix, unique_id_digits, "utils_users", "unique_id")
    deferrals.defer()
    update_deferral(deferrals, "Checking your identifiers...", 100)
    local result = check_if_user_data_exists(ids.license)
    if result[1] then
        update_deferral(deferrals, "User data found. Checking bans...", 500)
        if is_player_banned(result[1], deferrals) then return end
        update_deferral(deferrals, "Welcome back!", 500)
        temp_connected_users[ids.license] = { unique_id = result[1].unique_id, rank = result[1].rank }
    else
        update_deferral(deferrals, "Creating new user...", 500)
        create_user(name, unique_id, ids.license, ids.discord, GetPlayerTokens(source), ids.ip)
        temp_connected_users[ids.license] = { unique_id = unique_id, rank = "member" }
    end
    update_deferral(deferrals, "Welcome to the community!", 500)
    deferrals.done()
end
AddEventHandler("playerConnecting", on_player_connect)

--- Moves player from temp to connected on join.
local function on_player_joining()
    local source = source
    local ids = get_identifiers(source)
    if ids.license and temp_connected_users[ids.license] then
        connected_users[source] = temp_connected_users[ids.license]
        temp_connected_users[ids.license] = nil
    else
        print("No temp data found for license:", ids.license or "UNKNOWN")
    end
end
AddEventHandler("playerJoining", on_player_joining)

--- Handle player disconnection, removing them from all user tables.
local function on_player_drop()
    local source = source
    connected_users[source] = nil
end
AddEventHandler("playerDropped", on_player_drop)

--- @section Exports

exports("get_identifiers", get_identifiers)
exports("generate_unique_id", generate_unique_id)
exports("check_if_user_data_exists", check_if_user_data_exists)
exports("create_user", create_user)
exports("get_users", get_users)
exports("get_user", get_user)