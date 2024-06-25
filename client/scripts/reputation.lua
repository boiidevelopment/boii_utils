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

--- Reputation system.
--- @script client/scripts/reputation.lua

--- @section Local functions

--- Retrieves all reputation data for the client side.
--- @function get_reputations
--- @return table: A table containing all reputation data.
--- @usage utils.reputation.get_reputations()
local function get_reputations()
    utils.callback.cb('boii_utils:sv:get_reputations', {}, function(reputation_data)
        if reputation_data then
            debug_log('info', 'Reputation data fetched: '.. json.encode(reputation_data))
            return reputation_data
        else
            debug_log('err', 'Failed to fetch reputation data.')
            return nil
        end
    end)
end

exports('reputation_get_reputations', get_reputations)
utils.reputation.get_reputations = get_reputations

--- Retrieves specific data for a certain reputation.
--- @function get_reputation
--- @param reputation_name string: The name of the reputation to retrieve data for.
--- @return table: A table containing data for the specified reputation.
--- @usage utils.reputation.get_reputation('example_reputation')
local function get_reputation(reputation_name)
    utils.callback.cb('boii_utils:sv:get_reputations', {}, function(reputation_data)
        if reputation_data and reputation_data[reputation_name] then
            debug_log('info', 'Data for reputation ' .. reputation_name .. ': ' .. json.encode(reputation_data[reputation_name]))
            return reputation_data[reputation_name]
        else
            debug_log('err', 'Failed to fetch data for reputation ' .. reputation_name .. '.')
            return nil
        end
    end)
end

exports('reputation_get_reputation', get_reputation)
utils.reputation.get_reputation = get_reputation