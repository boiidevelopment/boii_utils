# 5 - API Cooldowns

The **Cooldowns module** provides a **standalone** system to handle **player, global, and resource-based cooldowns**. This ensures actions have enforced delays between executions.

# Server

## add_cooldown(source, cooldown_type, duration, is_global)
Adds a cooldown for a player, globally, or for a specific resource.

### Parameters:
- **source** *(number)* - The player's server ID (or identifier for non-global cooldowns).
- **cooldown_type** *(string)* - The cooldown category (e.g., "begging").
- **duration** *(number)* - Duration of the cooldown in **seconds**.
- **is_global** *(boolean)* - `true` for global cooldown, `false` for player-specific cooldown.

### Example Usage:
```lua
local COOLDOWNS = exports.boii_utils:get("modules.cooldowns")
COOLDOWNS.add(1, "begging", 60, false) -- Adds a 60s cooldown for player 1
```

---

## check_cooldown(source, cooldown_type, is_global)
Checks if a cooldown is active for a player or globally.

### Parameters:
- **source** *(number)* - The player's server ID.
- **cooldown_type** *(string)* - The cooldown category.
- **is_global** *(boolean)* - `true` for global cooldown, `false` for player-specific cooldown.

### Returns:
- *(boolean)* - `true` if cooldown is active, `false` otherwise.

### Example Usage:
```lua
if COOLDOWNS.check(1, "begging", false) then
    print("Player is on cooldown.")
end
```

---

## clear_cooldown(source, cooldown_type, is_global)
Clears an active cooldown for a player or globally.

### Parameters:
- **source** *(number)* - The player's server ID.
- **cooldown_type** *(string)* - The cooldown category.
- **is_global** *(boolean)* - `true` for global cooldown, `false` for player-specific cooldown.

### Example Usage:
```lua
COOLDOWNS.clear(1, "begging", false) -- Removes cooldown for player 1
```

---

## clear_expired_cooldowns()
Removes all expired cooldowns automatically.

### Example Usage:
```lua
COOLDOWNS.clear_expired_cooldowns()
```

---

## clear_resource_cooldowns(resource_name)
Clears all cooldowns set by a specific resource.

### Parameters:
- **resource_name** *(string)* - The name of the resource.

### Example Usage:
```lua
COOLDOWNS.clear_resource_cooldowns("some_resource")
```