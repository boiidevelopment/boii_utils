----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    FRAMEWORK 
]]

framework = config.framework

-- Framework initialization
if framework == 'boii_base' then
    fw = exports['boii_base']:get_object()
elseif framework == 'qb-core' then
    fw = exports['qb-core']:GetCoreObject()
elseif framework == 'esx_legacy' then
    fw = exports['es_extended']:getSharedObject()
elseif framework == 'ox_core' then    
    -- TO DO: Add initialization for ox_core
elseif framework == 'custom' then
    -- Custom framework initialization
end

--[[
    FUNCTIONS
]]

-- Retrieves player data from the server.
-- Usage: local player = utils.fw.get_player(player_source)
local function get_player(_src)
    local player
    if framework == 'boii_base' then
        player = fw.get_user(_src)
    elseif framework == 'qb-core' then
        player = fw.Functions.GetPlayer(_src)
    elseif framework == 'esx_legacy' then
        player = fw.GetPlayerFromId(_src)
    elseif framework == 'ox_core' then
        -- TO DO: Add logic for ox_core
    elseif framework == 'custom' then
        -- Custom framework logic
    end
    return player
end

-- Prepares query parameters for database operations based on the framework.
-- Usage: local query, params = utils.fw.get_id_params(player_source)
local function get_id_params(_src)
    local player = get_player(_src)
    local query, params
    if framework == 'boii_base' then
        query = 'unique_id = ? AND char_id = ?'
        params = { player.unique_id, player.char_id }
    elseif framework == 'qb-core' then
        query = 'citizenid = ?'
        params = { player.PlayerData.citizenid }
    elseif framework == 'esx_legacy' then
        query = 'identifier = ?'
        params = { player.identifier }
    elseif framework == 'ox_core' then
        -- TO DO: Add logic for ox_core
    elseif framework == 'custom' then
        -- Custom framework logic
    end
    return query, params
end

-- Prepares data for SQL INSERT operations.
-- Usage: local columns, values, params = utils.fw.get_insert_params(player_source, 'data_type', 'data_name', data)
local function get_insert_params(_src, data_type, data_name, data)
    local player = get_player(_src)
    local columns, values, params
    if framework == 'boii_base' then
        columns = {'unique_id', 'char_id', data_type}
        values = '?, ?, ?'
        params = { player.unique_id, player.char_id, json.encode(data) }
    elseif framework == 'qb-core' then
        columns = {'citizenid', data_type}
        values = '?, ?'
        params = { player.PlayerData.citizenid, json.encode(data) }
    elseif framework == 'esx_legacy' then
        columns = {'identifier', data_type}
        values = '?, ?'
        params = { player.identifier, json.encode(data) }
    elseif framework == 'ox_core' then
        -- TO DO: Add logic for ox_core
    elseif framework == 'custom' then
        -- Custom framework logic
    end
    return columns, values, params
end

-- Checks if a player has a specific item in their inventory.
-- Usage: local has_item = utils.fw.has_item(player_source, 'item_name', item_amount)
local function has_item(_src, item_name, item_amount)
    local player = get_player(_src)
    if not player then return false end

    local required_amount = item_amount or 1

    if framework == 'boii_base' then
        local item = player.get_inventory_item(item_name)
        return item ~= nil and item.quantity >= required_amount
    elseif framework == 'qb-core' then
        local item = player.Functions.GetItemByName(item_name)
        return item ~= nil and item.amount >= required_amount
    elseif framework == 'esx_legacy' then
        local item = player.getInventoryItem(item_name)
        return item ~= nil and item.count >= required_amount
    elseif framework == 'ox_core' then
        -- TO DO: Add logic for ox_core
    elseif framework == 'custom' then
        -- Custom framework logic
    end

    return false
end

-- Adjusts a player's inventory based on given options.
-- Usage: utils.fw.adjust_inventory(player_source, { item_id = 'item_id', action = 'add', amount = 1, info = {} })
local function adjust_inventory(_src, options)
    local player = get_player(_src)
    if not player then return false end

    if framework == 'boii_base' then
        player.modify_inventory(options.item_id, options.action, options.amount, options.info)
    elseif framework == 'qb-core' then
        if options.action == 'add' then
            player.Functions.AddItem(options.item_id, options.amount, nil, options.info)
        elseif options.action == 'remove' then
            player.Functions.RemoveItem(options.item_id, options.amount)
        end
    elseif framework == 'esx_legacy' then
        if options.action == 'add' then
            player.addInventoryItem(options.item_id, options.amount)
        elseif options.action == 'remove' then
            player.removeInventoryItem(options.item_id, options.amount)
        end
    elseif framework == 'ox_core' then  
        -- TO DO: Add logic for ox_core
    elseif framework == 'custom' then
        -- Custom framework logic
    end
end

-- Retrieves the balances of a player based on the framework.
-- Usage: local balances = utils.fw.get_balances(player_source)
local function get_balances(_src)
    local player = get_player(_src)
    if not player then return false end

    local balances = {}
    if framework == 'boii_base' then
        balances = player.balances
    elseif framework == 'qb-core' then
        balances = player.PlayerData.money
    elseif framework == 'esx_legacy' then
        if player then
            for _, account in pairs(player.getAccounts()) do
                balances[account.name] = account.money
            end
        end
    elseif framework == 'ox_core' then  
        -- TO DO: Add logic for ox_core
    elseif framework == 'custom' then
        -- Custom framework logic
    end
    return balances
end

-- Retrieves a specific balance of a player by type.
-- Usage: local balance = utils.fw.get_balance_by_type(player_source, 'balance_type')
local function get_balance_by_type(_src, balance_type)
    local balances = get_balances(_src)
    if not balances then return false end

    local balance = 0
    if framework == 'boii_base' then
        balance = balances[balance_type].amount
    elseif framework == 'qb-core' then
        balance = balances[balance_type]
    elseif framework == 'esx_legacy' then
        balance = balances[balance_type]
    elseif framework == 'ox_core' then  
        -- TO DO: Add logic for ox_core
    elseif framework == 'custom' then
        -- Custom framework logic
    end
    return balance
end

-- Function to adjust a players balance based on the framework
-- Usage: utils.fw.adjust_balance(player_source, { balance_type = 'balance_type', action = 'add/remove', amount = 1, note = 'a identifier note' })
local function adjust_balance(_src, options)
    local player = get_player(_src)
    if not player then return false end

    if framework == 'boii_base' then
        player.modify_balance(options.balance_type, options.action, options.amount, options.note)
    elseif framework == 'qb-core' then
        if options.action == 'add' then
            player.Functions.AddMoney(options.balance_type, options.amount, options.note)
        elseif options.action == 'remove' then
            player.Functions.RemoveMoney(options.balance_type, options.amount, options.note)
        end
    elseif framework == 'esx_legacy' then
        if options.action == 'add' then
            player.addAccountMoney(options.balance_type, options.amount)
        elseif options.action == 'remove' then
            player.removeAccountMoney(options.balance_type, options.amount)
        end
    elseif framework == 'ox_core' then  
        -- TO DO: Add logic for ox_core
    elseif framework == 'custom' then
        -- Custom framework logic
    end
end

-- Retrieves a players identity information depending on framework
-- Usage: local identity = utils.fw.get_identity(player_source)
local function get_identity(_src)
    local player = get_player(_src)
    if not player then return false end

    local player_data

    if framework == 'boii_base' then
        player_data = {
            first_name = player.identity.first_name,
            last_name = player.identity.last_name,
            dob = player.identity.dob,
            sex = player.identity.sex,
            nationality = player.identity.nationality
        }
    elseif framework == 'qb-core' then
        player_data = {
            first_name = player.PlayerData.charinfo.firstname,
            last_name = player.PlayerData.charinfo.lastname,
            dob = player.PlayerData.charinfo.birthdate,
            sex = player.PlayerData.charinfo.gender,
            nationality = player.PlayerData.charinfo.nationality
        }
    elseif framework == 'esx_legacy' then
        player_data = {
            first_name = player.variables.firstName,
            last_name = player.variables.lastName,
            dob = player.variables.dateofbirth,
            sex = player.variables.sex,
            nationality = 'LS, Los Santos'
        }
    elseif framework == 'ox_core' then  
        -- TO DO: Add logic for ox_core
    elseif framework == 'custom' then
        -- Custom framework logic
    end
    return player_data
end

--[[
    CREATE TABLES
]]

-- Function to create sql table on load if not created already
-- This runs internally meaning it is not a exportable function it simply creates tables required for the utils sections
local function create_skill_tables()
    utils.debugging.info("Creating skills table if not exists...")
    local query
    if framework == 'boii_base' then
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `unique_id` varchar(255) NOT NULL,
                `char_id` int(1) NOT NULL DEFAULT 1,
                `skills` json DEFAULT '{}',
                CONSTRAINT `fk_%s_players` FOREIGN KEY (`unique_id`, `char_id`)
                REFERENCES `players` (`unique_id`, `char_id`) ON DELETE CASCADE,
                PRIMARY KEY (`unique_id`, `char_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.skills.sql.table_name, config.skills.sql.table_name)
    elseif framework == 'qb-core' then
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `citizenid` varchar(50) NOT NULL,
                `skills` json DEFAULT '{}',
                PRIMARY KEY (`citizenid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.skills.sql.table_name)
    elseif framework == 'esx_legacy' then 
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `identifier` varchar(60) NOT NULL,
                `skills` json DEFAULT '{}',
                PRIMARY KEY (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.skills.sql.table_name)              
    elseif framework == 'ox_core' then
        -- TO DO:
    elseif framework == 'custom' then
        -- Add the table schema required for your custom framework here
    end
    MySQL.update(query, {})
    utils.debugging.info("Skills tables created if not exists...")
end
create_skill_tables()

-- Function to create sql table on load if not created already
-- This runs internally meaning it is not a exportable function it simply creates tables required for the utils sections
local function create_rep_tables()
    utils.debugging.info("Creating reputations table if not exists...")
    local query
    if framework == 'boii_base' then
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `unique_id` varchar(255) NOT NULL,
                `char_id` int(1) NOT NULL DEFAULT 1,
                `reputation` json DEFAULT '{}',
                CONSTRAINT `fk_%s_players` FOREIGN KEY (`unique_id`, `char_id`)
                REFERENCES `players` (`unique_id`, `char_id`) ON DELETE CASCADE,
                PRIMARY KEY (`unique_id`, `char_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.reputation.sql.table_name, config.reputation.sql.table_name)
    elseif framework == 'qb-core' then
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `citizenid` varchar(50) NOT NULL,
                `reputation` json DEFAULT '{}',
                PRIMARY KEY (`citizenid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.reputation.sql.table_name)
    elseif framework == 'esx_legacy' then 
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `identifier` varchar(60) NOT NULL,
                `reputation` json DEFAULT '{}',
                PRIMARY KEY (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.reputation.sql.table_name)              
    elseif framework == 'ox_core' then
        -- TO DO:
    elseif framework == 'custom' then
        -- Add the table schema required for your custom framework here
    end
    MySQL.update(query, {})
    utils.debugging.info("Reputations tables created if not exists...")
end
create_rep_tables()

-- Function to create sql table on load if not created already
-- This runs internally meaning it is not a exportable function it simply creates tables required for the utils sections
local function create_licence_tables()
    utils.debugging.info("Creating licence table if not exists...")
    local query
    if framework == 'boii_base' then
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `unique_id` varchar(255) NOT NULL,
                `char_id` int(1) NOT NULL DEFAULT 1,
                `licences` json DEFAULT '{}',
                CONSTRAINT `fk_%s_players` FOREIGN KEY (`unique_id`, `char_id`)
                REFERENCES `players` (`unique_id`, `char_id`) ON DELETE CASCADE,
                PRIMARY KEY (`unique_id`, `char_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.licences.sql.table_name, config.licences.sql.table_name)
    elseif framework == 'qb-core' then
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `citizenid` varchar(50) NOT NULL,
                `licences` json DEFAULT '{}',
                PRIMARY KEY (`citizenid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.licences.sql.table_name)
    elseif framework == 'esx_legacy' then 
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `identifier` varchar(60) NOT NULL,
                `licences` json DEFAULT '{}',
                PRIMARY KEY (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.licences.sql.table_name)              
    elseif framework == 'ox_core' then
        -- TO DO:
    elseif framework == 'custom' then
        -- Add the table schema required for your custom framework here
    end
    MySQL.update(query, {})
    utils.debugging.info("Licence tables created if not exists...")
end
create_licence_tables()

--[[
    ASSIGN LOCALS
]]

utils.fw = utils.fw or {}

utils.fw.get_player = get_player
utils.fw.get_id_params = get_id_params
utils.fw.get_insert_params = get_insert_params
utils.fw.has_item = has_item
utils.fw.get_balances = get_balances
utils.fw.get_balance_by_type = get_balance_by_type
utils.fw.adjust_balance = adjust_balance
utils.fw.adjust_inventory = adjust_inventory
utils.fw.get_identity = get_identity
