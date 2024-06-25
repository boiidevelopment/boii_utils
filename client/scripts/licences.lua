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
--- @script client/scripts/licenses.lua

--- @section Local Functions

--- Fetches all license data for the player client-side and logs the response.
--- @function get_licences
--- @usage utils.licences.get_licences()
local function get_licences()
    utils.callback.cb('boii_utils:sv:get_licences', {}, function(licences_data)
        if licences_data then
            debug_log('info', 'Licenses data fetched: '.. json.encode(licences_data))
        else
            debug_log('err', 'Failed to fetch licences data.')
        end
    end)
end

exports('licences_get_licences', get_licences)
utils.licences.get_licences = get_licences

--- Updates a specific license status client-side and logs the outcome.
--- @function update_licence
--- @param licence_id string: The identifier of the licence.
--- @param test_type string: The type of test within the licence ('theory', 'practical').
--- @param passed boolean: The status to set for the specified test within the licence.
--- @usage utils.licences.update_licence('driving', 'theory', true)
local function update_licence(licence_id, test_type, passed)
    utils.callback.cb('boii_utils:sv:update_licence', { licence_id = licence_id, test_type = test_type, passed = passed }, function(response)
        if response.success then
            debug_log('info', 'License status updated successfully.')
        else
            debug_log('err', 'Failed to update licence status.')
        end
    end)
end

exports('licences_update_licence', update_licence)
utils.licences.update = update_licence

--- Checks if a player has passed a specific part of the licence test and returns the result via a callback.
--- @function check_licence
--- @param licence_id string: The identifier of the licence.
--- @param test_type string: The type of test within the licence ('theory', 'practical').
--- @param cb function: A callback function that handles the response.
--- @usage utils.licences.check_licence('driving', 'theory', callback_function)
local function check_licence(licence_id, test_type, cb)
    utils.callback.cb('boii_utils:sv:check_licence_passed', {licence_id = licence_id, test_type = test_type}, function(response)
        if response.passed then
            cb(true)
        else
            cb(false)
        end
    end)
end

exports('licences_check_licence', check_licence)
utils.licences.check_licence = check_licence