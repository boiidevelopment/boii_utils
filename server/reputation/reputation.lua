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

--- Reputation system.
-- @script server/reputation.lua

--- @section Internal helper functions

--- Logs debug messages for the reputation section.
-- This function is used internally for debugging purposes.
-- @function debug_log
-- @param type string: The type of log (e.g., 'info', 'err').
-- @param message string: The message to log.
local function debug_log(type, message)
    if config.debug.reputation and utils.debug[type] then
        utils.debug[type](message)
    end
end

--- Function to calculate required reputation for the next level.
-- @param current_level The current level of reputation.
-- @param first_level_rep The reputation required for the first level.
-- @param growth_factor The growth factor for reputation.
-- @return The required reputation for the next level.
local function calculate_required_rep(current_level, first_level_rep, growth_factor)
    return math.floor(first_level_rep * (growth_factor ^ (current_level - 1)))
end

--- Function to insert a new reputation entry for a player.
-- @param _src The source/player identifier.
-- @param reputation_name The name of the reputation.
-- @param reputation_data The data for the reputation.
local function insert_new_reputation(_src, reputation_name, reputation_data)
    local columns, values, params = utils.fw.get_insert_params(_src, 'reputation', reputation_name, reputation_data)
    local query = string.format('INSERT IGNORE INTO %s (%s) VALUES (%s)', config.reputation.sql.table_name, table.concat(columns, ", "), values)
    MySQL.insert(query, params)
end

--- @section Local functions

--- Function to get reputation data for a specific reputation.
-- @param _src The source/player identifier.
-- @param reputation_name The name of the reputation to fetch data for.
-- @return Reputation data for the specified reputation if exists, nil otherwise.
-- @usage utils.reputation.get_reputation(player_source, reputation_name)
local function get_reputation(_src, reputation_name)
    debug_log("info", "Fetching rep for reputation: " .. reputation_name .. " for player: " .. _src)
    local query_part, params = utils.fw.get_id_params(_src)
    local query = string.format('SELECT reputation FROM %s WHERE %s', config.reputation.sql.table_name, query_part)
    local response = MySQL.query.await(query, params)
    if response then
        debug_log("info", "Fetched reputation data: " .. response)
        for i = 1, #response do
            local row = response[i]
            local reputation_data = json.decode(row.reputation) -- Adjust the column name
            if reputation_data and reputation_data[reputation_name] then
                return reputation_data[reputation_name]
            end
        end
    else
        debug_log("warn", "Reputation data not found for player: " .. _src)
    end
    return nil
end

--- Function to get all player reputation.
-- @param _src The source/player identifier.
-- @return All reputation data for the player if exists, empty table otherwise.
-- @usage utils.reputation.get_all_reputations(player_source)
local function get_all_reputations(_src)
    debug_log("info", "Fetching all reputation for player: " .. _src)
    local query_part, params = utils.fw.get_id_params(_src)
    debug_log("debug", "Generated query part: " .. query_part .. " with params: " .. table.concat(params, ", "))
    local query = string.format('SELECT * FROM %s WHERE %s', config.reputation.sql.table_name, query_part)
    local response = MySQL.query.await(query, params)
    if response and #response > 0 then
        debug_log("debug", "Reputations data fetched from DB: " .. response[1].reputation)
        return json.decode(response[1].reputation)
    end
    debug_log("warn", "No reputation data found in DB for player: " .. _src)
    return {}
end

--- Function to modify a specific reputation for a player.
-- @param _src The source/player identifier.
-- @param reputation_name The name of the reputation to modify.
-- @param value The value to modify the reputation by.
-- @param operation The operation to perform (add, remove, set).
-- @return true if modification succeeded, false otherwise.
-- @usage utils.reputation.modify_reputation(player_source, reputation_name, rep_value, operation)
local function modify_reputation(_src, reputation_name, value, operation)
    debug_log("info", "Modifying reputation: " .. reputation_name .. " for player: " .. _src .. " with operation: " .. operation .. " and value: " .. value)
    local all_reputation_data = get_all_reputations(_src)
    if not all_reputation_data then 
        debug_log("err", "Error: Could not fetch current reputation data for player")
        return false
    end
    if not all_reputation_data[reputation_name] then
        debug_log("debug", "reputation data not found for: " .. reputation_name .. ". Initializing default values...")
        local default_reputation_data = {
            level = config.reputation.list[reputation_name].level,
            current_rep = config.reputation.list[reputation_name].start_rep,
            required_rep = calculate_required_rep(config.reputation.list[reputation_name].level, config.reputation.list[reputation_name].first_level_rep, config.reputation.list[reputation_name].growth_factor),
            first_level_rep = config.reputation.list[reputation_name].first_level_rep,
            growth_factor = config.reputation.list[reputation_name].growth_factor,
            max_level = config.reputation.list[reputation_name].max_level
        }
        debug_log("debug", "Initialized default values for " .. reputation_name .. ": " .. json.encode(default_reputation_data))
        insert_new_reputation(_src, reputation_name, default_reputation_data)
        all_reputation_data[reputation_name] = default_reputation_data
    end
    if operation == "add" then
        all_reputation_data[reputation_name].current_rep = math.floor(all_reputation_data[reputation_name].current_rep + value)
    elseif operation == "remove" then
        all_reputation_data[reputation_name].current_rep = math.floor(all_reputation_data[reputation_name].current_rep - value)
    elseif operation == "set" then
        all_reputation_data[reputation_name].current_rep = math.floor(value)
    else
        debug_log("info", "Invalid operation for", reputation_name, ":", operation)
        return false
    end
    local required_rep = calculate_required_rep(all_reputation_data[reputation_name].level, all_reputation_data[reputation_name].first_level_rep, all_reputation_data[reputation_name].growth_factor)
    while all_reputation_data[reputation_name].current_rep >= required_rep and all_reputation_data[reputation_name].level < all_reputation_data[reputation_name].max_level do
        all_reputation_data[reputation_name].level = all_reputation_data[reputation_name].level + 1
        all_reputation_data[reputation_name].current_rep = math.floor(all_reputation_data[reputation_name].current_rep - required_rep)
        required_rep = calculate_required_rep(all_reputation_data[reputation_name].level, all_reputation_data[reputation_name].first_level_rep, all_reputation_data[reputation_name].growth_factor)
        debug_log("info", string.format("Player %d leveled up in reputation %s to level %d!", _src, reputation_name, all_reputation_data[reputation_name].level))
    end
    while all_reputation_data[reputation_name].current_rep < 0 and all_reputation_data[reputation_name].level > 1 do
        all_reputation_data[reputation_name].level = all_reputation_data[reputation_name].level - 1
        local required_rep_prev = calculate_required_rep(all_reputation_data[reputation_name].level, all_reputation_data[reputation_name].first_level_rep, all_reputation_data[reputation_name].growth_factor)
        all_reputation_data[reputation_name].current_rep = math.floor(required_rep_prev + all_reputation_data[reputation_name].current_rep)
        debug_log("info", string.format("Player %d leveled down in reputation %s to level %d!", _src, reputation_name, all_reputation_data[reputation_name].level))
    end    
    all_reputation_data[reputation_name].required_rep = calculate_required_rep(all_reputation_data[reputation_name].level, all_reputation_data[reputation_name].first_level_rep, all_reputation_data[reputation_name].growth_factor)
    local query_part, params = utils.fw.get_id_params(_src)
    local updated_params = { json.encode(all_reputation_data) }
    for _, v in ipairs(params) do
        updated_params[#updated_params + 1] = v
    end
    local query = string.format('UPDATE %s SET reputation = ? WHERE %s', config.reputation.sql.table_name, query_part)
    debug_log("info", "Executing SQL query: '" .. query .. "' with parameters: '" .. table.concat(updated_params, ", "))
    local affected = MySQL.Sync.execute(query, updated_params)
    if affected > 0 then
        debug_log("info", "Successfully modified reputation in DB.")
        return true
    else
        debug_log("err", "Failed to modify reputation in DB.")
        return false
    end
end

--- @section Callbacks

--- Function to fetch all reputation data for a specific player.
-- @param _src The source/player identifier.
-- @param data Data to pass to the callback.
-- @param cb The callback function.
local function fetch_player_reputations(_src, data, cb)
    local reputations_data = get_all_reputations(_src)
    if reputations_data then
        cb(reputations_data)
    else
        cb(nil)
    end
end
utils.callback.register('boii_utils:sv:get_reputations', fetch_player_reputations)

--- @section Assign local functions

utils.reputation = utils.reputation or {}

utils.reputation.calculate_required_rep = calculate_required_rep
utils.reputation.get_reputation = get_reputation
utils.reputation.get_all_reputations = get_all_reputations
utils.reputation.modify_reputation = modify_reputation


--- @section Testing


RegisterCommand("testmodifyrep", function(source, args, rawCommand)
    if #args < 4 then
        debug_log("warn", "Usage: /testmodifyrep <target_player> <rep_name> <add/remove/set> <value>")
        return
    end
    local target = tonumber(args[1])
    if not target then
        debug_log("warn", "Invalid target player ID.")
        return
    end
    local rep_name = args[2]
    local operation = args[3]
    local value = tonumber(args[4])
    if not value then
        debug_log("warn", "Invalid rep value.")
        return
    end
    if operation ~= "add" and operation ~= "remove" and operation ~= "set" then
        debug_log("info", "Invalid operation. Use 'add', 'remove', or 'set'.")
        return
    end
    local success = modify_reputation(target, rep_name, value, operation)
    if success then
        debug_log("info", string.format("Reputation %s modified successfully for player %d!", rep_name, target))
    else
        debug_log("err", "Failed to modify rep.")
    end
end, false)