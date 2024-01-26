--- This section is responsible for data conversions required by frameworks for ease of switching to utils systems
-- @script server/conversions.lua

--- @section Internal functions

--- Logs debug messages for the reputation section.
-- This function is used internally for debugging purposes.
-- @lfunction debug_log
-- @param type string: The type of log (e.g., 'info', 'err').
-- @param message string: The message to log.
local function debug_log(type, message)
    if config.debug.reputation and utils.debug[type] then
        utils.debug[type](message)
    end
end

--- Calculates the required XP for the next level based on the current level, first level XP, and growth factor.
-- @lfunction calculate_required_xp
-- @param current_level The current level of the player.
-- @param first_level_xp The amount of XP required for the first level.
-- @param growth_factor The factor by which the required XP increases per level.
-- @return The required XP for the next level.
local function calculate_required_xp(current_level, first_level_xp, growth_factor)
    return math.floor(first_level_xp * (growth_factor ^ (current_level - 1)))
end

--- Updates or inserts data into the specified database table.
-- If data for the specified source and data type exists, it updates it; otherwise, it inserts new data.
-- @lfunction update_or_insert_data
-- @param _src The player's server ID.
-- @param data_type The type of data being handled (e.g., 'skills', 'licences', 'reputation').
-- @param table_name The name of the database table to update or insert data into.
-- @param data The data to update or insert.
-- @return True if the update was successful, false otherwise.
local function update_or_insert_data(_src, data_type, table_name, data)
    local query_part, params = utils.fw.get_id_params(_src)
    local check_query = string.format('SELECT * FROM %s WHERE %s', table_name, query_part)
    local check_result = MySQL.query.await(check_query, params)
    if check_result and #check_result > 0 then
        local update_query = string.format('UPDATE %s SET %s = ? WHERE %s', table_name, data_type, query_part)
        local update_params = { json.encode(data) }
        for _, param in ipairs(params) do
            update_params[#update_params + 1] = param
        end
        local affected = MySQL.Sync.execute(update_query, update_params)
        if affected > 0 then
            debug_log("info", "Successfully ran qb-core metadata conversions and applied updated data.")
            return true
        else
            debug_log("err", "Failed update qb-core metadata conversions.")
            return false
        end
    else
        local columns, values, insert_params = utils.fw.get_insert_params(_src, data_type, data_type, data)
        local insert_query = string.format('INSERT INTO %s (%s) VALUES (%s)', config[data_type].sql.table_name, table.concat(columns, ', '), values)
        MySQL.insert.await(insert_query, insert_params)
    end
end
 
--- @section Conversions

--- Framework specific code block for 'qb-core'
if framework == 'qb-core' then

    --- Converts qb-core metadata for skills, licences, and job reputation into the data format used by the utils systems.
    -- @lfunction convert_qb_metadata
    -- @param _src The player's server ID.
    local function convert_qb_metadata(_src)
        local player = utils.fw.get_player(_src)
        local query_part, params = utils.fw.get_id_params(_src)
        local qb_metadata_query = string.format('SELECT metadata FROM players WHERE %s', query_part)
        local qb_metadata_result = MySQL.query.await(qb_metadata_query, params)
        if not qb_metadata_result or #qb_metadata_result == 0 then
            return
        end
        local qb_metadata = json.decode(qb_metadata_result[1].metadata)
        local player_skill_data = {}
        local player_licence_data = {}
        local player_reputation_data = {}
        for skill_id, skill_config in pairs(config.skills.list) do
            if qb_metadata[skill_id] ~= nil then
                local current_xp = qb_metadata[skill_id]
                local level = 1
                local required_xp = calculate_required_xp(level, skill_config.first_level_xp, skill_config.growth_factor)
                while current_xp >= required_xp and level < skill_config.max_level do
                    current_xp = math.floor(current_xp - required_xp)
                    level = level + 1
                    required_xp = calculate_required_xp(level, skill_config.first_level_xp, skill_config.growth_factor)
                end
                player_skill_data[skill_id] = {
                    level = level,
                    xp = current_xp,
                    required_xp = required_xp,
                    first_level_xp = skill_config.first_level_xp,
                    growth_factor = skill_config.growth_factor,
                    max_level = skill_config.max_level
                }
            else
                player_skill_data[skill_id] = {
                    level = skill_config.level,
                    xp = skill_config.start_xp,
                    required_xp = calculate_required_xp(skill_config.level, skill_config.first_level_xp, skill_config.growth_factor),
                    first_level_xp = skill_config.first_level_xp,
                    growth_factor = skill_config.growth_factor,
                    max_level = skill_config.max_level
                }
            end
            print('co.verted skills: '..json.encode(player_skill_data[skill_id]))
        end
        if qb_metadata['licences'] then
            for licence_id, _ in pairs(config.licences.list) do
                if licence_id == 'car' and qb_metadata['licences']['driver'] ~= nil then
                    local passed = qb_metadata['licences']['driver'] or false
                    if passed then
                        current_date = os.date('%Y-%m-%d %H:%M:%S')
                    end
                    player_licence_data[licence_id] = {
                        theory = passed,
                        practical = passed,
                        theory_date = passed and os.date('%Y-%m-%d %H:%M:%S') or nil,
                        practical_date = passed and os.date('%Y-%m-%d %H:%M:%S') or nil,
                        data = {}
                    }
                elseif licence_id == 'firearms' and qb_metadata['licences']['weapon'] ~= nil then
                    player_licence_data[licence_id] = {
                        theory = qb_metadata['licences']['weapon'],
                        practical = qb_metadata['licences']['weapon'],
                        theory_date = passed and os.date('%Y-%m-%d %H:%M:%S') or nil,
                        practical_date = passed and os.date('%Y-%m-%d %H:%M:%S') or nil,
                        data = {}
                    }
                else
                    player_licence_data[licence_id] = {
                        theory = qb_metadata['licences'][licence_id] or false,
                        practical = qb_metadata['licences'][licence_id] or false,
                        theory_date = passed and os.date('%Y-%m-%d %H:%M:%S') or nil,
                        practical_date = passed and os.date('%Y-%m-%d %H:%M:%S') or nil,
                        data = {}
                    }
                end
            end
        end
        if qb_metadata['jobrep'] then
            for rep_id, rep_config in pairs(config.reputation.list) do
                if qb_metadata['jobrep'][rep_id] ~= nil then
                    local current_rep = qb_metadata['jobrep'][rep_id]
                    local level = 1
                    local required_rep = calculate_required_xp(level, rep_config.first_level_rep, rep_config.growth_factor)
                    while current_rep >= required_rep and level < rep_config.max_level do
                        current_rep = math.floor(current_rep - required_rep)
                        level = level + 1
                        required_rep = calculate_required_xp(level, rep_config.first_level_rep, rep_config.growth_factor)
                    end
                    player_reputation_data[rep_id] = {
                        level = level,
                        current_rep = current_rep,
                        required_rep = required_rep,
                        first_level_rep = rep_config.first_level_rep,
                        growth_factor = rep_config.growth_factor,
                        max_level = rep_config.max_level
                    }
                else
                    player_reputation_data[rep_id] = {
                        level = rep_config.level,
                        current_rep = rep_config.start_rep,
                        required_rep = calculate_required_xp(rep_config.level, rep_config.first_level_rep, rep_config.growth_factor),
                        first_level_rep = rep_config.first_level_rep,
                        growth_factor = rep_config.growth_factor,
                        max_level = rep_config.max_level
                    }
                end
            end
        end
        update_or_insert_data(_src, 'skills', config.skills.sql.table_name, player_skill_data)
        update_or_insert_data(_src, 'licences', config.licences.sql.table_name, player_licence_data)
        update_or_insert_data(_src, 'reputation', config.reputation.sql.table_name, player_reputation_data)
    end

    --- Server event to trigger the conversion of qb-core metadata.
    RegisterServerEvent('boii_utils:sv:run_qb_meta_convert', function()
        local _src = source
        convert_qb_metadata(_src)
    end)
end