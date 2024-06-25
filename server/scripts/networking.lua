--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|             DEVELOPER UTILS
]]

--- Networking functions.
-- @script server/scripts/networking.lua

--- @section Tables

--- Stores synced data.
--- @table SYNCED_DATA
local SYNCED_DATA = {}

--- @section Constants

local MAX_TABLE_DEPTH = 3
local LAST_SYNC_TIME = 0
local SYNC_INTERVAL = 1000

--- @section Internal helper functions

--- Validates nested tables recursively up to a maximum depth.
--- @function validate_table
--- @param t The table to validate.
--- @param depth The current depth of recursion.
--- @return true if the table is valid, false otherwise.
local function validate_table(t, depth)
    if depth > MAX_TABLE_DEPTH then
        return false
    end
    for k, v in pairs(t) do
        local v_type = type(v)
        if v_type == 'table' then
            if not validate_table(v, depth + 1) then
                return false
            end
        elseif v_type ~= 'number' and v_type ~= 'string' then
            return false
        end
    end
    return true
end

--- Validates the provided data's type and nested table depth.
--- @function validate_data
--- @param data The data to validate.
--- @return true if the data is valid, false otherwise.
local function validate_data(data)
    local data_type = type(data)
    if data_type == 'number' or data_type == 'string' then
        return true
    elseif data_type == 'table' then
        return validate_table(data, 1)
    else
        return false
    end
end

--- @section Local functions

--- Sets a key-value pair in the synced table and triggers a client event.
--- @function set_synced_data
--- @param table_name The name of the table.
--- @param key The key to set the data for.
--- @param value The value to set.
--- @usage utils.networking.set_synced_data('player_data', 'health', 100)
local function set_synced_data(table_name, key, value)
    if GetGameTimer() - LAST_SYNC_TIME < SYNC_INTERVAL then
        utils.debug.warn('Data sync rate limit reached. Try again later.')
        return
    end
    if SYNCED_DATA[table_name] then
        if validate_data(value) then
            SYNCED_DATA[table_name][key] = value
            TriggerClientEvent('boii_utils2:cl:update_synced_data', -1, table_name, key, value)
            LAST_SYNC_TIME = GetGameTimer()
        else
            utils.debug.err('Invalid data provided for table ' .. table_name .. '.')
        end
    else
        utils.debug.err('Table ' .. table_name .. ' doesnt exist.')
    end
end

exports('networking_set_synced_data', set_synced_data)
utils.networking.set_synced_data = set_synced_data

--- Sets multiple key-value pairs in the synced table.
--- @function set_bulk_synced_data
--- @param table_name The name of the table.
--- @param data The data to set (as a table of key-value pairs).
--- @usage utils.networking.set_bulk_synced_data('player_data', {health=100, stamina=80})
local function set_bulk_synced_data(table_name, data)
    for k, v in pairs(data) do
        set_synced_data(table_name, k, v)
    end
end

exports('networking_set_bulk_synced_data', set_bulk_synced_data)
utils.networking.set_bulk_synced_data = set_bulk_synced_data

--- Retrieves a value from the synced table.
--- @function get_synced_data
--- @param table_name The name of the table.
--- @param key The key to retrieve the data for.
--- @return The value associated with the key, or nil if not found.
--- @usage local health = utils.networking.get_synced_data('player_data', 'health', 100)
local function get_synced_data(table_name, key)
    return SYNCED_DATA[table_name] and SYNCED_DATA[table_name][key]
end

exports('networking_get_synced_data', get_synced_data)
utils.networking.get_synced_data = get_synced_data

--- Retrieves multiple values from the synced table based on provided keys.
--- @function get_bulk_synced_data
--- @param table_name The name of the table.
--- @param keys A table of keys to retrieve data for.
--- @return A table of key-value pairs representing the requested data.
--- @usage local data = utils.networking.get_bulk_synced_data('player_data', {'health', 'stamina'})
local function get_bulk_synced_data(table_name, keys)
    local results = {}
    for _, key in ipairs(keys) do
        results[key] = get_synced_data(table_name, key)
    end
    return results
end

exports('networking_get_bulk_synced_data', get_bulk_synced_data)
utils.networking.get_bulk_synced_data = get_bulk_synced_data

--- @section Events

--- Handles client events to update server synced data.
--- @event boii_utils2:sv:sync_data
--- @param table_name The name of the table.
--- @param key The key that was updated.
--- @param value The new value for the key.
RegisterNetEvent('boii_utils2:sv:sync_data')
AddEventHandler('boii_utils2:sv:sync_data', function(table_name, key, value)
    set_synced_data(table_name, key, value)
end)