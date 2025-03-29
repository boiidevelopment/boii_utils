local tables = {}

--- Prints the contents of a table to the console. Useful for debugging.
--- @param t The table to print.
--- @param indent The indentation level for nested tables.
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
--- @param t The table to check.
--- @param val The value to search for in the table.
--- @return Boolean indicating if the value was found.
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

--- Creates a deep copy of a table, ensuring changes to the copy won't affect the original table.
--- @param t The table to copy.
--- @return A deep copy of the table.
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

--- Compares two nested tables.
--- @param t1 The first table.
--- @param t2 The second table.
--- @return Boolean indicating if the two tables are equal.
local function deep_compare(t1, t2)
    if t1 == t2 then return true end

    if type(t1) ~= "table" or type(t2) ~= "table" then return false end

    for k, v in pairs(t1) do
        if not deep_compare(v, t2[k]) then return false end
    end

    for k in pairs(t2) do
        if t1[k] == nil then return false end
    end

    return true
end

--- @section Function Assignments

tables.print = print_table
tables.contains = table_contains
tables.deep_copy = deep_copy
tables.compare = deep_compare

--- @section Exports

exports('print_table', print_table)
exports('table_contains', table_contains)
exports('deep_copy', deep_copy)
exports('deep_compare', deep_compare)


return tables