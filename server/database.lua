--- This section covers database related functions
-- @script server/database.lua

--- @section Local functions

--- Generates a unique ID by concatenating a prefix with a randomly generated string of specified length.
-- This function checks the uniqueness of the ID in the specified database table and column.
-- If a JSON path is provided, it checks within the JSON structure in the specified column.
-- @param prefix A string prefix for the ID (e.g., "CAR", "MOTO").
-- @param length The length of the numeric part of the ID.
-- @param table_name The name of the database table for uniqueness check.
-- @param column_name The name of the database column for uniqueness check.
-- @param json_path (Optional) The JSON path if the ID is within a JSON structure.
-- @return A unique ID string.
local function generate_unique_id(prefix, length, table_name, column_name, json_path)
    local charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local id
    local function create_id()
        local new_id = prefix
        for i = 1, length do
            local random_index = math.random(1, #charset)
            new_id = new_id .. charset:sub(random_index, random_index)
        end
        return new_id
    end
    local function id_exists(new_id)
        local query
        if json_path then
            query = string.format("SELECT COUNT(*) as count FROM %s WHERE JSON_EXTRACT(%s, '$.%s') = ?", table_name, column_name, json_path)
        else
            query = string.format("SELECT COUNT(*) as count FROM %s WHERE %s = ?", table_name, column_name)
        end
        local result = MySQL.query.await(query, { new_id })
        return result and result[1] and result[1].count > 0
    end
    repeat
        id = create_id()
    until not id_exists(id)
    return id
end

--- @section Assign local functions

utils.db = utils.db or {}

utils.db.generate_unique_id = generate_unique_id