## Vehicles Module

Provides functions for querying and modifying vehicle state, condition, customization, and spawning. Primarily client-side.

---

### Accessing the Module
```lua
local VEHICLES <const> = exports.boii_utils:get("modules.vehicles")
```

---

## Client

### get_vehicle_plate(vehicle)
Returns the license plate of a vehicle.

#### Parameters
| Name    | Type     | Description                  |
|---------|----------|------------------------------|
| vehicle | `number` | Vehicle entity handle        |

#### Example
```lua
local plate = VEHICLES.get_vehicle_plate(vehicle)
```

---

### get_vehicle_model(vehicle)
Returns the lowercase model name of a vehicle.

#### Parameters
| Name    | Type     | Description                  |
|---------|----------|------------------------------|
| vehicle | `number` | Vehicle entity handle        |

#### Example
```lua
local model = VEHICLES.get_vehicle_model(vehicle)
```

---

### get_doors_broken(vehicle)
Returns a table showing which doors are damaged.

#### Parameters
| Name    | Type     | Description                  |
|---------|----------|------------------------------|
| vehicle | `number` | Vehicle entity handle        |

#### Example
```lua
local doors = VEHICLES.get_doors_broken(vehicle)
```

---

### get_windows_broken(vehicle)
Returns a table showing which windows are broken.

#### Parameters
| Name    | Type     | Description                  |
|---------|----------|------------------------------|
| vehicle | `number` | Vehicle entity handle        |

#### Example
```lua
local windows = VEHICLES.get_windows_broken(vehicle)
```

---

### get_tyre_burst(vehicle)
Returns a table showing burst tyres.

#### Parameters
| Name    | Type     | Description                  |
|---------|----------|------------------------------|
| vehicle | `number` | Vehicle entity handle        |

#### Example
```lua
local tyres = VEHICLES.get_tyre_burst(vehicle)
```

---

### get_vehicle_extras(vehicle)
Returns a table of toggled vehicle extras.

#### Parameters
| Name    | Type     | Description                  |
|---------|----------|------------------------------|
| vehicle | `number` | Vehicle entity handle        |

#### Example
```lua
local extras = VEHICLES.get_vehicle_extras(vehicle)
```

---

### get_custom_xenon_color(vehicle)
Returns a custom xenon color as `{r, g, b}`.

#### Parameters
| Name    | Type     | Description                  |
|---------|----------|------------------------------|
| vehicle | `number` | Vehicle entity handle        |

#### Example
```lua
local color = VEHICLES.get_custom_xenon_color(vehicle)
```

---

### get_vehicle_mod(vehicle, mod_type)
Returns index and variation of a vehicle mod.

#### Parameters
| Name     | Type     | Description                      |
|----------|----------|----------------------------------|
| vehicle  | `number` | Vehicle entity handle            |
| mod_type | `number` | Mod slot index (0 to 49)         |

#### Example
```lua
local mod = VEHICLES.get_vehicle_mod(vehicle, 15)
```

---

### get_vehicle_properties(vehicle)
Returns a full set of mod and condition data.

#### Parameters
| Name    | Type     | Description                  |
|---------|----------|------------------------------|
| vehicle | `number` | Vehicle entity handle        |

#### Example
```lua
local props = VEHICLES.get_vehicle_properties(vehicle)
```

---

### get_vehicle_mods_and_maintenance(vehicle)
Returns mod and maintenance data separately.

#### Parameters
| Name    | Type     | Description                  |
|---------|----------|------------------------------|
| vehicle | `number` | Vehicle entity handle        |

#### Example
```lua
local mods, maintenance = VEHICLES.get_vehicle_mods_and_maintenance(vehicle)
```

---

### get_vehicle_class(vehicle)
Returns the class name (e.g. "sports") of the vehicle.

#### Parameters
| Name    | Type     | Description                  |
|---------|----------|------------------------------|
| vehicle | `number` | Vehicle entity handle        |

#### Example
```lua
local class = VEHICLES.get_vehicle_class(vehicle)
```

---

### get_vehicle_class_details(vehicle)
Returns stats for the vehicle class (traction, speed, etc).

#### Parameters
| Name    | Type     | Description                  |
|---------|----------|------------------------------|
| vehicle | `number` | Vehicle entity handle        |

#### Example
```lua
local stats = VEHICLES.get_vehicle_class_details(vehicle)
```

---

### get_vehicle_details(use_current_vehicle)
Returns full detailed data for a vehicle.

#### Parameters
| Name                | Type      | Description                             |
|---------------------|-----------|-----------------------------------------|
| use_current_vehicle | `boolean` | Use the current vehicle or nearby one   |

#### Example
```lua
local info = VEHICLES.get_vehicle_details(true)
```

---

### spawn_vehicle(vehicle_data)
Spawns and configures a vehicle.

#### Parameters
| Name         | Type    | Description                                  |
|--------------|---------|----------------------------------------------|
| vehicle_data | `table` | Vehicle data including model, coords, mods   |

#### Example
```lua
local vehicle = VEHICLES.spawn_vehicle({
  model = 'sultan',
  coords = vector4(0.0, 0.0, 72.0, 90.0),
  mods = { max_performance = true }
})
```

---

## Notes
- All functions assume the entity exists and is valid.
- Most functions return either raw data, formatted tables, or booleans.
- All customization-related functions only affect the client-side runtime vehicle.