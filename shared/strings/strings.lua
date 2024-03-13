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

--- String functions.
-- @script shared/strings/strings.lua

--- @section Local functions

--- Trims leading and trailing whitespace from a string.
-- @function trim
-- @param value The string to trim.
-- @return The trimmed string.
-- @usage local trimmed = utils.strings.trim("  Hello World  ")
local function trim(value)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

--- Checks if a string starts with a given substring.
-- @function starts_with
-- @param str The string to check.
-- @param start The substring to look for.
-- @return Boolean indicating if the string starts with the substring.
-- @usage local starts = utils.strings.starts_with("Hello World", "Hello")
local function starts_with(str, start)
    return str:sub(1, #start) == start
end

--- Checks if a string ends with a given substring.
-- @function ends_with
-- @param str The string to check.
-- @param ending The substring to look for.
-- @return Boolean indicating if the string ends with the substring.
-- @usage local ends = utils.strings.ends_with("Hello World", "World")
local function ends_with(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

--- Splits a string by a delimiter into a table.
-- @function split_string
-- @param str The string to split.
-- @param delimiter The delimiter to use for splitting.
-- @return A table containing the split parts of the string.
-- @usage local parts = utils.strings.split_string("Hello,World", ",")
local function split_string(str, delimiter)
    local result = {}
    for part in string.gmatch(str, "([^"..delimiter.."]+)") do
        table.insert(result, part)
    end
    return result
end

--- Counts the occurrences of a substring in a string.
-- @function count_occurrences
-- @param str The string to search.
-- @param substring The substring to count.
-- @return The number of occurrences of the substring.
-- @usage local count = utils.strings.count_occurrences("Hello World Hello Lua", "Hello")
local function count_occurrences(str, substring)
    local _, count = string.gsub(str, substring, substring)
    return count
end

--- Replaces all occurrences of a substring in a string with another substring.
-- @function replace_string
-- @param str The string to modify.
-- @param find The substring to find.
-- @param replace The substring to replace with.
-- @return The modified string.
-- @usage local replaced = utils.strings.replace_string("Hello World Hello Lua", "Hello", "Hi")
local function replace_string(str, find, replace)
    return string.gsub(str, find, replace)
end

--- Checks if a string is empty or contains only whitespace.
-- @function is_empty_or_whitespace
-- @param str The string to check.
-- @return Boolean indicating if the string is empty or contains only whitespace.
-- @usage local is_empty = utils.strings.is_empty_or_whitespace("   ")
local function is_empty(str)
    return trim(str) == ""
end

--- Reverses a string.
-- @function reverse_string
-- @param str The string to reverse.
-- @return The reversed string.
-- @usage local reversed = utils.strings.reverse_string("Hello")
local function reverse_string(str)
    return string.reverse(str)
end

--- Pads a string on the left side to a specified length.
-- @function pad_left
-- @param str The string to pad.
-- @param len The total length of the padded string.
-- @param char The character to use for padding.
-- @return The padded string.
-- @usage local padded = utils.strings.pad_left("Hello", 10, "*")
local function pad_left(str, len, char)
    char = char or " "
    return string.rep(char, len - #str) .. str
end

--- Pads a string on the right side to a specified length.
-- @function pad_right
-- @param str The string to pad.
-- @param len The total length of the padded string.
-- @param char The character to use for padding.
-- @return The padded string.
-- @usage local padded = utils.strings.pad_right("Hello", 10, "*")
local function pad_right(str, len, char)
    char = char or " "
    return str .. string.rep(char, len - #str)
end

--- Checks if a string contains another string.
-- @function string_contains
-- @param str The string to search in.
-- @param find The substring to search for.
-- @return Boolean indicating if the substring is found in the string.
-- @usage local has = utils.strings.string_contains("Hello World", "World")
local function string_contains(str, find)
    return string.find(str, find, 1, true) ~= nil
end

--- Converts a string representation of a boolean to an actual boolean value.
-- @function to_boolean
-- @param str The string to convert.
-- @return The boolean value of the string.
-- @usage local bool_value = utils.strings.to_boolean("true")
local function to_boolean(str)
    return str == "true"
end

--- Capitalizes the first letter of each word in a string.
-- @function capitalize
-- @param str The string to capitalize.
-- @return The capitalized string.
-- @usage local capitalized = utils.strings.capitalize("hello world")
local function capitalize(str)
    return string.gsub(str, "(%a)([%w_']*)", function(first, rest) return first:upper()..rest:lower() end)
end

--- Generates a random string of a specified length.
-- @function random_string
-- @param length The length of the random string.
-- @return The random string.
-- @usage local rand_str = utils.strings.random_string(10)
local function random_string(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = {}
    for _ = 1, length do
        local randomChar = chars[math.random(1, #chars)]
        table.insert(result, randomChar)
    end
    return table.concat(result)
end

--- Checks if all characters in a string are alphabets.
-- @function is_alphabet
-- @param str The string to check.
-- @return Boolean indicating if all characters are alphabets.
-- @usage local is_alpha = utils.strings.is_alphabet("Hello")
local function is_alphabet(str)
    return not string.find(str, "%W")
end

--- @section Assign local functions

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