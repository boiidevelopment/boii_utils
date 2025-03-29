## Usable Items Module

Provides a way to register and trigger usable item logic server-side. This module allows developers to define behavior when an item is used in-game.

---

### Accessing the Module

```lua
local ITEMS <const> = exports.boii_utils:get("modules.items")
```

---

## Server

### register_item(item_id, use_function)

Registers an item as usable. When the item is used, the callback function will be invoked with the source and item ID.

#### Parameters
| Name         | Type       | Description                              |
|--------------|------------|------------------------------------------|
| item_id      | `string`   | The item identifier                      |
| use_function | `function` | The function to call on item usage       |

#### Example
```lua
ITEMS.register_item("firstaid", function(source, item_id)
    print("Used item:", item_id, "by player:", source)
end)
```

---

### use_item(source, item_id)

Triggers a previously registered usable item for the player.

#### Parameters
| Name    | Type     | Description                   |
|---------|----------|-------------------------------|
| source  | `number` | The player source identifier  |
| item_id | `string` | The item identifier to use    |

#### Example
```lua
ITEMS.use_item(source, "firstaid")
```

---

## Notes

- Items must be registered with `register_item` before they can be used.
- If an item is not registered, using it will print a warning in the console.
- This module is server-only.