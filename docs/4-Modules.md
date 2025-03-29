# 4 - Modules

The library is devided into useful `modules` you can import into your resource through the export `exports.boii_utils:get(...)`.

A CFX friendly require function has been included into the `init.lua` to handle overriding the default require function.

# Available Modules

Below is a quick list of all current available modules and a brief description of what the module can do.
For more detailed instructions on whats available in each module view **5-API-Reference.md**

## Bridges

Bridges allow seamless integration with multiple resources through a single API, reducing the need for writing framework-specific code.  
They detect available resources and route accordingly, making scripts more flexible and future-proof.

- **Framework Bridge:** Supported by default; `"esx", "boii_core", "nd", "ox", "qb", "qbx"`.
- **DrawText UI Bridge:** Supported by default; `"default", "boii", "esx", "okok", "ox", "qb"`.
- **Notifications Bridge:** Supported by default; `"default", "boii", "esx", "okok", "ox", "qb"`.

## Standalone Replacement Systems

These systems are designed to replace framework-locked features, allowing resources to function independently of any specific core.  
They also provide a solution for supporting servers that lack certain mechanics.

- **Callbacks:** Unified callback system to replace framework-specific handlers.  
- **Commands:** Database-based command system with configurable permissions.  
- **Item Registry:** Standalone item system for managing usable items.  
- **Licence System:** Full licence handling, including theory/practical tests, points, and revocation.  
- **Player XP:** Leveling and experience system with growth factors and max levels.

## Other Modules

- **Characters:** A unique module covering everything related to character creation/customisation, including shared styles data.
- **Cooldowns:** Allows for setting player-specific, resource-based, or global cooldowns throughout the game world.
- **Debugging:** A set of useful debugging functions to aid development and troubleshooting.
- **Entities:** Covers everything related to entities (NPCs, vehicles, objects) within the game world.
- **Environment:** Functions to handle environmental elements such as time, weather, and simulated seasons.
- **Geometry:** A suite of functions to simplify geometric calculations in both 2D and 3D space.
- **Keys:** Provides a full static key list and functions for retrieving keys by name or value.
- **Maths:** Extends base `math.` functionality with additional useful mathematical functions.
- **Player:** Includes various player-related functions such as retrieving the player's cardinal direction or playing animations with prop support.
- **Requests:** Wrapper functions around CFX `Request` functions to simplify resource requests.
- **Strings:** Extends base `string.` functionality by adding additional helper functions.
- **Tables:** Enhances base `table.` functionality by providing additional utility functions.
- **Timestamps:** Handles everything related to server-side timestamps with formatted responses.
- **Vehicles:** A comprehensive suite of vehicle-related functions, covering all aspects needed for a vehicle customization system.
- **Version:** Provides resource version checking from an externally hosted `.json` file.

# Importing Modules

You can use the following methods in client/server/shared files to access the modules:

## Exports

```lua
local CALLBACKS <const> = exports.boii_utils:get("modules.callbacks")
```

## get(...)

Adding `@boii_utils/init.lua` into your `fxmanifest.lua` will allow access to the librarys `get(...)` function.
You can add this into any context where it is required however for ease of use `shared_script "@boii_utils/init.lua"` is usually the best path.

```lua
local CALLBACKS <const> = get("modules.callbacks")
```

# Using Modules

Once you have imported a module it is ready to be used.
Below is a quick example of using the `callbacks` module. 

## Server

```lua
local CALLBACKS <const> = exports.boii_utils:get("modules.callbacks")

CALLBACKS.register("some_event_name", function(source, data, cb)
    if source == 0 then 
        cb(false, "Callback must be triggered by a player!")
        return
    end
    cb(true, "Callback successful!")
end)
```

## Client

```lua
local CALLBACKS <const> = exports.boii_utils:get("modules.callbacks")

CALLBACKS.trigger("some_event_name", nil, function(success, message)
    local success_text = success and "Success!" or "Failed!"
    print(("Callback %s Message: %s"):format(success_text, message)) 
    -- Output: "Callback Success! Message: Callback successful!" or "Callback Failed! Message: Callback must be triggered by a player!
end)
```

# Get Modules

```lua
exports.boii_utils:get("modules.core") -- Framework Bridge
exports.boii_utils:get("modules.notifications") -- Notifications Bridge
exports.boii_utils:get("modules.drawtext") -- DrawText UI Bridge
exports.boii_utils:get("modules.callbacks") -- Callbacks System
exports.boii_utils:get("modules.characters") -- Character Customisation
exports.boii_utils:get("modules.commands") -- Commands System
exports.boii_utils:get("modules.debugging") -- Debugging Utilities
exports.boii_utils:get("modules.entities") -- Entity Management
exports.boii_utils:get("modules.environment") -- Environment Functions
exports.boii_utils:get("modules.geometry") -- Geometry Calculations
exports.boii_utils:get("modules.items") -- Item Registry
exports.boii_utils:get("modules.keys") -- Key Management
exports.boii_utils:get("modules.licences") -- Licence System
exports.boii_utils:get("modules.maths") -- Extended Maths Functions
exports.boii_utils:get("modules.player") -- Player Utilities
exports.boii_utils:get("modules.requests") -- Request Handlers
exports.boii_utils:get("modules.strings") -- Extended String Functions
exports.boii_utils:get("modules.tables") -- Extended Table Functions
exports.boii_utils:get("modules.timestamps") -- Timestamp Utilities
exports.boii_utils:get("modules.vehicles") -- Vehicle Management
exports.boii_utils:get("modules.version") -- Version Checking
exports.boii_utils:get("modules.xp") -- XP System
```