--- @module Entities

local entities = {}

if not IS_SERVER then

    --- Find nearby entities.
    --- @param pool string: The type of entity pool to search in (e.g., "CObject", "CPed", "CVehicle").
    --- @param coords vector3: The center coordinates to search from.
    --- @param max_distance number: The maximum distance within which to search for entities.
    --- @param filter function: (Optional) A function to apply additional filtering logic. Should return `true` to include the entity.
    --- @return table: A table containing a list of entities and their coordinates.
    local function get_nearby_entities(pool, coords, max_distance, filter)
        local entities = GetGamePool(pool)

        local nearby = {}
        local count = 0
        max_distance = max_distance or 2.0

        for i = 1, #entities do
            local entity = entities[i]
            local entity_coords = GetEntityCoords(entity)
            local distance = #(coords - entity_coords)
            if distance < max_distance and (not filter or filter(entity)) then
                count = count + 1
                nearby[count] = { entity = entity, coords = entity_coords }
            end
        end

        return nearby
    end

    --- Retrieves nearby objects.
    --- @param coords vector3: The center coordinates to search from.
    --- @param max_distance number: The maximum distance within which to search for objects.
    --- @return table: A list of nearby objects and their coordinates.
    local function get_nearby_objects(coords, max_distance)

        return get_nearby_entities("CObject", coords, max_distance)
    end

    --- Retrieves nearby peds, excluding players.
    --- @param coords vector3: The center coordinates to search from.
    --- @param max_distance number: The maximum distance within which to search for peds.
    --- @return table: A list of nearby peds and their coordinates.
    local function get_nearby_peds(coords, max_distance)

        return get_nearby_entities("CPed", coords, max_distance, function(ped)
            return not IsPedAPlayer(ped)
        end)
    end

    --- Retrieves nearby players, optionally including the executing player.
    --- @param coords vector3: The center coordinates to search from.
    --- @param max_distance number: The maximum distance within which to search for players.
    --- @param include_player boolean: Whether to include the executing player in the results.
    --- @return table: A list of nearby players, their peds, and their coordinates.
    local function get_nearby_players(coords, max_distance, include_player)
        local player_id = PlayerId()

        return get_nearby_entities("CPed", coords, max_distance, function(ped)
            local ped_player_id = NetworkGetEntityOwner(ped)
            return include_player or ped_player_id ~= player_id
        end)
    end

    --- Retrieves nearby vehicles, optionally excluding the player"s vehicle.
    --- @param coords vector3: The center coordinates to search from.
    --- @param max_distance number: The maximum distance within which to search for vehicles.
    --- @param include_player_vehicle boolean: Whether to include the players current vehicle in the results.
    --- @return table: A list of nearby vehicles and their coordinates.
    local function get_nearby_vehicles(coords, max_distance, include_player_vehicle)
        local player_vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

        return get_nearby_entities("CVehicle", coords, max_distance, function(vehicle)
            return include_player_vehicle or vehicle ~= player_vehicle
        end)
    end

    --- Retrieves the closest object.
    --- @param coords vector3: The center coordinates to search from.
    --- @param max_distance number: The maximum distance within which to search for objects.
    --- @return object: The closest object found within the given distance.
    --- @return vector3: The coordinates of the closest object.
    local function get_closest_object(coords, max_distance)

        return get_closest_entity("CObject", coords, max_distance)
    end

    --- Retrieves the closest ped, excluding players.
    --- @param coords vector3: The center coordinates to search from.
    --- @param max_distance number: The maximum distance within which to search for peds.
    --- @return ped: The closest ped found within the given distance.
    --- @return vector3: The coordinates of the closest ped.
    local function get_closest_ped(coords, max_distance)

        return get_closest_entity("CPed", coords, max_distance, function(ped)
            return not IsPedAPlayer(ped)
        end)
    end

    --- Retrieves the closest player.
    --- @param coords vector3: The center coordinates to search from.
    --- @param max_distance number: The maximum distance within which to search for players.
    --- @param include_player boolean: Whether to include the executing player in the search.
    --- @return player_id: The ID of the closest player found within the given distance.
    --- @return ped: The ped of the closest player.
    --- @return vector3: The coordinates of the closest player.
    local function get_closest_player(coords, max_distance, include_player)

        return get_closest_entity("CPed", coords, max_distance, function(ped)
            local ped_player_id = NetworkGetEntityOwner(ped)
            return include_player or ped_player_id ~= PlayerId()
        end)
    end

    --- Retrieves the closest vehicle.
    --- @param coords vector3: The center coordinates to search from.
    --- @param max_distance number: The maximum distance within which to search for vehicles.
    --- @param include_player_vehicle boolean: Whether to include the players current vehicle in the search.
    --- @return vehicle: The closest vehicle found within the given distance.
    --- @return vector3: The coordinates of the closest vehicle.
    local function get_closest_vehicle(coords, max_distance, include_player_vehicle)

        return get_closest_entity("CVehicle", coords, max_distance, function(vehicle)
            return include_player_vehicle or vehicle ~= GetVehiclePedIsIn(PlayerPedId(), false)
        end)
    end

    --- Get entities in front of the player within a specified FOV and distance.
    --- @param fov number: The field of view in degrees to search within.
    --- @param distance number: The maximum distance to search for entities in front of the player.
    --- @return entity: The entity directly in front of the player within the given FOV and distance, or `nil` if none found.
    local function get_entities_in_front_of_player(fov, distance)
        local player = PlayerPedId()
        local player_coords = GetEntityCoords(player)
        local forward_vector = GetEntityForwardVector(player)

        local end_coords = vector3(
            player_coords.x + forward_vector.x * distance,
            player_coords.y + forward_vector.y * distance,
            player_coords.z + forward_vector.z * distance
        )

        local hit, _, _, _, entity = StartShapeTestRay(
            player_coords.x, player_coords.y, player_coords.z,
            end_coords.x, end_coords.y, end_coords.z, -1, player, 0
        )

        return hit and GetEntityType(entity) ~= 0 and entity or nil
    end

    --- Get the target ped or nearest ped.
    --- @param player_ped number: The ped ID of the player.
    --- @param fov number: The field of view in degrees to search within.
    --- @param distance number: The maximum distance to search for a target ped.
    --- @return ped: The ped directly in front of the player or the nearest ped, if none found.
    --- @return vector3: The coordinates of the found ped.
    local function get_target_ped(player_ped, fov, distance)

        local entity = get_entities_in_front_of_player(fov, distance)
        if entity and IsEntityAPed(entity) and not IsPedAPlayer(entity) then
            return entity, GetEntityCoords(entity)
        end

        return get_closest_ped(GetEntityCoords(player_ped), distance)
    end

    --- @section Function Assignments
    
    entities.get_nearby_objects = get_nearby_objects
    entities.get_nearby_peds = get_nearby_peds
    entities.get_nearby_players = get_nearby_players
    entities.get_nearby_vehicles = get_nearby_vehicles
    entities.get_closest_object = get_closest_object
    entities.get_closest_ped = get_closest_ped
    entities.get_closest_player = get_closest_player
    entities.get_closest_vehicle = get_closest_vehicle
    entities.get_entities_in_front_of_player = get_entities_in_front_of_player
    entities.get_target_ped = get_target_ped

    --- @section Exports

    exports("get_nearby_objects", get_nearby_objects)
    exports("get_nearby_peds", get_nearby_peds)
    exports("get_nearby_players", get_nearby_players)
    exports("get_nearby_vehicles", get_nearby_vehicles)
    exports("get_closest_object", get_closest_object)
    exports("get_closest_ped", get_closest_ped)
    exports("get_closest_player", get_closest_player)
    exports("get_closest_vehicle", get_closest_vehicle)
    exports("get_entities_in_front_of_player", get_entities_in_front_of_player)
    exports("get_target_ped", get_target_ped)

end

return entities