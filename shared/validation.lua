----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    INPUT VALIDATION UTILITIES
]]

-- Check if a given string has a minimum length
-- Usage: local valid = has_min_length("Hello", 5) -- Returns true
local function has_min_length(str, length)
    return #str >= length
end

-- Check if a given string has a maximum length
-- Usage: local valid = has_max_length("Hello", 10) -- Returns true
local function has_max_length(str, length)
    return #str <= length
end

-- Check if a given string matches a specific pattern (regex)
-- Usage: local valid = matches_pattern("abc", "^%a+$") -- Returns true
local function matches_pattern(str, pattern)
    return (str:match(pattern) ~= nil)
end

-- Check if a given string is a valid email address format
-- Usage: local valid = is_email("test@example.com") -- Returns true
local function is_email(str)
    return (str:match("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+%.%a%a+$") ~= nil)
end

-- Check if a given string has only alphabets
-- Usage: local valid = is_alpha("Hello") -- Returns true
local function is_alpha(str)
    return (str:match("^%a+$") ~= nil)
end

-- Check if a given string has only digits
-- Usage: local valid = is_digit("12345") -- Returns true
local function is_digit(str)
    return (str:match("^%d+$") ~= nil)
end

-- Check if a given string is alphanumeric (contains only letters and numbers)
-- Usage: local valid = is_alphanumeric("Hello123") -- Returns true
local function is_alphanumeric(str)
    return (str:match("^%w+$") ~= nil)
end

-- Check if a given value is within a certain range (inclusive)
-- Usage: local valid = is_within_range(5, 1, 10) -- Returns true
local function is_within_range(value, min, max)
    return value >= min and value <= max
end

-- Check if a given string is a valid URL
-- Usage: local valid = is_url("https://www.example.com") -- Returns true
local function is_url(str)
    local pattern = "https?://[%w-]+%.%w+([/?].*)?$"
    return (str:match(pattern) ~= nil)
end

-- Check if a given value is a valid date format (YYYY-MM-DD)
-- Usage: local valid = is_date("2023-04-01") -- Returns true
local function is_date(str)
    local pattern = "(%d+)-(%d+)-(%d+)"
    local year, month, day = str:match(pattern)
    if year and month and day then
        month, day, year = tonumber(month), tonumber(day), tonumber(year)
        if month > 0 and month <= 12 and day > 0 and day <= 31 and #tostring(year) == 4 then
            return true
        end
    end
    return false
end

-- Check if a given string is a valid username (assuming certain generic rules)
-- Usage: local valid = is_username("Username123") -- Returns true
local function is_username(str)
    return (str:match("^%w{5,20}$") ~= nil)
end

-- Check if a given string is a valid IP address
-- Usage: local valid = is_ip_address("192.168.1.1") -- Returns true
local function is_ip_address(str)
    return (str:match("^(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)$") ~= nil)
end

-- Check if a given string is a valid server IP address with port (e.g., 192.168.1.1:30120)
-- Usage: local valid = is_server_address("192.168.1.1:30120") -- Returns true
local function is_server_address(str)
    return (str:match("^(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?):%d+$") ~= nil)
end

-- Check if a given string is a strong password (uppercase, lowercase, digit, special char)
-- Usage: local valid = is_strong_password("Password123!") -- Returns true
local function is_strong_password(str)
    local has_upper = str:match("%u")
    local has_lower = str:match("%l")
    local has_digit = str:match("%d")
    local has_special = str:match("%W")
    return has_upper and has_lower and has_digit and has_special
end

-- Check if a given string is a valid hex color code
-- Usage: local valid = is_hex_colour("#FF00AA") -- Returns true
local function is_hex_colour(str)
    return (str:match("^#%x%x%x%x%x%x$") ~= nil)
end

--[[
    ASSIGN LOCAL FUNCTIONS
]]

utils.validation = utils.validation or {}

utils.validation.has_min_length = has_min_length
utils.validation.has_max_length = has_max_length
utils.validation.matches_pattern = matches_pattern
utils.validation.is_email = is_email
utils.validation.is_alpha = is_alpha
utils.validation.is_digit = is_digit
utils.validation.is_alphanumeric = is_alphanumeric
utils.validation.is_within_range = is_within_range
utils.validation.is_url = is_url
utils.validation.is_date = is_date
utils.validation.is_username = is_username
utils.validation.is_ip_address = is_ip_address
utils.validation.is_server_address = is_server_address
utils.validation.is_strong_password = is_strong_password
utils.validation.is_hex_colour = is_hex_colour