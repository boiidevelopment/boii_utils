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

--- Skills system.
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
            return skills_data
        else
            return nil
        end
    end)
end

--- Retrieves specific data for a given skill from the skill data.
-- @function get_skill
-- @param skill_name string: The identifier of the skill to retrieve data for.
-- @usage utils.skills.get_skill('driving')
local function get_skill(skill_name, cb)
    utils.callback.cb('boii_utils:sv:get_skill', { skill_name = skill_name }, function(skill_data)
        if skill_data then
            cb(skill_data)
        else
            debug_log("err", "Failed to fetch data for skill " .. skill_name .. ".")
            cb(nil)
        end
    end)
end

--- @section Assign local functions

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
