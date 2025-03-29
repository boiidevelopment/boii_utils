## UI Bridges Module

Provides a unified API for handling DrawText UI and Notifications across multiple FiveM resources. Automatically routes to the appropriate underlying implementation based on what's active.

---

### Accessing the Module
```lua
local DRAWTEXT <const> = exports.boii_utils:get("modules.drawtext")
local NOTIFY <const> = exports.boii_utils:get("modules.notifications")
```

---

## Server

### drawtext.show(source, options)
Displays drawtext UI for a specific client.

#### Parameters
| Name    | Type     | Description                         |
|---------|----------|-------------------------------------|
| source  | `number` | Player server ID                    |
| options | `table`  | Drawtext options                    |
| └ message | `string` | Text message to display             |
| └ icon    | `string` | Optional icon (depends on system)  |

#### Example
```lua
DRAWTEXT.show(1, { message = "Hello, player!", icon = "info" })
```

---

### drawtext.hide(source)
Hides drawtext UI for a specific client.

#### Parameters
| Name   | Type     | Description         |
|--------|----------|---------------------|
| source | `number` | Player server ID    |

#### Example
```lua
DRAWTEXT.hide(1)
```

---

### notifications.send(source, options)
Sends a notification to a specific client.

#### Parameters
| Name    | Type     | Description                        |
|---------|----------|------------------------------------|
| source  | `number` | Player server ID                   |
| options | `table`  | Notification options               |
| └ type    | `string` | Notification type (e.g., info)     |
| └ message | `string` | Notification message               |
| └ duration| `number` | Duration in ms                     |

#### Example
```lua
NOTIFY.send(1, { type = "info", message = "You received $500", duration = 5000 })
```

---

## Client

### drawtext.show(options)
Displays drawtext UI locally on the client.

#### Parameters
| Name    | Type     | Description                        |
|---------|----------|------------------------------------|
| options | `table`  | Drawtext options                   |
| └ message | `string` | Text message to display            |
| └ icon    | `string` | Optional icon                      |

#### Example
```lua
DRAWTEXT.show({ message = "Press E to interact", icon = "info" })
```

---

### drawtext.hide()
Hides the drawtext UI locally on the client.

#### Example
```lua
DRAWTEXT.hide()
```

---

### notifications.send(options)
Displays a notification on the client.

#### Parameters
| Name    | Type     | Description                        |
|---------|----------|------------------------------------|
| options | `table`  | Notification options               |
| └ type    | `string` | Notification type (e.g., success)  |
| └ message | `string` | Notification message               |
| └ duration| `number` | Duration in ms                     |

#### Example
```lua
NOTIFY.send({ type = "success", message = "Mission Complete!", duration = 3000 })
```