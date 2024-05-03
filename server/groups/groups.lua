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
    for _, player in ipairs(player_groups[params.name].members) do
        if player.id == params.player_id then
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
        for _, player in ipairs(group_data.members) do
            if player.id == player_id then
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
            for _, player in ipairs(group_data.members) do
                players[player.id] = true
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
    local player_id = params.player_id
    local group_name = params.name
    if #player_groups[group_name].members >= player_groups[group_name].max_members then
        utils.debug.info("Group has reached its max members limit.")
        return false
    end
    local identity = utils.fw.get_identity(player_id)
    if not identity then
        utils.debug.info("Could not fetch player identity for " .. player_id)
        return false
    end
    local player_detail = {
        id = player_id,
        first_name = identity.first_name,
        last_name = identity.last_name
    }
    player_groups[group_name].members[player_groups[group_name].members + 1] = player_detail
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
    for i, id in ipairs(player_groups[params.name].members.id) do
        if id == params.player_id then
            table.remove(player_groups[params.name].members.id, i)
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

--- @section Assign local functions

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
            template = "<div class='msg chat-message warning'><span><i class='fa-solid fa-triangle-exclamation'></i>[WARNING] Error: You must specify a group name and type.</span></div>",
            args = {}
        })
        return
    end

    -- Fetch the identity of the creator
    local identity = utils.fw.get_identity(source)
    if not identity then
        TriggerClientEvent('chat:addMessage', source, {
            template = "<div class='msg chat-message warning'><span><i class='fa-solid fa-triangle-exclamation'></i>[WARNING] Error: Could not fetch player identity.</span></div>",
            args = {}
        })
        return
    end

    -- Adjusted to include creator as a detailed member
    local creator_detail = {
        id = source, -- or use get_player_id(source) if you need a specific ID format
        first_name = identity.first_name,
        last_name = identity.last_name
    }

    local group_id = utils.groups.create({
        name = group_name,
        type = group_type,
        members = {creator_detail}, -- Pass as a table containing the creator detail
        max_members = 5 -- Or another number / leave out for default
    })

    if group_id then
        TriggerClientEvent('chat:addMessage', source, {
            template = "<div class='msg chat-message success'><span><i class='fa-solid fa-check'></i>[SUCCESS] Group " .. group_name .. " of type " .. group_type .. " created successfully.</span></div>",
            args = {}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            template = "<div class='msg chat-message warning'><span><i class='fa-solid fa-triangle-exclamation'></i>[WARNING] Error: Failed to create group. It may already exist.</span></div>",
            args = {}
        })
    end
end, false)


-- Command to add oneself to a group
RegisterCommand("joingroup", function(source, args, rawCommand)
    local group_name = args[1]
    if not group_name then
        TriggerClientEvent('chat:addMessage', source, {
            template = [[
                <div class="msg chat-message warning">
                    <span><i class="fa-solid fa-triangle-exclamation"></i>[WARNING] Error: Please specify a group name.</span>
                </div>
            ]],
            args = { }
        })
        return
    end
    local success = utils.groups.add({
        name = group_name,
        player_id = source
    })
    if success then
        TriggerClientEvent('chat:addMessage', source, {
            template = [[
                <div class="msg chat-message success">
                    <span><i class="fa-solid fa-check"></i>[SUCCESS] You joined <group_name>{0}</group_name>.</span>
                </div>
            ]],
            args = { group_name }
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            template = [[
                <div class="msg chat-message warning">
                    <span><i class="fa-solid fa-triangle-exclamation"></i>[WARNING] Error: Failed to join the group. It might be full or you've reached the group limit.</span>
                </div>
            ]],
            args = { }
        })
    end
end, false)

-- Command to remove oneself from a group
RegisterCommand("leavegroup", function(source, args, rawCommand)
    local group_name = args[1]
    if not group_name then
        TriggerClientEvent('chat:addMessage', source, {
            template = [[
                <div class="msg chat-message warning">
                    <span><i class="fa-solid fa-triangle-exclamation"></i>[WARNING] Error: Please specify a group name.</span>
                </div>
            ]],
            args = { }
        })
        return
    end

    utils.groups.remove({
        name = group_name,
        player_id = source
    })
    TriggerClientEvent('chat:addMessage', source, {
        template = [[
            <div class="msg chat-message success">
                <span><i class="fa-solid fa-check"></i>[SUCCESS] You left <group_name>{0}</group_name>.</span>
            </div>
        ]],
        args = { group_name }
    })
end, false)

-- Command to print out all groups
RegisterCommand("allgroups", function(source, _args, _raw_command)
    local all_groups = utils.groups.get_all_groups()
    TriggerClientEvent('chat:addMessage', source, {
        template = [[
            <div class="msg chat-message default">
                <span><i class="fa-solid fa-list"></i>[SYSTEM] All existing groups:</span>
            </div>
        ]],
        args = {}
    })
    for group_name, group_data in pairs(all_groups) do
        local member_names = {}
        for _, member in ipairs(group_data.members) do
            member_names[#member_names + 1] = member.first_name .. " " .. member.last_name
        end
        local member_names_str = table.concat(member_names, ", ")
        local member_count = tostring(#group_data.members)
        TriggerClientEvent('chat:addMessage', source, {
            template = [[
                <div class="msg chat-message default">
                    <span><i class="fa-solid fa-users"></i>[GROUP INFO] <strong>{0}</strong>: Type: {1}, Members ({2}): {3}</span>
                </div>
            ]],
            args = { group_name, group_data.type, member_count, member_names_str }
        })
    end
end, false)
