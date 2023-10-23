----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    GEOMETRY UTILITIES
]]

-- Calculate the distance between two 2D points
-- Usage: local dist = distance_2d({x = 0, y = 0}, {x = 3, y = 4}) -- Returns 5
local function distance_2d(p1, p2)
    return math.sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2)
end

-- Calculate the distance between two 3D points
-- Usage: local dist = distance_3d({x = 0, y = 0, z = 0}, {x = 3, y = 4, z = 0}) -- Returns 5
local function distance_3d(p1, p2)
    return math.sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2 + (p2.z - p1.z)^2)
end

-- Returns the midpoint between two 3D points
-- Usage: local mp = midpoint({x = 0, y = 0, z = 0}, {x = 2, y = 2, z = 2}) -- Returns {x = 1, y = 1, z = 1}
local function midpoint(p1, p2)
    return {
        x = (p1.x + p2.x) / 2,
        y = (p1.y + p2.y) / 2,
        z = (p1.z + p2.z) / 2
    }
end

-- Determines if a point is inside a given 2D rectangle boundary
-- Usage: local inside = is_point_in_rect({x = 1, y = 1}, {x = 0, y = 0, width = 3, height = 3}) -- Returns true
local function is_point_in_rect(point, rect)
    return point.x >= rect.x and point.x <= (rect.x + rect.width) and
           point.y >= rect.y and point.y <= (rect.y + rect.height)
end

-- Determines if a point is inside a given 3D box boundary
-- Usage: local inside = is_point_in_box({x = 1, y = 1, z = 1}, {x = 0, y = 0, z = 0, width = 3, height = 3, depth = 3}) -- Returns true
local function is_point_in_box(point, box)
    return point.x >= box.x and point.x <= (box.x + box.width) and
           point.y >= box.y and point.y <= (box.y + box.height) and
           point.z >= box.z and point.z <= (box.z + box.depth)
end

-- Determine if a point is on a line segment defined by two 2D points
-- Usage: local on_line = is_point_on_line_segment({x = 1, y = 1}, {x = 0, y = 0}, {x = 2, y = 2}) -- Returns true
local function is_point_on_line_segment(point, line_start, line_end)
    return distance_2d(point, line_start) + distance_2d(point, line_end) == distance_2d(line_start, line_end)
end

-- Calculate the projected point of p onto the line segment defined by p1 and p2
-- Usage: local proj_point = project_point_on_line({x = 1, y = 2}, {x = 0, y = 0}, {x = 2, y = 0})
local function project_point_on_line(p, p1, p2)
    local l2 = (p2.x-p1.x)^2 + (p2.y-p1.y)^2
    local t = ((p.x-p1.x)*(p2.x-p1.x) + (p.y-p1.y)*(p2.y-p1.y)) / l2
    return {x = p1.x + t * (p2.x - p1.x), y = p1.y + t * (p2.y - p1.y)}
end

-- Calculate the slope of a line given two 2D points
-- Usage: local slope = calculate_slope({x = 0, y = 0}, {x = 2, y = 2}) -- Returns 1
local function calculate_slope(p1, p2)
    if p2.x - p1.x == 0 then
        return nil
    end
    return (p2.y - p1.y) / (p2.x - p1.x)
end


-- Returns the angle between two 2D points in degrees
-- Usage: local angle = angle_between_points({x = 0, y = 0}, {x = 1, y = 1}) -- Returns 45 (assuming the first point as origin)
local function angle_between_points(p1, p2)
    return math.atan2(p2.y - p1.y, p2.x - p1.x) * (180 / math.pi)
end

-- Calculate the angle between three 3D points (p1, p2 as center, p3)
-- Usage: local angle = angle_between_3_points({x = 0, y = 0, z = 0}, {x = 1, y = 1, z = 1}, {x = 2, y = 2, z = 2})
local function angle_between_3_points(p1, p2, p3)
    local a = distance_3d(p2, p3)
    local b = distance_3d(p1, p3)
    local c = distance_3d(p1, p2)
    return math.acos((a*a + c*c - b*b) / (2*a*c)) * (180 / math.pi)
end

-- Determine if two circles defined by center and radius intersect
-- Usage: local intersect = do_circles_intersect({x = 1, y = 1}, 5, {x = 10, y = 1}, 5) -- Returns true
local function do_circles_intersect(c1_center, c1_radius, c2_center, c2_radius)
    return distance_2d(c1_center, c2_center) <= (c1_radius + c2_radius)
end

-- Determine if a point is inside a circle defined by center and radius
-- Usage: local inside = is_point_in_circle({x = 1, y = 1}, {x = 0, y = 0}, 5) -- Returns true
local function is_point_in_circle(point, circle_center, circle_radius)
    return distance_2d(point, circle_center) <= circle_radius
end

-- Determine if two 2D line segments intersect
-- Usage: local intersect = do_lines_intersect({x = 0, y = 0}, {x = 2, y = 2}, {x = 0, y = 2}, {x = 2, y = 0}) -- Returns true
local function do_lines_intersect(l1_start, l1_end, l2_start, l2_end)
    local function ccw(a, b, c)
        return (c.y-a.y) * (b.x-a.x) > (b.y-a.y) * (c.x-a.x)
    end
    return ccw(l1_start, l2_start, l2_end) ~= ccw(l1_end, l2_start, l2_end) and ccw(l1_start, l1_end, l2_start) ~= ccw(l1_start, l1_end, l2_end)
end

-- Determine if a rectangle intersects with a 2D line segment
-- Usage: local intersect = does_rect_intersect_line({x = 1, y = 1, width = 3, height = 3}, {x = 0, y = 2}, {x = 5, y = 2}) -- Returns true
local function does_rect_intersect_line(rect, line_start, line_end)
    return do_lines_intersect({x = rect.x, y = rect.y}, {x = rect.x + rect.width, y = rect.y}, line_start, line_end) or
           do_lines_intersect({x = rect.x + rect.width, y = rect.y}, {x = rect.x + rect.width, y = rect.y + rect.height}, line_start, line_end) or
           do_lines_intersect({x = rect.x + rect.width, y = rect.y + rect.height}, {x = rect.x, y = rect.y + rect.height}, line_start, line_end) or
           do_lines_intersect({x = rect.x, y = rect.y + rect.height}, {x = rect.x, y = rect.y}, line_start, line_end)
end

-- Determine the closest point on a 2D line segment to a given point
-- Usage: local closest = closest_point_on_line_segment({x = 1, y = 3}, {x = 0, y = 0}, {x = 2, y = 2}) -- Returns {x = 1, y = 1}
local function closest_point_on_line_segment(point, line_start, line_end)
    local l2 = distance_2d(line_start, line_end)^2
    if l2 == 0 then return line_start end
    local t = ((point.x - line_start.x) * (line_end.x - line_start.x) + (point.y - line_start.y) * (line_end.y - line_start.y)) / l2
    if t < 0 then return line_start end
    if t > 1 then return line_end end
    return {x = line_start.x + t * (line_end.x - line_start.x), y = line_start.y + t * (line_end.y - line_start.y)}
end

-- Calculate the area of a 3D triangle given three points
-- Usage: local area = triangle_area_3d({x = 0, y = 0, z = 0}, {x = 1, y = 0, z = 0}, {x = 0, y = 1, z = 0}) -- Returns 0.5
local function triangle_area_3d(p1, p2, p3)
    local u = {x = p2.x - p1.x, y = p2.y - p1.y, z = p2.z - p1.z}
    local v = {x = p3.x - p1.x, y = p3.y - p1.y, z = p3.z - p1.z}
    local cross_product = {
        x = u.y * v.z - u.z * v.y,
        y = u.z * v.x - u.x * v.z,
        z = u.x * v.y - u.y * v.x
    }
    return 0.5 * math.sqrt(cross_product.x^2 + cross_product.y^2 + cross_product.z^2)
end

-- Check if a point is inside a 3D sphere
-- Usage: local inside = is_point_in_sphere({x = 1, y = 1, z = 1}, {x = 0, y = 0, z = 0}, 5) -- Returns true
local function is_point_in_sphere(point, sphere_center, sphere_radius)
    return distance_3d(point, sphere_center) <= sphere_radius
end

-- Check if two spheres intersect
-- Usage: local intersect = do_spheres_intersect({x = 1, y = 1, z = 1}, 5, {x = 10, y = 1, z = 1}, 5) -- Returns true
local function do_spheres_intersect(s1_center, s1_radius, s2_center, s2_radius)
    return distance_3d(s1_center, s2_center) <= (s1_radius + s2_radius)
end

-- Check if a point is inside a 2D convex polygon
-- Assume `polygon` is a table of points in order {p1, p2, ...}
-- Usage: local inside = is_point_in_convex_polygon({x = 1, y = 1}, {{x = 0, y = 0}, {x = 2, y = 0}, {x = 1, y = 2}}) -- Returns true
local function is_point_in_convex_polygon(point, polygon)
    local sign = nil
    for i = 1, #polygon do
        local dx1 = polygon[i].x - point.x
        local dy1 = polygon[i].y - point.y
        local dx2 = polygon[(i % #polygon) + 1].x - point.x
        local dy2 = polygon[(i % #polygon) + 1].y - point.y
        local cross = dx1 * dy2 - dx2 * dy1
        if i == 1 then
            sign = cross > 0
        else
            if sign ~= (cross > 0) then
                return false
            end
        end
    end
    return true
end

-- Rotate a point around another point in 2D by a given angle in degrees
-- Usage: local rotated = rotate_point_around_point_2d({x = 1, y = 0}, {x = 0, y = 0}, 90) -- Returns {x = 0, y = 1}
local function rotate_point_around_point_2d(point, pivot, angle_degrees)
    local angle_rad = math.rad(angle_degrees)
    local sin_angle = math.sin(angle_rad)
    local cos_angle = math.cos(angle_rad)
    local dx = point.x - pivot.x
    local dy = point.y - pivot.y
    return {
        x = cos_angle * dx - sin_angle * dy + pivot.x,
        y = sin_angle * dx + cos_angle * dy + pivot.y
    }
end

-- Calculate distance from a point to a plane
-- `plane_point` is a point on the plane, `plane_normal` is the normal to the plane
-- Usage: local dist = distance_point_to_plane({x = 1, y = 1, z = 1}, {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 1}) -- Returns 1
local function distance_point_to_plane(point, plane_point, plane_normal)
    local v = {
        x = point.x - plane_point.x,
        y = point.y - plane_point.y,
        z = point.z - plane_point.z
    }
    local dist = v.x * plane_normal.x + v.y * plane_normal.y + v.z * plane_normal.z
    return math.abs(dist)
end

--[[
    ASSIGN LOCAL FUNCTIONS
]]

utils.geometry = utils.geometry or {}

utils.geometry.distance_2d = distance_2d
utils.geometry.distance_3d = distance_3d
utils.geometry.midpoint = midpoint
utils.geometry.is_point_in_rect = is_point_in_rect
utils.geometry.is_point_in_box = is_point_in_box
utils.geometry.calculate_slope = calculate_slope
utils.geometry.is_point_on_line_segment = is_point_on_line_segment
utils.geometry.project_point_on_line = project_point_on_line
utils.geometry.angle_between_points = angle_between_points
utils.geometry.angle_between_3_points = angle_between_3_points
utils.geometry.do_circles_intersect = do_circles_intersect
utils.geometry.is_point_in_circle = is_point_in_circle
utils.geometry.do_lines_intersect = do_lines_intersect
utils.geometry.does_rect_intersect_line = does_rect_intersect_line
utils.geometry.closest_point_on_line_segment = closest_point_on_line_segment
utils.geometry.triangle_area_3d = triangle_area_3d
utils.geometry.is_point_in_sphere = is_point_in_sphere
utils.geometry.do_spheres_intersect = do_spheres_intersect
utils.geometry.is_point_in_convex_polygon = is_point_in_convex_polygon
utils.geometry.rotate_point_around_point_2d = rotate_point_around_point_2d
utils.geometry.distance_point_to_plane = distance_point_to_plane