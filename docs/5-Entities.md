## Entities Module

The `entities` module provides utility functions for detecting, filtering, and retrieving nearby or targeted game entities such as objects, peds, players, and vehicles.

---

### Accessing the Module

```lua
local ENTITIES <const> = exports.boii_utils:get("modules.entities")
```

---

## Client

### get_nearby_objects(coords, max_distance)

Returns nearby objects within a certain distance.

#### Parameters

| Name         | Type      | Description                                      |
|--------------|-----------|--------------------------------------------------|
| coords       | `vector3` | The center coordinates to search from.          |
| max_distance | `number`  | The maximum radius to search in.                |

#### Example

```lua
local nearby = ENTITIES.get_nearby_objects(GetEntityCoords(PlayerPedId()), 5.0)
for _, obj in pairs(nearby) do
    print("Nearby Object:", obj.entity, obj.coords)
end
```

---

### get_nearby_peds(coords, max_distance)

Returns non-player peds nearby.

#### Parameters

| Name         | Type      | Description                             |
|--------------|-----------|-----------------------------------------|
| coords       | `vector3` | The center position to search from.     |
| max_distance | `number`  | The maximum distance to search within.  |

#### Example

```lua
local peds = ENTITIES.get_nearby_peds(GetEntityCoords(PlayerPedId()), 10.0)
```

---

### get_nearby_players(coords, max_distance, include_player)

Returns player peds nearby.

#### Parameters

| Name              | Type      | Description                                        |
|-------------------|-----------|----------------------------------------------------|
| coords            | `vector3` | The origin position to search from.               |
| max_distance      | `number`  | How far out to search.                            |
| include_player    | `boolean` | Whether to include the executing player.          |

#### Example

```lua
local players = ENTITIES.get_nearby_players(GetEntityCoords(PlayerPedId()), 10.0, false)
```

---

### get_nearby_vehicles(coords, max_distance, include_player_vehicle)

Finds vehicles in proximity.

#### Parameters

| Name                   | Type      | Description                                                  |
|------------------------|-----------|--------------------------------------------------------------|
| coords                 | `vector3` | Starting point for the check.                                |
| max_distance           | `number`  | Max distance to scan.                                        |
| include_player_vehicle | `boolean` | Whether to include the player’s vehicle in the results.     |

#### Example

```lua
local vehicles = ENTITIES.get_nearby_vehicles(GetEntityCoords(PlayerPedId()), 20.0, false)
```

---

### get_closest_object(coords, max_distance)

Returns the closest object.

#### Parameters

| Name         | Type      | Description                            |
|--------------|-----------|----------------------------------------|
| coords       | `vector3` | Where to search from.                  |
| max_distance | `number`  | Search radius.                         |

#### Example

```lua
local object, coords = ENTITIES.get_closest_object(GetEntityCoords(PlayerPedId()), 5.0)
```

---

### get_closest_ped(coords, max_distance)

Returns the nearest non-player ped.

#### Parameters

| Name         | Type      | Description                |
|--------------|-----------|----------------------------|
| coords       | `vector3` | Where to begin search.     |
| max_distance | `number`  | Distance limit.            |

#### Example

```lua
local ped, coords = ENTITIES.get_closest_ped(GetEntityCoords(PlayerPedId()), 10.0)
```

---

### get_closest_player(coords, max_distance, include_player)

Finds the nearest player ped.

#### Parameters

| Name              | Type      | Description                              |
|-------------------|-----------|------------------------------------------|
| coords            | `vector3` | Origin point.                            |
| max_distance      | `number`  | Search distance.                         |
| include_player    | `boolean` | Include calling player in search.        |

#### Example

```lua
local player, ped, coords = ENTITIES.get_closest_player(GetEntityCoords(PlayerPedId()), 10.0, false)
```

---

### get_closest_vehicle(coords, max_distance, include_player_vehicle)

Returns the closest vehicle entity.

#### Parameters

| Name                   | Type      | Description                                      |
|------------------------|-----------|--------------------------------------------------|
| coords                 | `vector3` | Coordinates to center the search on.            |
| max_distance           | `number`  | Max scan distance.                              |
| include_player_vehicle | `boolean` | Whether to consider the player’s current vehicle. |

#### Example

```lua
local veh, coords = ENTITIES.get_closest_vehicle(GetEntityCoords(PlayerPedId()), 10.0, false)
```

---

### get_entities_in_front_of_player(fov, distance)

Checks for an entity in the player’s FOV.

#### Parameters

| Name     | Type     | Description                        |
|----------|----------|------------------------------------|
| fov      | `number` | The angle cone to check in degrees.|
| distance | `number` | Max range to scan forward.         |

#### Example

```lua
local entity = ENTITIES.get_entities_in_front_of_player(45, 10.0)
```

---

### get_target_ped(player_ped, fov, distance)

Finds a valid non-player ped in front or the nearest.

#### Parameters

| Name       | Type     | Description                               |
|------------|----------|-------------------------------------------|
| player_ped | `number` | The calling player’s ped.                 |
| fov        | `number` | Angle to check forward.                   |
| distance   | `number` | Maximum range to search.                 |

#### Example

```lua
local ped, coords = ENTITIES.get_target_ped(PlayerPedId(), 60.0, 10.0)
```

---

## Notes

- All entity searches rely on `GetGamePool(pool)`
- `CObject`, `CPed`, and `CVehicle` are standard CFX entity types
- This module only works on the **client side**