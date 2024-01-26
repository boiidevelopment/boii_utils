--- This script manages server-side of the reputa skillstion system.
-- @script server/skills.lua

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

--- Calculates required experience points for the next level.
-- @param current_level The current level of the skill.
-- @param first_level_xp The experience points required for the first level.
-- @param growth_factor The growth factor for experience points.
-- @return The required experience points for the next level.
local function calculate_required_xp(current_level, first_level_xp, growth_factor)
    return math.floor(first_level_xp * (growth_factor ^ (current_level - 1)))
end

--- Inserts a new skill entry for a player if it doesn't already exist.
-- @param _src The player identifier.
-- @param skill_name The name of the skill.
-- @param skill_data The data for the new skill.
local function insert_new_skill(_src, skill_name, skill_data)
    local columns, values, params = utils.fw.get_insert_params(_src, 'skills', skill_name, skill_data)
    local query = string.format('INSERT IGNORE INTO %s (%s) VALUES (%s)', config.skills.sql.table_name, table.concat(columns, ", "), values)
    MySQL.insert(query, params)
end

--- @section Local functions

--- Fetches skill data for a specific skill.
-- @param _src The player identifier.
-- @param skill_name The name of the skill.
-- @return Skill data for the specified skill if it exists, nil otherwise.
-- @usage utils.skills.get_skill(player_source, skill_name)
local function get_skill(_src, skill_name)
    debug_log("info", "Fetching XP for skill: " .. skill_name .. " for player: " .. _src)
    local query_part, params = utils.fw.get_id_params(_src)
    local query = string.format('SELECT skills FROM %s WHERE %s', config.skills.sql.table_name, query_part)
    local response = MySQL.query.await(query, params)
    if response then
        debug_log("info", "Fetched skill data: " .. response)
        for i = 1, #response do
            local row = response[i]
            local skill_data = json.decode(row.skills)
            if skill_data and skill_data[skill_name] then
                return skill_data[skill_name]
            end
        end
    else
        debug_log("warn", "Skill data not found for player: " .. _src)
    end
    return nil
end

--- Fetches all skills for a player.
-- @param _src The player identifier.
-- @return All skill data for the player if it exists, an empty table otherwise.
-- @usage utils.skills.get_all_skills(player_source)
local function get_all_skills(_src)
    debug_log("info", "Fetching all skills for player: " .. _src)
    local query_part, params = utils.fw.get_id_params(_src)
    debug_log("debug", "Generated query part: " .. query_part .. " with params: " .. table.concat(params, ", "))
    local query = string.format('SELECT * FROM %s WHERE %s', config.skills.sql.table_name, query_part)
    local response = MySQL.query.await(query, params)
    if response and #response > 0 then
        debug_log("debug", "Skills data fetched from DB: " .. response[1].skills)
        return json.decode(response[1].skills)
    end
    debug_log("warn", "No skills data found in DB for player: " .. _src)
    return {}
end

--- Modifies a specific skill's experience points for a player.
-- @param _src The player identifier.
-- @param skill_name The name of the skill to modify.
-- @param value The value to modify the skill by.
-- @param operation The operation to perform (add, remove, set).
-- @return true if the modification was successful, false otherwise.
-- @usage utils.skills.modify_skill(player_source, skill_name, xp_value, operation)
local function modify_skill(_src, skill_name, value, operation)
    debug_log("info", "Modifying skill: " .. skill_name .. " for player: " .. _src .. " with operation: " .. operation .. " and value: " .. value)
    local all_skill_data = get_all_skills(_src)
    if not all_skill_data then 
        debug_log("err", "Error: Could not fetch current skills data for player")
        return false
    end
    if not all_skill_data[skill_name] then
        debug_log("debug", "Skill data not found for: " .. skill_name .. ". Initializing default values...")
        local default_skill_data = {
            level = config.skills.list[skill_name].level,
            current_xp = config.skills.list[skill_name].start_xp,
            required_xp = calculate_required_xp(config.skills.list[skill_name].level, config.skills.list[skill_name].first_level_xp, config.skills.list[skill_name].growth_factor),
            first_level_xp = config.skills.list[skill_name].first_level_xp,
            growth_factor = config.skills.list[skill_name].growth_factor,
            max_level = config.skills.list[skill_name].max_level
        }
        debug_log("debug", "Initialized default values for " .. skill_name .. ": " .. json.encode(default_skill_data))
        insert_new_skill(_src, skill_name, default_skill_data)
        all_skill_data[skill_name] = default_skill_data
    end
    if operation == "add" then
        all_skill_data[skill_name].current_xp = math.floor(all_skill_data[skill_name].current_xp + value)
    elseif operation == "remove" then
        all_skill_data[skill_name].current_xp = math.floor(all_skill_data[skill_name].current_xp - value)
    elseif operation == "set" then
        all_skill_data[skill_name].current_xp = math.floor(value)
    else
        debug_log("info", "Invalid operation for", skill_name, ":", operation)
        return false
    end
    local required_xp = calculate_required_xp(all_skill_data[skill_name].level, all_skill_data[skill_name].first_level_xp, all_skill_data[skill_name].growth_factor)
    while all_skill_data[skill_name].current_xp >= required_xp and all_skill_data[skill_name].level < all_skill_data[skill_name].max_level do
        all_skill_data[skill_name].level = all_skill_data[skill_name].level + 1
        all_skill_data[skill_name].current_xp = math.floor(all_skill_data[skill_name].current_xp - required_xp)
        required_xp = calculate_required_xp(all_skill_data[skill_name].level, all_skill_data[skill_name].first_level_xp, all_skill_data[skill_name].growth_factor)
        debug_log("info", string.format("Player %d leveled up in skill %s to level %d!", _src, skill_name, all_skill_data[skill_name].level))
    end
    while all_skill_data[skill_name].current_xp < 0 and all_skill_data[skill_name].level > 1 do
        all_skill_data[skill_name].level = all_skill_data[skill_name].level - 1
        local required_xp_prev = calculate_required_xp(all_skill_data[skill_name].level, all_skill_data[skill_name].first_level_xp, all_skill_data[skill_name].growth_factor)
        all_skill_data[skill_name].current_xp = math.floor(required_xp_prev + all_skill_data[skill_name].current_xp)
        debug_log("info", string.format("Player %d leveled down in skill %s to level %d!", _src, skill_name, all_skill_data[skill_name].level))
    end    
    all_skill_data[skill_name].required_xp = calculate_required_xp(all_skill_data[skill_name].level, all_skill_data[skill_name].first_level_xp, all_skill_data[skill_name].growth_factor)
    local query_part, params = utils.fw.get_id_params(_src)
    local updated_params = { json.encode(all_skill_data) }
    for _, v in ipairs(params) do
        updated_params[#updated_params + 1] = v
    end
    local query = string.format('UPDATE %s SET skills = ? WHERE %s', config.skills.sql.table_name, query_part)
    debug_log("info", "Executing SQL query: '" .. query .. "' with parameters: '" .. table.concat(updated_params, ", "))
    local affected = MySQL.Sync.execute(query, updated_params)
    if affected > 0 then
        debug_log("info", "Successfully modified skill in DB.")
        return true
    else
        debug_log("err", "Failed to modify skill in DB.")
        return false
    end
end

--- @section Callbacks

--- Fetches all skill data for a specific player.
-- @param _src The player identifier.
-- @param data Data to pass to the callback.
-- @param cb The callback function.
local function fetch_player_skills(_src, data, cb)
    local skills_data = get_all_skills(_src)
    if skills_data then
        cb(skills_data)  -- return skills data to the client
    else
        cb(nil)
    end
end
utils.callback.register('boii_utils:sv:get_skills', fetch_player_skills)

--- @section Assign local functions

utils.skills = utils.skills or {}

utils.skills.calculate_required_xp = calculate_required_xp
utils.skills.get_skill = get_skill
utils.skills.get_all_skills = get_all_skills
utils.skills.modify_skill = modify_skill

--- @section Testing

-- Command to Modify a Skill's XP for a Target Player
RegisterCommand("testmodifyskill", function(source, args, rawCommand)
    if #args < 4 then
        debug_log("warn", "Usage: /testmodifyskill <target_player> <skill_name> <add/remove/set> <value>")
        return
    end
    local target = tonumber(args[1])
    if not target then
        debug_log("warn", "Invalid target player ID.")
        return
    end
    local skill_name = args[2]
    local operation = args[3]
    local value = tonumber(args[4])
    if not value then
        debug_log("warn", "Invalid XP value.")
        return
    end
    if operation ~= "add" and operation ~= "remove" and operation ~= "set" then
        debug_log("info", "Invalid operation. Use 'add', 'remove', or 'set'.")
        return
    end
    local success = modify_skill(target, skill_name, value, operation)
    if success then
        debug_log("info", string.format("Skill %s modified successfully for player %d!", skill_name, target))
    else
        debug_log("err", "Failed to modify skill.")
    end
end, false)