# 3 - Configuration

Configuration for the library is primary handled through convars.
If you are unsure on how convars work view the CFX documentation here: https://docs.fivem.net/docs/scripting-reference/convars/

Some configuration options do have manual overrides, you can find these under `ENV` in `init.lua`

## Environment Variables

```lua
ENV = setmetatable({
    --- @section Cache

    DATA = {},
    MODULES = {},

    --- @section Natives

    RESOURCE_NAME = GetCurrentResourceName(),
    IS_SERVER = IsDuplicityVersion(),

    --- @section User Registry

    DEFFERAL_UPDATE_MESSAGES = GetConvar("utils:deferals_updates", "true") == "true", -- Defferal connection messages, disable with convars.
    UNIQUE_ID_PREFIX = GetConvar("utils:unique_id_prefix", "USER_"), -- Prefix is combined with digits below to create a unique id e.g, "USER_12345"
    UNIQUE_ID_CHARS = GetConvar("utils:unique_id_chars", "5"), -- Amount of random characters to use after prefix e.g, "ABC12"

    --- @section Framework Bridge

    --- Supported Frameworks: If you have changed the name of your core resource folder update it here.
    FRAMEWORKS = {
        -- If you use multiple cores you can adjust the priority loading order by changed the arrangement here.
        { key = "boii_core", resource = "boii_core" },
        { key = "esx", resource = "es_extended" },
        { key = "nd", resource = "ND_Core" },
        { key = "ox", resource = "ox_core" },
        { key = "qb", resource = "qb-core" },
        { key = "qbx", resource = "qbx_core" },
    },
    AUTO_DETECT_FRAMEWORK = true, -- If true FRAMEWORK convar setting will be overwritten with auto detection.
    FRAMEWORK = GetConvar("utils:framework", "standalone"), -- This should not be changed, set up convars correctly and change there if needed.

    --- @section UI Bridges

    --- Supported DrawText UIs: If you have changed the name of a resource folder update it here.
    DRAWTEXTS = {
        -- If you use multiple drawtext resource you can adjust the priority loading order by changed the arrangement here.
        { key = "boii", resource = "boii_ui" },
        { key = "esx", resource = "es_extended" },
        { key = "okok", resource = "okokTextUi" },
        { key = "ox", resource = "ox_lib" },
        { key = "qb", resource = "qb-core" }
    },
    AUTO_DETECT_DRAWTEXT = true, -- If true DRAWTEXT convar setting will be overwritten with auto detection.
    DRAWTEXT = GetConvar("utils:drawtext_ui", "default"), -- This should not be changed, set up convars correctly and change there if needed.

    --- Supported Notifys: If you have changed the name of a resource folder update it here.
    NOTIFICATIONS = {
        -- If you use multiple notify resources you can adjust the priority loading order by changed the arrangement here.
        { key = "boii", resource = "boii_ui" },
        { key = "esx", resource = "es_extended" },
        { key = "okok", resource = "okokNotify" },
        { key = "ox", resource = "ox_lib" },
        { key = "qb", resource = "qb-core" }
    },
    AUTO_DETECT_NOTIFY = true, -- If true NOTIFY convar setting will be overwritten with auto detection.
    NOTIFY = GetConvar("utils:notify", "default"), -- This should not be changed, set up convars correctly and change there if needed.

    --- @section Timers

    CLEAR_EXPIRED_COOLDOWNS = 5 -- Timer to clear expired cooldowns from cache in mins; default 5mins.

}, { __index = _G })
```

## Convars

You can add the following convars into your `server.cfg` to have further control over the library.  
Since many people seem to misunderstand how to configure these, default values are included to prevent misconfiguration.

### Manual Framework Control
You can manually specify the framework with the following convar:

```bash
setr utils:framework "standalone" # Replace "standalone" with "boii_core", "esx", "nd", "ox", "qb", or "qbx".
```

- If set, this will override auto-detection (`AUTO_DETECT_FRAMEWORK`).
- If left unset, the system will attempt to auto-detect the framework.

### Deferals Update Messages
Control whether deferal messages (e.g., connection checks, bans, etc.) are updated during login.

```bash
setr utils:deferals_updates "true" # Set to "false" to disable.
```

- If true, deferal messages update dynamically during login.
- If false, only the initial message will display.

### Unique ID Generation
Control how unique player IDs are generated.

```bash
setr utils:unique_id_prefix "USER_" # Prefix for generated unique IDs.
setr utils:unique_id_chars "5" # Number of random characters in the ID.
```

- Example Output: `USER_ABC12`
- `unique_id_prefix`: Set a custom prefix for player IDs.
- `unique_id_chars`: Defines the number of random letters/numbers after the prefix.

### DrawText UI Selection
Choose which DrawText UI the library should use.

```bash
setr utils:drawtext_ui "default" # Options: "default", "boii", "esx", "okok", "ox", "qb".
```

- If unset, defaults to `"default"`.

### Notification System Selection
Choose which notification system to use.

```bash
setr utils:notify "default" # Options: "default", "boii", "esx", "okok", "ox", "qb".
```

- If unset, defaults to `"default"`.

### Cooldown Cleanup Timer
Set how often expired cooldowns are removed from the cache.

```bash
setr utils:clear_expired_cooldowns "5" # Default: 5 minutes.
```