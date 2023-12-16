----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    CLIENT GROUP SYSTEM
]]

local client_groups = {}

--[[
    FUNCTIONS
]]

-- Function to check if a player is part of a specified group
-- Usage: local grouped = utils.client.in_group('racing-1')
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

-- Function to fetch all groups the client is a member of
-- Usage: local my_groups = utils.client.get_player_groups()
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

-- Function to check if a group exists on the client side
-- Usage: local exists = utils.client.group_exists('racing-1')
local function group_exists(group_name)
    return client_groups[group_name] ~= nil
end

--[[
    EVENTS
]]

-- Event to update the local 'client_groups' table whenever there's a change in the group data on the server side
RegisterNetEvent('boii_utils:cl:update_groups')
AddEventHandler('boii_utils:cl:update_groups', function(updated_groups)
    client_groups = updated_groups
end)

--[[
    ASSIGN LOCALS
]]

utils.groups = utils.groups or {}

utils.groups.in_group = in_group
utils.groups.get_player_groups = get_player_groups
utils.groups.group_exists = group_exists