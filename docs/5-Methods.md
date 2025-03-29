# Methods Module API

The `methods` module provides a system to register, remove, and trigger custom method callbacks on both the client and server. 
These are useful for extending resource behavior without modifying the core logic.

---

### Accessing the Module

```lua
local METHODS <const> = exports.boii_utils:get("modules.methods")
```

---

## Shared

### add_method(event_name, cb, options?)
Adds a method callback to a specific event.

#### Parameters
| Name         | Type     | Description                               |
|--------------|----------|-------------------------------------------|
| event_name   | string   | Name of the event to hook into.           |
| cb           | function | Function to call when the event triggers. |
| options?     | table    | Optional table for method filtering/data. |

#### Returns
| Type   | Description                       |
|--------|-----------------------------------|
| number | ID of the method for later removal. |

#### Example
```lua
METHODS.add("on_some_event", function(data)
    if data.thing == "important" then
        print("Handled important thing")
    end
end)
```

---

### remove_method(event_name, id)
Removes a method callback from an event.

#### Parameters
| Name       | Type   | Description                        |
|------------|--------|------------------------------------|
| event_name | string | The event name to remove from.     |
| id         | number | ID returned from `add_method()`.   |

#### Example
```lua
local id = METHODS.add("custom_event", function(data) end)
METHODS.remove("custom_event", id)
```

---

### trigger_method(event_name, response)
Triggers all registered methods for an event. If any method returns `false`, execution halts.

#### Parameters
| Name       | Type   | Description                               |
|------------|--------|-------------------------------------------|
| event_name | string | The event to trigger.                     |
| response   | table  | The table passed to all method callbacks. |

#### Returns
| Type    | Description                         |
|---------|-------------------------------------|
| boolean | `false` if any callback returned `false`, otherwise `true`. |

#### Example
```lua
local allowed = METHODS.trigger("check_permissions", { player = source })
if not allowed then return end
```