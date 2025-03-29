## Maths Module

Provides mathematical utility functions not covered by Lua's built-in math library.

---

### Accessing the Module

```lua
local MATHS <const> = exports.boii_utils:get("modules.maths")
```

---

## Shared

### round(number, decimals)
Rounds a number to a specified number of decimal places.

#### Parameters
| Name     | Type     | Description                        |
|----------|----------|------------------------------------|
| number   | `number` | The number to round                |
| decimals | `number` | Number of decimal places to round to |

#### Example
```lua
local result = MATHS.round(3.14159, 2) -- 3.14
```

---

### calculate_distance(start_coords, end_coords)
Calculates the 3D distance between two points.

#### Parameters
| Name         | Type    | Description                  |
|--------------|---------|------------------------------|
| start_coords | `table` | Start point `{x, y, z}`      |
| end_coords   | `table` | End point `{x, y, z}`        |

#### Example
```lua
local dist = MATHS.calculate_distance({x=0,y=0,z=0}, {x=3,y=4,z=0}) -- 5.0
```

---

### clamp(val, lower, upper)
Clamps a number within a given range.

#### Parameters
| Name  | Type     | Description           |
|-------|----------|-----------------------|
| val   | `number` | Value to clamp        |
| lower | `number` | Minimum value         |
| upper | `number` | Maximum value         |

#### Example
```lua
local result = MATHS.clamp(15, 0, 10) -- 10
```

---

### lerp(a, b, t)
Performs linear interpolation between two numbers.

#### Parameters
| Name | Type     | Description                    |
|------|----------|--------------------------------|
| a    | `number` | Start value                    |
| b    | `number` | End value                      |
| t    | `number` | Interpolation factor (0.0-1.0) |

#### Example
```lua
local result = MATHS.lerp(0, 100, 0.5) -- 50
```

---

### factorial(n)
Calculates the factorial of a number.

#### Parameters
| Name | Type     | Description         |
|------|----------|---------------------|
| n    | `number` | Number to factorial |

#### Example
```lua
local fact = MATHS.factorial(5) -- 120
```

---

### deg_to_rad(deg)
Converts degrees to radians.

#### Parameters
| Name | Type     | Description        |
|------|----------|--------------------|
| deg  | `number` | Angle in degrees   |

#### Example
```lua
local rad = MATHS.deg_to_rad(180) -- 3.1415...
```

---

### rad_to_deg(rad)
Converts radians to degrees.

#### Parameters
| Name | Type     | Description        |
|------|----------|--------------------|
| rad  | `number` | Angle in radians   |

#### Example
```lua
local deg = MATHS.rad_to_deg(math.pi) -- 180
```

---

### circle_circumference(radius)
Returns circumference of a circle.

#### Parameters
| Name   | Type     | Description     |
|--------|----------|-----------------|
| radius | `number` | Radius of circle|

#### Example
```lua
local circ = MATHS.circle_circumference(10) -- 62.83...
```

---

### circle_area(radius)
Returns area of a circle.

#### Parameters
| Name   | Type     | Description     |
|--------|----------|-----------------|
| radius | `number` | Radius of circle|

#### Example
```lua
local area = MATHS.circle_area(5) -- 78.539...
```

---

### triangle_area(p1, p2, p3)
Calculates area of triangle from 2D points.

#### Parameters
| Name | Type    | Description        |
|------|---------|--------------------|
| p1   | `table` | Point `{x, y}`     |
| p2   | `table` | Point `{x, y}`     |
| p3   | `table` | Point `{x, y}`     |

#### Example
```lua
local area = MATHS.triangle_area(p1, p2, p3)
```

---

### mean(numbers)
Returns average of number list.

#### Parameters
| Name    | Type     | Description         |
|---------|----------|---------------------|
| numbers | `table`  | List of numbers     |

#### Example
```lua
local avg = MATHS.mean({1,2,3,4,5}) -- 3
```

---

### median(numbers)
Returns median of list.

#### Parameters
| Name    | Type     | Description         |
|---------|----------|---------------------|
| numbers | `table`  | List of numbers     |

#### Example
```lua
local m = MATHS.median({5, 2, 1, 4, 3}) -- 3
```

---

### mode(numbers)
Returns most frequent number.

#### Parameters
| Name    | Type     | Description         |
|---------|----------|---------------------|
| numbers | `table`  | List of numbers     |

#### Example
```lua
local m = MATHS.mode({1, 2, 2, 3, 4}) -- 2
```

---

### standard_deviation(numbers)
Returns standard deviation.

#### Parameters
| Name    | Type     | Description         |
|---------|----------|---------------------|
| numbers | `table`  | List of numbers     |

#### Example
```lua
local std = MATHS.standard_deviation({1,2,3,4,5})
```

---

### linear_regression(points)
Returns slope + intercept for set of 2D points.

#### Parameters
| Name   | Type    | Description                   |
|--------|---------|-------------------------------|
| points | `table` | List of `{x, y}` points       |

#### Example
```lua
local result = MATHS.linear_regression({{x=1,y=2},{x=2,y=4},{x=3,y=6}})
print(result.slope, result.intercept)
```

---

## Notes

- Designed for use in any context where extra mathematical utilities are needed.
- Operates only on raw tables and primitive types.
- Does not modify input tables.