----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    MATH UTILITIES
]]

-- Round a given number to the specified number of decimals
-- Usage: local rounded = round_number(5.6789, 2) -- Returns 5.68
local function round_number(number, decimals)
    local power = 10 ^ decimals
    return math.floor(number * power + 0.5) / power
end

-- Calculate the distance between two coordinate points
-- Usage: local dist = calculate_distance({x = 0, y = 0, z = 0}, {x = 3, y = 4, z = 0}) -- Returns 5 (Pythagorean theorem)
local function calculate_distance(start_coords, end_coords)
    local dx = end_coords.x - start_coords.x
    local dy = end_coords.y - start_coords.y
    local dz = end_coords.z - start_coords.z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end
    
-- Clamp a given value between two bounds (lower and upper)
-- Usage: local clamped = clamp(15, 10, 20) -- Returns 15
local function clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

-- Checks if a number is within a range (inclusive)
-- Usage: local in_range = is_within_range(5, 1, 10) -- Returns true
local function is_within_range(number, min, max)
    return number >= min and number <= max
end

-- Returns the linear interpolation between two numbers based on a third number
-- Usage: local result = lerp(0, 10, 0.5) -- Returns 5
local function lerp(a, b, t)
    return a + (b - a) * t
end

-- Returns a random number between two bounds (inclusive)
-- Usage: local random_num = random_between(1, 10) -- Returns a number between 1 and 10, inclusive
local function random_between(min, max)
    return math.random() * (max - min) + min
end

-- Returns the factorial of a number
-- Usage: local result = factorial(5) -- Returns 120 (because 5! = 5*4*3*2*1)
local function factorial(n)
    if n == 0 then 
        return 1 
    else 
        return n * factorial(n - 1) 
    end
end

-- Checks if a number is even
-- Usage: local is_even = is_even(4) -- Returns true
local function is_even(n)
    return n % 2 == 0
end

-- Checks if a number is odd
-- Usage: local is_odd = is_odd(3) -- Returns true
local function is_odd(n)
    return n % 2 ~= 0
end

-- Converts degrees to radians
-- Usage: local rad = deg_to_rad(180) -- Returns pi
local function deg_to_rad(deg)
    return deg * (math.pi / 180)
end

-- Converts radians to degrees
-- Usage: local deg = rad_to_deg(math.pi) -- Returns 180
local function rad_to_deg(rad)
    return rad * (180 / math.pi)
end

-- Safely divide two numbers, avoiding division by zero
-- Usage: local result = safe_divide(10, 2) -- Returns 5
local function safe_divide(a, b)
    if b and b ~= 0 then
        return a / b
    end
    return 0
end

-- Calculate the circumference of a circle given its radius
-- Usage: local circumference = circle_circumference(5) -- Returns 31.4159265358979
local function circle_circumference(radius)
    return 2 * math.pi * radius
end

-- Calculate the area of a circle given its radius
-- Usage: local area = circle_area(5) -- Returns 78.5398163397448
local function circle_area(radius)
    return math.pi * radius^2
end

-- Calculate the area of a triangle given three 2D points
-- Usage: local area = triangle_area({x = 0, y = 0}, {x = 1, y = 0}, {x = 0, y = 1}) -- Returns 0.5
local function triangle_area(p1, p2, p3)
    return math.abs((p1.x*(p2.y-p3.y) + p2.x*(p3.y-p1.y) + p3.x*(p1.y-p2.y))/2)
end

--[[
    ASSIGN LOCAL FUNCTIONS
]]

utils.maths = utils.maths or {}

utils.maths.round_number = round_number
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