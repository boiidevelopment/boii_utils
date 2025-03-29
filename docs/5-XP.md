## XP Module

Handles player XP tracking, leveling, and data persistence for skills, reputation, and other growth systems.

---

### Accessing the Module

```lua
local XP <const> = exports.boii_utils:get("modules.xp")
```

---

## Server

### get_all_xp(source)
Retrieves all XP data for a player.

#### Parameters
| Name   | Type     | Description           |
|--------|----------|-----------------------|
| source | `number` | Player source ID      |

#### Returns
| Type   | Description               |
|--------|---------------------------|
| table  | Table of XP entries       |

#### Example
```lua
local all_xp = XP.get_all(source)
```

---

### get_xp(source, xp_id)
Gets a specific XP entry for a player.

#### Parameters
| Name   | Type     | Description      |
|--------|----------|------------------|
| source | `number` | Player source ID |
| xp_id  | `string` | The XP ID        |

#### Returns
| Type   | Description         |
|--------|---------------------|
| table  | XP data for the ID  |

#### Example
```lua
local fishing = XP.get(source, "fishing")
```

---

### set_xp(source, xp_id, amount)
Sets a player's XP to a fixed value.

#### Parameters
| Name   | Type     | Description             |
|--------|----------|-------------------------|
| source | `number` | Player source ID        |
| xp_id  | `string` | The XP ID               |
| amount | `number` | Amount of XP to assign  |

#### Example
```lua
XP.set(source, "fishing", 100)
```

---

### add_xp(source, xp_id, amount)
Adds XP to a player's skill and handles level-ups.

#### Parameters
| Name   | Type     | Description             |
|--------|----------|-------------------------|
| source | `number` | Player source ID        |
| xp_id  | `string` | The XP ID               |
| amount | `number` | Amount of XP to add     |

#### Example
```lua
XP.add(source, "fishing", 10)
```

---

### remove_xp(source, xp_id, amount)
Removes XP from a player's skill and handles level-downs.

#### Parameters
| Name   | Type     | Description              |
|--------|----------|--------------------------|
| source | `number` | Player source ID         |
| xp_id  | `string` | The XP ID                |
| amount | `number` | Amount of XP to subtract |

#### Example
```lua
XP.remove(source, "fishing", 5)
```

---

## Client

### get_all_xp()
Requests all XP data for the local player.

#### Returns
| Type   | Description          |
|--------|----------------------|
| table  | XP data for player   |

#### Example
```lua
local xp_data = XP.get_all()
```