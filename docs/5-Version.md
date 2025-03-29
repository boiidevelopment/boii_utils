## Vehicles Module

Provides utilities for inspecting, modifying, and spawning vehicles with customization support.

---

### Accessing the Module

```lua
local VEHICLES <const> = exports.boii_utils:get("modules.vehicles")
```

---

## Client

### check_version(opts)

Checks the version of a resource against the latest version on GitHub.

#### Parameters
| Name           | Type   | Description                                                                 |
|----------------|--------|-----------------------------------------------------------------------------|
| opts           | `table`| Configuration table containing:                                            |
| └ resource_name| `string`| The resource name (optional, defaults to current resource)                 |
| └ url_path     | `string`| Path to the versions JSON file on GitHub                                   |
| └ callback     | `function`| Callback function receiving `(success, current_version, latest_version, notes)` |

#### Example
```lua
local options = {
    resource_name = 'my_resource',
    url_path = 'myuser/myrepo/refs/heads/main/versions.json',
    callback = function(success, current, latest, notes)
        if success then
            print('Up to date!')
        else
            print('Outdated:', notes)
        end
    end
}

VERSION.check(options)
```

---

### Notes
- Version format must follow semantic versioning: `MAJOR.MINOR.PATCH`
- Requires `version` entry to be set in `fxmanifest.lua` using `version 'x.y.z'`