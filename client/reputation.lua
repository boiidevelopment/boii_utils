----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    REPUTATION UTILITIES
]]

-- Internal function to handle debug logging for the reputation section
local function debug_log(type, message)
    if config.debug.reputation and utils.debugging[type] then
        utils.debugging[type](message)
    end
end

-- Function to get the current reputation for the client side
-- Usage:  utils.reputation.get_reputations()
local function get_reputations()
    utils.callback.cb('boii_utils:sv:get_reputations', {}, function(reputation_data)
        if reputation_data then
            debug_log("info", "Reputation data fetched: ".. json.encode(reputation_data))
            return reputation_data
        else
            debug_log("err", "Failed to fetch reputation data.")
            return nil
        end
    end)
end

-- Function to get specific data for a certain reputation
-- Usage:  utils.reputation.get_reputation('example_reputation')
local function get_reputation(reputation_name)
    utils.callback.cb('boii_utils:sv:get_reputations', {}, function(reputation_data)
        if reputation_data and reputation_data[reputation_name] then
            debug_log("info", "Data for reputation " .. reputation_name .. ": " .. json.encode(reputation_data[reputation_name]))
            return reputation_data[reputation_name]
        else
            debug_log("err", "Failed to fetch data for reputation " .. reputation_name .. ".")
            return nil
        end
    end)
end

--[[
    ASSIGN LOCALS
]]

utils.reputation = utils.reputation or {}

utils.reputation.get_reputations = get_reputations
utils.reputation.get_reputation = get_reputation

--[[
    TESTING
]]

-- Test command to get reputation
RegisterCommand('client_get_reputation', function()
    get_reputations()
end)

-- Test command to get specific reputation data
RegisterCommand('client_get_specific_reputation', function(source, args, rawCommand)
    if #args < 1 then
        print("Usage: /client_get_specific_reputation <reputation_name>")
        return
    end
    get_reputation(args[1])
end)
