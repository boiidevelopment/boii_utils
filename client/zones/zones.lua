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

local zones = {}

--- @section Local functions

--- Gets all zones
local function get_zones()
    return zones
end

--- Draws debug shapes for the zones.
-- @param zone_type string: Type of zone to create debug for. 
-- @param options table: Table of options for the zone.
local function draw_debug(zone_type, options)
    local render_distance = 50.0
    CreateThread(function()
        while options.debug do
            local player_coords = GetEntityCoords(PlayerPedId())
            local distance = #(player_coords - options.coords)
            if distance < render_distance then
                if zone_type == 'circle' then
                    utils.draw.marker({
                        type = 1,
                        coords = vector3(options.coords.x, options.coords.y, options.coords.z - 1.0),
                        dir = vector3(0.0, 0.0, 1.0),
                        rot = vector3(90.0, 0.0, 0.0),
                        scale = vector3(options.radius * 2, options.radius * 2, 1.0),
                        colour = {77, 203, 194, 100},
                        bob = false,
                        face_cam = false,
                        p19 = 2,
                        rotate = false,
                        texture_dict = nil,
                        texture_name = nil,
                        draw_on_ents = false
                    })
                elseif zone_type == 'box' then
                    local dimensions = {
                        width = options.width,
                        length = options.depth,
                        height = options.height
                    }
                    utils.draw.draw_3d_cuboid(options.coords, dimensions, options.heading, {77, 203, 194, 100})
                end
            end
            Wait(0)
        end
    end)
end

--- Adds a circle zone.
-- @param options table: Table of options for the zone.
local function add_circle_zone(options)
    zones = zones or {}
    zones[options.id] = options
    TriggerServerEvent('boii_utils:sv:add_zone', options)
    if options.debug then
        draw_debug('circle', options)
    end
end

--- Adds a circle zone.
-- @param options table: Table of options for the zone.
local function add_box_zone(options)
    zones = zones or {}
    zones[options.id] = options
    TriggerServerEvent('boii_utils:sv:add_zone', options)
    if options.debug then
        draw_debug('box', options)
    end
end

--- Removes a zone.
-- @param id string: The unique identifier for the zone to remove.
local function remove_zone(id)
    zones[id] = nil
end

--- Check if a point is inside a zone.
-- @param point vector3: The point to check.
-- @return boolean: True if the point is inside any zone, false otherwise.
local function is_in_zone(point)
    for id, zone in pairs(zones) do
        if zone.type == 'circle' then
            if #(point - zone.center) <= zone.radius then
                return true
            end
        elseif zone.type == 'box' then
            if utils.geometry.is_point_in_oriented_box(point, zone) then
                return true
            end
        end
    end
    return false
end

--- @section Events

--- Syncs zones.
-- @param updated_zones table: Zones table received from server.
RegisterNetEvent('boii_utils:cl:update_zones', function(updated_zones)
    zones = updated_zones
end)

--- @section Assign local functions

utils.zones.get_zones = get_zones
utils.zones.add_circle = add_circle_zone
utils.zones.add_box = add_box_zone
utils.zones.remove_zone = remove_zone
utils.zones.is_in_zone = is_in_zone


