--[[
    DB WRAPPER FUNCTIONS
]]

local wrapper_resource = config_sv.sql.wrapper

-- Function to insert into db
-- Usage: 
-- utils.db.insert(query, params) -- No callback
-- utils.db.insert(query, params, [callback])
local function insert(query, params, callback)
    local result, error_msg
    if wrapper_resource == 'mysql-async' then
        MySQL.ready(function ()
            if callback then
                MySQL.Async.insert(query, params, function(id)
                    callback(id)
                end)
            else
                result, error_msg = pcall(function()
                    return MySQL.Sync.insert(query, params)
                end)
                if not result then
                    utils.debugging.err("Database error: " .. tostring(error_msg))
                end
            end
        end)
    elseif wrapper_resource == 'ghmattimysql' then
        if callback then
            exports.ghmattimysql.execute(query, params, function(id)
                callback(id)
            end)
        else
            result, error_msg = pcall(function()
                return exports.ghmattimysql.executeSync(query, params)
            end)
        end
    elseif wrapper_resource == 'oxmysql' then
        if callback then
            exports.oxmysql.insert(query, params, function(id)
                callback(id)
            end)
        else
            result, error_msg = pcall(function()
                return exports.oxmysql.insert_async(query, params)
            end)
        end
    elseif wrapper_resource == 'custom' then
        -- add your own custom code here
        if callback then
            -- Your custom callback logic
        else
            result, error_msg = pcall(function()
                -- Your custom logic
                -- return whatever your custom logic returns
            end)
        end
    end
    if not result and not callback then
        utils.debugging.err("Database error: " .. tostring(error_msg))
    end
    return result
end

-- Function to prepare a statement in the db
-- Usage:
-- utils.db.prepare(query, params) -- No callback
-- utils.db.prepare(query, params, [callback])
local function prepare(query, params, callback)
    if wrapper_resource == 'oxmysql' then
        if callback then
            exports.oxmysql.prepare(query, params, function(response)
                callback(response)
            end)
        else
            local result, error_msg
            result, error_msg = pcall(function()
                return exports.oxmysql.prepare_async(query, params)
            end)
            if not result then
                utils.debugging.err("Database error: " .. tostring(error_msg))
            end
            return result
        end
    elseif wrapper_resource == 'custom' then
        if callback then
            -- Insert your custom callback logic here
            -- Your custom logic should call the provided callback with the result
        else
            local result, error_msg
            result, error_msg = pcall(function()
                -- Insert your custom synchronous logic here
                -- Return the result of your custom logic
            end)
            if not result then
                utils.debugging.err("Database error: " .. tostring(error_msg))
            end
            return result
        end
    else
        utils.debugging.warn("Wrapper " .. wrapper_resource .. " is not supported for prepared statements.")
    end
end

-- Function to query the db
-- Usage:
-- utils.db.query(query, params) -- No callback
-- utils.db.query(query, params, [callback]) -- does callback
local function query(query, params, callback)
    if wrapper_resource == 'mysql-async' then
        MySQL.ready(function ()
            if callback then
                MySQL.Async.fetchAll(query, params, function(response)
                    callback(response)
                end)
            else
                local result, error_msg
                result, error_msg = pcall(function()
                    return MySQL.Sync.fetchAll(query, params)
                end)
                if not result then
                    utils.debugging.err("Database error: " .. tostring(error_msg))
                end
            end
        end)
    elseif wrapper_resource == 'ghmattimysql' then
        local result, error_msg
        result, error_msg = pcall(function()
            return exports.ghmattimysql.execute(query, params)
        end)
        if not result then
            utils.debugging.err("Database error: " .. tostring(error_msg))
        end
        return result
    elseif wrapper_resource == 'oxmysql' then
        if callback then
            exports.oxmysql.query(query, params, function(response)
                if response then
                    for i = 1, #response do
                        local row = response[i]
                        callback(row)
                    end
                end
            end)
        else
            local result, error_msg
            result, error_msg = pcall(function()
                return exports.oxmysql.query_async(query, params)
            end)
            if not result then
                utils.debugging.err("Database error: " .. tostring(error_msg))
            end
            return result
        end
    elseif wrapper_resource == 'custom' then
        if callback then
            -- Insert your custom callback logic here
            -- Your custom logic should call the provided callback with the result
        else
            local result, error_msg
            result, error_msg = pcall(function()
                -- Insert your custom synchronous logic here
                -- Return the result of your custom logic
            end)
            if not result then
                utils.debugging.err("Database error: " .. tostring(error_msg))
            end
            return result
        end
    else
        utils.debugging.warn("Wrapper " .. wrapper_resource .. " is not supported for querying.")
    end
end

-- Function to execute a raw query on the db
-- Usage:
-- utils.db.raw_execute(query, params) -- No callback
-- utils.db.raw_execute(query, params, [callback]) -- does callback
local function raw_execute(query, params, callback)
    if wrapper_resource == 'oxmysql' then
        if callback then
            exports.oxmysql.rawExecute(query, params, function(response)
                callback(response)
            end)
        else
            local result, error_msg
            result, error_msg = pcall(function()
                return exports.oxmysql.rawExecute_async(query, params)
            end)
            if not result then
                utils.debugging.err("Database error: " .. tostring(error_msg))
            end
            return result
        end
    elseif wrapper_resource == 'custom' then
        if callback then
            -- Insert your custom callback logic here
            -- Your custom logic should call the provided callback with the result
        else
            local result, error_msg
            result, error_msg = pcall(function()
                -- Insert your custom synchronous logic here
                -- Return the result of your custom logic
            end)
            if not result then
                utils.debugging.err("Database error: " .. tostring(error_msg))
            end
            return result
        end
    else
        utils.debugging.warn("Wrapper " .. wrapper_resource .. " is not supported for rawExecute.")
    end
end

-- Function to fetch a single scalar value from the db
-- Usage:
-- utils.db.scalar(query, params) -- No callback
-- utils.db.scalar(query, params, [callback]) -- does callback
local function scalar(query, params, callback)
    if wrapper_resource == 'mysql-async' then
        MySQL.ready(function ()
            if callback then
                MySQL.Async.fetchScalar(query, params, function(value)
                    callback(value)
                end)
            else
                local result, error_msg
                result, error_msg = pcall(function()
                    return MySQL.Sync.fetchScalar(query, params)
                end)
                if not result then
                    utils.debugging.err("Database error: " .. tostring(error_msg))
                end
                return result
            end
        end)
    elseif wrapper_resource == 'ghmattimysql' then
        if callback then
            exports.ghmattimysql.scalar(query, params, function(value)
                callback(value)
            end)
        else
            local result, error_msg
            result, error_msg = pcall(function()
                return exports.ghmattimysql.scalar(query, params)
            end)
            if not result then
                utils.debugging.err("Database error: " .. tostring(error_msg))
            end
            return result
        end
    elseif wrapper_resource == 'oxmysql' then
        if callback then
            exports.oxmysql.scalar(query, params, function(value)
                callback(value)
            end)
        else
            local result, error_msg
            result, error_msg = pcall(function()
                return exports.oxmysql.scalar_async(query, params)
            end)
            if not result then
                utils.debugging.err("Database error: " .. tostring(error_msg))
            end
            return result
        end
    elseif wrapper_resource == 'custom' then
        if callback then
            -- Insert your custom callback logic here
            -- Your custom logic should call the provided callback with the result
        else
            local result, error_msg
            result, error_msg = pcall(function()
                -- Insert your custom synchronous logic here
                -- Return the result of your custom logic
            end)
            if not result then
                utils.debugging.err("Database error: " .. tostring(error_msg))
            end
            return result
        end
    else
        utils.debugging.warn("Wrapper " .. wrapper_resource .. " is not supported for scalar fetch.")
    end
end

-- Function to fetch a single row from the db
-- Usage:
-- utils.db.single(query, params) -- No callback
-- utils.db.single(query, params, [callback]) -- does callback
local function single(query, params, callback)
    if wrapper_resource == 'oxmysql' then
        if callback then
            exports.oxmysql.single(query, params, function(row)
                if not row then 
                    callback(nil)
                    return 
                end
                callback(row)
            end)
        else
            local result, error_msg
            result, error_msg = pcall(function()
                return exports.oxmysql.single_async(query, params)
            end)
            if not result then
                utils.debugging.err("Database error: " .. tostring(error_msg))
            end
            return result
        end
    elseif wrapper_resource == 'custom' then
        if callback then
            -- Insert your custom callback logic here
            -- Your custom logic should call the provided callback with the result
        else
            local result, error_msg
            result, error_msg = pcall(function()
                -- Insert your custom synchronous logic here
                -- Return the result of your custom logic
            end)
            if not result then
                utils.debugging.err("Database error: " .. tostring(error_msg))
            end
            return result
        end
    else
        utils.debugging.warn("Wrapper " .. wrapper_resource .. " is not supported for fetching a single row.")
    end
end

-- Function to execute a transaction on the db
-- Usage:
-- utils.db.transaction(queries, [values]) -- No callback
-- utils.db.transaction(queries, [values], [callback]) -- with callback
local function transaction(queries, values, callback)
    if type(values) == 'function' then  -- Adjusting for the "shared" version where only queries and callback are provided
        callback = values
        values = nil
    end
    
    if wrapper_resource == 'oxmysql' then
        if callback then
            if values then
                exports.oxmysql.transaction(queries, values, function(success)
                    callback(success)
                end)
            else
                exports.oxmysql.transaction(queries, function(success)
                    callback(success)
                end)
            end
        else
            local result, error_msg
            result, error_msg = pcall(function()
                if values then
                    return exports.oxmysql.transaction_async(queries, values)
                else
                    return exports.oxmysql.transaction_async(queries)
                end
            end)
            if not result then
                utils.debugging.err("Database error: " .. tostring(error_msg))
            end
            return result
        end
    elseif wrapper_resource == 'custom' then
        if callback then
            -- Insert your custom callback logic here
            -- Your custom logic should call the provided callback with the result
        else
            local result, error_msg
            result, error_msg = pcall(function()
                -- Insert your custom synchronous logic here
                -- Return the result of your custom logic
            end)
            if not result then
                utils.debugging.err("Database error: " .. tostring(error_msg))
            end
            return result
        end
    else
        utils.debugging.warn("Wrapper " .. wrapper_resource .. " is not supported for transactions.")
    end
end

-- Function to update entries in the db
-- Usage:
-- utils.db.update(query, params) -- No callback
-- utils.db.update(query, params, [callback]) -- with callback
local function update(query, params, callback)
    local result, error_msg
    if wrapper_resource == 'mysql-async' then
        MySQL.ready(function ()
            if callback then
                MySQL.Async.execute(query, params, function(affectedRows)
                    callback(affectedRows)
                end)
            else
                result, error_msg = pcall(function()
                    return MySQL.Sync.execute(query, params)
                end)
                if not result then
                    utils.debugging.err("Database error: " .. tostring(error_msg))
                end
            end
        end)
    elseif wrapper_resource == 'ghmattimysql' then
        if callback then
            exports.ghmattimysql.execute(query, params, function(affectedRows)
                callback(affectedRows)
            end)
        else
            result, error_msg = pcall(function()
                return exports.ghmattimysql.executeSync(query, params)
            end)
        end
    elseif wrapper_resource == 'oxmysql' then
        if callback then
            exports.oxmysql.update(query, params, function(affectedRows)
                callback(affectedRows)
            end)
        else
            result, error_msg = pcall(function()
                return exports.oxmysql.update_async(query, params)
            end)
        end
    elseif wrapper_resource == 'custom' then
        if callback then
            -- Insert your custom callback logic here
            -- Your custom logic should call the provided callback with the result
        else
            result, error_msg = pcall(function()
                -- Insert your custom synchronous logic here
                -- Return the result of your custom logic
            end)
        end
    end
    if not result and not callback then
        utils.debugging.err("Database error: " .. tostring(error_msg))
    end
    return result
end

--[[
    DB UTILITY FUNCTIONS
]]

-- Fetches records based on a specific field and its value from a specified table.
-- Usage: utils.db.fetch_by_field({ table_name = 'players', field_name = 'player_id', field_value = '1234', callback = callback })
local function fetch_by_field(params)
    local query = string.format("SELECT * FROM `%s` WHERE `%s` = ?", params.table_name, params.field_name)
    query(query, {params.field_value}, params.callback)
end

-- Fetches all records from a specified table.
-- Usage: utils.db.fetch_all({ table_name = 'players', callback = callback })
local function fetch_all(params)
    local query = string.format("SELECT * FROM `%s`", params.table_name)
    query(query, {}, params.callback)
end

-- Updates a specific field based on another field in a specified table.
-- Usage: utils.db.update_record({ table_name = 'players', condition_field = 'player_id', condition_value = '1234', data = { score = 100 }, callback = callback })
local function update_record(params)
    local setters = {}
    local values = {}
    for key, value in pairs(params.data) do
        setters[#setters + 1] = string.format("`%s` = ?", key)
        values[#values + 1] = value
    end
    local query = string.format("UPDATE `%s` SET %s WHERE `%s` = ?", params.table_name, table.concat(setters, ", "), params.condition_field)
    values[#values + 1] = params.condition_value
    update(query, values, params.callback)
end

-- Deletes a record from a specified table based on a specific field and value.
-- Usage: utils.db.delete_by_field({ table_name = 'players', field_name = 'player_id', field_value = '1234', callback = callback })
local function delete_by_field(params)
    local query = string.format("DELETE FROM `%s` WHERE `%s` = ?", params.table_name, params.field_name)
    update(query, {params.field_value}, params.callback)
end

-- Checks if a record exists in a specified table based on a specific field and value.
-- Usage: utils.db.record_exists_by_field({ table_name = 'players', field_name = 'player_id', field_value = '1234', callback = callback })
local function record_exists_by_field(params)
    local query = string.format("SELECT COUNT(*) as count FROM `%s` WHERE `%s` = ?", params.table_name, params.field_name)
    scalar(query, {params.field_value}, function(count)
        params.callback(count > 0)
    end)
end

-- Inserts a new record into a specified table.
-- Usage: utils.db.insert_record({ table_name = 'players', data = { player_id = '1234', name = 'John' }, callback = callback })
local function insert_record(params)
    local columns = {}
    local placeholders = {}
    local values = {}
    for column, value in pairs(params.data) do
        columns[#columns + 1] = string.format("`%s`", column)
        placeholders[#placeholders + 1] = "?"
        values[#values + 1] = value
    end
    local query = string.format("INSERT INTO `%s` (%s) VALUES (%s)", params.table_name, table.concat(columns, ","), table.concat(placeholders, ","))
    insert(query, values, params.callback)
end

-- Function to generate a unique value based on provided parameters
-- Usage:
-- utils.db.generate_unique_value({
--     generator = function() return tostring(math.random(11111111, 99999999)) end,
--     table_name = 'players',
--     condition = 'JSON_EXTRACT(balances, "$.bank.account_no") = ?'
-- })
local function generate_unique_value(params)
    local value
    local exists = true
    while exists do
        value = params.generator()
        local query = string.format('SELECT 1 FROM `%s` WHERE %s', params.table_name, params.condition)
        query(query, {value}, function(result)
            exists = result[1] ~= nil
        end)
    end
    return value
end

-- Function to generate a unique debit card number
local function generate_debit_card_number()
    return utils.db.generate_unique_value({
        generator = function()
            local card_number = ""
            for i = 1, 16 do
                card_number = card_number .. tostring(math.random(0, 9))
                if i % 4 == 0 and i ~= 16 then
                    card_number = card_number .. "-"
                end
            end
            return card_number
        end,
        table_name = 'players',
        condition = 'JSON_EXTRACT(balances, "$.bank.card_number") = ?'
    })
end

--[[
    ASSIGN LOCALS
]]

utils.db = utils.db or {}

utils.db.insert = insert
utils.db.prepare = prepare
utils.db.query = query
utils.db.raw_execute = raw_execute
utils.db.scalar = scalar
utils.db.single = single
utils.db.transaction = transaction
utils.db.update = update
utils.db.fetch_by_field = fetch_by_field
utils.db.fetch_all = fetch_all
utils.db.update_record = update_record
utils.db.delete_by_field = delete_by_field
utils.db.record_exists_by_field = record_exists_by_field
utils.db.insert_record = insert_record
utils.db.generate_unique_value = generate_unique_value