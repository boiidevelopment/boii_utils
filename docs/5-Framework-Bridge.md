## Core Bridge Module (boii_core)

The Core Bridge module provides a unified API across multiple frameworks for player data, identity, inventory, balances, jobs, and more. The examples below reflect the boii_core implementation, but the API remains consistent across all supported frameworks.

---

### Accessing the Module

```lua
local CORE <const> = exports.boii_utils:get("bridges.framework")
```

---

## Server

### get_players()
Returns all players connected to the server.

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| -    | -    | None        |

#### Example
```lua
local players = CORE.get_players()
```

---

### get_player(source)
Retrieves player data by source ID.

#### Parameters
| Name   | Type     | Description |
|--------|----------|-------------|
| source | `number` | Player source ID |

#### Example
```lua
local player = CORE.get_player(source)
```

---

### get_id_params(source)
Generates identifier query and parameters.

#### Parameters
| Name   | Type     | Description |
|--------|----------|-------------|
| source | `number` | Player source ID |

#### Example
```lua
local query, params = CORE.get_id_params(source)
```

---

### get_player_id(source)
Returns the player's main identifier.

#### Parameters
| Name   | Type     | Description |
|--------|----------|-------------|
| source | `number` | Player source ID |

#### Example
```lua
local id = CORE.get_player_id(source)
```

---

### get_identity(source)
Returns a player's identity information.

#### Parameters
| Name   | Type     | Description |
|--------|----------|-------------|
| source | `number` | Player source ID |

#### Example
```lua
local identity = CORE.get_identity(source)
```

---

### get_inventory(source)
Gets a player's inventory.

#### Parameters
| Name   | Type     | Description |
|--------|----------|-------------|
| source | `number` | Player source ID |

#### Example
```lua
local inventory = CORE.get_inventory(source)
```

---

### get_item(source, item_name)
Gets a specific item from the player's inventory.

#### Parameters
| Name      | Type     | Description           |
|-----------|----------|-----------------------|
| source    | `number` | Player source ID      |
| item_name | `string` | Name of the item      |

#### Example
```lua
local item = CORE.get_item(source, "radio")
```

---

### has_item(source, item_name, item_amount?)
Checks if a player has an item in their inventory.

#### Parameters
| Name         | Type      | Description                     |
|--------------|-----------|---------------------------------|
| source       | `number`  | Player source ID                |
| item_name    | `string`  | Name of the item                |
| item_amount? | `number`  | Optional quantity (default: 1) |

#### Example
```lua
if CORE.has_item(source, "bandage", 2) then
    -- has at least 2 bandages
end
```

---

### add_item(source, item_id, amount, data?)
Adds an item to a player's inventory.

#### Parameters
| Name    | Type     | Description                    |
|---------|----------|--------------------------------|
| source  | `number` | Player source ID               |
| item_id | `string` | ID of the item                 |
| amount  | `number` | Quantity                       |
| data?   | `table`  | Optional metadata (e.g. ammo)  |

#### Example
```lua
CORE.add_item(source, "ammo_9mm", 50)
```

---

### remove_item(source, item_id, amount)
Removes an item from a player's inventory.

#### Parameters
| Name    | Type     | Description           |
|---------|----------|-----------------------|
| source  | `number` | Player source ID      |
| item_id | `string` | ID of the item        |
| amount  | `number` | Quantity to remove    |

#### Example
```lua
CORE.remove_item(source, "radio", 1)
```

---

### update_item_data(source, item_id, updates)
Modifies an item entry (e.g. ammo or durability).

#### Parameters
| Name    | Type     | Description            |
|---------|----------|------------------------|
| source  | `number` | Player source ID       |
| item_id | `string` | ID of the item         |
| updates | `table`  | Data to apply (key/value) |

#### Example
```lua
CORE.update_item_data(source, "weapon_pistol", { durability = 95 })
```

---

### get_balances(source)
Returns all account balances.

#### Parameters
| Name   | Type     | Description           |
|--------|----------|-----------------------|
| source | `number` | Player source ID      |

#### Example
```lua
local balances = CORE.get_balances(source)
```

---

### get_balance_by_type(source, balance_type)
Gets a specific account balance.

#### Parameters
| Name         | Type     | Description           |
|--------------|----------|-----------------------|
| source       | `number` | Player source ID      |
| balance_type | `string` | Type: "cash", "bank"  |

#### Example
```lua
local cash = CORE.get_balance_by_type(source, "cash")
```

---

### add_balance(source, balance_type, amount, sender?, note?)
Adds money to a player account.

#### Parameters
| Name         | Type      | Description                   |
|--------------|-----------|-------------------------------|
| source       | `number`  | Player source ID              |
| balance_type | `string`  | Account type                  |
| amount       | `number`  | Amount to add                 |
| sender?      | `string`  | Optional sender description   |
| note?        | `string`  | Optional transaction note     |

#### Example
```lua
CORE.add_balance(source, "bank", 1000, "ATM", "Paycheck")
```

---

### remove_balance(source, balance_type, amount, recipient?, note?)
Removes money from a player account.

#### Parameters
| Name          | Type      | Description                 |
|---------------|-----------|-----------------------------|
| source        | `number`  | Player source ID            |
| balance_type  | `string`  | Account type                |
| amount        | `number`  | Amount to remove            |
| recipient?    | `string`  | Optional recipient name     |
| note?         | `string`  | Optional transaction note   |

#### Example
```lua
CORE.remove_balance(source, "cash", 250)
```

---

### get_player_jobs(source)

Returns a list of jobs the player currently holds.

#### Parameters
| Name   | Type     | Description               |
|--------|----------|---------------------------|
| source | `number` | Player source identifier  |

#### Example
```lua
local jobs = CORE.get_player_jobs(source)
for _, job in pairs(jobs) do
    print("Job:", job)
end
```

---

### player_has_job(source, job_names, check_on_duty?)

Checks whether a player has one of the specified jobs. Optionally checks if they're on duty.

#### Parameters
| Name           | Type        | Description                                  |
|----------------|-------------|----------------------------------------------|
| source         | `number`    | Player source identifier                     |
| job_names      | `table`     | List of job names to check                   |
| check_on_duty  | `boolean?`  | Whether to require on-duty status            |

#### Example
```lua
local hasJob = CORE.player_has_job(source, { "police" }, true)
```

---

### get_player_job_grade(source, job_id)

Returns the player's rank (grade) for the specified job.

#### Parameters
| Name    | Type     | Description              |
|---------|----------|--------------------------|
| source  | `number` | Player source identifier |
| job_id  | `string` | Job ID to check          |

#### Example
```lua
local grade = CORE.get_player_job_grade(source, "police")
```

---

### count_players_by_job(job_names, check_on_duty?)

Counts players with a specific job. Optionally checks duty status.

#### Parameters
| Name           | Type        | Description                              |
|----------------|-------------|------------------------------------------|
| job_names      | `table`     | List of job names to count               |
| check_on_duty  | `boolean?`  | Whether to check for on-duty only        |

#### Example
```lua
local total, onduty = CORE.count_players_by_job({ "ambulance" }, true)
```

---

### get_player_job_name(source)

Returns the first job name assigned to a player.

#### Parameters
| Name   | Type     | Description               |
|--------|----------|---------------------------|
| source | `number` | Player source identifier  |

#### Example
```lua
local job = CORE.get_player_job_name(source)
```

---

### adjust_statuses(source, statuses)

Applies status modifications to a player server-side.

#### Parameters
| Name     | Type     | Description               |
|----------|----------|---------------------------|
| source   | `number` | Player source identifier  |
| statuses | `table`  | Table of status values    |

#### Example
```lua
CORE.adjust_statuses(source, { hunger = -10, thirst = -5 })
```

---

### register_item(item, cb)

Registers an item as usable and calls the callback on use.

#### Parameters
| Name  | Type       | Description                    |
|-------|------------|--------------------------------|
| item  | `string`   | Name of the usable item        |
| cb    | `function` | Function to run on item usage  |

#### Example
```lua
CORE.register_item("joint", function(source)
    print("Joint used by:", source)
end)
```

---

## Client

### get_data(key?)

Returns the full or partial player data table.

#### Parameters
| Name | Type     | Description                     |
|------|----------|---------------------------------|
| key  | `string` | (Optional) Specific key to get  |

#### Example
```lua
local data = CORE.get_data("identity")
```

---

### get_identity()

Returns a structured identity object.

#### Example
```lua
local id = CORE.get_identity()
print("Name:", id.first_name, id.last_name)
```

---

### get_player_id()

Returns the current player's unique identifier.

#### Example
```lua
local player_id = CORE.get_player_id()
```

---

## Notes

- This module is fully framework-agnostic
- The bridge loads only the file matching the current detected framework
- Provides a consistent API regardless of core (boii_core, esx, qb-core, etc)



