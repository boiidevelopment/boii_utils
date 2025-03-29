## String Module

Provides utility functions for common string operations including casing, trimming, splitting, and generating random strings.

---

### Accessing the Module

```lua
local STRINGS <const> = exports.boii_utils:get("modules.strings")
```

---

## Shared

### capitalize(str)

Capitalizes the first letter of each word in the string.

#### Parameters
| Name | Type     | Description               |
|------|----------|---------------------------|
| str  | `string` | The string to capitalize  |

#### Example
```lua
local result = STRINGS.capitalize("hello world") -- "Hello World"
```

---

### random_string(length)

Generates a random alphanumeric string of a given length.

#### Parameters
| Name   | Type     | Description                      |
|--------|----------|----------------------------------|
| length | `number` | The desired length of the string |

#### Example
```lua
local id = STRINGS.random_string(8) -- e.g., "aZ82xY0p"
```

---

### split(str, delimiter)

Splits a string into parts using a given delimiter.

#### Parameters
| Name      | Type     | Description                    |
|-----------|----------|--------------------------------|
| str       | `string` | The string to split            |
| delimiter | `string` | The delimiter to split on      |

#### Example
```lua
local parts = STRINGS.split("one,two,three", ",") -- parts = {"one", "two", "three"}
```

---

### trim(str)

Trims whitespace from both ends of the string.

#### Parameters
| Name | Type     | Description               |
|------|----------|---------------------------|
| str  | `string` | The string to trim        |

#### Example
```lua
local clean = STRINGS.trim("  hello world  ") -- "hello world"
```

---

## Notes

- All functions are pure and return new values.
- Intended to support clean, minimal string manipulation throughout other modules.