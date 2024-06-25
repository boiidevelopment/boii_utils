--[[
    ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|             DEVELOPER UTILS
]]

--- Geometry functions.
-- @script shared/scripts/geometry.lua

--- @section Local functions

--- Calculates the distance between two 2D points.
--- @function distance_2d
--- @param p1 table: The first point (x, y).
--- @param p2 table: The second point (x, y).
--- @return number: The Euclidean distance between the two points.
local function distance_2d(p1, p2)
    return math.sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2)
end

exports('geometry_distance_2d', distance_2d)
utils.geometry.distance_2d = distance_2d

--- Calculates the distance between two 3D points.
--- @function distance_3d
--- @param p1 table: The first point (x, y, z).
--- @param p2 table: The second point (x, y, z).
--- @return number: The Euclidean distance between the two points.
local function distance_3d(p1, p2)
    return math.sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2 + (p2.z - p1.z)^2)
end

exports('geometry_distance_3d', distance_3d)
utils.geometry.distance_3d = distance_3d

--- Returns the midpoint between two 3D points.
--- @function midpoint
--- @param p1 table: The first point (x, y, z).
--- @param p2 table: The second point (x, y, z).
--- @return table: The midpoint (x, y, z).
local function midpoint(p1, p2)
    return {x = (p1.x + p2.x) / 2, y = (p1.y + p2.y) / 2, z = (p1.z + p2.z) / 2}
end

exports('geometry_midpoint', midpoint)
utils.geometry.midpoint = midpoint

--- Determines if a point is inside a given 2D rectangle boundary.
--- @function is_point_in_rect
--- @param point table: The point to check (x, y).
--- @param rect table: The rectangle (x, y, width, height).
--- @return boolean: True if the point is inside the rectangle, false otherwise.
local function is_point_in_rect(point, rect)
    return point.x >= rect.x and point.x <= (rect.x + rect.width) and point.y >= rect.y and point.y <= (rect.y + rect.height)
end

exports('geometry_is_point_in_rect', is_point_in_rect)
utils.geometry.is_point_in_rect = is_point_in_rect

--- Determines if a point is inside a given 3D box boundary.
--- @function is_point_in_box
--- @param point table: The point to check (x, y, z).
--- @param box table: The box (x, y, z, width, height, depth).
--- @return boolean: True if the point is inside the box, false otherwise.
local function is_point_in_box(point, box)
    return point.x >= box.x and point.x <= (box.x + box.width) and point.y >= box.y and point.y <= (box.y + box.height) and point.z >= box.z and point.z <= (box.z + box.depth)
end

exports('geometry_is_point_in_box', is_point_in_box)
utils.geometry.is_point_in_box = is_point_in_box

--- Determines if a point is on a line segment defined by two 2D points.
--- @function is_point_on_line_segment
--- @param point table: The point to check (x, y).
--- @param line_start table: The starting point of the line segment (x, y).
--- @param line_end table: The ending point of the line segment (x, y).
--- @return boolean: True if the point is on the line segment, false otherwise.
local function is_point_on_line_segment(point, line_start, line_end)
    return distance_2d(point, line_start) + distance_2d(point, line_end) == distance_2d(line_start, line_end)
end

exports('geometry_is_point_on_line_segment', is_point_on_line_segment)
utils.geometry.is_point_on_line_segment = is_point_on_line_segment

--- Projects a point onto a line segment defined by two 2D points.
--- @function project_point_on_line
--- @param p table: The point to project (x, y).
--- @param p1 table: The starting point of the line segment (x, y).
--- @param p2 table: The ending point of the line segment (x, y).
--- @return table: The projected point (x, y).
local function project_point_on_line(p, p1, p2)
    local l2 = (p2.x-p1.x)^2 + (p2.y-p1.y)^2
    local t = ((p.x-p1.x)*(p2.x-p1.x) + (p.y-p1.y)*(p2.y-p1.y)) / l2
    return {x = p1.x + t * (p2.x - p1.x), y = p1.y + t * (p2.y - p1.y)}
end

exports('geometry_project_point_on_line', project_point_on_line)
utils.geometry.project_point_on_line = project_point_on_line

--- Calculates the slope of a line given two 2D points.
--- @function calculate_slope
--- @param p1 table: The first point (x, y).
--- @param p2 table: The second point (x, y).
--- @return number: The slope of the line. Returns nil if the slope is undefined (vertical line).
local function calculate_slope(p1, p2)
    if p2.x - p1.x == 0 then
        return nil
    end
    return (p2.y - p1.y) / (p2.x - p1.x)
end

exports('geometry_calculate_slope', calculate_slope)
utils.geometry.calculate_slope = calculate_slope

--- Returns the angle between two 2D points in degrees.
--- @function angle_between_points
--- @param p1 table: The first point (x, y).
--- @param p2 table: The second point (x, y).
--- @return number: The angle in degrees.
local function angle_between_points(p1, p2)
    return math.atan2(p2.y - p1.y, p2.x - p1.x) * (180 / math.pi)
end

exports('geometry_angle_between_points', angle_between_points)
utils.geometry.angle_between_points = angle_between_points

--- Calculates the angle between three 3D points (p1, p2 as center, p3).
--- @function angle_between_3_points
--- @param p1 table: The first point (x, y, z).
--- @param p2 table: The center point (x, y, z).
--- @param p3 table: The third point (x, y, z).
--- @return number: The angle in degrees.
local function angle_between_3_points(p1, p2, p3)
    local a = distance_3d(p2, p3)
    local b = distance_3d(p1, p3)
    local c = distance_3d(p1, p2)
    return math.acos((a*a + c*c - b*b) / (2*a*c)) * (180 / math.pi)
end

exports('geometry_angle_between_3_points', angle_between_3_points)
utils.geometry.angle_between_3_points = angle_between_3_points

--- Determines if two circles defined by center and radius intersect.
--- @function do_circles_intersect
--- @param c1_center table: The center of the first circle (x, y).
--- @param c1_radius number: The radius of the first circle.
--- @param c2_center table: The center of the second circle (x, y).
--- @param c2_radius number: The radius of the second circle.
--- @return boolean: True if the circles intersect, false otherwise.
local function do_circles_intersect(c1_center, c1_radius, c2_center, c2_radius)
    return distance_2d(c1_center, c2_center) <= (c1_radius + c2_radius)
end

exports('geometry_do_circles_intersect', do_circles_intersect)
utils.geometry.do_circles_intersect = do_circles_intersect

--- Determines if a point is inside a circle defined by center and radius.
--- @function is_point_in_circle
--- @param point table: The point to check (x, y).
--- @param circle_center table: The center of the circle (x, y).
--- @param circle_radius number: The radius of the circle.
--- @return boolean: True if the point is inside the circle, false otherwise.
local function is_point_in_circle(point, circle_center, circle_radius)
    return distance_2d(point, circle_center) <= circle_radius
end

exports('geometry_is_point_in_circle', is_point_in_circle)
utils.geometry.is_point_in_circle = is_point_in_circle

--- Determines if two 2D line segments intersect.
--- @function do_lines_intersect
--- @param l1_start table: The starting point of the first line segment (x, y).
--- @param l1_end table: The ending point of the first line segment (x, y).
--- @param l2_start table: The starting point of the second line segment (x, y).
--- @param l2_end table: The ending point of the second line segment (x, y).
--- @return boolean: True if the line segments intersect, false otherwise.
local function do_lines_intersect(l1_start, l1_end, l2_start, l2_end)
    local function ccw(a, b, c)
        return (c.y-a.y) * (b.x-a.x) > (b.y-a.y) * (c.x-a.x)
    end
    return ccw(l1_start, l2_start, l2_end) ~= ccw(l1_end, l2_start, l2_end) and ccw(l1_start, l1_end, l2_start) ~= ccw(l1_start, l1_end, l2_end)
end

exports('geometry_do_lines_intersect', do_lines_intersect)
utils.geometry.do_lines_intersect = do_lines_intersect

--- Determines if a line segment intersects a circle.
--- @function line_intersects_circle
--- @param line_start table: Starting point of the line (x, y).
--- @param line_end table: Ending point of the line (x, y).
--- @param circle_center table: Center of the circle (x, y).
--- @param circle_radius number: Radius of the circle.
--- @return boolean: True if the line intersects the circle, false otherwise.
local function line_intersects_circle(line_start, line_end, circle_center, circle_radius)
    local d = {x = line_end.x - line_start.x, y = line_end.y - line_start.y}
    local f = {x = line_start.x - circle_center.x, y = line_start.y - circle_center.y}
    local a = d.x^2 + d.y^2
    local b = 2 * (f.x * d.x + f.y * d.y)
    local c = (f.x^2 + f.y^2) - circle_radius^2
    local discriminant = b^2 - 4 * a * c
    if discriminant >= 0 then
        discriminant = math.sqrt(discriminant)
        local t1 = (-b - discriminant) / (2 * a)
        local t2 = (-b + discriminant) / (2 * a)
        if t1 >= 0 and t1 <= 1 or t2 >= 0 and t2 <= 1 then
            return true
        end
    end
    return false
end

exports('geometry_line_intersects_circle', line_intersects_circle)
utils.geometry.line_intersects_circle = line_intersects_circle

--- Determines if a rectangle intersects with a 2D line segment.
--- @function does_rect_intersect_line
--- @param rect table: The rectangle (x, y, width, height).
--- @param line_start table: The starting point of the line segment (x, y).
--- @param line_end table: The ending point of the line segment (x, y).
--- @return boolean: True if the rectangle intersects with the line segment, false otherwise.
local function does_rect_intersect_line(rect, line_start, line_end)
    return do_lines_intersect({x = rect.x, y = rect.y}, {x = rect.x + rect.width, y = rect.y}, line_start, line_end) or do_lines_intersect({x = rect.x + rect.width, y = rect.y}, {x = rect.x + rect.width, y = rect.y + rect.height}, line_start, line_end) or do_lines_intersect({x = rect.x + rect.width, y = rect.y + rect.height}, {x = rect.x, y = rect.y + rect.height}, line_start, line_end) or do_lines_intersect({x = rect.x, y = rect.y + rect.height}, {x = rect.x, y = rect.y}, line_start, line_end)
end

exports('geometry_does_rect_intersect_line', does_rect_intersect_line)
utils.geometry.does_rect_intersect_line = does_rect_intersect_line

--- Determines the closest point on a 2D line segment to a given point.
--- @function closest_point_on_line_segment
--- @param point table: The point to find the closest point for (x, y).
--- @param line_start table: The starting point of the line segment (x, y).
--- @param line_end table: The ending point of the line segment (x, y).
--- @return table: The closest point on the line segment (x, y).
local function closest_point_on_line_segment(point, line_start, line_end)
    local l2 = distance_2d(line_start, line_end)^2
    if l2 == 0 then return line_start end
    local t = ((point.x - line_start.x) * (line_end.x - line_start.x) + (point.y - line_start.y) * (line_end.y - line_start.y)) / l2
    if t < 0 then return line_start end
    if t > 1 then return line_end end
    return {x = line_start.x + t * (line_end.x - line_start.x), y = line_start.y + t * (line_end.y - line_start.y)}
end

exports('geometry_closest_point_on_line_segment', closest_point_on_line_segment)
utils.geometry.closest_point_on_line_segment = closest_point_on_line_segment

--- Calculates the area of a 3D triangle given three points.
--- @function triangle_area_3d
--- @param p1 table: The first point of the triangle (x, y, z).
--- @param p2 table: The second point of the triangle (x, y, z).
--- @param p3 table: The third point of the triangle (x, y, z).
--- @return number: The area of the triangle.
local function triangle_area_3d(p1, p2, p3)
    local u = {x = p2.x - p1.x, y = p2.y - p1.y, z = p2.z - p1.z}
    local v = {x = p3.x - p1.x, y = p3.y - p1.y, z = p3.z - p1.z}
    local cross_product = {x = u.y * v.z - u.z * v.y, y = u.z * v.x - u.x * v.z, z = u.x * v.y - u.y * v.x}
    return 0.5 * math.sqrt(cross_product.x^2 + cross_product.y^2 + cross_product.z^2)
end

exports('geometry_triangle_area_3d', triangle_area_3d)
utils.geometry.triangle_area_3d = triangle_area_3d

--- Determines if a point is inside a 3D sphere defined by center and radius.
--- @function is_point_in_sphere
--- @param point table: The point to check (x, y, z).
--- @param sphere_center table: The center of the sphere (x, y, z).
--- @param sphere_radius number: The radius of the sphere.
--- @return boolean: True if the point is inside the sphere, false otherwise.
local function is_point_in_sphere(point, sphere_center, sphere_radius)
    return distance_3d(point, sphere_center) <= sphere_radius
end

exports('geometry_is_point_in_sphere', is_point_in_sphere)
utils.geometry.is_point_in_sphere = is_point_in_sphere

--- Determines if two spheres intersect.
--- @function do_spheres_intersect
--- @param s1_center table: The center of the first sphere (x, y, z).
--- @param s1_radius number: The radius of the first sphere.
--- @param s2_center table: The center of the second sphere (x, y, z).
--- @param s2_radius number: The radius of the second sphere.
--- @return boolean: True if the spheres intersect, false otherwise.
local function do_spheres_intersect(s1_center, s1_radius, s2_center, s2_radius)
    return distance_3d(s1_center, s2_center) <= (s1_radius + s2_radius)
end

exports('geometry_do_spheres_intersect', do_spheres_intersect)
utils.geometry.do_spheres_intersect = do_spheres_intersect

--- Determines if a point is inside a 2D convex polygon.
--- @function is_point_in_convex_polygon
--- @param point table: The point to check (x, y).
--- @param polygon table: The polygon defined as a sequence of points [{x, y}, {x, y}, ...].
--- @return boolean: True if the point is inside the polygon, false otherwise.
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

exports('geometry_is_point_in_convex_polygon', is_point_in_convex_polygon)
utils.geometry.is_point_in_convex_polygon = is_point_in_convex_polygon

--- Rotates a point around another point in 2D by a given angle in degrees.
--- @function rotate_point_around_point_2d
--- @param point table: The point to rotate (x, y).
--- @param pivot table: The pivot point to rotate around (x, y).
--- @param angle_degrees number: The angle in degrees to rotate the point.
--- @return table: The rotated point (x, y).
local function rotate_point_around_point_2d(point, pivot, angle_degrees)
    local angle_rad = math.rad(angle_degrees)
    local sin_angle = math.sin(angle_rad)
    local cos_angle = math.cos(angle_rad)
    local dx = point.x - pivot.x
    local dy = point.y - pivot.y
    return {x = cos_angle * dx - sin_angle * dy + pivot.x, y = sin_angle * dx + cos_angle * dy + pivot.y}
end

exports('geometry_rotate_point_around_point_2d', rotate_point_around_point_2d)
utils.geometry.rotate_point_around_point_2d = rotate_point_around_point_2d

--- Calculates the distance from a point to a plane.
--- @function distance_point_to_plane
--- @param point table: The point to check (x, y, z).
--- @param plane_point table: A point on the plane (x, y, z).
--- @param plane_normal table: The normal of the plane (x, y, z).
--- @return number: The distance from the point to the plane.
local function distance_point_to_plane(point, plane_point, plane_normal)
    local v = { x = point.x - plane_point.x, y = point.y - plane_point.y, z = point.z - plane_point.z }
    local dist = v.x * plane_normal.x + v.y * plane_normal.y + v.z * plane_normal.z
    return math.abs(dist)
end

exports('geometry_distance_point_to_plane', distance_point_to_plane)
utils.geometry.distance_point_to_plane = distance_point_to_plane

--- Converts a rotation vector to a direction vector.
--- @function rotation_to_direction
--- @param rotation table: A vector representing rotation in Euler angles (pitch, yaw, roll) in degrees.
--- @return table: A direction vector.
local function rotation_to_direction(rotation)
    local z = math.rad(rotation.z)
    local x = math.rad(rotation.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

exports('geometry_rotation_to_direction', rotation_to_direction)
utils.geometry.rotation_to_direction = rotation_to_direction

--- Rotates a box around a central point in 3D by a given heading.
--- @function rotate_box
--- @param center table: The central point of the box (x, y, z).
--- @param width number: The width of the box.
--- @param length number: The length of the box.
--- @param heading number: The heading to rotate the box by, in degrees.
--- @return table: The rotated corners of the box.
local function rotate_box(center, width, length, heading)
    local half_width = width / 2
    local half_length = length / 2
    local rad = math.rad(heading)
    local sin_heading = math.sin(rad)
    local cos_heading = math.cos(rad)
    local corners = {{x = center.x + cos_heading * half_length + sin_heading * half_width, y = center.y + sin_heading * half_length - cos_heading * half_width}, {x = center.x - cos_heading * half_length + sin_heading * half_width, y = center.y - sin_heading * half_length - cos_heading * half_width}, {x = center.x - cos_heading * half_length - sin_heading * half_width, y = center.y - sin_heading * half_length + cos_heading * half_width}, {x = center.x + cos_heading * half_length - sin_heading * half_width, y = center.y + sin_heading * half_length + cos_heading * half_width}}
    local rotated_corners = {}
    for _, corner in ipairs(corners) do
        rotated_corners[#rotated_corners + 1] = vector3(corner.x, corner.y, center.z)
    end
    return rotated_corners
end

exports('geometry_rotate_box', rotate_box)
utils.geometry.rotate_box = rotate_box

--- Calculates a rotation matrix from heading, pitch, and roll.
--- @function calculate_rotation_matrix
--- @param heading number: The heading/yaw angle in degrees.
--- @param pitch number: The pitch angle in degrees.
--- @param roll number: The roll angle in degrees.
--- @return table: A rotation matrix represented as a 2D array.
local function calculate_rotation_matrix(heading, pitch, roll)
    local rad_heading = math.rad(heading or 0)
    local rad_pitch = math.rad(pitch or 0)
    local rad_roll = math.rad(roll or 0)
    local z_rot_matrix = {{math.cos(rad_heading), -math.sin(rad_heading), 0}, {math.sin(rad_heading), math.cos(rad_heading),  0}, {0, 0, 1}}
    return z_rot_matrix
end

exports('geometry_calculate_rotation_matrix', calculate_rotation_matrix)
utils.geometry.calculate_rotation_matrix = calculate_rotation_matrix

--- Translates a point to a box's local coordinate system using a rotation matrix.
--- @function translate_point_to_local_space
--- @param point table: The point to be translated (x, y, z).
--- @param box_origin table: The origin point of the box (x, y, z).
--- @param rot_matrix table: The rotation matrix to apply.
--- @return table: The point translated to the box's local space.
local function translate_point_to_local_space(point, box_origin, rot_matrix)
    local relative_point = {
        x = point.x - box_origin.x,
        y = point.y - box_origin.y,
        z = point.z - box_origin.z
    }
    return {x = rot_matrix[1][1] * relative_point.x + rot_matrix[1][2] * relative_point.y + rot_matrix[1][3] * relative_point.z, y = rot_matrix[2][1] * relative_point.x + rot_matrix[2][2] * relative_point.y + rot_matrix[2][3] * relative_point.z, z = rot_matrix[3][1] * relative_point.x + rot_matrix[3][2] * relative_point.y + rot_matrix[3][3] * relative_point.z}
end

exports('geometry_translate_point_to_local_space', translate_point_to_local_space)
utils.geometry.translate_point_to_local_space = translate_point_to_local_space

--- Determines if a point is inside an oriented 3D box.
--- @function is_point_in_oriented_box
--- @param point table: The point to check (x, y, z).
--- @param box table: The box with properties: coords (x, y, z), width, height, depth, heading, pitch, and roll.
--- @return boolean: True if the point is inside the box, false otherwise.
local function is_point_in_oriented_box(point, box)
    local rot_matrix = calculate_rotation_matrix(box.heading, box.pitch, box.roll)
    local translated_point = translate_point_to_local_space(point, box.coords, rot_matrix)
    return math.abs(translated_point.x) <= box.width / 2 and math.abs(translated_point.y) <= box.height / 2 and math.abs(translated_point.z) <= box.depth / 2
end

exports('geometry_is_point_in_oriented_box', is_point_in_oriented_box)
utils.geometry.is_point_in_oriented_box = is_point_in_oriented_box