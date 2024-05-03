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

--- Table functions.
-- @script shared/tables/tables.lua

--- @section Local functions

--- Prints the contents of a table to the console. Useful for debugging.
-- @function print_table
-- @param t The table to print.
-- @param indent The indentation level for nested tables.
-- @usage utils.tables.print_table({a = 1, b = {x = 10, y = 20}})
local function print_table(t, indent)
    indent = indent or ''
    for k, v in pairs(t) do
        if type(v) == 'table' then
            print(indent .. k .. ':')
            print_table(v, indent .. '  ')
        else
            local value_str = type(v) == "boolean" and tostring(v) or v
            print(indent .. k .. ': ' .. value_str)
        end
    end
end

--- Checks if a table contains a specific value.
-- Updated to support nested tables.
-- @function table_contains
-- @param t The table to check.
-- @param val The value to search for in the table.
-- @return Boolean indicating if the value was found.
-- @usage local contains = utils.tables.table_contains({1, 2, 3, 4, 5}, 3)
local function table_contains(tbl, val)
    for _, value in pairs(tbl) do
        if value == val then
            return true
        elseif type(value) == "table" then
            if table_contains(value, val) then
                return true
            end
        end
    end
    return false
end

--- Counts the number of entries in a table.
-- @function table_count
-- @param t The table to count entries in.
-- @return The number of entries in the table.
-- @usage local count = utils.tables.table_count({a = 1, b = 2, c = 3})
local function table_count(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

--- Creates a deep copy of a table, ensuring changes to the copy won't affect the original table.
-- @function deep_copy
-- @param t The table to copy.
-- @return A deep copy of the table.
-- @usage local copied_table = utils.tables.deep_copy(original_table)
local function deep_copy(t)
    local orig_type = type(t)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, t, nil do
            copy[deep_copy(orig_key)] = deep_copy(orig_value)
        end
        setmetatable(copy, deep_copy(getmetatable(t)))
    else
        copy = t
    end
    return copy
end

--- Flattens a nested table into a single level table.
-- @function flatten
-- @param t The table to flatten.
-- @param flat Optional accumulator table.
-- @return The flattened table.
-- @usage local flat_table = utils.tables.flatten({1, 2, {3, 4, {5, 6}}, 7})
local function flatten(t, flat)
    flat = flat or {}
    for _, v in ipairs(t) do
        if type(v) == "table" then
            flatten(v, flat)
        else
            flat[#flat + 1] = v
        end
    end
    return flat
end

--- Merges two tables, with values from the second table overwriting existing keys in the first table.
-- @function merge_tables
-- @param t1 The first table.
-- @param t2 The second table.
-- @return The merged table.
-- @usage local merged_table = utils.tables.merge_tables({a = 1, b = 2}, {b = 3, c = 4})
local function merge_tables(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end
    return t1
end

--- Removes a specific value from a table.
-- @function remove_value_from_table
-- @param t The table to remove the value from.
-- @param value The value to remove.
-- @return The modified table.
-- @usage local modified_table = utils.tables.remove_value_from_table({1, 2, 3, 4, 5}, 3)
local function remove_value_from_table(t, value)
    for i, v in ipairs(t) do
        if v == value then
            table.remove(t, i)
            break
        end
    end
    return t
end

--- Filters a table based on a given condition function.
-- @function filter_table
-- @param t The table to filter.
-- @param condition The condition function to use for filtering.
-- @return The filtered table.
-- @usage local evens = utils.tables.filter_table({1, 2, 3, 4, 5}, function(num) return num % 2 == 0 end)
local function filter_table(t, condition)
    local result = {}
    for _, v in ipairs(t) do
        if condition(v) then
            result[#result + 1] = v
        end
    end
    return result
end

--- Applies a function to each item in the table and returns a new table with the results.
-- @function map_table
-- @param t The table to map.
-- @param func The function to apply to each item.
-- @return The resulting table after applying the function.
-- @usage local doubled = utils.tables.map_table({1, 2, 3, 4, 5}, function(num) return num * 2 end)
local function map_table(t, func)
    local result = {}
    for _, v in ipairs(t) do
        result[#result + 1] = func(v)
    end
    return result
end

--- Finds an item in the table based on a given condition function.
-- @function find_in_table
-- @param t The table to search in.
-- @param condition The condition function to use for finding the item.
-- @return The found item, or nil if not found.
-- @usage local found = utils.tables.find_in_table({1, 2, 3, 4, 5}, function(num) return num > 3 end)
local function find_in_table(t, condition)
    for _, v in ipairs(t) do
        if condition(v) then
            return v
        end
    end
    return nil
end

--- Gets all keys from a table.
-- @function get_keys
-- @param t The table to get keys from.
-- @return A table containing all keys from the input table.
-- @usage local keys = utils.tables.get_keys({a = 1, b = 2, c = 3})
local function get_keys(t)
    local keys = {}
    for k in pairs(t) do
        keys[#keys + 1] = k
    end
    return keys
end

--- Gets a random value from a table.
-- Mostly pointless could just use math.random(1, #table) really but its here since why not.
-- @function get_random_value
-- @param t The table to get a random value from.
-- @return A random value from the table.
-- @usage local random_fruit = utils.tables.get_random_value({"apple", "banana", "cherry"})
local function get_random_value(t)
    local index = math.random(1, #t)
    return t[index]
end

--- Calculates the intersection of two tables (elements present in both tables).
-- @function intersection
-- @param t1 The first table.
-- @param t2 The second table.
-- @return A table containing elements present in both input tables.
-- @usage local intersection_table = utils.tables.intersection({1, 2, 3}, {3, 4, 5})
local function intersection(t1, t2)
    local inter = {}
    for _, v in ipairs(t1) do
        if table_contains(t2, v) then
            inter[#inter + 1] = v
        end
    end
    return inter
end

--- Calculates the difference of two tables (elements present in the first table but not in the second).
-- @function difference
-- @param t1 The first table.
-- @param t2 The second table.
-- @return A table containing elements present in the first table but not in the second.
-- @usage local diff_table = utils.tables.difference({1, 2, 3}, {3, 4, 5})
local function difference(t1, t2)
    local diff = {}
    for _, v in ipairs(t1) do
        if not table_contains(t2, v) then
            diff[#diff + 1] = v
        end
    end
    return diff
end

--- Shuffles a table.
-- @function shuffle
-- @param t The table to shuffle.
-- @return The shuffled table.
-- @usage local shuffled_table = utils.tables.shuffle({1, 2, 3, 4, 5})
local function shuffle(t)
    local shuffled = {}
    for i = #t, 1, -1 do
        local rand = math.random(i)
        shuffled[#shuffled + 1] = t[rand]
        table.remove(t, rand)
    end
    return shuffled
end

--- Converts a table to a string representation.
-- @function table_to_string
-- @param t The table to convert.
-- @return The string representation of the table.
-- @usage local str = utils.tables.table_to_string({a = 1, b = 2, c = 3})
local function table_to_string(t)
    local str = "{"
    for k, v in pairs(t) do
        local value = type(v) == "table" and table_to_string(v) or tostring(v)
        str = str .. k .. " = " .. value .. ", "
    end
    return str:sub(1, -3) .. "}" -- Remove trailing comma and space, and close with }
end

--- Reduces a table to a single value using a reducer function.
-- @function reduce
-- @param t The table to reduce.
-- @param reducer The reducer function to apply to each item.
-- @param initial The initial accumulator value.
-- @return The final accumulator value after applying the reducer to each item.
-- @usage local sum = utils.tables.reduce({1, 2, 3, 4}, function(acc, val) return acc + val end, 0)
local function reduce(t, condition, initial)
    local acc = initial
    for _, v in ipairs(t) do
        acc = condition(acc, v)
    end
    return acc
end

--- Checks if all elements in a table satisfy a given condition.
-- @function every
-- @param t The table to check.
-- @param condition The condition function to test each element.
-- @return Boolean indicating if all elements satisfy the condition.
-- @usage local all_even = utils.tables.every({2, 4, 6}, function(num) return num % 2 == 0 end)
local function every(t, condition)
    for _, v in ipairs(t) do
        if not condition(v) then return false end
    end
    return true
end

--- Checks if at least one element in a table satisfies a given condition.
-- @function some
-- @param t The table to check.
-- @param condition The condition function to test each element.
-- @return Boolean indicating if at least one element satisfies the condition.
-- @usage local has_odd = utils.tables.some({2, 4, 5}, function(num) return num % 2 ~= 0 end)
local function some(t, condition)
    for _, v in ipairs(t) do
        if condition(v) then return true end
    end
    return false
end

--- Removes and returns the last element from the table.
-- @function pop
-- @param t The table to remove the element from.
-- @return The removed element.
-- @usage local last = utils.tables.pop(tbl)
local function pop(t)
    return table.remove(t)
end

--- Removes and returns the first element from the table.
-- @function shift
-- @param t The table to remove the element from.
-- @return The removed element.
-- @usage local first = utils.tables.shift(tbl)
local function shift(t)
    local first = t[1]
    table.remove(t, 1)
    return first
end

--- Adds an element to the end of the table.
-- @function push
-- @param t The table to add the element to.
-- @param val The element to add.
-- @usage utils.tables.push(tbl, value)
local function push(t, val)
    table.insert(t, val)
end

--- Adds an element to the beginning of the table.
-- @function unshift
-- @param t The table to add the element to.
-- @param val The element to add.
-- @usage utils.tables.unshift(tbl, value)
local function unshift(t, val)
    table.insert(t, 1, val)
end

--- @section Assign local functions

utils.tables.print_table = print_table
utils.tables.table_contains = table_contains
utils.tables.table_count = table_count
utils.tables.deep_copy = deep_copy
utils.tables.flatten = flatten
utils.tables.merge_tables = merge_tables
utils.tables.remove_value_from_table = remove_value_from_table
utils.tables.filter_table = filter_table
utils.tables.map_table = map_table
utils.tables.find_in_table = find_in_table
utils.tables.get_keys = get_keys
utils.tables.get_random_value = get_random_value
utils.tables.intersection = intersection
utils.tables.difference = difference
utils.tables.shuffle = shuffle
utils.tables.table_to_string = table_to_string
utils.tables.reduce = reduce
utils.tables.every = every
utils.tables.some = some
utils.tables.pop = pop
utils.tables.shift = shift
utils.tables.push = push
utils.tables.unshift = unshift