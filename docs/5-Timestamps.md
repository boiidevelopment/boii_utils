## Timestamps Module

Provides utility functions for working with date, time, and UNIX timestamps.

---

### Accessing the Module

```lua
local TIMESTAMPS <const> = exports.boii_utils:get("modules.timestamps")
```

---

## Server

### get_timestamp()

Gets the current UNIX timestamp and its formatted string.

#### Returns
| Name       | Type    | Description                       |
|------------|---------|-----------------------------------|
| timestamp  | number  | Current UNIX timestamp            |
| formatted  | string  | Formatted date-time string        |

#### Example
```lua
local time = TIMESTAMPS.get_timestamp()
print(time.timestamp)  -- 1700000000
print(time.formatted)  -- "2025-03-29 18:00:00"
```

---

### convert_timestamp(timestamp)

Converts a UNIX timestamp to a readable date and time.

#### Parameters
| Name      | Type   | Description            |
|-----------|--------|------------------------|
| timestamp | number | UNIX timestamp to convert |

#### Returns
| Name   | Type   | Description            |
|--------|--------|------------------------|
| date   | string | Date in `YYYY-MM-DD`   |
| time   | string | Time in `HH:MM:SS`     |
| both   | string | Full datetime string   |

#### Example
```lua
local result = TIMESTAMPS.convert_timestamp(os.time())
print(result.both) -- "2025-03-29 18:00:00"
```

---

### get_current_date_time()

Gets the current full date and time information.

#### Returns
| Name       | Type    | Description                |
|------------|---------|----------------------------|
| timestamp  | number  | UNIX timestamp             |
| date       | string  | `YYYY-MM-DD`               |
| time       | string  | `HH:MM:SS`                 |
| both       | string  | Full formatted string      |

#### Example
```lua
local now = TIMESTAMPS.get_current_date_time()
print(now.date, now.time)
```

---

### add_days_to_date(date, days)

Adds days to a given date.

#### Parameters
| Name  | Type   | Description                    |
|-------|--------|--------------------------------|
| date  | string | Base date in `YYYY-MM-DD`      |
| days  | number | Number of days to add          |

#### Returns
| Type   | Description               |
|--------|---------------------------|
| string | New date in `YYYY-MM-DD` |

#### Example
```lua
local new_date = TIMESTAMPS.add_days_to_date("2025-03-29", 7)
print(new_date) -- "2025-04-05"
```

---

### date_difference(start_date, end_date)

Calculates the number of days between two dates.

#### Parameters
| Name        | Type   | Description               |
|-------------|--------|---------------------------|
| start_date  | string | Start date `YYYY-MM-DD`   |
| end_date    | string | End date `YYYY-MM-DD`     |

#### Returns
| Name | Type   | Description                  |
|------|--------|------------------------------|
| days | number | Absolute difference in days  |

#### Example
```lua
local diff = TIMESTAMPS.date_difference("2025-03-01", "2025-03-29")
print(diff.days) -- 28
```

---

### convert_timestamp_ms(timestamp_ms)

Converts a millisecond-based UNIX timestamp to human-readable format.

#### Parameters
| Name         | Type   | Description                     |
|--------------|--------|---------------------------------|
| timestamp_ms | number | UNIX timestamp in milliseconds  |

#### Returns
| Name   | Type   | Description            |
|--------|--------|------------------------|
| date   | string | `YYYY-MM-DD`           |
| time   | string | `HH:MM:SS`             |
| both   | string | Full formatted string  |

#### Example
```lua
local readable = TIMESTAMPS.convert_timestamp_ms(1700000000000)
print(readable.both) -- "2025-03-29 18:00:00"
```

---

## Notes

- Dates must be in `YYYY-MM-DD` format.
- All functions return deterministic, formatted Lua date values.
- Useful for logs, cooldowns, time calculations, and expirations.