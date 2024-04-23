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

--- @section Tables

--- Stores zones server side for syncing.
local zones = {}

--- @section Local functions

--- Gets all zones
local function get_zones()
    return zones
end

--- Send zones to players.
-- @param _src: Source player.
local function send_zones(_src)
    TriggerClientEvent('boii_utils:cl:update_zones', _src, zones)
end

--- @section Events

--- Adds a new zone to server side table and syncs back to clients.
-- @param id: ID of the new zone.
-- @param zone: Zone options table.
RegisterNetEvent('boii_utils:sv:add_zone', function(id, zone)
    zones[id] = zone
    TriggerClientEvent('boii_utils:cl:update_zones', -1, zones)
end)

--- Removes a zone from server side table and syncs back to clients.
-- @param id: ID of the new zone.
RegisterNetEvent('boii_utils:sv:remove_zone', function(id)
    zones[id] = nil
    TriggerClientEvent('boii_utils:cl:update_zones', -1, zones)
end)

--- Send all zones to a newly connected player
AddEventHandler('playerConnecting', function()
    local _src = source
    send_zones(_src)
end)

--- @section Assign local functions

utils.zones = utils.zones or {}

utils.zones.get_zones = get_zones
