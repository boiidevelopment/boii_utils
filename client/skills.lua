----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    SKILLS UTILITIES
]]

-- Internal function to handle debug logging for the skills section
local function debug_log(type, message)
    if config.debug.skills and utils.debug[type] then
        utils.debug[type](message)
    end
end

-- Function to get the current xp for the skill client side
-- Usage:  utils.skills.get_skills()
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

-- Function to get specific data for a certain skill from the skills data
-- Usage:  utils.skills.get_skill('driving')
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

--[[
    ASSIGN LOCALS
]]

utils.skills = utils.skills or {}

utils.skills.get_skills = get_skills
utils.skills.get_skill = get_skill

--[[
    TESTING
]]

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
