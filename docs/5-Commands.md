## Commands Module

The Commands module provides a simple interface to register server commands with built-in permission checking and chat suggestions.

---

### Accessing the Module

```lua
local COMMANDS <const> = exports.boii_utils:get("modules.commands")
```

---

## Server

### register_command(command, required_rank, help, params, handler)

Registers a new server command.

#### Parameters

| Name          | Type             | Description                                                                 |
|---------------|------------------|-----------------------------------------------------------------------------|
| command       | `string`         | The command name to register (e.g., `"/kick"`).                             |
| required_rank | `string | table` | The rank(s) required to execute the command (e.g., `"admin"` or `{ "mod", "admin" }`). |
| help          | `string`         | Help text for the command (displayed in suggestions).                      |
| params        | `table`          | Array of parameter objects with `name` and `help` fields.                  |
| handler       | `function`       | Function to execute when the command is run. Signature: `function(source, args, raw)` |

#### Example

```lua
COMMANDS.register("announce", "admin", "Broadcast a message to all players", {
    { name = "message", help = "The message to broadcast" }
}, function(source, args, raw)
    local message = table.concat(args, " ")
    TriggerClientEvent("chat:addMessage", -1, {
        args = { "^3Announcement", message }
    })
end)
```

---

## Client

### get_chat_suggestions()

Requests the server to send updated chat suggestions to the client.

#### Parameters

| Name | Type | Description           |
|------|------|-----------------------|
| None | -    | This function takes no parameters. |

#### Example

```lua
COMMANDS.get_chat_suggestions()
```

---

## Notes

- Permission checking is handled server-side via `get_user().rank`
- Chat suggestions use FiveM's native `addSuggestion` event
- Suggestions must be manually refreshed if commands are registered after player joins
- `register_command` is server-side only
- `get_chat_suggestions` is client-side only