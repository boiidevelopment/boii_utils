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
--- @script client/scripts/groups.lua

--- @section Tables

--- @table client_groups: Stores all groups the client is a member of.
local client_groups = {}

--- @section Functions

--- Checks if the player is part of a specified group.
--- @function in_group
--- @param group_name string: The name of the group.
--- @return boolean: True if the player is part of the group, false otherwise.
--- @usage local grouped = utils.client.in_group('racing-1')
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

exports('groups_in_group', in_group)
utils.groups.in_group = in_group

--- Fetches all groups the client is a member of.
--- @function get_player_groups
--- @return table: A list of group names the client is a member of.
--- @usage local my_groups = utils.client.get_player_groups()
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

exports('groups_get_player_groups', get_player_groups)
utils.groups.get_player_groups = get_player_groups

--- Checks if a group exists on the client side.
--- @function group_exists
--- @param group_name string: The name of the group.
--- @return boolean: True if the group exists, false otherwise.
--- @usage local exists = utils.client.group_exists('racing-1')
local function group_exists(group_name)
    return client_groups[group_name] ~= nil
end

exports('groups_group_exists', group_exists)
utils.groups.group_exists = group_exists

--- Checks if the player is the leader of a specified group.
--- @function is_leader
--- @param group_name string: The name of the group.
--- @return boolean: True if the player is the leader, false otherwise.
--- @usage local is_lead = utils.client.is_leader('racing-1')
local function is_leader(group_name)
    local group = client_groups[group_name]
    if group and group.leader == GetPlayerServerId(PlayerId()) then
        return true
    end
    return false
end

exports('groups_is_leader', is_leader)
utils.groups.is_leader = is_leader

--- Checks if the player is a member of a specified group.
--- @function is_member
--- @param group_name string: The name of the group.
--- @return boolean: True if the player is a member, false otherwise.
--- @usage local is_mem = utils.client.is_member('racing-1')
local function is_member(group_name)
    local group = client_groups[group_name]
    if group then
        for _, id in ipairs(group.members) do
            if id == GetPlayerServerId(PlayerId()) then
                return true
            end
        end
    end
    return false
end

exports('groups_is_member', is_member)
utils.groups.is_member = is_member

--- Fetches all members of the specified group.
--- @function get_group_members
--- @param group_name string: The name of the group.
--- @return table: A list of member IDs in the specified group.
--- @usage local members = utils.client.get_group_members('racing-1')
local function get_group_members(group_name)
    local group = client_groups[group_name]
    if group then
        return group.members
    end
    return {}
end

exports('groups_get_group_members', get_group_members)
utils.groups.get_group_members = get_group_members

--- Fetches all members of the group the specified player is in.
--- @function get_group_members
--- @param player_id number: The ID of the player.
--- @return table: A list of member IDs in the group the player is in, or an empty table if the player is not in a group.
--- @usage local members = utils.client.get_group_members_by_id(PlayerId())
local function get_group_members_by_id(player_id)
    for group_name, group_data in pairs(client_groups) do
        for _, id in ipairs(group_data.members) do
            if id == player_id then
                return group_data.members
            end
        end
    end
    return {}
end

exports('groups_get_group_members_by_id', get_group_members_by_id)
utils.groups.get_group_members_by_id = get_group_members_by_id

--- @section Events

--- Updates the local 'client_groups' table whenever there's a change in the group data on the server side.
RegisterNetEvent('boii_utils:cl:update_groups')
AddEventHandler('boii_utils:cl:update_groups', function(updated_groups)
    client_groups = updated_groups
end)
