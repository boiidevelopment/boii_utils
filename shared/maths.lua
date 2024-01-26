--- This script provides a collection of mathematical utility functions.
-- @script shared/math_utilities.lua

--- @section Local functions

--- Rounds a number to the specified number of decimal places.
-- @function round
-- @param number The number to round.
-- @param decimals The number of decimal places to round to.
-- @return The rounded number.
-- @usage local rounded = round(5.6789, 2) -- Returns 5.68
local function round(number, decimals)
    local power = 10 ^ decimals
    return math.floor(number * power + 0.5) / power
end

--- Calculates the distance between two 3D coordinate points.
-- @function calculate_distance
-- @param start_coords The starting coordinates.
-- @param end_coords The ending coordinates.
-- @return The distance between the two points.
-- @usage local dist = calculate_distance({x = 0, y = 0, z = 0}, {x = 3, y = 4, z = 0}) -- Returns 5 (Pythagorean theorem)
local function calculate_distance(start_coords, end_coords)
    local dx = end_coords.x - start_coords.x
    local dy = end_coords.y - start_coords.y
    local dz = end_coords.z - start_coords.z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end
    
--- Clamps a number within a specified range.
-- @function clamp
-- @param val The value to clamp.
-- @param lower The lower bound of the range.
-- @param upper The upper bound of the range.
-- @return The clamped value.
-- @usage local clamped = clamp(15, 10, 20) -- Returns 15
local function clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

--- Checks if a number is within a specified range.
-- @function is_within_range
-- @param number The number to check.
-- @param min The minimum value of the range.
-- @param max The maximum value of the range.
-- @return true if the number is within the range, false otherwise.
-- @usage local in_range = is_within_range(5, 1, 10) -- Returns true
local function is_within_range(number, min, max)
    return number >= min and number <= max
end

--- Linearly interpolates between two numbers.
-- @function lerp
-- @param a The start value.
-- @param b The end value.
-- @param t The interpolation factor (0-1).
-- @return The interpolated value.
-- @usage local result = lerp(0, 10, 0.5) -- Returns 5
local function lerp(a, b, t)
    return a + (b - a) * t
end

--- Generates a random number within a specified range.
-- @function random_between
-- @param min The minimum value of the range.
-- @param max The maximum value of the range.
-- @return A random number within the range.
-- @usage local random_num = random_between(1, 10) -- Returns a number between 1 and 10, inclusive
local function random_between(min, max)
    return math.random() * (max - min) + min
end

--- Calculates the factorial of a number.
-- @function factorial
-- @param n The number to calculate the factorial of.
-- @return The factorial of the number.
-- @usage local result = factorial(5) -- Returns 120 (because 5! = 5*4*3*2*1)
local function factorial(n)
    if n == 0 then 
        return 1 
    else 
        return n * factorial(n - 1) 
    end
end

--- Checks if a number is even.
-- @function is_even
-- @param n The number to check.
-- @return true if the number is even, false otherwise.
-- @usage local is_even = is_even(4) -- Returns true
local function is_even(n)
    return n % 2 == 0
end

--- Checks if a number is odd.
-- @function is_odd
-- @param n The number to check.
-- @return true if the number is odd, false otherwise.
-- @usage local is_odd = is_odd(3) -- Returns true
local function is_odd(n)
    return n % 2 ~= 0
end

--- Converts degrees to radians.
-- @function deg_to_rad
-- @param deg The angle in degrees.
-- @return The angle in radians.
-- @usage local rad = deg_to_rad(180) -- Returns pi
local function deg_to_rad(deg)
    return deg * (math.pi / 180)
end

--- Converts radians to degrees.
-- @function rad_to_deg
-- @param rad The angle in radians.
-- @return The angle in degrees.
-- @usage local deg = rad_to_deg(math.pi) -- Returns 180
local function rad_to_deg(rad)
    return rad * (180 / math.pi)
end

--- Safely divides two numbers, avoiding division by zero.
-- @function safe_divide
-- @param a The numerator.
-- @param b The denominator.
-- @return The result of the division, or 0 if the denominator is zero.
-- @usage local result = safe_divide(10, 2) -- Returns 5
local function safe_divide(a, b)
    if b and b ~= 0 then
        return a / b
    end
    return 0
end

--- Calculates the circumference of a circle given its radius.
-- @function circle_circumference
-- @param radius The radius of the circle.
-- @return The circumference of the circle.
-- @usage local circumference = circle_circumference(5) -- Returns 31.4159265358979
local function circle_circumference(radius)
    return 2 * math.pi * radius
end

--- Calculates the area of a circle given its radius.
-- @function circle_area
-- @param radius The radius of the circle.
-- @return The area of the circle.
-- @usage local area = circle_area(5) -- Returns 78.5398163397448
local function circle_area(radius)
    return math.pi * radius^2
end

--- Calculates the area of a triangle given three 2D points.
-- @function triangle_area
-- @param p1 The first point.
-- @param p2 The second point.
-- @param p3 The third point.
-- @return The area of the triangle.
-- @usage local area = triangle_area({x = 0, y = 0}, {x = 1, y = 0}, {x = 0, y = 1}) -- Returns 0.5
local function triangle_area(p1, p2, p3)
    return math.abs((p1.x*(p2.y-p3.y) + p2.x*(p3.y-p1.y) + p3.x*(p1.y-p2.y))/2)
end

--- @section Assign local functions

utils.maths = utils.maths or {}

utils.maths.round = round
utils.maths.calculate_distance = calculate_distance
utils.maths.clamp = clamp
utils.maths.is_within_range = is_within_range
utils.maths.lerp = lerp
utils.maths.random_between = random_between
utils.maths.factorial = factorial
utils.maths.is_even = is_even
utils.maths.is_odd = is_odd
utils.maths.deg_to_rad = deg_to_rad
utils.maths.rad_to_deg = rad_to_deg
utils.maths.safe_divide = safe_divide
utils.maths.circle_circumference = circle_circumference
utils.maths.circle_area = circle_area
utils.maths.triangle_area = triangle_area