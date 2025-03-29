## Licences Module

Provides a standalone licence system supporting driving, weapon, hunting licences and more, with support for points and revocation. Framework-agnostic.

---

### Accessing the Module

```lua
local LICENCES <const> = exports.boii_utils:get("modules.licences")
```

---

## Server

### get_licences(source)

Retrieves all licences for a player.

#### Parameters
| Name   | Type     | Description                    |
|--------|----------|--------------------------------|
| source | `number` | Player source identifier       |

#### Example
```lua
local all_licences = LICENCES.get_all(source)
```

---

### get_licence(source, licence_id)

Retrieves a specific licence for a player.

#### Parameters
| Name       | Type     | Description                    |
|------------|----------|--------------------------------|
| source     | `number` | Player source identifier       |
| licence_id | `string` | Licence ID                     |

#### Example
```lua
local weapon_licence = LICENCES.get(source, "weapon")
```

---

### add_licence(source, licence_id)

Grants a player a new licence.

#### Parameters
| Name       | Type     | Description              |
|------------|----------|--------------------------|
| source     | `number` | Player source ID         |
| licence_id | `string` | Licence ID to add        |

#### Example
```lua
LICENCES.add(source, "driver")
```

---

### remove_licence(source, licence_id)

Removes a player's licence.

#### Parameters
| Name       | Type     | Description              |
|------------|----------|--------------------------|
| source     | `number` | Player source ID         |
| licence_id | `string` | Licence ID to remove     |

#### Example
```lua
LICENCES.remove(source, "driver")
```

---

### add_points(source, licence_id, points)

Adds penalty points to a player's licence.

#### Parameters
| Name       | Type     | Description                      |
|------------|----------|----------------------------------|
| source     | `number` | Player source ID                 |
| licence_id | `string` | Licence ID to modify             |
| points     | `number` | Points to add                    |

#### Example
```lua
LICENCES.add_points(source, "driver", 3)
```

---

### remove_points(source, licence_id, points)

Removes penalty points from a player's licence.

#### Parameters
| Name       | Type     | Description                      |
|------------|----------|----------------------------------|
| source     | `number` | Player source ID                 |
| licence_id | `string` | Licence ID to modify             |
| points     | `number` | Points to remove                 |

#### Example
```lua
LICENCES.remove_points(source, "driver", 2)
```

---

### update_licence(source, licence_id, test_type, passed)

Updates a licence to mark theory or practical passed.

#### Parameters
| Name       | Type      | Description                                |
|------------|-----------|--------------------------------------------|
| source     | `number`  | Player source ID                           |
| licence_id | `string`  | Licence ID to update                       |
| test_type  | `string`  | Either `"theory"` or `"practical"`         |
| passed     | `boolean` | `true` if passed, `false` if not          |

#### Example
```lua
LICENCES.update(source, "driver", "practical", true)
```

---

## Client

### get_licences()

Triggers server callback to fetch current player's licences.

#### Parameters
None

#### Example
```lua
LICENCES.get_all(function(data)
    print(json.encode(data))
end)
```

---

## Notes

- Licences include: `theory`, `practical`, `points`, `max_points`, `revoked`.
- Designed to support all major frameworks with no dependency.
- Stored in `utils_licences` MySQL table.
- Data is cached per player session for performance.