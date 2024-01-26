--- This script manages server-side group system interactions.
-- It provides functionalities to check group memberships, fetch groups, and maintain up-to-date group information.
-- @script server/groups.lua

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
-- @param params Table containing group creation parameters like name, type, members, and max_members.
-- @return The name of the group if created successfully, nil otherwise.
-- @usage
--[[ 
    local group_id = utils.groups.create({
        name = 'racing-1',
        type = 'racing',
        members = {1, 2, 3},
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
        members = params.members,
        max_members = max_members
    }
    update_client()
    return params.name
end

--- Function to check if a player is in a specified group.
-- @param params Table containing group name and player_id.
-- @return True if the player is in the group, false otherwise.
-- @usage
--[[ 
    local grouped = utils.groups.in_group({
        name = 'racing-1',
        player_id = 2
    })
    utils.debug.info(tostring(grouped))  --> true or false
]]
local function in_group(params)
    for _, id in ipairs(player_groups[params.name].members) do
        if id == params.player_id then
            return true
        end
    end
    return false
end

--- Function to get data for all groups.
-- @return A deep copy of all group data.
-- @usage local all_groups = utils.groups.get_all_groups()
local function get_all_groups()
    return utils.tables.deep_copy(player_groups)
end

--- Function to get data for a specific group by name.
-- @param name The name of the group to retrieve data for.
-- @return A deep copy of the specific group data.
-- @usage local specific_group = utils.groups.get_group('racing-1')
local function get_group(name)
    return utils.tables.deep_copy(player_groups[name])
end

--- Function to check if a group exists by name.
-- @param name The name of the group to check.
-- @return True if the group exists, false otherwise.
-- @usage local exists = utils.groups.group_exists('racing-1')
local function group_exists(name)
    return player_groups[name] ~= nil
end

--- Function to get names of all groups.
-- @return A list of all group names.
-- @usage local all_names = utils.groups.get_all_group_names()
local function get_all_group_names()
    return utils.tables.get_keys(player_groups)
end

--- Function to get all groups a player is part of.
-- @param player_id The player ID to check groups for.
-- @return A list of group names the player is part of.
-- @usage local player_groups = utils.groups.get_player_groups(player_id)
local function get_player_groups(player_id)
    local groups_for_player = {}
    for name, group_data in pairs(player_groups) do
        for _, id in ipairs(group_data.members) do
            if id == player_id then
                groups_for_player[#groups_for_player + 1] = name
                break
            end
        end
    end
    return groups_for_player
end

--- Function to get all players of a specific group type.
-- @param type The type of group to get players for.
-- @return A table of players in groups of the specified type.
-- @usage local type_players = utils.groups.get_players_of_type('racing')
local function get_players_of_type(type)
    local players = {}
    for _, group_data in pairs(player_groups) do
        if group_data.type == type then
            for _, id in ipairs(group_data.members) do
                players[id] = true
            end
        end
    end
    return players
end

--- Function to add a player to a specified group.
-- @param params Table containing group name and player_id to add.
-- @return True if the player was successfully added, false otherwise.
-- @usage
--[[ 
    utils.groups.add({
        name = 'racing-1',
        player_id = 4
    })
]]
local function add(params)
    if #player_groups[params.name].members >= player_groups[params.name].max_members then
        utils.debug.info("Group has reached its max members limit.")
        return false
    end
    local groups_for_player = get_player_groups(params.player_id)
    if #groups_for_player >= config.groups.max_groups then
        utils.debug.info("Player has reached the max number of groups they can be in.")
        return false
    end
    player_groups[params.name].members[#player_groups[params.name].members + 1] = params.player_id
    update_client()
    return true
end


--- Function to remove a player from a specified group.
-- @param params Table containing group name and player_id to remove.
-- @usage
--[[ 
    utils.groups.remove({
        name = 'racing-1',
        player_id = 3
    })
]]
local function remove(params)
    for i, id in ipairs(player_groups[params.name].members) do
        if id == params.player_id then
            table.remove(player_groups[params.name].members, i)
            update_client()
            break
        end
    end
end

--- @section Events

--- Event to synchronize groups with the client when they join.
-- Sends the group data to the client during the connecting phase.
AddEventHandler('playerConnecting', function(name, reason, deferrals)
    local player = source
    TriggerClientEvent('boii_utils:cl:update_groups', player, utils.tables.deep_copy(player_groups[name]))
end)

--- Event for cleaning up when a player drops.
-- Removes the player from any groups they are a part of.
AddEventHandler('playerDropped', function(reason)
    local player_dropped = source
    local was_in_group = false
    for _, group_data in pairs(player_groups) do
        for i, player in ipairs(group_data.members) do
            if player == player_dropped then
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

--- @section Assign local functions

utils.groups = utils.groups or {}

utils.groups.create = create
utils.groups.add = add
utils.groups.remove = remove
utils.groups.in_group = in_group
utils.groups.get_all_groups = get_all_groups
utils.groups.get_group = get_group
utils.groups.get_player_groups = get_player_groups
utils.groups.get_players_of_type = get_players_of_type
utils.groups.group_exists = group_exists
utils.groups.get_all_group_names = get_all_group_names

--- @section Testing

-- Command to create a group
RegisterCommand("creategroup", function(source, args, rawCommand)
    local group_name = args[1]
    local group_type = args[2]
    if not group_name or not group_type then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255,0,0},
            multiline = true,
            args = {"System", "Please specify a group name and type."}
        })
        return
    end

    local group_id = utils.groups.create({
        name = group_name,
        type = group_type,
        members = {source},
    })
    if group_id then
        TriggerClientEvent('chat:addMessage', source, {
            color = {0,255,0},
            multiline = true,
            args = {"System", "Group " .. group_name .. " of type " .. group_type .. " created successfully."}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255,0,0},
            multiline = true,
            args = {"System", "Failed to create group. It might already exist."}
        })
    end
end, false)

-- Command to add oneself to a group
RegisterCommand("joingroup", function(source, args, rawCommand)
    local group_name = args[1]
    if not group_name then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255,0,0},
            multiline = true,
            args = {"System", "Please specify a group name."}
        })
        return
    end
    local success = utils.groups.add({
        name = group_name,
        player_id = source
    })
    if success then
        TriggerClientEvent('chat:addMessage', source, {
            color = {0,255,0},
            multiline = true,
            args = {"System", "Successfully joined the group: " .. group_name}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255,0,0},
            multiline = true,
            args = {"System", "Failed to join the group. It might be full or you've reached the group limit."}
        })
    end
end, false)

-- Command to remove oneself from a group
RegisterCommand("leavegroup", function(source, args, rawCommand)
    local group_name = args[1]
    if not group_name then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255,0,0},
            multiline = true,
            args = {"System", "Please specify a group name."}
        })
        return
    end

    utils.groups.remove({
        name = group_name,
        player_id = source
    })
    TriggerClientEvent('chat:addMessage', source, {
        color = {0,255,0},
        multiline = true,
        args = {"System", "Successfully left the group: " .. group_name}
    })
end, false)

-- Command to print out all groups
RegisterCommand("allgroups", function(source, args, rawCommand)
    local allGroups = utils.groups.get_all_groups()
    TriggerClientEvent('chat:addMessage', source, {
        color = {255,255,0},
        multiline = true,
        args = {"System", "All existing groups:"}
    })
    for group_name, group_data in pairs(allGroups) do
        TriggerClientEvent('chat:addMessage', source, {
            color = {255,255,255},
            multiline = true,
            args = {"System", group_name .. " (Type: " .. group_data.type .. ", Members: " .. #group_data.members .. ")"}
        })
    end
end, false)
