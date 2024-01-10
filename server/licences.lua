----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    LICENSES UTILITIES
]]

-- Function to initialize a player's licences if they don't exist in the database
local function initialize_licences(_src)
    local player = utils.fw.get_player(_src)
    local query_part, params = utils.fw.get_id_params(_src)
    local query = string.format('SELECT licences FROM %s WHERE %s', config.licences.sql.table_name, query_part)
    local response = MySQL.query.await(query, params)
    if not response or #response == 0 then
        local default_licences = {}
        for licence_id, _ in pairs(config.licences.list) do
            default_licences[licence_id] = { theory = false, practical = false, theory_date = nil, practical_date = nil, data = {} }
        end
        local insert_query = string.format('INSERT INTO %s (unique_id, char_id, licences) VALUES (?, ?, ?)', config.licences.sql.table_name)
        local insert_params = { player.unique_id, player.char_id, json.encode(default_licences) }
        MySQL.insert.await(insert_query, insert_params)
    end
end

-- Function to get a player's licence information
local function get_licences(_src)
    local query_part, params = utils.fw.get_id_params(_src)
    local query = string.format('SELECT licences FROM %s WHERE %s', config.licences.sql.table_name, query_part)
    local response = MySQL.query.await(query, params)
    if response and #response > 0 then
        return json.decode(response[1].licences)
    end
    return nil
end

-- Function to update a player's licence status
local function update_licence(_src, licence_id, test_type, passed)
    local licences = get_licences(_src)
    if licences then
        licences[licence_id][test_type] = passed
        licences[licence_id][test_type..'_date'] = passed and os.date('%Y-%m-%d %H:%M:%S') or nil

        local query_part, params = utils.fw.get_id_params(_src)
        local update_query = string.format('UPDATE %s SET licences = ? WHERE %s', config.licences.sql.table_name, query_part)
        local update_params = { json.encode(licences) }
        for _, param in ipairs(params) do
            table.insert(update_params, param)
        end
        MySQL.update.await(update_query, update_params)
    end
end

-- Function to update a player's licence data
local function update_licence_data(_src, licence_id, data)
    local licences = get_licences(_src)
    if licences and licences[licence_id] then
        licences[licence_id]['data'] = data
        local query_part, params = utils.fw.get_id_params(_src)
        local update_query = string.format('UPDATE %s SET licences = ? WHERE %s', config.licences.sql.table_name, query_part)
        local update_params = { json.encode(licences) }
        for _, param in ipairs(params) do
            update_params[#update_params + 1] = param
        end
        MySQL.update.await(update_query, update_params)
    end
end

-- Function to check if a player has passed a specific licence test
local function check_licence_passed(_src, licence_id, test_type)
    local licences = get_licences(_src)
    if licences then
        return licences[licence_id] and licences[licence_id][test_type]
    end
    return false
end

-- Function to fetch a player's licence information
local function fetch_player_licences(_src, data, cb)
    local licences_data = get_licences(_src)
    if licences_data then
        cb(licences_data)  -- return licence data to the client
    else
        cb(nil)
    end
end
utils.callback.register('boii_utils:sv:get_licences', fetch_player_licences)

-- Function to update a player's licence status via callback
local function update_player_licence(_src, data, cb)
    local licence_id = data.licence_id
    local test_type = data.test_type
    local passed = data.passed
    update_licence(_src, licence_id, test_type, passed)
    cb({ success = true })
end
utils.callback.register('boii_utils:sv:update_licence', update_player_licence)

-- Function to check if a player has passed a specific licence test via callback
local function check_player_licence_passed(_src, data, cb)
    local licence_id = data.licence_id
    local test_type = data.test_type
    local passed = check_licence_passed(_src, licence_id, test_type)
    cb({ passed = passed })  -- return the check result to the client
end
utils.callback.register('boii_utils:sv:check_licence_passed', check_player_licence_passed)

-- Function to update a player's licence data via callback
local function update_player_licence_data(_src, data, cb)
    local licence_id = data.licence_id
    local licence_data = data.licence_data
    update_licence_data(_src, licence_id, licence_data)
    cb({ success = true })
end
utils.callback.register('boii_utils:sv:update_licence_data', update_player_licence_data)

--[[
    ASSIGN LOCALS
]]

-- Assign the callback functions to the utils.licences table
utils.licences = utils.licences or {}

utils.licences.initialize = initialize_licences
utils.licences.get = get_licences
utils.licences.update = update_licence
utils.licences.update_data = update_licence_data
utils.licences.check_passed = check_licence_passed
