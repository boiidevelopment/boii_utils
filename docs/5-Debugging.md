## Debugging Module

The Debugging module provides lightweight logging tools with color-coded output and timestamping, useful for both client and server contexts.

---

### Accessing the Module

```lua
local DEBUG <const> = exports.boii_utils:get("modules.debugging")
```

---

## Shared

### get_current_time()

Returns the current formatted time string.

#### Returns

| Type     | Description                              |
|----------|------------------------------------------|
| `string` | Current time in "YYYY-MM-DD HH:MM:SS" format |

#### Example

```lua
local time = DEBUG.get_current_time()
DEBUG.print("info", "Current time:", time)
```

---

### print(level, message, data?)

Logs a formatted message to the console with a colored prefix and optional table data. Automatically detects and prints the name of the invoking resource.

#### Parameters

| Name    | Type       | Description                                                       |
|---------|------------|-------------------------------------------------------------------|
| level   | `string`   | The log level: `debug`, `info`, `success`, `warn`, `error`        |
| message | `string`   | The message string to print                                       |
| data?   | `table?`   | Optional table to JSON encode and append to the message           |

#### Example

```lua
DEBUG.print("info", "Loading complete")
DEBUG.print("error", "Something went wrong", { code = 500, reason = "Bad request" })
```

---

## Notes

- Colour levels follow standard FiveM color codes (e.g., `^1`, `^2`, etc.)
- Useful for debugging without external logging dependencies
- `print()` is available both server-side and client-side