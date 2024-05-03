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

--- Licence system.
-- @script server/licenses.lua

--- @section Internal helper functions

--- Function to initialize a player's licenses if they don't exist in the database.
-- @lfunction initialize_licences
-- @param _src The source/player identifier.
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
        local columns, values, insert_params = utils.fw.get_insert_params(_src, 'licences', 'licences', default_licences)
        local insert_query = string.format('INSERT INTO %s (%s) VALUES (%s)', config.licences.sql.table_name, table.concat(columns, ', '), values)
        
        MySQL.insert.await(insert_query, insert_params)
    end
end

--- @section Local functions

--- Function to get a player's license information.
-- @param _src The source/player identifier.
-- @return License data of the player if exists, nil otherwise.
local function get_licences(_src)
    local query_part, params = utils.fw.get_id_params(_src)
    local query = string.format('SELECT licences FROM %s WHERE %s', config.licences.sql.table_name, query_part)
    local response = MySQL.query.await(query, params)
    if response and #response > 0 then
        return json.decode(response[1].licences)
    end
    return nil
end

--- Function to update a player's license status.
-- @param _src The source/player identifier.
-- @param licence_id The identifier of the license.
-- @param test_type The type of test (theory/practical).
-- @param passed Boolean indicating if the test was passed.
local function update_licence(_src, licence_id, test_type, passed)
    local licences = get_licences(_src)
    if licences then
        licences[licence_id][test_type] = passed
        licences[licence_id][test_type..'_date'] = passed and os.date('%Y-%m-%d %H:%M:%S') or nil
        local query_part, params = utils.fw.get_id_params(_src)
        local update_query = string.format('UPDATE %s SET licences = ? WHERE %s', config.licences.sql.table_name, query_part)
        local update_params = { json.encode(licences) }
        for _, param in ipairs(params) do
            update_params[#update_params + 1] = param
        end
        MySQL.update.await(update_query, update_params)
    end
end

--- Function to update a player's license data.
-- @param _src The source/player identifier.
-- @param licence_id The identifier of the license.
-- @param data The data to be updated for the license.
local function update_licence_data(_src, data)
    local licences = get_licences(_src)
    if licences and licences[data.licence_id] then
        licences[data.licence_id].data = data.licence_data
        local query_part, params = utils.fw.get_id_params(_src)
        local update_query = string.format('UPDATE %s SET licences = ? WHERE %s', config.licences.sql.table_name, query_part)
        local update_params = { json.encode(licences) }
        for _, param in ipairs(params) do
            update_params[#update_params + 1] = param
        end
        MySQL.update.await(update_query, update_params)
    end
end

--- Function to check if a player has passed a specific license test.
-- @param _src The source/player identifier.
-- @param licence_id The identifier of the license.
-- @param test_type The type of test (theory/practical).
-- @return Boolean indicating if the test was passed.
local function check_licence_passed(_src, licence_id, test_type)
    local licences = get_licences(_src)
    if licences then
        return licences[licence_id] and licences[licence_id][test_type]
    end
    return false
end

--- @section Callbacks

--- Function to fetch a player's license information via callback.
-- @param _src The source/player identifier.
-- @param data The data to be fetched.
-- @param cb The callback function.
local function fetch_player_licences(_src, data, cb)
    local licences_data = get_licences(_src)
    if licences_data then
        cb(licences_data)
    else
        cb(nil)
    end
end
utils.callback.register('boii_utils:sv:get_licences', fetch_player_licences)

--- Function to update a player's license status via callback.
-- @param _src The source/player identifier.
-- @param data The data to be updated.
-- @param cb The callback function.
local function update_player_licence(_src, data, cb)
    local licence_id = data.licence_id
    local test_type = data.test_type
    local passed = data.passed
    update_licence(_src, licence_id, test_type, passed)
    cb({ success = true })
end
utils.callback.register('boii_utils:sv:update_licence', update_player_licence)

--- Function to check if a player has passed a specific license test via callback.
-- @param _src The source/player identifier.
-- @param data The data to be checked.
-- @param cb The callback function.
local function check_player_licence_passed(_src, data, cb)
    local licence_id = data.licence_id
    local test_type = data.test_type
    local passed = check_licence_passed(_src, licence_id, test_type)
    cb({ passed = passed })
end
utils.callback.register('boii_utils:sv:check_licence_passed', check_player_licence_passed)

--- Function to update a player's license data via callback.
-- @param _src The source/player identifier.
-- @param data The data to be updated.
-- @param cb The callback function.
local function update_player_licence_data(_src, data, cb)
    local licence_id = data.licence_id
    local licence_data = data.licence_data
    update_licence_data(_src, licence_id, licence_data)
    cb({ success = true })
end
utils.callback.register('boii_utils:sv:update_licence_data', update_player_licence_data)

--- @section Assign local functions

utils.licences.initialize = initialize_licences
utils.licences.get = get_licences
utils.licences.update = update_licence
utils.licences.update_data = update_licence_data
utils.licences.check_passed = check_licence_passed