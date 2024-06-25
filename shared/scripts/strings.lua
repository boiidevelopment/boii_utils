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
--- @script shared/scripts/strings.lua

--- Trims leading and trailing whitespace from a string.
--- @function trim
--- @param value The string to trim.
--- @return The trimmed string.
--- @usage local trimmed = utils.strings.trim('  Hello World  ')
local function trim(value)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

exports('strings_trim', trim)
utils.strings.trim = trim

--- Checks if a string starts with a given substring.
--- @function starts_with
--- @param str The string to check.
--- @param start The substring to look for.
--- @return Boolean indicating if the string starts with the substring.
--- @usage local starts = utils.strings.starts_with('Hello World', 'Hello')
local function starts_with(str, start)
    return str:sub(1, #start) == start
end

exports('strings_starts_with', starts_with)
utils.strings.starts_with = starts_with

--- Checks if a string ends with a given substring.
--- @function ends_with
--- @param str The string to check.
--- @param ending The substring to look for.
--- @return Boolean indicating if the string ends with the substring.
--- @usage local ends = utils.strings.ends_with('Hello World', 'World')
local function ends_with(str, ending)
    return ending == '' or str:sub(-#ending) == ending
end

exports('strings_ends_with', ends_with)
utils.strings.ends_with = ends_with

--- Splits a string by a delimiter into a table.
--- @function split_string
--- @param str The string to split.
--- @param delimiter The delimiter to use for splitting.
--- @return A table containing the split parts of the string.
--- @usage local parts = utils.strings.split_string('Hello,World', ',')
local function split_string(str, delimiter)
    local result = {}
    for part in string.gmatch(str, "([^"..delimiter.."]+)") do
        table.insert(result, part)
    end
    return result
end

exports('strings_split_string', split_string)
utils.strings.split_string = split_string

--- Counts the occurrences of a substring in a string.
--- @function count_occurrences
--- @param str The string to search.
--- @param substring The substring to count.
--- @return The number of occurrences of the substring.
--- @usage local count = utils.strings.count_occurrences('Hello World Hello Lua', 'Hello')
local function count_occurrences(str, substring)
    local _, count = string.gsub(str, substring, substring)
    return count
end

exports('strings_count_occurrences', count_occurrences)
utils.strings.count_occurrences = count_occurrences

--- Replaces all occurrences of a substring in a string with another substring.
--- @function replace_string
--- @param str The string to modify.
--- @param find The substring to find.
--- @param replace The substring to replace with.
--- @return The modified string.
--- @usage local replaced = utils.strings.replace_string('Hello World Hello Lua', 'Hello', 'Hi')
local function replace_string(str, find, replace)
    return string.gsub(str, find, replace)
end

exports('strings_replace_string', replace_string)
utils.strings.replace_string = replace_string

--- Checks if a string is empty or contains only whitespace.
--- @function is_empty_or_whitespace
--- @param str The string to check.
--- @return Boolean indicating if the string is empty or contains only whitespace.
--- @usage local is_empty = utils.strings.is_empty_or_whitespace('   ')
local function is_empty(str)
    return trim(str) == ''
end

exports('strings_is_empty', is_empty)
utils.strings.is_empty = is_empty

--- Reverses a string.
--- @function reverse_string
--- @param str The string to reverse.
--- @return The reversed string.
--- @usage local reversed = utils.strings.reverse_string('Hello')
local function reverse_string(str)
    return string.reverse(str)
end

exports('strings_reverse_string', reverse_string)
utils.strings.reverse_string = reverse_string

--- Pads a string on the left side to a specified length.
--- @function pad_left
--- @param str The string to pad.
--- @param len The total length of the padded string.
--- @param char The character to use for padding.
--- @return The padded string.
--- @usage local padded = utils.strings.pad_left('Hello', 10, '*')
local function pad_left(str, len, char)
    char = char or ' '
    return string.rep(char, len - #str) .. str
end

exports('strings_pad_left', pad_left)
utils.strings.pad_left = pad_left

--- Pads a string on the right side to a specified length.
--- @function pad_right
--- @param str The string to pad.
--- @param len The total length of the padded string.
--- @param char The character to use for padding.
--- @return The padded string.
--- @usage local padded = utils.strings.pad_right('Hello', 10, '*')
local function pad_right(str, len, char)
    char = char or ' '
    return str .. string.rep(char, len - #str)
end

exports('strings_pad_right', pad_right)
utils.strings.pad_right = pad_right

--- Checks if a string contains another string.
--- @function string_contains
--- @param str The string to search in.
--- @param find The substring to search for.
--- @return Boolean indicating if the substring is found in the string.
--- @usage local has = utils.strings.string_contains('Hello World', 'World')
local function string_contains(str, find)
    return string.find(str, find, 1, true) ~= nil
end

exports('strings_string_contains', string_contains)
utils.strings.string_contains = string_contains

--- Converts a string representation of a boolean to an actual boolean value.
--- @function to_boolean
--- @param str The string to convert.
--- @return The boolean value of the string.
--- @usage local bool_value = utils.strings.to_boolean('true')
local function to_boolean(str)
    return str == 'true'
end

exports('strings_to_boolean', to_boolean)
utils.strings.to_boolean = to_boolean

--- Capitalizes the first letter of each word in a string.
--- @function capitalize
--- @param str The string to capitalize.
--- @return The capitalized string.
--- @usage local capitalized = utils.strings.capitalize('hello world')
local function capitalize(str)
    return string.gsub(str, "(%a)([%w_']*)", function(first, rest) return first:upper()..rest:lower() end)
end

exports('strings_capitalize', capitalize)
utils.strings.capitalize = capitalize

--- Generates a random string of a specified length.
--- @function random_string
--- @param length The length of the random string.
--- @return The random string.
--- @usage local rand_str = utils.strings.random_string(10)
local function random_string(length)
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local result = {}
    for _ = 1, length do
        local randomChar = chars:sub(math.random(1, #chars), math.random(1, #chars))
        table.insert(result, randomChar)
    end
    return table.concat(result)
end

exports('strings_random_string', random_string)
utils.strings.random_string = random_string

--- Checks if all characters in a string are alphabets.
--- @function is_alphabet
--- @param str The string to check.
--- @return Boolean indicating if all characters are alphabets.
--- @usage local is_alpha = utils.strings.is_alphabet('Hello')
local function is_alphabet(str)
    return not string.find(str, '%W')
end

exports('strings_is_alphabet', is_alphabet)
utils.strings.is_alphabet = is_alphabet

--- Converts a string to uppercase.
--- @function to_upper
--- @param str The string to convert.
--- @return The uppercase string.
--- @usage local upper = utils.strings.to_upper('hello')
local function to_upper(str)
    return string.upper(str)
end

exports('strings_to_upper', to_upper)
utils.strings.to_upper = to_upper

--- Converts a string to lowercase.
--- @function to_lower
--- @param str The string to convert.
--- @return The lowercase string.
--- @usage local lower = utils.strings.to_lower('HELLO')
local function to_lower(str)
    return string.lower(str)
end

exports('strings_to_lower', to_lower)
utils.strings.to_lower = to_lower

--- Truncates a string to a specified length.
--- @function truncate
--- @param str The string to truncate.
--- @param length The length to truncate to.
--- @return The truncated string.
--- @usage local truncated = utils.strings.truncate('Hello World', 5)
local function truncate(str, length)
    return str:sub(1, length)
end

exports('strings_truncate', truncate)
utils.strings.truncate = truncate

--- Repeats a string a specified number of times.
--- @function repeat_string
--- @param str The string to repeat.
--- @param count The number of times to repeat.
--- @return The repeated string.
--- @usage local repeated = utils.strings.repeat_string('Hello', 3)
local function repeat_string(str, count)
    return string.rep(str, count)
end

exports('strings_repeat_string', repeat_string)
utils.strings.repeat_string = repeat_string

--- Converts a string to a title case.
--- @function to_title_case
--- @param str The string to convert.
--- @return The title-cased string.
--- @usage local title_cased = utils.strings.to_title_case('hello world')
local function to_title_case(str)
    return string.gsub(str, "(%a)([%w_']*)", function(first, rest) return first:upper()..rest:lower() end)
end

exports('strings_to_title_case', to_title_case)
utils.strings.to_title_case = to_title_case

--- Converts the first character of a string to uppercase.
--- @function capitalize_first
--- @param str The string to convert.
--- @return The string with the first character capitalized.
--- @usage local capitalized = utils.strings.capitalize_first('hello')
local function capitalize_first(str)
    return (str:gsub("^%l", string.upper))
end

exports('strings_capitalize_first', capitalize_first)
utils.strings.capitalize_first = capitalize_first

--- Removes all occurrences of a specified character from a string.
--- @function remove_char
--- @param str The string to modify.
--- @param char The character to remove.
--- @return The modified string without the specified character.
--- @usage local modified = utils.strings.remove_char('hello world', 'o')
local function remove_char(str, char)
    local pattern = "%" .. char
    return (str:gsub(pattern, ""))
end

exports('strings_remove_char', remove_char)
utils.strings.remove_char = remove_char

--- Converts a string from one case to another.
--- @function convert_case
--- @param str The input string.
--- @param from_case The current case of the input string.
--- @param to_case The desired case for the output string.
--- @return The converted string.
--- @usage local converted = utils.strings.convert_case('helloWorld', 'camel', 'snake')
local function convert_case(str, from_case, to_case)
    local function camel_to_snake(s) return s:gsub('%f[%l]%u', '_%1'):lower() end
    local function snake_to_camel(s) return s:gsub('_(%a)', function(c) return c:upper() end) end
    local function snake_to_pascal(s) return s:gsub('_(%a)', function(c) return c:upper() end):gsub('^%l', string.upper) end
    local function pascal_to_camel(s) return s:gsub('^%u', string.lower) end
    local function camel_to_pascal(s) return s:gsub('^%l', string.upper) end
    local function pascal_to_snake(s) return s:gsub('(%u)', function(c) return '_' .. c:lower() end):gsub('^_', '') end
    local function camel_to_kebab(s) return s:gsub('%f[%l]%u', '-%1'):lower() end
    local function kebab_to_camel(s) return s:gsub('-(%a)', function(c) return c:upper() end) end
    local function flat_to_upper_flat(s) return s:upper() end
    local function upper_flat_to_flat(s) return s:lower() end
    local function snake_to_screaming_snake(s) return s:upper() end
    local function screaming_snake_to_snake(s) return s:lower() end
    local function snake_to_pascal_snake(s) return s:gsub('_(%a)', function(c) return '_' .. c:upper() end):gsub('^%l', string.upper) end
    local function pascal_snake_to_snake(s) return s:lower() end
    local function snake_to_camel_snake(s) return s:gsub('_(%a)', function(c) return '_' .. c:upper() end) end
    local function camel_snake_to_snake(s) return s:lower() end
    local function snake_to_train(s) return s:gsub('_', '-'):gsub('^%l', string.upper):gsub('%-(%l)', function(c) return '-' .. c:upper() end) end
    local function train_to_snake(s) return s:gsub('-', '_'):lower() end
    local function snake_to_cobol(s) return s:upper():gsub('_', '-') end
    local function cobol_to_snake(s) return s:lower():gsub('-', '_') end

    local conversions = {
        camel = {
            snake = camel_to_snake,
            pascal = camel_to_pascal,
            kebab = camel_to_kebab
        },
        snake = {
            camel = snake_to_camel,
            pascal = snake_to_pascal,
            screaming_snake = snake_to_screaming_snake,
            pascal_snake = snake_to_pascal_snake,
            camel_snake = snake_to_camel_snake,
            train = snake_to_train,
            cobol = snake_to_cobol
        },
        pascal = {
            camel = pascal_to_camel,
            snake = pascal_to_snake
        },
        kebab = {
            camel = kebab_to_camel
        },
        flat = {
            upper_flat = flat_to_upper_flat
        },
        upper_flat = {
            flat = upper_flat_to_flat
        },
        screaming_snake = {
            snake = screaming_snake_to_snake
        },
        pascal_snake = {
            snake = pascal_snake_to_snake
        },
        camel_snake = {
            snake = camel_snake_to_snake
        },
        train = {
            snake = train_to_snake
        },
        cobol = {
            snake = cobol_to_snake
        }
    }
    local from = conversions[from_case]
    if from and from[to_case] then
        return from[to_case](str)
    else
        return str
    end
end

exports('strings_convert_case', convert_case)
utils.strings.convert_case = convert_case

--- Converts a string to a URL-friendly slug.
--- @function slugify
--- @param str The string to convert.
--- @return The slugified string.
--- @usage local slug = utils.strings.slugify('Hello World!')
local function slugify(str)
    local slug = str:lower():gsub('%s+', '-'):gsub('[^%w%-]', '')
    return slug
end

exports('strings_slugify', slugify)
utils.strings.slugify = slugify

--- Counts the number of words in a string.
--- @function count_words
--- @param str The string to count words in.
--- @return The number of words.
--- @usage local word_count = utils.strings.count_words('Hello World!')
local function count_words(str)
    local _, count = string.gsub(str, "%S+", "")
    return count
end

exports('strings_count_words', count_words)
utils.strings.count_words = count_words

--- Calculates the Levenshtein distance between two strings.
--- @function levenshtein_distance
--- @param str1 The first string.
--- @param str2 The second string.
--- @return The Levenshtein distance between the two strings.
--- @usage local distance = utils.strings.levenshtein_distance('kitten', 'sitting')
local function levenshtein_distance(str1, str2)
    local len1, len2 = #str1, #str2
    local matrix = {}
    for i = 0, len1 do
        matrix[i] = {}
        matrix[i][0] = i
    end
    for j = 0, len2 do
        matrix[0][j] = j
    end
    for i = 1, len1 do
        for j = 1, len2 do
            local cost = (str1:sub(i, i) == str2:sub(j, j)) and 0 or 1
            matrix[i][j] = math.min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost)
        end
    end
    return matrix[len1][len2]
end

exports('strings_levenshtein', levenshtein_distance)
utils.strings.levenshtein = levenshtein_distance

--- Checks if a given string is a palindrome.
--- @function is_palindrome
--- @param str The string to check.
--- @return Boolean indicating if the string is a palindrome.
--- @usage local valid = utils.strings.is_palindrome("madam")
local function is_palindrome(str)
    return str == str:reverse()
end

exports('strings_is_palindrome', is_palindrome)
utils.strings.is_palindrome = is_palindrome