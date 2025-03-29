## Callbacks Module

The Callbacks module provides a standalone, framework-agnostic system for registering and triggering callbacks between the client and server.

---

### Accessing the Module

```lua
local CALLBACKS <const> = exports.boii_utils:get("modules.callbacks")
```

---

## Server

### register_callback(name, cb)

Registers a server-side callback that clients can trigger.

#### Parameters

| Name   | Type     | Description                                              |
|--------|----------|----------------------------------------------------------|
| name   | `string` | The unique identifier for the callback event.           |
| cb     | `function` | The function to execute when the callback is triggered. |

#### Example

```lua
CALLBACKS.register("get_server_time", function(source, data, cb)
    local response = {
        unix = os.time(),
        hour = GetClockHours()
    }
    cb(response)
end)
```

---

## Client

### trigger_callback(name, data, cb)

Triggers a server-side callback and handles the result asynchronously.

#### Parameters

| Name   | Type     | Description                                              |
|--------|----------|----------------------------------------------------------|
| name   | `string` | The event name to trigger.                              |
| data   | `table`  | Optional data to send to the server.                    |
| cb     | `function` | Callback function to handle the response. Signature: `function(response)` |

#### Example

```lua
CALLBACKS.trigger("get_server_time", nil, function(response)
    print("Unix time:", response.unix)
    print("In-game hour:", response.hour)
end)
```

---

## Notes

- `register_callback` is server-only  
- `trigger_callback` is client-only  
- Callback IDs are tracked internally and are safe to reuse  
- Input validation should always be handled on the server  
- This module is fully standalone and does not depend on any framework