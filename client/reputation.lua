--- This script provides utility functions for managing player reputation.
-- It includes functions for obtaining reputation data and specific reputation details.
-- @script client/reputation.lua

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

--- Retrieves all reputation data for the client side.
-- @function get_reputations
-- @return table: A table containing all reputation data.
-- @usage utils.reputation.get_reputations()
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

--- Retrieves specific data for a certain reputation.
-- @function get_reputation
-- @param reputation_name string: The name of the reputation to retrieve data for.
-- @return table: A table containing data for the specified reputation.
-- @usage utils.reputation.get_reputation('example_reputation')
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

--- @section Assign local functions

utils.reputation = utils.reputation or {}

utils.reputation.get_reputations = get_reputations
utils.reputation.get_reputation = get_reputation

--- @section Testing Commands

--- Test command to get reputation
RegisterCommand('client_get_reputation', function()
    get_reputations()
end)

--- Test command to get specific reputation data
RegisterCommand('client_get_specific_reputation', function(source, args, rawCommand)
    if #args < 1 then
        print("Usage: /client_get_specific_reputation <reputation_name>")
        return
    end
    get_reputation(args[1])
end)
