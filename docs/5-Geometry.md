## Geometry Module

Provides utility functions for performing geometric and spatial calculations in 2D and 3D environments.

---

### Accessing the Module

```lua
local GEOMETRY <const> = exports.boii_utils:get("modules.geometry")
```

---

### distance_2d(p1, p2)
Calculates the distance between two 2D points.

#### Parameters
| Name | Type   | Description                     |
|------|--------|---------------------------------|
| p1   | `table`| First point `{x, y}`            |
| p2   | `table`| Second point `{x, y}`           |

#### Example
```lua
local d = GEOMETRY.distance_2d({x = 0, y = 0}, {x = 3, y = 4})
-- d = 5
```

---

### distance_3d(p1, p2)
Calculates the distance between two 3D points.

#### Parameters
| Name | Type   | Description                     |
|------|--------|---------------------------------|
| p1   | `table`| First point `{x, y, z}`         |
| p2   | `table`| Second point `{x, y, z}`        |

#### Example
```lua
local d = GEOMETRY.distance_3d({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 10})
-- d = 10
```

---

### midpoint(p1, p2)
Returns the midpoint between two 3D points.

#### Parameters
| Name | Type   | Description                     |
|------|--------|---------------------------------|
| p1   | `table`| First point `{x, y, z}`         |
| p2   | `table`| Second point `{x, y, z}`        |

#### Example
```lua
local mid = GEOMETRY.midpoint({x = 0, y = 0, z = 0}, {x = 4, y = 4, z = 4})
-- mid = {x = 2, y = 2, z = 2}
```

---

### is_point_in_rect(point, rect)
Checks if a point is within a 2D rectangle.

#### Parameters
| Name  | Type   | Description                                  |
|-------|--------|----------------------------------------------|
| point | `table`| The point `{x, y}`                           |
| rect  | `table`| The rectangle `{x, y, width, height}`       |

#### Example
```lua
local inside = GEOMETRY.is_point_in_rect({x = 5, y = 5}, {x = 0, y = 0, width = 10, height = 10})
-- inside = true
```

---

### is_point_in_box(point, box)
Checks if a 3D point is within a box.

#### Parameters
| Name  | Type   | Description                                 |
|-------|--------|---------------------------------------------|
| point | `table`| The point `{x, y, z}`                        |
| box   | `table`| The box `{x, y, z, width, height, depth}`   |

#### Example
```lua
local inside = GEOMETRY.is_point_in_box({x = 2, y = 2, z = 2}, {x = 0, y = 0, z = 0, width = 5, height = 5, depth = 5})
```

---

### is_point_on_line_segment(point, line_start, line_end)
Checks if a 2D point lies on a line segment.

#### Parameters
| Name       | Type   | Description                  |
|------------|--------|------------------------------|
| point      | `table`| The point `{x, y}`           |
| line_start | `table`| Line segment start `{x, y}`  |
| line_end   | `table`| Line segment end `{x, y}`    |

#### Example
```lua
local result = GEOMETRY.is_point_on_line_segment({x = 2, y = 2}, {x = 0, y = 0}, {x = 4, y = 4})
```

---

### project_point_on_line(p, p1, p2)
Projects a point onto a 2D line segment.

#### Parameters
| Name | Type   | Description             |
|------|--------|-------------------------|
| p    | `table`| Point `{x, y}`          |
| p1   | `table`| Line start `{x, y}`     |
| p2   | `table`| Line end `{x, y}`       |

#### Example
```lua
local projected = GEOMETRY.project_point_on_line({x = 3, y = 4}, {x = 0, y = 0}, {x = 5, y = 0}) -- projected = {x = 3, y = 0}
```

---

### calculate_slope(p1, p2)
Calculates the slope of a line between two 2D points.

#### Parameters
| Name | Type   | Description        |
|------|--------|--------------------|
| p1   | `table`| First point `{x,y}`|
| p2   | `table`| Second point `{x,y}`|

#### Example
```lua
local slope = GEOMETRY.calculate_slope({x = 1, y = 2}, {x = 4, y = 6}) -- slope = 1.333
```

### angle_between_points(p1, p2)

Returns the angle between two 2D points in degrees.

#### Parameters
| Name | Type   | Description                  |
|------|--------|------------------------------|
| p1   | `table` | The first point `{x, y}`     |
| p2   | `table` | The second point `{x, y}`    |

#### Example
```lua
local angle = GEOMETRY.angle_between_points({ x = 0, y = 0 }, { x = 1, y = 1 })
```

---

### angle_between_3_points(p1, p2, p3)

Calculates the angle between three 3D points (with `p2` as the vertex).

#### Parameters
| Name | Type   | Description                 |
|------|--------|-----------------------------|
| p1   | `table` | First point `{x, y, z}`     |
| p2   | `table` | Center/vertex point `{x, y, z}` |
| p3   | `table` | Third point `{x, y, z}`     |

#### Example
```lua
local angle = GEOMETRY.angle_between_3_points(p1, p2, p3)
```

---

### do_circles_intersect(c1_center, c1_radius, c2_center, c2_radius)

Checks if two 2D circles intersect.

#### Parameters
| Name        | Type    | Description                       |
|-------------|---------|-----------------------------------|
| c1_center   | `table` | Center of first circle `{x, y}`   |
| c1_radius   | `number` | Radius of first circle            |
| c2_center   | `table` | Center of second circle `{x, y}`  |
| c2_radius   | `number` | Radius of second circle           |

#### Example
```lua
local result = GEOMETRY.do_circles_intersect({ x = 0, y = 0 }, 5, { x = 3, y = 0 }, 5)
```

---

### is_point_in_circle(point, circle_center, circle_radius)

Checks if a 2D point is inside a circle.

#### Parameters
| Name          | Type    | Description                     |
|---------------|---------|---------------------------------|
| point         | `table` | The point to check `{x, y}`     |
| circle_center | `table` | Circle center `{x, y}`          |
| circle_radius | `number` | Radius of the circle            |

#### Example
```lua
local inside = GEOMETRY.is_point_in_circle({ x = 2, y = 2 }, { x = 0, y = 0 }, 5)
```

---

### do_lines_intersect(l1_start, l1_end, l2_start, l2_end)

Determines whether two 2D line segments intersect.

#### Parameters
| Name       | Type    | Description                        |
|------------|---------|------------------------------------|
| l1_start   | `table` | Start of line 1 `{x, y}`           |
| l1_end     | `table` | End of line 1 `{x, y}`             |
| l2_start   | `table` | Start of line 2 `{x, y}`           |
| l2_end     | `table` | End of line 2 `{x, y}`             |

#### Example
```lua
local intersects = GEOMETRY.do_lines_intersect(p1, p2, p3, p4)
```

---

### line_intersects_circle(line_start, line_end, circle_center, circle_radius)

Checks if a line segment intersects with a circle.

#### Parameters
| Name           | Type    | Description                       |
|----------------|---------|-----------------------------------|
| line_start     | `table` | Line start `{x, y}`               |
| line_end       | `table` | Line end `{x, y}`                 |
| circle_center  | `table` | Circle center `{x, y}`            |
| circle_radius  | `number` | Radius of circle                  |

#### Example
```lua
local hit = GEOMETRY.line_intersects_circle(p1, p2, { x = 0, y = 0 }, 10)
```

---

### does_rect_intersect_line(rect, line_start, line_end)

Checks if a 2D rectangle intersects with a line segment.

#### Parameters
| Name        | Type    | Description                         |
|-------------|---------|-------------------------------------|
| rect        | `table` | Rectangle `{x, y, width, height}`   |
| line_start  | `table` | Line start `{x, y}`                 |
| line_end    | `table` | Line end `{x, y}`                   |

#### Example
```lua
local crosses = GEOMETRY.does_rect_intersect_line(rect, p1, p2)
```

---

### closest_point_on_line_segment(point, line_start, line_end)

Returns the closest point on a line segment to a given point.

#### Parameters
| Name       | Type    | Description                 |
|------------|---------|-----------------------------|
| point      | `table` | The point to check `{x, y}` |
| line_start | `table` | Line start `{x, y}`         |
| line_end   | `table` | Line end `{x, y}`           |

#### Example
```lua
local closest = GEOMETRY.closest_point_on_line_segment({ x = 2, y = 2 }, p1, p2)
```

---

### triangle_area_3d(p1, p2, p3)

Returns the area of a 3D triangle given three vertices.

#### Parameters
| Name | Type    | Description            |
|------|---------|------------------------|
| p1   | `table` | Vertex 1 `{x, y, z}`   |
| p2   | `table` | Vertex 2 `{x, y, z}`   |
| p3   | `table` | Vertex 3 `{x, y, z}`   |

#### Example
```lua
local area = GEOMETRY.triangle_area_3d(p1, p2, p3)
```

---

### is_point_in_sphere(point, sphere_center, sphere_radius)

Checks if a 3D point lies inside a sphere.

#### Parameters
| Name          | Type    | Description               |
|---------------|---------|---------------------------|
| point         | `table` | `{x, y, z}`               |
| sphere_center | `table` | Sphere center `{x, y, z}` |
| sphere_radius | `number` | Radius of the sphere      |

#### Example
```lua
local inside = GEOMETRY.is_point_in_sphere(pos, center, 10)
```

---

### do_spheres_intersect(s1_center, s1_radius, s2_center, s2_radius)

Checks if two spheres intersect.

#### Parameters
| Name       | Type    | Description              |
|------------|---------|--------------------------|
| s1_center  | `table` | Sphere 1 center `{x,y,z}`|
| s1_radius  | `number`| Sphere 1 radius          |
| s2_center  | `table` | Sphere 2 center `{x,y,z}`|
| s2_radius  | `number`| Sphere 2 radius          |

#### Example
```lua
local hit = GEOMETRY.do_spheres_intersect(c1, 5, c2, 6)
```

---

### is_point_in_convex_polygon(point, polygon)

Checks if a 2D point lies inside a convex polygon.

#### Parameters
| Name    | Type    | Description                            |
|---------|---------|----------------------------------------|
| point   | `table` | `{x, y}`                               |
| polygon | `table` | List of points `{ {x,y}, {x,y}, ... }` |

#### Example
```lua
local inside = GEOMETRY.is_point_in_convex_polygon({ x = 2, y = 3 }, polygon)
```

---

### rotate_point_around_point_2d(point, pivot, angle_degrees)

Rotates a point around another point by degrees.

#### Parameters
| Name           | Type    | Description                    |
|----------------|---------|--------------------------------|
| point          | `table` | `{x, y}`                       |
| pivot          | `table` | Rotation center `{x, y}`       |
| angle_degrees  | `number`| Degrees to rotate              |

#### Example
```lua
local result = GEOMETRY.rotate_point_around_point_2d({x = 3, y = 3}, {x = 0, y = 0}, 90)
```

---

### distance_point_to_plane(point, plane_point, plane_normal)

Calculates the shortest distance from a point to a plane.

#### Parameters
| Name         | Type    | Description               |
|--------------|---------|---------------------------|
| point        | `table` | `{x, y, z}`               |
| plane_point  | `table` | Point on the plane        |
| plane_normal | `table` | Normal of the plane       |

#### Example
```lua
local dist = GEOMETRY.distance_point_to_plane(p, plane_p, normal)
```

---

### rotation_to_direction(rotation)

Converts Euler angles into a directional vector.

#### Parameters
| Name     | Type    | Description                      |
|----------|---------|----------------------------------|
| rotation | `table` | Euler rotation `{x, y, z}` in °  |

#### Example
```lua
local dir = GEOMETRY.rotation_to_direction({x = 0, y = 0, z = 90})
```

---

### rotate_box(center, width, length, heading)

Returns the 4 rotated corners of a box in 3D.

#### Parameters
| Name     | Type     | Description               |
|----------|----------|---------------------------|
| center   | `table`  | Center of box `{x, y, z}` |
| width    | `number` | Box width                 |
| length   | `number` | Box length                |
| heading  | `number` | Heading in degrees        |

#### Example
```lua
local corners = GEOMETRY.rotate_box({x=0,y=0,z=0}, 4, 2, 45)
```

---

### calculate_rotation_matrix(heading, pitch, roll)

Returns a basic Z rotation matrix.

#### Parameters
| Name    | Type     | Description          |
|---------|----------|----------------------|
| heading | `number` | Heading in degrees   |
| pitch   | `number` | Pitch in degrees     |
| roll    | `number` | Roll in degrees      |

#### Example
```lua
local matrix = GEOMETRY.calculate_rotation_matrix(90, 0, 0)
```

---

### translate_point_to_local_space(point, box_origin, rot_matrix)

Converts world point into local box space.

#### Parameters
| Name        | Type    | Description                 |
|-------------|---------|-----------------------------|
| point       | `table` | Point `{x, y, z}`           |
| box_origin  | `table` | Origin `{x, y, z}`          |
| rot_matrix  | `table` | 3x3 rotation matrix         |

#### Example
```lua
local local_point = GEOMETRY.translate_point_to_local_space(p, origin, matrix)
```

---

### is_point_in_oriented_box(point, box)

Checks if a point is inside a rotated 3D box.

#### Parameters
| Name | Type   | Description                                         |
|------|--------|-----------------------------------------------------|
| point | `table` | The point `{x, y, z}`                             |
| box   | `table` | Box config with keys `coords`, `width`, `height`, `depth`, `heading`, `pitch`, `roll` |

#### Example
```lua
local inside = GEOMETRY.is_point_in_oriented_box(pos, box)
```

---

## Notes

- All geometry functions are standalone and pure (no side effects)
- Most return true/false or table/number outputs depending on shape comparison
- Functions are designed to operate on tables of `{x, y}` or `{x, y, z}` as inputs