----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    FUNCTIONS
]]

-- Function to generate a unique ID 
-- `prefix`: A string that will be the start of the ID (e.g., "CAR", "MOTO")
-- `length`: The desired length of the numeric part of the ID
-- `table_name`: The name of the database table where IDs should be checked for uniqueness
-- `column_name`: The name of the column to check in the table
-- `json_path`: Optional parameter, the JSON path if the ID is stored within JSON text
-- Example: local id = utils.db.generate_unique_id("FSC", 5, "player_licences", "licences", 'firearms.data.id')
local function generate_unique_id(prefix, length, table_name, column_name, json_path)
    local charset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local id
    local function create_id()
        local newId = prefix
        for i = 1, length do
            local random_index = math.random(1, #charset)
            newId = newId .. charset:sub(random_index, random_index)
        end
        return newId
    end
    local function id_exists(newId)
        local query
        if json_path then
            query = string.format("SELECT COUNT(*) as count FROM %s WHERE JSON_EXTRACT(%s, '$.%s') = ?", table_name, column_name, json_path)
        else
            query = string.format("SELECT COUNT(*) as count FROM %s WHERE %s = ?", table_name, column_name)
        end
        local result = MySQL.query.await(query, { newId })
        return result and result[1] and result[1].count > 0
    end
    repeat
        id = create_id()
    until not id_exists(id)
    return id
end

--[[
    ASSIGN LOCALS
]]

utils.db = utils.db or {}

utils.db.generate_unique_id = generate_unique_id