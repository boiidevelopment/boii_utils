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

--- Entity functions.
--- @script client/scripts/entities.lua

--- @section Local functions

--- Retrieves a list of objects within a specified radius from given coordinates.
--- @function get_nearby_objects
--- @param coords vector3: Center coordinates to search from.
--- @param max_distance number: Maximum distance to search within.
--- @return table: List of nearby objects and their coordinates.
--- @usage local objects = utils.entities.get_nearby_objects({x = 0, y = 0, z = 0}, 10.0)
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

exports('entities_get_nearby_objects', get_nearby_objects)
utils.entities.get_nearby_objects = get_nearby_objects

--- Retrieves a list of peds within a specified radius from given coordinates, excluding player peds.
--- @function get_nearby_peds
--- @param coords vector3: Center coordinates to search from.
--- @param max_distance number: Maximum distance to search within.
--- @return table: List of nearby peds and their coordinates.
--- @usage local peds = utils.entities.get_nearby_peds({x = 0, y = 0, z = 0}, 10.0)
local function get_nearby_peds(coords, max_distance)
    local peds = GetGamePool('CPed')
    local nearby = {}
    local count = 0
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

exports('entities_get_nearby_peds', get_nearby_peds)
utils.entities.get_nearby_peds = get_nearby_peds

--- Retrieves a list of players within a specified radius from given coordinates.
--- @function get_nearby_players
--- @param coords vector3: Center coordinates to search from.
--- @param max_distance number: Maximum distance to search within.
--- @param include_player boolean: Whether to include the executing player in the list.
--- @return table: List of nearby players, their peds, and their coordinates.
--- @usage local players = utils.entities.get_nearby_players({x = 0, y = 0, z = 0}, 10.0, true)
local function get_nearby_players(coords, max_distance, include_player)
    local players_list = GetActivePlayers()
    local nearby = {}
    local count = 0
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

exports('entities_get_nearby_players', get_nearby_players)
utils.entities.get_nearby_players = get_nearby_players

--- Retrieves a list of vehicles within a specified radius from given coordinates.
--- @function get_nearby_vehicles
--- @param coords vector3: Center coordinates to search from.
--- @param max_distance number: Maximum distance to search within.
--- @param player_vehicle boolean: Whether to include the player's vehicle in the list.
--- @return table: List of nearby vehicles and their coordinates.
--- @usage local vehicles = utils.entities.get_nearby_vehicles({x = 0, y = 0, z = 0}, 10.0, true)
local function get_nearby_vehicles(coords, max_distance, player_vehicle)
    local vehicles = GetGamePool('CVehicle')
    local nearby = {}
    local count = 0
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

exports('entities_get_nearby_vehicles', get_nearby_vehicles)
utils.entities.get_nearby_vehicles = get_nearby_vehicles

--- Identifies the closest object to given coordinates within a max distance.
--- @function get_closest_object
--- @param coords vector3: Center coordinates to search from.
--- @param max_distance number: Maximum distance to search within.
--- @return object: The closest object within the max distance.
--- @return vector3: Coordinates of the closest object.
--- @usage local closest_obj, closest_coords = utils.entities.get_closest_object({x = 0, y = 0, z = 0}, 10.0)
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

exports('entities_get_closest_object', get_closest_object)
utils.entities.get_closest_object = get_closest_object

--- Identifies the closest ped to given coordinates within a max distance, excluding player peds.
--- @function get_closest_ped
--- @param coords vector3: Center coordinates to search from.
--- @param max_distance number: Maximum distance to search within.
--- @return ped: The closest ped within the max distance.
--- @return vector3: Coordinates of the closest ped.
--- @usage local closest_ped, closest_coords = utils.entities.get_closest_ped({x = 0, y = 0, z = 0}, 10.0)
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

exports('entities_get_closest_ped', get_closest_ped)
utils.entities.get_closest_ped = get_closest_ped

--- Identifies the closest player to given coordinates within a max distance.
--- @function get_closest_player
--- @param coords vector3: Center coordinates to search from.
--- @param max_distance number: Maximum distance to search within.
--- @param include_player boolean: Whether to include the executing player in the search.
--- @return player_id: ID of the closest player within the max distance.
--- @return ped: Ped of the closest player.
--- @return vector3: Coordinates of the closest player.
--- @usage local closest_id, closest_ped, closest_coords = utils.entities.get_closest_player({x = 0, y = 0, z = 0}, 10.0)
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

exports('entities_get_closest_player', get_closest_player)
utils.entities.get_closest_player = get_closest_player

--- Identifies the closest vehicle to given coordinates within a max distance.
--- @function get_closest_vehicle
--- @param coords vector3: Center coordinates to search from.
--- @param max_distance number: Maximum distance to search within.
--- @param player_vehicle boolean: Whether to include the player's vehicle in the search.
--- @return vehicle: The closest vehicle within the max distance.
--- @return vector3: Coordinates of the closest vehicle.
--- @usage local closest_vehicle, closest_coords = utils.entities.get_closest_vehicle({x = 0, y = 0, z = 0}, 10.0, true|false)
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

exports('entities_get_closest_vehicle', get_closest_vehicle)
utils.entities.get_closest_vehicle = get_closest_vehicle

--- Get entities in front of the player within a specified field of view and distance.
--- @function get_entities_in_front_of_player
--- @param fov number: Field of view in degrees.
--- @param distance number: Maximum distance to search within.
--- @return entity: The entity in front of the player within the specified FOV and distance.
--- @usage local entities_in_front = utils.entities.get_entities_in_front_of_player(45.0, 10.0)
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

exports('entities_get_entities_in_front_of_player', get_entities_in_front_of_player)
utils.entities.get_entities_in_front_of_player = get_entities_in_front_of_player

--- Get the target ped or nearest
--- @function get_target_ped
--- @param player_ped: PlayerPedId() for the player.
--- @param fov number: Field of view in degrees.
--- @param distance number: Maximum distance to search within.
--- @return entity: The entity in front of the player within the specified FOV and distance, or the closest entity.
--- @usage local target_ped = utils.entities.get_target_ped(PlayerPedId(), 45.0, 10.0)
local function get_target_ped(player_ped, fov, distance)
    local entity = get_entities_in_front_of_player(fov, distance)
    if entity and IsEntityAPed(entity) and not IsPedAPlayer(entity) then
        return entity, GetEntityCoords(entity)
    end
    
    local player_coords = GetEntityCoords(player_ped)
    local target_ped, target_coords = get_closest_ped(player_coords, 5.0)
    return target_ped, target_coords
end

exports('entities_get_target_ped', get_target_ped)
utils.entities.get_target_ped = get_target_ped
