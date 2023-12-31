----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    ENTITY UTILITIES
]]

-- Retrieves a list of objects within a specified radius from given coordinates.
-- Usage: local objects = utils.entities.get_nearby_objects({x = 0, y = 0, z = 0}, 10.0)
local function get_nearby_objects(coords, max_distance)
    local objects = GetGamePool('CObject')
    local nearby = {}
    local count = 0
    max_distance = max_distance or 2.0
    for i = 1, #objects do
        local object = objects[i]
        local object_coords = GetEntityCoords(object)
        local distance = #(coords - object_coords)
        if distance < max_distance then
            count = count + 1
            nearby[count] = {
                object = object,
                coords = object_coords
            }
        end
    end
    return nearby
end

-- Retrieves a list of peds within a specified radius from given coordinates, excluding player peds.
-- Usage: local peds = utils.entities.get_nearby_peds({x = 0, y = 0, z = 0}, 10.0)
local function get_nearby_peds(coords, max_distance)
    local peds = GetGamePool('CPed')
    local nearby = {}
    max_distance = max_distance or 2.0
    for i = 1, #peds do
        local ped = peds[i]
        if not IsPedAPlayer(ped) then
            local ped_coords = GetEntityCoords(ped)
            local distance = #(coords - ped_coords)
            if distance < max_distance then
                count = count + 1
                nearby[count] = {
                    ped = ped,
                        coords = ped_coords
                }
            end
        end
    end
    return nearby
end

-- Retrieves a list of players within a specified radius from given coordinates.
-- Usage: local players = utils.entities.get_nearby_players({x = 0, y = 0, z = 0}, 10.0, true)
local function get_nearby_players(coords, max_distance, include_player)
    local players_list = GetActivePlayers()
    local nearby = {}
    max_distance = max_distance or 2.0
    for i = 1, #players_list do
        local player_id = players_list[i]
        if player_id ~= PlayerId() or include_player then
            local player_ped = GetPlayerPed(player_id)
            local player_coords = GetEntityCoords(player_ped)
            local distance = #(coords - player_coords)
            if distance < max_distance then
                count = count + 1
                nearby[count] = {
                    id = player_id,
                    ped = player_ped,
                    coords = player_coords
                }
            end
        end
    end
    return nearby
end

-- Retrieves a list of vehicles within a specified radius from given coordinates.
-- Usage: local vehicles = utils.entities.get_nearby_vehicles({x = 0, y = 0, z = 0}, 10.0, true)
local function get_nearby_vehicles(coords, max_distance, player_vehicle)
    local vehicles = GetGamePool('CVehicle')
    local nearby = {}
    local count = 0  -- Initialize count to 0
    max_distance = max_distance or 2.0
    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        if not IsPedInVehicle(PlayerPedId(), vehicle, true) or player_vehicle then
            local vehicle_coords = GetEntityCoords(vehicle)
            local distance = #(coords - vehicle_coords)
            if distance < max_distance then
                count = count + 1
                nearby[count] = {
                    vehicle = vehicle,
                    coords = vehicle_coords
                }
            end
        end
    end
    return nearby
end


-- Identifies the closest object to given coordinates within a max distance.
-- Usage: local closest_obj, closest_coords = utils.entities.get_closest_object({x = 0, y = 0, z = 0}, 10.0)
local function get_closest_object(coords, max_distance)
    local objects = GetGamePool('CObject')
    local closest_object, closest_coords
    max_distance = max_distance or 2.0
    for i = 1, #objects do
        local object = objects[i]
        local object_coords = GetEntityCoords(object)
        local distance = #(coords - object_coords)
        if distance < max_distance then
            max_distance = distance
            closest_object = object
            closest_coords = object_coords
        end
    end
    return closest_object, closest_coords
end

-- Identifies the closest ped to given coordinates within a max distance, excluding player peds.
-- Usage: local closest_ped, closest_coords = utils.entities.get_closest_ped({x = 0, y = 0, z = 0}, 10.0)
local function get_closest_ped(coords, max_distance)
    local peds = GetGamePool('CPed')
    local closest_ped, closest_coords
    max_distance = max_distance or 2.0
    for i = 1, #peds do
        local ped = peds[i]
        if not IsPedAPlayer(ped) then
            local ped_coords = GetEntityCoords(ped)
            local distance = #(coords - ped_coords)
            if distance < max_distance then
                max_distance = distance
                closest_ped = ped
                closest_coords = ped_coords
            end
        end
    end
    return closest_ped, closest_coords
end

-- Identifies the closest player to given coordinates within a max distance.
-- Usage: local closest_id, closest_ped, closest_coords = utils.entities.get_closest_player({x = 0, y = 0, z = 0}, 10.0)
local function get_closest_player(coords, max_distance, include_player)
    local players = GetActivePlayers()
    local closest_id, closest_ped, closest_coords
    max_distance = max_distance or 2.0
    for i = 1, #players do
        local player_id = players[i]
        if player_id ~= PlayerId() or include_player then
            local player_ped = GetPlayerPed(player_id)
            local player_coords = GetEntityCoords(player_ped)
            local distance = #(coords - player_coords)
            if distance < max_distance then
                max_distance = distance
                closest_id = player_id
                closest_ped = player_ped
                closest_coords = player_coords
            end
        end
    end
    return closest_id, closest_ped, closest_coords
end

-- Identifies the closest vehicle to given coordinates within a max distance.
-- Usage: local closest_vehicle, closest_coords = utils.entities.get_closest_vehicle({x = 0, y = 0, z = 0}, 10.0)
local function get_closest_vehicle(coords, max_distance, player_vehicle)
    local vehicles = GetGamePool('CVehicle')
    local closest_vehicle, closest_coords
    max_distance = max_distance or 2.0
    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        if not IsPedInVehicle(PlayerPedId(), vehicle, true) or player_vehicle then
            local vehicle_coords = GetEntityCoords(vehicle)
            local distance = #(coords - vehicle_coords)
            if distance < max_distance then
                max_distance = distance
                closest_vehicle = vehicle
                closest_coords = vehicle_coords
            end
        end
    end
    return closest_vehicle, closest_coords
end

-- Get entities in front of the player within a specified field of view and distance.
-- Usage: local entities_in_front = utils.entities.get_entities_in_front_of_player(45.0, 10.0)
local function get_entities_in_front_of_player(fov, distance)
    local player = PlayerPedId()
    local player_coords = GetEntityCoords(player)
    local forward_vector = GetEntityForwardVector(player)
    local end_coords = vector3(player_coords.x + forward_vector.x * distance, player_coords.y + forward_vector.y * distance, player_coords.z + forward_vector.z * distance)
    local hit, _, _, _, entity = StartShapeTestRay(player_coords.x, player_coords.y, player_coords.z, end_coords.x, end_coords.y, end_coords.z, -1, player, 0)
    if hit then
        local entity_type = GetEntityType(entity)
        if entity_type ~= 0 then 
            return entity
        end
    end
    return nil
end

--[[
    ASSIGN LOCALS
]]

utils.entities = utils.entities or {}

utils.entities.get_nearby_objects = get_nearby_objects
utils.entities.get_nearby_peds = get_nearby_peds
utils.entities.get_nearby_vehicles = get_nearby_vehicles
utils.entities.get_closest_object = get_closest_object
utils.entities.get_closest_ped = get_closest_ped
utils.entities.get_closest_player = get_closest_player
utils.entities.get_closest_vehicle = get_closest_vehicle
utils.entities.get_entities_in_front_of_player = get_entities_in_front_of_player