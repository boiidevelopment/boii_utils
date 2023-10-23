----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    STRING UTILITIES
]]

-- Trim leading and trailing whitespace from a string
-- Usage: local trimmed = trim("  Hello World  ") -- Returns "Hello World"
local function trim(value)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

-- Check if a string starts with a given substring
-- Usage: local starts = starts_with("Hello World", "Hello") -- Returns true
local function starts_with(str, start)
    return str:sub(1, #start) == start
end

-- Check if a string ends with a given substring
-- Usage: local ends = ends_with("Hello World", "World") -- Returns true
local function ends_with(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

-- Split a string by a delimiter
-- Usage: local parts = split_string("Hello,World", ",") -- Returns {"Hello", "World"}
local function split_string(str, delimiter)
    local result = {}
    for part in string.gmatch(str, "([^"..delimiter.."]+)") do
        table.insert(result, part)
    end
    return result
end

-- Count the occurrences of a substring in a string
-- Usage: local count = count_occurrences("Hello World Hello Lua", "Hello") -- Returns 2
local function count_occurrences(str, substring)
    local _, count = string.gsub(str, substring, substring)
    return count
end

-- Replace all occurrences of a substring in a string
-- Usage: local replaced = replace_string("Hello World Hello Lua", "Hello", "Hi") -- Returns "Hi World Hi Lua"
local function replace_string(str, find, replace)
    return string.gsub(str, find, replace)
end

-- Check if a string is empty or only contains whitespace
-- Usage: local is_empty = is_empty_or_whitespace("   ") -- Returns true
local function is_empty(str)
    return trim(str) == ""
end

-- Reverse a string
-- Usage: local reversed = reverse_string("Hello") -- Returns "olleH"
local function reverse_string(str)
    return string.reverse(str)
end

-- Pad a string to the left
-- Usage: local padded = pad_left("Hello", 10, "*") -- Returns "*****Hello"
local function pad_left(str, len, char)
    char = char or " "
    return string.rep(char, len - #str) .. str
end

-- Pad a string to the right
-- Usage: local padded = pad_right("Hello", 10, "*") -- Returns "Hello*****"
local function pad_right(str, len, char)
    char = char or " "
    return str .. string.rep(char, len - #str)
end

-- Check if a string contains another string
-- Usage: local has = string_contains("Hello World", "World") -- Returns true
local function string_contains(str, find)
    return string.find(str, find, 1, true) ~= nil
end

-- Convert a string to a boolean value
-- Usage: local boolValue = to_boolean("true") -- Returns true
local function to_boolean(str)
    return str == "true"
end

-- Capitalize the first letter of each word in a string
-- Usage: local capitalized = capitalize("hello world") -- Returns "Hello World"
local function capitalize(str)
    return string.gsub(str, "(%a)([%w_']*)", function(first, rest) return first:upper()..rest:lower() end)
end

-- Generate a random string of given length
-- Usage: local randStr = random_string(10) -- Returns a random 10-character string
local function random_string(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = {}
    for _ = 1, length do
        local randomChar = chars[math.random(1, #chars)]
        table.insert(result, randomChar)
    end
    return table.concat(result)
end

-- Check if all characters in a string are alphabets
-- Usage: local isAlpha = is_alphabet("Hello") -- Returns true
local function is_alphabet(str)
    return not string.find(str, "%W")
end

--[[
    ASSIGN LOCALS
]]

utils.strings = utils.strings or {}

utils.strings.trim = trim
utils.strings.starts_with = starts_with
utils.strings.ends_with = ends_with
utils.strings.split_string = split_string
utils.strings.count_occurrences = count_occurrences
utils.strings.replace_string = replace_string
utils.strings.is_empty_or_whitespace = is_empty_or_whitespace
utils.strings.reverse_string = reverse_string
utils.strings.pad_left = pad_left
utils.strings.pad_right = pad_right
utils.strings.string_contains = string_contains
utils.strings.to_boolean = to_boolean
utils.strings.capitalize = capitalize
utils.strings.random_string = random_string
utils.strings.is_alphabet = is_alphabet