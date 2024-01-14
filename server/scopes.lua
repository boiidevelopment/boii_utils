----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    SCOPES UTILITIES
]]

local player_scopes = {}

--[[
    FUNCTIONS
]]

-- Get players in the scope of the specified player
-- Usage: local players_in_scope = utils.scope.get_player_scope(source)
local function get_player_scope(_src)
    return player_scopes[_src] or {}
end

-- Trigger an event to all players within the scope of a specified player
-- Usage: utils.scope.trigger_scope_event('EventName', source, arg1, arg2, ...)
local function trigger_scope_event(event_name, scope_owner, ...)
    local targets = player_scopes[scope_owner]
    if targets then
        for target, _ in pairs(targets) do
            TriggerClientEvent(event_name, target, ...)
        end
    end
    TriggerClientEvent(event_name, scope_owner, ...)
end

-- Function to get all players within a certain range of a point or a player
-- If 'include_source' is true, the source player will be included in the list
-- Usage: local players_in_range = utils.scope.get_players_in_range(coords_or_source, range, include_source)
local function get_players_in_range(coords_or_source, range, include_source)
    local players_in_range = {}
    local source_coords
    if type(coords_or_source) == 'number' then
        source_coords = GetEntityCoords(GetPlayerPed(coords_or_source))
    else
        source_coords = coords_or_source
    end
    local players = GetPlayers()
    for _, player_id in ipairs(players) do
        local ped_coords = GetEntityCoords(GetPlayerPed(player_id))
        local distance = #(source_coords - ped_coords)
        if distance <= range then
            if player_id ~= coords_or_source or include_source then
                players_in_range[#players_in_range + 1] = player_id
            end
        end
    end
    return players_in_range
end

--[[
    EVENTS
]]

-- Event handler when a player enters the scope of another player
AddEventHandler('playerEnteredScope', function(data)
    local player_entering, player = data['player'], data['for']
    player_scopes[player] = player_scopes[player] or {}
    player_scopes[player][player_entering] = true
end)

-- Event handler when a player leaves the scope of another player
AddEventHandler('playerLeftScope', function(data)
    local player_leaving, player = data['player'], data['for']
    if player_scopes[player] then
        player_scopes[player][player_leaving] = nil
    end
end)

-- Cleanup when a player drops
AddEventHandler('playerDropped', function()
    local _src = source
    if not _src then return end
    player_scopes[_src] = nil
    for owner, tbl in pairs(player_scopes) do
        if tbl[_src] then
            tbl[_src] = nil
        end
    end
end)

-- Cleanup when the resource stops
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    player_scopes = {}
end)

--[[
    ASSIGN LOCALS
]]

utils.scope = utils.scope or {}

utils.scope.get_player_scope = get_player_scope
utils.scope.trigger_scope_event = trigger_scope_event
utils.scope.get_players_in_range = get_players_in_range
