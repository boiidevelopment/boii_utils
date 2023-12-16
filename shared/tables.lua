----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    TABLE UTILITIES
]]

-- Print the contents of a table (useful for debugging)
-- Usage: print_table({a = 1, b = {x = 10, y = 20}})
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

-- Check if a table contains a specific value
-- Usage: local contains = table_contains({1, 2, 3, 4, 5}, 3) -- Returns true
local function table_contains(t, val)
    for _, value in ipairs(t) do
        if value == val then
            return true
        end
    end
    return false
end

-- Count the number of entries in a table
-- Usage: local count = table_count({a = 1, b = 2, c = 3}) -- Returns 3
local function table_count(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

-- Create a deep copy of a table, ensuring changes to the copy won't affect the original table
-- Usage: local copied_table = deep_copy(original_table)
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

-- Flattens a nested table
-- Usage: local flat_table = flatten({1, 2, {3, 4, {5, 6}}, 7}) -- Returns {1, 2, 3, 4, 5, 6, 7}
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

-- Merge two tables
-- Usage: local merged_table = merge_tables({a = 1, b = 2}, {b = 3, c = 4}) -- Returns {a = 1, b = 3, c = 4}
local function merge_tables(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end
    return t1
end

-- Remove specific value from table
-- Usage: local modified_table = remove_value_from_table({1, 2, 3, 4, 5}, 3) -- Returns {1, 2, 4, 5}
local function remove_value_from_table(t, value)
    for i, v in ipairs(t) do
        if v == value then
            table.remove(t, i)
            break
        end
    end
    return t
end

-- Filter a table based on a given condition
-- Usage: local evens = filter_table({1, 2, 3, 4, 5}, function(num) return num % 2 == 0 end) -- Returns {2, 4}
local function filter_table(t, condition)
    local result = {}
    for _, v in ipairs(t) do
        if condition(v) then
            result[#result + 1] = v
        end
    end
    return result
end

-- Apply a function to each item in the table
-- Usage: local doubled = map_table({1, 2, 3, 4, 5}, function(num) return num * 2 end) -- Returns {2, 4, 6, 8, 10}
local function map_table(t, func)
    local result = {}
    for _, v in ipairs(t) do
        result[#result + 1] = func(v)
    end
    return result
end

-- Find an item in the table based on a given condition
-- Usage: local found = find_in_table({1, 2, 3, 4, 5}, function(num) return num > 3 end) -- Returns 4
local function find_in_table(t, condition)
    for _, v in ipairs(t) do
        if condition(v) then
            return v
        end
    end
    return nil
end

-- Get all keys from a table
-- Usage: local keys = get_keys({a = 1, b = 2, c = 3}) -- Returns {"a", "b", "c"}
local function get_keys(t)
    local keys = {}
    for k in pairs(t) do
        keys[#keys + 1] = k
    end
    return keys
end

-- Gets a random value from a table
-- Usage: local random_fruit = get_random_value({"apple", "banana", "cherry"}) -- Returns e.g., "banana"
local function get_random_value(t)
    local index = math.random(1, #t)
    return t[index]
end

-- Intersection of two tables
-- Usage: local intersection_table = intersection({1, 2, 3}, {3, 4, 5}) -- Returns {3}
local function intersection(t1, t2)
    local inter = {}
    for _, v in ipairs(t1) do
        if table_contains(t2, v) then
            inter[#inter + 1] = v
        end
    end
    return inter
end

-- Difference of two tables
-- Usage: local diff_table = difference({1, 2, 3}, {3, 4, 5}) -- Returns {1, 2}
local function difference(t1, t2)
    local diff = {}
    for _, v in ipairs(t1) do
        if not table_contains(t2, v) then
            diff[#diff + 1] = v
        end
    end
    return diff
end

-- Shuffle table
-- Usage: local shuffled_table = shuffle({1, 2, 3, 4, 5})
local function shuffle(t)
    local shuffled = {}
    for i = #t, 1, -1 do
        local rand = math.random(i)
        shuffled[#shuffled + 1] = t[rand]
        table.remove(t, rand)
    end
    return shuffled
end

-- Convert table to string
-- Usage: local str = table_to_string({a = 1, b = 2, c = 3})
local function table_to_string(t)
    local str = "{"
    for k, v in pairs(t) do
        local value = type(v) == "table" and table_to_string(v) or tostring(v)
        str = str .. k .. " = " .. value .. ", "
    end
    return str:sub(1, -3) .. "}" -- Remove trailing comma and space, and close with }
end

-- Reduce a table to a single value
-- Usage: local sum = reduce({1, 2, 3, 4}, function(acc, val) return acc + val end, 0) -- Returns 10
local function reduce(t, condition, initial)
    local acc = initial
    for _, v in ipairs(t) do
        acc = condition(acc, v)
    end
    return acc
end

-- Check if all elements in a table satisfy a condition
-- Usage: local all_even = every({2, 4, 6}, function(num) return num % 2 == 0 end) -- Returns true
local function every(t, condition)
    for _, v in ipairs(t) do
        if not condition(v) then return false end
    end
    return true
end

-- Check if at least one element in a table satisfies a condition
-- Usage: local has_odd = some({2, 4, 5}, function(num) return num % 2 ~= 0 end) -- Returns true
local function some(t, condition)
    for _, v in ipairs(t) do
        if condition(v) then return true end
    end
    return false
end

-- Remove and return the last element from the table
-- Usage: local last = pop(tbl)
local function pop(t)
    return table.remove(t)
end

-- Remove and return the first element from the table
-- Usage: local first = shift(tbl)
local function shift(t)
    local first = t[1]
    table.remove(t, 1)
    return first
end

-- Add an element to the end of the table
-- Usage: push(tbl, value)
local function push(t, val)
    table.insert(t, val)
end

-- Add an element to the beginning of the table
-- Usage: unshift(tbl, value)
local function unshift(t, val)
    table.insert(t, 1, val)
end

--[[
    ASSIGN LOCAL FUNCTIONS
]]

utils.tables = utils.tables or {}

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