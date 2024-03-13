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

--- Group system.
-- @script client/groups.lua

--- @section Tables

--- @table client_groups: Stores all groups the client is a member of.
local client_groups = {}

--- @section Functions

--- Checks if the player is part of a specified group.
-- @function in_group
-- @param group_name string: The name of the group.
-- @return boolean: True if the player is part of the group, false otherwise.
-- @usage local grouped = utils.client.in_group('racing-1')
local function in_group(group_name)
    for _, group in pairs(client_groups) do
        for _, id in ipairs(group.members) do
            if id == GetPlayerServerId(PlayerId()) then
                return true
            end
        end
    end
    return false
end

--- Fetches all groups the client is a member of.
-- @function get_player_groups
-- @return table: A list of group names the client is a member of.
-- @usage local my_groups = utils.client.get_player_groups()
local function get_player_groups()
    local player_groups = {}
    for group_name, group_data in pairs(client_groups) do
        for _, id in ipairs(group_data.members) do
            if id == GetPlayerServerId(PlayerId()) then
                player_groups[#player_groups + 1] = group_name
            end
        end
    end
    return player_groups
end

--- Checks if a group exists on the client side.
-- @function group_exists
-- @param group_name string: The name of the group.
-- @return boolean: True if the group exists, false otherwise.
-- @usage local exists = utils.client.group_exists('racing-1')
local function group_exists(group_name)
    return client_groups[group_name] ~= nil
end

--- @section Events

--- Updates the local 'client_groups' table whenever there's a change in the group data on the server side.
RegisterNetEvent('boii_utils:cl:update_groups')
AddEventHandler('boii_utils:cl:update_groups', function(updated_groups)
    client_groups = updated_groups
end)

--- @section Assigning local functions

utils.groups = utils.groups or {}

utils.groups.in_group = in_group
utils.groups.get_player_groups = get_player_groups
utils.groups.group_exists = group_exists
