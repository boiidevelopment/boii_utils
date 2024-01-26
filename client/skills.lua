--- This script provides utility functions for managing player skills.
-- It includes functions for fetching and retrieving skill-related data on the client side.
-- @script client/skills.lua

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

--- @section Local functions

--- Retrieves the current skill data for the client side.
-- @function get_skills
-- @usage utils.skills.get_skills()
local function get_skills()
    utils.callback.cb('boii_utils:sv:get_skills', {}, function(skills_data)
        if skills_data then
            debug_log("info", "Skills data fetched: ".. json.encode(skills_data))
            return skills_data
        else
            debug_log("err", "Failed to fetch skills data.")
            return nil
        end
    end)
end

--- Retrieves specific data for a given skill from the skill data.
-- @function get_skill
-- @param skill_name string: The identifier of the skill to retrieve data for.
-- @usage utils.skills.get_skill('driving')
local function get_skill(skill_name)
    utils.callback.cb('boii_utils:sv:get_skills', {}, function(skills_data)
        if skills_data and skills_data[skill_name] then
            debug_log("info", "Data for skill " .. skill_name .. ": " .. json.encode(skills_data[skill_name]))
            return skills_data[skill_name]
        else
            debug_log("err", "Failed to fetch data for skill " .. skill_name .. ".")
            return nil
        end
    end)
end

--- @section Assign local functions

utils.skills = utils.skills or {}

utils.skills.get_skills = get_skills
utils.skills.get_skill = get_skill

--- @section Testing

-- Test command to get skill xp
RegisterCommand('client_get_skill', function()
    get_skills()
end)

-- Test command to get specific skill data
RegisterCommand('client_get_specific_skill', function(source, args, rawCommand)
    if #args < 1 then
        print("Usage: /client_get_specific_skill <skill_name>")
        return
    end
    get_skill(args[1])
end)
