## Table Utility Module

Provides utility functions for working with tables, including printing, copying, comparison, and value checking.

---

### Accessing the Module

```lua
local TABLES <const> = exports.boii_utils:get("modules.tables")
```

---

## Shared

### print_table(t, indent)

Recursively prints the contents of a table to the console. Useful for debugging nested data.

#### Parameters
| Name   | Type     | Description                        |
|--------|----------|------------------------------------|
| t      | `table`  | The table to print                 |
| indent | `string` | (Optional) Indentation for nesting |

#### Example
```lua
TABLES.print({ hello = "world", nested = { foo = true } })
```

---

### table_contains(tbl, val)

Checks if a table contains a specific value.

#### Parameters
| Name | Type     | Description                       |
|------|----------|-----------------------------------|
| tbl  | `table`  | Table to search in                |
| val  | `any`    | Value to look for                 |

#### Example
```lua
local found = TABLES.contains({1, 2, {3}}, 3) -- true
```

---

### deep_copy(t)

Creates a deep copy of the given table.

#### Parameters
| Name | Type     | Description              |
|------|----------|--------------------------|
| t    | `table`  | Table to deep copy       |

#### Example
```lua
local original = { a = 1, nested = { b = 2 } }
local copy = TABLES.deep_copy(original)
```

---

### deep_compare(t1, t2)

Compares two tables deeply.

#### Parameters
| Name | Type     | Description         |
|------|----------|---------------------|
| t1   | `table`  | First table         |
| t2   | `table`  | Second table        |

#### Example
```lua
local is_same = TABLES.compare({ a = { b = 1 } }, { a = { b = 1 } }) -- true
```

---

## Notes

- These functions work on both flat and nested tables.
- `deep_copy` ensures references are not shared between the original and copied table.
- `deep_compare` checks keys and values recursively.