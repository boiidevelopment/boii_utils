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
-- @script client/licenses.lua

--- @section Internal Functions

--- Logs messages for debugging purposes, specifically for the licenses section.
-- @function debug_log
-- @param type string: The type of log ('info', 'err', etc.)
-- @param message string: The message to log.
-- @usage debug_log("info", "Licenses data fetched.")
local function debug_log(type, message)
    if config.debug.licences and utils.debug[type] then
        utils.debug[type](message)
    end
end

--- @section Local Functions

--- Fetches all license data for the player client-side and logs the response.
-- @function get_licences
-- @usage utils.licences.get_licences()
local function get_licences()
    utils.callback.cb('boii_utils:sv:get_licences', {}, function(licences_data)
        if licences_data then
            debug_log("info", "Licenses data fetched: ".. json.encode(licences_data))
        else
            debug_log("err", "Failed to fetch licences data.")
        end
    end)
end

--- Updates a specific license status client-side and logs the outcome.
-- @function update_licence
-- @param licence_id string: The identifier of the licence.
-- @param test_type string: The type of test within the licence ('theory', 'practical').
-- @param passed boolean: The status to set for the specified test within the licence.
-- @usage utils.licences.update_licence('driving', 'theory', true)
local function update_licence(licence_id, test_type, passed)
    utils.callback.cb('boii_utils:sv:update_licence', {licence_id = licence_id, test_type = test_type, passed = passed}, function(response)
        if response.success then
            debug_log("info", "License status updated successfully.")
        else
            debug_log("err", "Failed to update licence status.")
        end
    end)
end

--- Checks if a player has passed a specific part of the licence test and returns the result via a callback.
-- @function check_licence
-- @param licence_id string: The identifier of the licence.
-- @param test_type string: The type of test within the licence ('theory', 'practical').
-- @param cb function: A callback function that handles the response.
-- @usage utils.licences.check_licence('driving', 'theory', callback_function)
local function check_licence(licence_id, test_type, cb)
    utils.callback.cb('boii_utils:sv:check_licence_passed', {licence_id = licence_id, test_type = test_type}, function(response)
        if response.passed then
            cb(true)
        else
            cb(false)
        end
    end)
end

--- @section Assigning to utils table

utils.licences = utils.licences or {}

utils.licences.get_licences = get_licences
utils.licences.update = update_licence
utils.licences.check_licence = check_licence

--- @section Testing

--- Test commands for fetching, updating, and checking license data.

-- Fetch all licenses
RegisterCommand('client_get_licences', function()
    get_licences()
end)

-- Update license status
RegisterCommand('client_update_licence', function(source, args, rawCommand)
    if #args < 3 then
        print("Usage: /client_update_licence <licence_id> <theory/practical> <true/false>")
        return
    end
    update_licence(args[1], args[2], args[3] == 'true')
end)

-- Check if a specific license test is passed
RegisterCommand('client_check_licence_passed', function(source, args, rawCommand)
    if #args < 2 then
        print("Usage: /client_check_licence_passed <licence_id> <theory/practical>")
        return
    end
    check_licence(args[1], args[2], function(passed)
        if passed then
            print("Test passed for license: " .. args[1] .. " type: " .. args[2])
        else
            print("Test not passed for license: " .. args[1] .. " type: " .. args[2])
        end
    end)
end)
