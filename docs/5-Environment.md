## Environment Module

The Environment module provides utility functions to query and process in-game environmental data such as weather, time, season, terrain, and more.

---

### Accessing the Module

```lua
local ENVIRONMENT <const> = exports.boii_utils:get("modules.environment")
```

---

## get_weather_name(hash)

Returns the readable name of a weather type from its hash.

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| hash | `number` | The hash key of the weather type. |

#### Example
```lua
local weather = ENVIRONMENT.get_weather_name(GetPrevWeatherTypeHashName())
print("Current Weather:", weather)
```

---

## get_game_time()

Returns current game time (hour + minute) in both raw and formatted format.

#### Returns
| Name | Type | Description |
|------|------|-------------|
| time | `table` | `{ hour, minute }` |
| formatted | `string` | Time formatted as `HH:MM` |

#### Example
```lua
local time = ENVIRONMENT.get_game_time()
print("Game Time:", time.formatted)
```

---

## get_game_date()

Returns current in-game date in both raw and formatted format.

#### Returns
| Name | Type | Description |
|------|------|-------------|
| date | `table` | `{ day, month, year }` |
| formatted | `string` | Date formatted as `DD/MM/YYYY` |

#### Example
```lua
local date = ENVIRONMENT.get_game_date()
print("Game Date:", date.formatted)
```

---

## get_sunrise_sunset_times(weather)

Returns sunrise and sunset times based on weather type.

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| weather | `string` | The weather type name (e.g. "CLEAR") |

#### Example
```lua
local times = ENVIRONMENT.get_sunrise_sunset_times("CLOUDS")
print("Sunrise:", times.sunrise, "Sunset:", times.sunset)
```

---

## is_daytime()

Checks if the current time is between 06:00 and 18:00.

#### Returns
| Type | Description |
|------|-------------|
| `boolean` | `true` if daytime, otherwise `false` |

#### Example
```lua
if ENVIRONMENT.is_daytime() then
    print("It's daytime!")
end
```

---

## get_current_season()

Returns the current season based on in-game month.

#### Returns
| Type | Description |
|------|-------------|
| `string` | Season name: "Winter", "Spring", "Summer", or "Autumn" |

#### Example
```lua
local season = ENVIRONMENT.get_current_season()
print("Season:", season)
```

---

## get_distance_to_water()

Calculates the vertical distance from player to nearest water surface.

#### Returns
| Type | Description |
|------|-------------|
| `number` | Distance to water or `-1` if no water nearby |

#### Example
```lua
local dist = ENVIRONMENT.get_distance_to_water()
print("Water Distance:", dist)
```

---

## get_zone_scumminess()

Returns the "scumminess" level of the player's current zone.

#### Returns
| Type | Description |
|------|-------------|
| `integer` | Value from 0-5, or -1 if not found |

#### Example
```lua
print("Zone Scumminess:", ENVIRONMENT.get_zone_scumminess())
```

---

## get_ground_material()

Returns the hash of the ground material at the player's feet.

#### Returns
| Type | Description |
|------|-------------|
| `number` | Material hash value |

#### Example
```lua
print("Ground Material Hash:", ENVIRONMENT.get_ground_material())
```

---

## get_wind_direction()

Returns the wind direction as a compass direction (N, NE, etc).

#### Returns
| Type | Description |
|------|-------------|
| `string` | Compass direction |

#### Example
```lua
print("Wind Direction:", ENVIRONMENT.get_wind_direction())
```

---

## get_altitude()

Returns the player's current altitude above sea level.

#### Returns
| Type | Description |
|------|-------------|
| `number` | Altitude value |

#### Example
```lua
print("Altitude:", ENVIRONMENT.get_altitude())
```

---

## get_environment_details()

Returns a detailed breakdown of the current environment.

#### Returns
| Key | Type | Description |
|-----|------|-------------|
| weather | `string` | Current weather name |
| time | `table` | Table of game time info |
| date | `table` | Table of game date info |
| season | `string` | Current season |
| sunrise_sunset | `table` | Sunrise/sunset times |
| is_daytime | `boolean` | True if daytime |
| distance_to_water | `number` | Distance to nearest water |
| scumminess | `number` | Zone scumminess level |
| ground_material | `number` | Ground hash |
| rain_level | `number` | Current rain amount |
| wind_speed | `number` | Current wind speed |
| wind_direction | `string` | Compass wind direction |
| snow_level | `number` | Current snow amount |
| altitude | `number` | Player's altitude |

#### Example
```lua
local env = ENVIRONMENT.get_environment_details()
print(json.encode(env))
```