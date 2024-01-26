--- This script provides a set of utilities for input validation.
-- @script server/validation_utilities.lua

--- @section Local functions

--- Checks if a given string has a minimum length.
-- @function has_min_length
-- @param str The string to check.
-- @param length The minimum length.
-- @return Boolean indicating if the string meets the minimum length.
-- @usage local valid = utils.validation.has_min_length("Hello", 5)
local function has_min_length(str, length)
    return #str >= length
end

--- Checks if a given string has a maximum length.
-- @function has_max_length
-- @param str The string to check.
-- @param length The maximum length.
-- @return Boolean indicating if the string is within the maximum length.
-- @usage local valid = utils.validation.has_max_length("Hello", 10)
local function has_max_length(str, length)
    return #str <= length
end

--- Checks if a given string matches a specific pattern (regex).
-- @function matches_pattern
-- @param str The string to check.
-- @param pattern The regex pattern to match.
-- @return Boolean indicating if the string matches the pattern.
-- @usage local valid = utils.validation.matches_pattern("abc", "^%a+$")
local function matches_pattern(str, pattern)
    return (str:match(pattern) ~= nil)
end

--- Checks if a given string is a valid email address format.
-- @function is_email
-- @param str The string to check.
-- @return Boolean indicating if the string is a valid email format.
-- @usage local valid = utils.validation.is_email("test@example.com")
local function is_email(str)
    return (str:match("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+%.%a%a+$") ~= nil)
end

--- Checks if a given string has only alphabets.
-- @function is_alpha
-- @param str The string to check.
-- @return Boolean indicating if the string has only alphabets.
-- @usage local valid = utils.validation.is_alpha("Hello")
local function is_alpha(str)
    return (str:match("^%a+$") ~= nil)
end

--- Checks if a given string has only digits.
-- @function is_digit
-- @param str The string to check.
-- @return Boolean indicating if the string has only digits.
-- @usage local valid = utils.validation.is_digit("12345")
local function is_digit(str)
    return (str:match("^%d+$") ~= nil)
end

--- Checks if a given string is alphanumeric (contains only letters and numbers).
-- @function is_alphanumeric
-- @param str The string to check.
-- @return Boolean indicating if the string is alphanumeric.
-- @usage local valid = utils.validation.is_alphanumeric("Hello123")
local function is_alphanumeric(str)
    return (str:match("^%w+$") ~= nil)
end

--- Checks if a given value is within a certain range (inclusive).
-- @function is_within_range
-- @param value The value to check.
-- @param min The minimum bound.
-- @param max The maximum bound.
-- @return Boolean indicating if the value is within the range.
-- @usage local valid = utils.validation.is_within_range(5, 1, 10)
local function is_within_range(value, min, max)
    return value >= min and value <= max
end

--- Checks if a given string is a valid URL.
-- @function is_url
-- @param str The string to check.
-- @return Boolean indicating if the string is a valid URL.
-- @usage local valid = utils.validation.is_url("https://www.example.com")
local function is_url(str)
    local pattern = "https?://[%w-]+%.%w+([/?].*)?$"
    return (str:match(pattern) ~= nil)
end

--- Checks if a given value is a valid date format (YYYY-MM-DD).
-- @function is_date
-- @param str The string to check.
-- @return Boolean indicating if the string is a valid date format.
-- @usage local valid = utils.validation.is_date("2023-04-01")
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

--- Checks if a given string is a valid username (assuming certain generic rules).
-- @function is_username
-- @param str The string to check.
-- @return Boolean indicating if the string is a valid username.
-- @usage local valid = utils.validation.is_username("Username123")
local function is_username(str)
    return (str:match("^%w{5,20}$") ~= nil)
end

--- Checks if a given string is a valid IP address.
-- @function is_ip_address
-- @param str The string to check.
-- @return Boolean indicating if the string is a valid IP address.
-- @usage local valid = utils.validation.is_ip_address("192.168.1.1")
local function is_ip_address(str)
    return (str:match("^(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)$") ~= nil)
end

--- Checks if a given string is a valid server IP address with port (e.g., 192.168.1.1:30120).
-- @function is_server_address
-- @param str The string to check.
-- @return Boolean indicating if the string is a valid server address.
-- @usage local valid = utils.validation.is_server_address("192.168.1.1:30120")
local function is_server_address(str)
    return (str:match("^(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?):%d+$") ~= nil)
end

--- Checks if a given string is a strong password (uppercase, lowercase, digit, special char).
-- @function is_strong_password
-- @param str The string to check.
-- @return Boolean indicating if the string is a strong password.
-- @usage local valid = utils.validation.is_strong_password("Password123!")
local function is_strong_password(str)
    local has_upper = str:match("%u")
    local has_lower = str:match("%l")
    local has_digit = str:match("%d")
    local has_special = str:match("%W")
    return has_upper and has_lower and has_digit and has_special
end

--- Checks if a given string is a valid hex color code.
-- @function is_hex_colour
-- @param str The string to check.
-- @return Boolean indicating if the string is a valid hex color code.
-- @usage local valid = utils.validation.is_hex_colour("#FF00AA")
local function is_hex_colour(str)
    return (str:match("^#%x%x%x%x%x%x$") ~= nil)
end

--- @section Assign local functions

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