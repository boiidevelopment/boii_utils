--[[
    FRAMEWORK 
]]

framework = config.framework

if framework == 'boii_base' then
    fw = exports['boii_base']:get_object()
elseif framework == 'qb-core' then
    fw = exports['qb-core']:GetCoreObject()
elseif framework == 'esx_legacy' then
    fw = exports['es_extended']:getSharedObject()
elseif framework == 'ox_core' then    
    -- TO DO:
elseif framework == 'custom' then
    -- add code for your own framework here
end

--[[
    FUNCTIONS
]]

-- Function to get a player
local function get_player(_src)
    if framework == 'boii_base' then
        player = fw.get_user(_src)
    elseif framework == 'qb-core' then
        player = fw.Functions.GetPlayer(_src)
    elseif framework == 'esx_legacy' then
        player = fw.GetPlayerFromId(_src)
    elseif framework == 'ox_core' then
        -- TO DO:
    elseif framework == 'custom' then
        -- Add your own custom entry here.
    end
    return player
end

-- Function to get identifier and prepare database statement
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
        -- TO DO:
    elseif framework == 'custom' then
        -- Add your own custom entry here.
    end
    return query, params
end

-- Function to get columns, values, and parameters for insert
local function get_insert_params(_src, data_type, data_name, data)
    local player = get_player(_src)
    local columns, values, params
    local new_data = {}
    new_data[data_name] = data
    if framework == 'boii_base' then
        columns = {'unique_id', 'char_id', data_type}
        values = '?, ?, ?'
        params = { player.unique_id, player.char_id, json.encode(new_data) }
    elseif framework == 'qb-core' then
        columns = {'citizenid', data_type}
        values = '?, ?'
        params = { player.PlayerData.citizenid, json.encode(new_data) }
    elseif framework == 'esx_legacy' then
        columns = {'identifier', data_type}
        values = '?, ?'
        params = { player.identifier, json.encode(new_data) }
    elseif framework == 'ox_core' then
        -- TO DO:
    elseif framework == 'custom' then
        -- Add your own custom entry here.
    end
    return columns, values, params
end

-- Function to check if player has a specific item (and optionally its amount)
local function has_item(_src, item_name, item_amount)
    local player = utils.fw.get_player(_src)
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
        -- TO DO:
    elseif framework == 'custom' then
        -- Add your own custom entry here.
    end

    return false
end

-- Function to get a players balances depending on framework
local function get_balances(_src)
    local player = get_player(_src)
    if not player then return false end

    if framework == 'boii_base' then
        return player.balances
    elseif framework == 'qb-core' then
        -- TO DO:
    elseif framework == 'esx_legacy' then
        -- TO DO:
    elseif framework == 'ox_core' then  
        -- TO DO:
    elseif framework == 'custom' then
        
    end
end

-- Function to adjust a players balance depending on framework
local function adjust_balance(_src, options)
    local player = get_player(_src)
    if not player then return false end

    if framework == 'boii_base' then
        player.modify_balance(options.balance_type, options.action, options.amount, options.note)
    elseif framework == 'qb-core' then
        -- TO DO:
    elseif framework == 'esx_legacy' then
        -- TO DO:
    elseif framework == 'ox_core' then  
        -- TO DO:
    elseif framework == 'custom' then
        
    end
end


--[[
    CREATE TABLES
]]

-- Function to create sql table on load if not created already
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
utils.fw.adjust_balance = adjust_balance
