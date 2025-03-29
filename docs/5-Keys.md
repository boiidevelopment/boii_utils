## Keys Module

Provides functions for working with key names and codes.

---

### Accessing the Module

```lua
local KEYS <const> = exports.boii_utils:get("modules.keys")
```

---

## Shared

### get_keys()

Returns the full key list as a table.

#### Parameters
_None_

#### Returns
- `table`: A mapping of key names to key codes.

#### Example
```lua
local all_keys = KEYS.get_keys()
print(all_keys["e"]) -- 46
```

---

### get_key(key_name)

Gets the key code for a given key name.

#### Parameters
| Name      | Type     | Description              |
|-----------|----------|--------------------------|
| key_name  | `string` | Name of the key (e.g. "e")|

#### Returns
- `number|nil`: Key code if found, or `nil` if not.

#### Example
```lua
local code = KEYS.get_key("f")
if code then
    print("Key code for F is:", code)
end
```

---

### get_key_name(key_code)

Gets the key name for a given key code.

#### Parameters
| Name      | Type     | Description               |
|-----------|----------|---------------------------|
| key_code  | `number` | The code to look up       |

#### Returns
- `string|nil`: The key name if found, or `nil` if not.

#### Example
```lua
local name = KEYS.get_key_name(244)
if name then
    print("Key 244 is:", name)
end
```

---

### print_key_list()

Prints the full list of key names and codes to the console.

#### Parameters
_None_

#### Returns
_None_

#### Example
```lua
KEYS.print_key_list()
```

---

### key_exists(key_name)

Checks if a given key name exists in the key table.

#### Parameters
| Name      | Type     | Description               |
|-----------|----------|---------------------------|
| key_name  | `string` | Key name to check         |

#### Returns
- `boolean`: `true` if the key exists, `false` otherwise.

#### Example
```lua
if KEYS.key_exists("enter") then
    print("Enter key exists")
end
```

---

## Notes

- Key names are lowercase and must match exactly.
- Used for input checks, mappings, or control setups in scripts.