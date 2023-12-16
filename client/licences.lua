----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    LICENSES UTILITIES
]]

-- Internal function to handle debug logging for the licences section
local function debug_log(type, message)
    if config.debug.licences and utils.debugging[type] then
        utils.debugging[type](message)
    end
end

-- Function to get all licence data for the player client side
-- Usage: utils.licences.get_licences()
local function get_licences()
    utils.callback.cb('boii_utils:sv:get_licences', {}, function(licences_data)
        if licences_data then
            debug_log("info", "Licenses data fetched: ".. json.encode(licences_data))
            -- You can now use licences_data to update UI or check status
        else
            debug_log("err", "Failed to fetch licences data.")
            -- Handle the failure case, maybe retry or show an error message
        end
    end)
end

-- Function to update a specific licence status client side
-- Usage: utils.licences.update_licence('driving', 'theory', true)
local function update_licence(licence_id, test_type, passed)
    utils.callback.cb('boii_utils:sv:update_licence', {licence_id = licence_id, test_type = test_type, passed = passed}, function(response)
        if response.success then
            debug_log("info", "License status updated successfully.")
            -- You can now proceed to update UI or notify the user of success
        else
            debug_log("err", "Failed to update licence status.")
            -- Handle the error, maybe allow retrying or show an error message
        end
    end)
end

-- Function to check if a player has passed a specific part of the licence test
-- Usage: utils.licences.check_licence('driving', 'theory')
local function check_licence(licence_id, test_type)
    utils.callback.cb('boii_utils:sv:check_licence', {licence_id = licence_id, test_type = test_type}, function(response)
        if response.passed then
            return true
        else
            return false
        end
    end)
end

--[[
    ASSIGN LOCALS
]]

utils.licences = utils.licences or {}

utils.licences.get_licences = get_licences
utils.licences.update_licence = update_licence
utils.licences.check_licence = check_licence

--[[
    TESTING
]]

-- Test command to get all licences
RegisterCommand('client_get_licences', function()
    get_licences()
end)

-- Test command to update licence status
RegisterCommand('client_update_licence', function(source, args, rawCommand)
    if #args < 3 then
        print("Usage: /client_update_licence <licence_id> <theory/practical> <true/false>")
        return
    end
    update_licence(args[1], args[2], args[3] == 'true')
end)

-- Test command to check if the player passed a specific licence test
RegisterCommand('client_check_licence_passed', function(source, args, rawCommand)
    if #args < 2 then
        print("Usage: /client_check_licence_passed <licence_id> <theory/practical>")
        return
    end
    check_licence(args[1], args[2])
end)
