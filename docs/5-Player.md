## Player Module

Provides utility functions for retrieving player information, directional logic, entity targeting, animations, and more.

---

### Accessing the Module

```lua
local PLAYER <const> = exports.boii_utils:get("modules.player")
```

---

## Shared

### get_cardinal_direction(player_ped)
Returns the cardinal direction the player is facing.

#### Parameters
| Name        | Type     | Description                                            |
|-------------|----------|--------------------------------------------------------|
| player_ped  | `number` | The player ped (use `PlayerPedId()` or `GetPlayerPed(source)`) |

#### Example
```lua
local dir = PLAYER.get_cardinal_direction(PlayerPedId())
```

---

### get_distance_to_entity(player, entity)
Calculates the distance between a player and another entity.

#### Parameters
| Name    | Type     | Description                        |
|---------|----------|------------------------------------|
| player  | `number` | The player entity                  |
| entity  | `number` | The target entity (or net ID)      |

#### Example
```lua
local dist = PLAYER.get_distance_to_entity(PlayerPedId(), entity)
```

---

## Client Only

### get_street_name(player_ped)
Gets the current street and area the player is in.

#### Parameters
| Name        | Type     | Description         |
|-------------|----------|---------------------|
| player_ped  | `number` | The player ped      |

#### Example
```lua
local location = PLAYER.get_street_name(PlayerPedId())
```

---

### get_region(player_ped)
Returns the name of the region the player is located in.

#### Parameters
| Name        | Type     | Description         |
|-------------|----------|---------------------|
| player_ped  | `number` | The player ped      |

#### Example
```lua
local region = PLAYER.get_region(PlayerPedId())
```

---

### get_player_details(player_ped)
Returns a table with extended player stats and data.

#### Parameters
| Name        | Type     | Description         |
|-------------|----------|---------------------|
| player_ped  | `number` | The player ped      |

#### Example
```lua
local details = PLAYER.get_player_details(PlayerPedId())
```

---

### get_target_entity(player_ped)
Returns the entity a player is currently aiming at.

#### Parameters
| Name        | Type     | Description         |
|-------------|----------|---------------------|
| player_ped  | `number` | The player ped      |

#### Example
```lua
local target = PLAYER.get_target_entity(PlayerPedId())
```

---

### play_animation(player_ped, options, callback)
Plays an animation with optional props and visual progress.

#### Parameters
| Name        | Type      | Description                         |
|-------------|-----------|-------------------------------------|
| player_ped  | `number`  | The player ped                      |
| options     | `table`   | Animation and prop options          |
| callback    | `function`| Function called after animation     |

#### Example
```lua
PLAYER.play_animation(PlayerPedId(), {
    dict = 'anim@heists@ornate_bank@grab_cash',
    anim = 'grab',
    flags = 49,
    duration = 3000,
    freeze = true,
    props = {
        {
            model = 'prop_cs_burger_01',
            bone = 57005,
            coords = vector3(0.1, 0.0, 0.0),
            rotation = vector3(0.0, 0.0, 0.0),
            is_ped = true
        }
    }
}, function()
    print('Animation completed.')
end)
```

---

## Notes
- Most client functions require `PlayerPedId()`
- Animations use `REQUESTS` for dictionary and model loading internally