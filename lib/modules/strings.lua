local strings = {}

--- Capitalizes the first letter of each word in a string.
--- @param str The string to capitalize.
--- @return The capitalized string.
local function capitalize(str)
    return string.gsub(str, "(%a)([%w_']*)", function(first, rest) return first:upper()..rest:lower() end)
end

--- Generates a random string of a specified length.
--- @param length The length of the random string.
--- @return The random string.
local function random_string(length)
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local result = {}

    for _ = 1, length do
        local r_char = chars:sub(math.random(1, #chars), math.random(1, #chars))
        table.insert(result, r_char)
    end

    return table.concat(result)
end

--- Splits a string into a table based on a given delimiter.
--- @param str The string to split.
--- @param delimiter The delimiter to split by.
--- @return A table of split segments.
local function split(str, delimiter)
    local result = {}

    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        result[result + 1] = match
    end
    
    return result
end

--- Trims whitespace from the beginning and end of a string.
--- @param str The string to trim.
--- @return The trimmed string.
local function trim(str)
    return str:match("^%s*(.-)%s*$")
end

--- Converts a snake_case string to a readable string.
--- @param str string: The snake_case string.
--- @param case_type string: "normal" | "title" | "upper"
--- @return string
local function format_snake_case(str, case_type)
    local parts = {}
    for word in string.gmatch(str, "[^_]+") do
        table.insert(parts, word)
    end

    if case_type == "title" then
        for i = 1, #parts do
            parts[i] = parts[i]:sub(1,1):upper() .. parts[i]:sub(2):lower()
        end
    elseif case_type == "upper" then
        for i = 1, #parts do
            parts[i] = parts[i]:upper()
        end
    end

    return table.concat(parts, " ")
end

--- Checks if a string starts with a given substring.
--- @param str string
--- @param start string
--- @return boolean
local function starts_with(str, start)
    return str:sub(1, #start) == start
end

--- Checks if a string ends with a given substring.
--- @param str string
--- @param ending string
--- @return boolean
local function ends_with(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

--- @section Function Assignments

strings.capitalize = capitalize
strings.random_string = random_string
strings.split = split
strings.trim = trim
strings.format_snake_case = format_snake_case
strings.starts_with = starts_with
strings.ends_with = ends_with

--- @section Exports

exports('capitalize', capitalize)
exports('random_string', random_string)
exports('split', split)
exports('trim', trim)
exports('format_snake_case', format_snake_case)
exports('starts_with', starts_with)
exports('ends_with', ends_with)

return strings
