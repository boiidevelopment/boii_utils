----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    NETWORKING UTILITIES
]]

local synced_data = {}
local data_callbacks = {}
local max_table_depth = 3
local last_sync_time = 0
local sync_interval = 1000

-- Creates a new synced data table and initializes it as empty if it doesn't exist
-- Usage: utils.networking.create_synced_table("player_data")
local function create_synced_table(table_name)
    if not synced_data[table_name] then
        synced_data[table_name] = {}
    else
        utils.debugging.warn("Table " .. table_name .. " already exists.")
    end
end

-- Registers a callback function to be executed when a specific key's data changes
-- Usage: utils.networking.register_data_callback("player_data", "health", function(old_val, new_val) ... end)
local function register_data_callback(table_name, key, callback)
    data_callbacks[table_name] = data_callbacks[table_name] or {}
    data_callbacks[table_name][key] = callback
end

-- Recursively validate nested tables
-- Usage: (Internal, not directly used outside this module)
-- local max_table_depth = 3 -- Sets the maximum depth
local function validate_table(t, depth)
    if depth > max_table_depth then
        return false
    end
    for k, v in pairs(t) do
        local v_type = type(v)
        if v_type == "table" then
            if not validate_table(v, depth + 1) then
                return false
            end
        elseif v_type ~= "number" and v_type ~= "string" then
            return false
        end
    end
    return true
end

-- Validates the data type and checks nested table depth
-- Usage: (Internal, not directly used outside this module)
local function validate_data(data)
    local data_type = type(data)
    if data_type == "number" or data_type == "string" then
        return true
    elseif data_type == "table" then
        return validate_table(data, 1)
    else
        return false
    end
end

-- Sets a key-value pair in the synced table and triggers a server event
-- Usage: utils.networking.set_synced_data("player_data", "health", 100)
local function set_synced_data(table_name, key, value)
    if GetGameTimer() - last_sync_time < sync_interval then
        utils.debugging.warn("Data sync rate limit reached. Try again later.")
        return
    end
    if synced_data[table_name] then
        if validate_data(value) then
            local old_value = synced_data[table_name][key]
            synced_data[table_name][key] = value

            if data_callbacks[table_name] and data_callbacks[table_name][key] then
                data_callbacks[table_name][key](old_value, value)
            end
            local data_to_send = utils.tables.deep_copy(synced_data[table_name][key])
            if IsDuplicityVersion() then
                TriggerServerEvent('boii_utils:sv:sync_data', table_name, key, data_to_send)
            end
            last_sync_time = GetGameTimer()
        else
            utils.debugging.err("Invalid data provided for table '" .. table_name .. "'.")
        end
    else
        utils.debugging.err("Table '" .. table_name .. "' doesn't exist.")
    end
end

-- Sets multiple key-value pairs in the synced table
-- Usage: utils.networking.set_bulk_synced_data("player_data", {health=100, stamina=80})
local function set_bulk_synced_data(table_name, data)
    for k, v in pairs(data) do
        set_synced_data(table_name, k, v)
    end
end

-- Retrieves a value from the synced table
-- Usage: local health = utils.networking.get_synced_data("player_data", "health", 100)
local function get_synced_data(table_name, key)
    return synced_data[table_name] and synced_data[table_name][key]
end

-- Retrieves multiple values from the synced table based on provided keys
-- Usage: local data = utils.networking.get_bulk_synced_data("player_data", {"health", "stamina"})
local function get_bulk_synced_data(table_name, keys)
    local results = {}
    for _, key in ipairs(keys) do
        results[key] = get_synced_data(table_name, key)
    end
    return results
end

-- Updates local synced data based on server events
-- Usage: (Automatically called upon receiving 'boii_utils:cl:update_synced_data' event)
RegisterNetEvent('boii_utils:cl:update_synced_data')
AddEventHandler('boii_utils:cl:update_synced_data', function(table_name, key, value)
    if synced_data[table_name] then
        synced_data[table_name][key] = value
    else
        utils.debugging.err("Received data for non-existent table '" .. table_name .. "'.")
    end
end)

--[[
    ASSIGN LOCALS
]]

utils.networking = utils.networking or {}

utils.networking.create_synced_table = create_synced_table
utils.networking.set_synced_data = set_synced_data
utils.networking.set_bulk_synced_data = set_bulk_synced_data
utils.networking.get_synced_data = get_synced_data
utils.networking.get_bulk_synced_data = get_bulk_synced_data
utils.networking.register_data_callback = register_data_callback