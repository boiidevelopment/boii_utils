--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|
                              | |
                              |_|
]]

--- Group system.
--- @script server/groups.lua

--- @section Tables

--- Stores player created groups
-- @table player_groups
local player_groups = {}

--- @section Internal helper functions

--- Function to update client side after any group change.
-- Called internally after any change in group data to synchronize with the client.
local function update_client()
    TriggerClientEvent('boii_utils:cl:update_groups', -1, utils.tables.deep_copy(player_groups))
end

--- @section Local functions

--- Function to create a new group.
--- @param params Table containing group creation parameters like name, type, members, and max_members.
--- @return The name of the group if created successfully, nil otherwise.
--- @usage
--[[ 
    local group_id = utils.groups.create({
        name = 'racing-1',
        type = 'racing',
        image = 'https://i.ibb.co/gj2bYmD/logo.png',
        leader = { id = 1, username = TestPlayer, profile_picture = ''}
        members = {
            { id = 4, username = 'Player1', profile_picture = 'assets/images/default_user.jpg' }
        },
        max_members = 5  -- Optional. If not provided, config value is used
    })
    if not group_id then
        utils.debug.err("Group creation failed. Duplicated name.")
    end
]]
local function create(params)
    if player_groups[params.name] then return nil end
    local max_members = params.max_members or config.groups.max_members
    player_groups[params.name] = {
        type = params.type,
        image = params.image or 'https://i.ibb.co/gj2bYmD/logo.png',
        leader = params.leader,
        members = params.members,
        max_members = max_members
    }
    update_client()
    return params.name
end

exports('groups_create', create)
utils.groups.create = create

--- Function to check if a player is in a specified group.
--- @param params Table containing group name and player_id.
--- @return True if the player is in the group, false otherwise.
--- @usage
--[[ 
    local grouped = utils.groups.in_group({
        name = 'racing-1',
        player_id = 2
    })
    utils.debug.info(tostring(grouped))  --> true or false
]]
local function in_group(params)
    local group = player_groups[params.name]
    if not group then return false end
    for _, member in ipairs(group.members) do
        if member.id == params.player_id then
            return true
        end
    end
    if group.leader and group.leader.id == params.player_id then
        return true
    end
    return false
end

exports('groups_in_group', in_group)
utils.groups.in_group = in_group

--- Function to check if a player is a leader of a specified group.
--- @param params Table containing group name and player_id.
--- @return True if the player is the leader of the group, false otherwise.
--- @usage
--[[ 
    local is_leader = utils.groups.is_leader({
        name = 'racing-1',
        player_id = 2
    })
    utils.debug.info(tostring(is_leader))  --> true or false
]]
local function is_leader(params)
    local group = player_groups[params.name]
    if not group then return false end
    if group.leader and group.leader.id == params.player_id then
        return true
    end
    return false
end

exports('groups_is_leader', is_leader)
utils.groups.is_leader = is_leader

--- Function to check if a player is a member of a specified group.
--- @param params Table containing group name and player_id.
--- @return True if the player is a member of the group, false otherwise.
--- @usage
--[[ 
    local is_member = utils.groups.is_member({
        name = 'racing-1',
        player_id = 2
    })
    utils.debug.info(tostring(is_member))  --> true or false
]]
local function is_member(params)
    local group = player_groups[params.name]
    if not group then return false end
    for _, member in ipairs(group.members) do
        if member.id == params.player_id then
            return true
        end
    end
    return false
end

exports('groups_is_member', is_member)
utils.groups.is_member = is_member

--- Function to get data for all groups.
--- @return A deep copy of all group data.
--- @usage local all_groups = utils.groups.get_all_groups()
local function get_all_groups()
    return utils.tables.deep_copy(player_groups)
end

exports('groups_get_all_groups', get_all_groups)
utils.groups.get_all_groups = get_all_groups

--- Function to get data for a specific group by name.
--- @param name The name of the group to retrieve data for.
--- @return A deep copy of the specific group data.
--- @usage local specific_group = utils.groups.get_group('racing-1')
local function get_group(name)
    return utils.tables.deep_copy(player_groups[name])
end

exports('groups_get_group', get_group)
utils.groups.get_group = get_group

--- Function to check if a group exists by name.
--- @param name The name of the group to check.
--- @return True if the group exists, false otherwise.
--- @usage local exists = utils.groups.group_exists('racing-1')
local function group_exists(name)
    return player_groups[name] ~= nil
end

exports('groups_group_exists', group_exists)
utils.groups.group_exists = group_exists

--- Function to get names of all groups.
--- @return A list of all group names.
--- @usage local all_names = utils.groups.get_all_group_names()
local function get_all_group_names()
    return utils.tables.get_keys(player_groups)
end

exports('groups_get_all_group_names', get_all_group_names)
utils.groups.get_all_group_names = get_all_group_names

--- Function to get all groups a player is part of.
--- @param player_id The player ID to check groups for.
--- @return A list of group names the player is part of.
--- @usage local player_groups = utils.groups.get_player_groups(player_id)
local function get_player_groups(player_id)
    local groups_for_player = {}
    for name, group_data in pairs(player_groups) do
        for _, player in ipairs(group_data.members) do
            if player.id == player_id then
                groups_for_player[#groups_for_player + 1] = name
                break
            end
        end
    end
    return groups_for_player
end

exports('groups_get_player_groups', get_player_groups)
utils.groups.get_player_groups = get_player_groups

--- Function to get all players of a specific group type.
--- @param type The type of group to get players for.
--- @return A table of players in groups of the specified type.
--- @usage local type_players = utils.groups.get_players_of_type('racing')
local function get_players_of_type(type)
    local players = {}
    for _, group_data in pairs(player_groups) do
        if group_data.type == type then
            for _, player in ipairs(group_data.members) do
                players[player.id] = true
            end
        end
    end
    return players
end

exports('groups_get_players_of_type', get_players_of_type)
utils.groups.get_players_of_type = get_players_of_type

--- Function to get all groups of a specific type.
--- @param type The type of group to retrieve.
--- @return A table containing all groups of the specified type.
--- @usage
--[[ 
    local type_groups = utils.groups.get_groups_of_type('racing')
    for name, group_data in pairs(type_groups) do
        print(name, group_data.type)
    end
]]
local function get_groups_of_type(type)
    local groups_of_type = {}
    for name, group_data in pairs(player_groups) do
        if group_data.type == type then
            groups_of_type[name] = group_data
        end
    end
    return groups_of_type
end

exports('groups_get_groups_of_type', get_groups_of_type)
utils.groups.get_groups_of_type = get_groups_of_type

--- Function to add a player to a specified group.
--- @param params Table containing group name and player_id to add.
--- @return True if the player was successfully added, false otherwise.
--- @usage
--[[ 
    utils.groups.add({
        name = 'racing-1',
        player_details = { player_id = 4, username = 'Player1', profile_picture = 'assets/images/default_user.jpg' }
    })
]]
local function add(params)
    local player_id = params.player_details.player_id
    local group_name = params.name
    if #player_groups[group_name].members >= player_groups[group_name].max_members then
        utils.debug.info("Group has reached its max members limit.")
        return false
    end
    local player_detail = params.player_details
    player_groups[group_name].members[#player_groups[group_name].members + 1] = player_detail
    update_client()
    return true
end

exports('groups_add', add)
utils.groups.add = add

--- Function to remove a player from a specified group.
--- @param params Table containing group name and player_id to remove.
--- @usage
--[[ 
    utils.groups.remove({
        name = 'racing-1',
        player_id = 3
    })
]]
local function remove(params)
    for i, member in ipairs(player_groups[params.name].members) do
        if member.id == params.player_id then
            table.remove(player_groups[params.name].members, i)
            update_client()
            break
        end
    end
end

exports('groups_remove', remove)
utils.groups.remove = remove

--- Function to close a group and remove all its members.
--- @param group_name The name of the group to close.
local function close_group(group_name)
    if player_groups[group_name] then
        for _, member in ipairs(player_groups[group_name].members) do
            TriggerClientEvent('chat:addMessage', member.id, {
                template = "<div class='msg chat-message warning'><span><i class='fa-solid fa-triangle-exclamation'></i>[WARNING] The group '" .. group_name .. "' has been disbanded.</span></div>",
                args = {}
            })
        end
        player_groups[group_name] = nil
        update_client()
    end
end

exports('groups_close_group', close_group)
utils.groups.close_group = close_group

--- @section Events

--- Event to synchronize groups with the client when they join.
-- Sends the group data to the client during the connecting phase.
AddEventHandler('playerConnecting', function(name, reason, deferrals)
    local player = source
    TriggerClientEvent('boii_utils:cl:update_groups', player, utils.tables.deep_copy(player_groups))
end)

--- Event for cleaning up when a player drops.
-- Removes the player from any groups they are a part of.
AddEventHandler('playerDropped', function(reason)
    local player_dropped = source
    local was_in_group = false
    for _, group_data in pairs(player_groups) do
        for i, player in ipairs(group_data.members) do
            if player.id == player_dropped then
                table.remove(group_data.members, i)
                was_in_group = true
                break
            end
        end
        if was_in_group then break end
    end
    if was_in_group then
        update_client()  -- Update clients if the player was in any group
    end
end)
