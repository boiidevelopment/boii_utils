--- This script manages interactions with different server frameworks.
-- It provides a set of utilities for handling player data and identity information, supporting multiple frameworks.
-- @script client/framework.lua
-- @todo Add support for other frameworks { nd_core, qbox, ?? }

--- @section Initialization

--- Flag to check if framework sections should be disabled
-- If true this section will not run meaning the library is entirely standalone again
-- @see client/config.lua
if config.disable.frameworks then return end

--- @section Constants

--- Assigning config.framework to framework for brevity.
-- Framework setting can be changed within the config files.
-- @see client/config.lua & server/config.lua
FRAMEWORK = config.framework

--- Initializes the connection to the specified framework when the resource starts.
-- Supports 'boii_rp', 'qb-core', 'esx_legacy', 'ox_core', and custom frameworks *(provided you fill this in of course)*.
CreateThread(function()
    while GetResourceState(FRAMEWORK) ~= 'started' do
        Wait(500)
    end

    -- Initialize the framework based on the configuration.
    -- Extend this if-block to add support for additional frameworks.
    if FRAMEWORK == 'boii_rp' then
        fw = exports['boii_rp']:get_object()
    elseif FRAMEWORK == 'qb-core' then
        fw = exports['qb-core']:GetCoreObject()
    elseif FRAMEWORK == 'esx_legacy' then
        fw = exports['es_extended']:getSharedObject()
    elseif FRAMEWORK == 'ox_core' then
        local file = ('imports/%s.lua'):format(IsDuplicityVersion() and 'server' or 'client')
        local import = LoadResourceFile('ox_core', file)
        local chunk = assert(load(import, ('@@ox_core/%s'):format(file)))
        chunk()
        fw = Ox
    elseif FRAMEWORK == 'custom' then
        -- Custom framework initialization
    end

    return
end)

--- @section Local functions

--- Retrieves player data from the server based on the framework.
-- @param _src Player source identifier.
-- @return Player data object.
-- @usage local player = utils.fw.get_player(player_source)
local function get_player(_src)
    local player
    if FRAMEWORK == 'boii_base' then
        player = fw.get_user(_src)
    elseif FRAMEWORK == 'qb-core' then
        player = fw.Functions.GetPlayer(_src)
    elseif FRAMEWORK == 'esx_legacy' then
        player = fw.GetPlayerFromId(_src)
    elseif FRAMEWORK == 'ox_core' then
        player = fw.GetPlayer(_src)
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic
    end
    return player
end

--- Retrieves player id from the server based on the framework.
-- @param _src Player source identifier.
-- @return Player's main identifier.
-- @usage local player = utils.fw.get_player_id(player_source)
local function get_player_id(_src)
    local player = get_player(_src)
    local player_id
    if FRAMEWORK == 'boii_base' then
        player_id = player.unique_id..'_'..player.char_id -- place holder until boii_base has a state id 
    elseif FRAMEWORK == 'qb-core' then
        player_id = player.PlayerData.citizenid
    elseif FRAMEWORK == 'esx_legacy' then
        player_id = player.identifier
    elseif FRAMEWORK == 'ox_core' then
        player_id = player.stateId
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic
    end
    return player_id
end

--- Prepares query parameters for database operations based on the framework.
-- Useful for consistent database operations across different frameworks.
-- @param _src Player source identifier.
-- @return Query part and parameters suitable for the configured framework.
-- @usage local query, params = utils.fw.get_id_params(player_source)
local function get_id_params(_src)
    local player = get_player(_src)
    local query, params
    if FRAMEWORK == 'boii_base' then
        query = 'unique_id = ? AND char_id = ?'
        params = { player.unique_id, player.char_id }
    elseif FRAMEWORK == 'qb-core' then
        query = 'citizenid = ?'
        params = { player.PlayerData.citizenid }
    elseif FRAMEWORK == 'esx_legacy' then
        query = 'identifier = ?'
        params = { player.identifier }
    elseif FRAMEWORK == 'ox_core' then
        query = 'charId = ? AND userId = ?'
        params = { player.charId, player.userId }
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic
    end
    return query, params
end

--- Prepares data for SQL INSERT operations based on the framework.
-- Provides a consistent way to insert data into the database.
-- @param _src Player source identifier.
-- @param data_type The type of data being inserted.
-- @param data_name The name of the data field.
-- @param data The data to insert.
-- @return Columns, values, and parameters suitable for the configured framework.
-- @usage local columns, values, params = utils.fw.get_insert_params(_src, 'data_type', 'data_name', data)
local function get_insert_params(_src, data_type, data_name, data)
    local player = get_player(_src)
    local columns, values, params
    if FRAMEWORK == 'boii_base' then
        columns = {'unique_id', 'char_id', data_type}
        values = '?, ?, ?'
        params = { player.unique_id, player.char_id, json.encode(data) }
    elseif FRAMEWORK == 'qb-core' then
        columns = {'citizenid', data_type}
        values = '?, ?'
        params = { player.PlayerData.citizenid, json.encode(data) }
    elseif FRAMEWORK == 'esx_legacy' then
        columns = {'identifier', data_type}
        values = '?, ?'
        params = { player.identifier, json.encode(data) }
    elseif FRAMEWORK == 'ox_core' then
        columns = {'charId', 'userId', data_type}
        values = '?, ?, ?'
        params = { player.charId, player.userId, json.encode(data) }
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic
    end
    return columns, values, params
end

--- Checks if a player has a specific item in their inventory.
-- @param _src Player source identifier.
-- @param item_name Name of the item to check.
-- @param item_amount (Optional) Amount of the item to check for.
-- @return True if the player has the item (and amount), False otherwise.
-- @usage local has_item = utils.fw.has_item(_src, 'item_name', item_amount)
local function has_item(_src, item_name, item_amount)
    local player = get_player(_src)
    if not player then return false end

    local required_amount = item_amount or 1

    if FRAMEWORK == 'boii_base' then
        local item = player.get_inventory_item(item_name)
        return item ~= nil and item.quantity >= required_amount
    elseif FRAMEWORK == 'qb-core' then
        local item = player.Functions.GetItemByName(item_name)
        return item ~= nil and item.amount >= required_amount
    elseif FRAMEWORK == 'esx_legacy' then
        local item = player.getInventoryItem(item_name)
        return item ~= nil and item.count >= required_amount
    elseif FRAMEWORK == 'ox_core' then
        local count = exports.ox_inventory:Search(_src, 'count', item_name)
        return count ~= nil and count >= required_amount
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic
    end

    return false
end

--- Adjusts a player's inventory based on given options.
-- Options include adding or removing items and setting item information.
-- @param _src Player source identifier.
-- @param options Options for inventory adjustment.
-- @usage utils.fw.adjust_inventory(player_source, { item_id = 'item_id', action = 'add', amount = 1, info = {} })
local function adjust_inventory(_src, options)
    local player = get_player(_src)
    if not player then return false end

    if FRAMEWORK == 'boii_base' then
        player.modify_inventory(options.item_id, options.action, options.amount, options.info)
    elseif FRAMEWORK == 'qb-core' then
        if options.action == 'add' then
            player.Functions.AddItem(options.item_id, options.amount, nil, options.info)
        elseif options.action == 'remove' then
            player.Functions.RemoveItem(options.item_id, options.amount)
        end
    elseif FRAMEWORK == 'esx_legacy' then
        if options.action == 'add' then
            player.addInventoryItem(options.item_id, options.amount)
        elseif options.action == 'remove' then
            player.removeInventoryItem(options.item_id, options.amount)
        end
    elseif FRAMEWORK == 'ox_core' then  
        if options.action == 'add' then
            exports.ox_inventory:AddItem(_src, options.item_id, options.amount, options.info)
        elseif options.action == 'remove' then
            exports.ox_inventory:RemoveItem(_src, options.item_id, options.amount, options.info)
        end
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic
    end
end

--- Retrieves the balances of a player based on the framework.
-- @param _src Player source identifier.
-- @return A table of balances by type.
-- @usage local balances = utils.fw.get_balances(player_source)
local function get_balances(_src)
    local player = get_player(_src)
    if not player then return false end

    local balances = {}
    if FRAMEWORK == 'boii_base' then
        balances = player.balances
    elseif FRAMEWORK == 'qb-core' then
        balances = player.PlayerData.money
    elseif FRAMEWORK == 'esx_legacy' then
        if player then
            for _, account in pairs(player.getAccounts()) do
                balances[account.name] = account.money
            end
        end
    elseif FRAMEWORK == 'ox_core' then  
        balances = exports.ox_inventory:Search(_src, 'count', 'money')
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic
    end
    return balances
end

--- Retrieves a specific balance of a player by type.
-- @param _src Player source identifier.
-- @param balance_type The type of balance to retrieve.
-- @return The balance amount for the specified type.
-- @usage local balance = utils.fw.get_balance_by_type(player_source, 'balance_type')
local function get_balance_by_type(_src, balance_type)
    local balances = get_balances(_src)
    if not balances then return false end

    local balance
    if FRAMEWORK == 'boii_base' then
        balance = balances[balance_type].amount
    elseif FRAMEWORK == 'qb-core' then
        balance = balances[balance_type]
    elseif FRAMEWORK == 'esx_legacy' then
        balance = balances[balance_type]
    elseif FRAMEWORK == 'ox_core' then  
        balance = balances
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic
    end
    return balance
end

--- Function to adjust a player's balance based on the framework.
-- Supports adding or removing funds from different balance types.
-- @param _src Player source identifier.
-- @param options Options for balance adjustment.
-- @usage utils.fw.adjust_balance({ balance_type = 'balance_type', action = 'add/remove', amount = 1, note = 'a identifier note' })
local function adjust_balance(_src, options)
    local player = get_player(_src)
    if not player then return false end

    if FRAMEWORK == 'boii_base' then
        player.modify_balance(options.balance_type, options.action, options.amount, options.note)
    elseif FRAMEWORK == 'qb-core' then
        if options.action == 'add' then
            player.Functions.AddMoney(options.balance_type, options.amount, options.note)
        elseif options.action == 'remove' then
            player.Functions.RemoveMoney(options.balance_type, options.amount, options.note)
        end
    elseif FRAMEWORK == 'esx_legacy' then
        if options.action == 'add' then
            player.addAccountMoney(options.balance_type, options.amount)
        elseif options.action == 'remove' then
            player.removeAccountMoney(options.balance_type, options.amount)
        end
    elseif FRAMEWORK == 'ox_core' then  
        if options.action == 'add' then
            exports.ox_inventory:AddItem(_src, 'money', options.amount)
        elseif options.action == 'remove' then
            exports.ox_inventory:RemoveItem(_src, 'money', options.amount)
        end
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic
    end
end

--- Retrieves a player's identity information depending on the framework.
-- @param _src Player source identifier.
-- @return A table of identity information.
-- @usage local identity = utils.fw.get_identity(_src)
local function get_identity(_src)
    local player = get_player(_src)
    if not player then return false end

    local player_data

    if FRAMEWORK == 'boii_base' then
        player_data = {
            first_name = player.identity.first_name,
            last_name = player.identity.last_name,
            dob = player.identity.dob,
            sex = player.identity.sex,
            nationality = player.identity.nationality
        }
    elseif FRAMEWORK == 'qb-core' then
        player_data = {
            first_name = player.PlayerData.charinfo.firstname,
            last_name = player.PlayerData.charinfo.lastname,
            dob = player.PlayerData.charinfo.birthdate,
            sex = player.PlayerData.charinfo.gender,
            nationality = player.PlayerData.charinfo.nationality
        }
    elseif FRAMEWORK == 'esx_legacy' then
        player_data = {
            first_name = player.variables.firstName,
            last_name = player.variables.lastName,
            dob = player.variables.dateofbirth,
            sex = player.variables.sex,
            nationality = 'LS, Los Santos'
        }
    elseif FRAMEWORK == 'ox_core' then  
        player_data = {
            first_name = player.firstName,
            last_name = player.lastName,
            dob = player.dob,
            sex = player.gender,
            nationality = 'LS, Los Santos'
        }
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic
    end
    return player_data
end

--- Retrieves a player's identity information from the database depending on the framework.
-- This function abstracts the differences between various server frameworks by providing a unified interface
-- to access player identity information. It supports multiple frameworks and custom implementations.
-- @param id The player's identifier specific to the framework (e.g., passport for boii_base, citizenid for qb-core).
-- @return table|nil A table containing identity information (first name, last name, date of birth, sex, and nationality)
-- if the player is found, or nil if the player is not found or the framework is not supported.
-- @usage local identity = get_identity_by_id('some_player_id')
local function get_identity_by_id(id)
    local player_data
    local queries = {
        ['boii_base'] = {
            query = "SELECT identity FROM players WHERE passport = ?",
            fields = { 'first_name', 'last_name', 'dob', 'sex', 'nationality' }
        },
        ['qb-core'] = {
            query = "SELECT charinfo FROM players WHERE citizenid = ?",
            fields = { 'firstname', 'lastname', 'birthdate', 'gender', 'nationality' }
        },
        ['esx_legacy'] = {
            query = "SELECT firstName, lastName, dateofbirth, sex FROM users WHERE identifier = ?",
            fields = { 'firstName', 'lastName', 'dateofbirth', 'sex' }
        },
        ['ox_core'] = {
            query = "SELECT firstName, lastName, dob, gender FROM users WHERE stateId = ?",
            fields = { 'firstName', 'lastName', 'dob', 'gender' }
        },
        ['custom'] = {
            query = "", -- Custom framework SQL query
            fields = {} -- Custom framework fields
        }
    }
    local framework_query = queries[FRAMEWORK]
    if not framework_query then
        print("Framework not supported.")
        return nil
    end
    local db_result = MySQL.query.await(framework_query.query, {id})
    if db_result and #db_result > 0 then
        local result = db_result[1]
        if FRAMEWORK == 'qb-core' and result.charinfo then
            result = json.decode(result.charinfo)
        elseif FRAMEWORK == 'boii_base' and result.identity then
            result = json.decode(result.identity)
        end
        player_data = {}
        for _, field in ipairs(framework_query.fields) do
            player_data[field] = result[field]
        end
        if FRAMEWORK == 'esx_legacy' or FRAMEWORK == 'ox_core' then
            player_data.nationality = 'LS, Los Santos'
        end
    else
        print("Player not found.")
        return nil
    end
    return player_data
end

--- @section Database tables

--- Function to create sql table on load if not created already
-- This runs internally meaning it is not a exportable function it simply creates tables required for the utils sections
local function create_skill_tables()
    utils.debug.info("Creating skills table if not exists...")
    local query
    if FRAMEWORK == 'boii_base' then
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
    elseif FRAMEWORK == 'qb-core' then
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `citizenid` varchar(50) NOT NULL,
                `skills` json DEFAULT '{}',
                PRIMARY KEY (`citizenid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.skills.sql.table_name)
    elseif FRAMEWORK == 'esx_legacy' then 
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `identifier` varchar(60) NOT NULL,
                `skills` json DEFAULT '{}',
                PRIMARY KEY (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.skills.sql.table_name)              
    elseif FRAMEWORK == 'ox_core' then
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `charId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `userId` INT UNSIGNED NOT NULL,
                `skills` json DEFAULT '{}',
                PRIMARY KEY (`charId`) USING BTREE,
                KEY `FK_%s_users` (`userId`) USING BTREE,
                CONSTRAINT `FK_%s_users` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON UPDATE CASCADE ON DELETE CASCADE
            );
        ]], config.skills.sql.table_name, config.skills.sql.table_name, config.skills.sql.table_name)
    elseif FRAMEWORK == 'custom' then
        -- Add the table schema required for your custom framework here
    end
    MySQL.update(query, {})
end
create_skill_tables()

-- Create sql tables required by rep system
local function create_rep_tables()
    utils.debug.info("Creating reputations table if not exists...")
    local query
    if FRAMEWORK == 'boii_base' then
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
    elseif FRAMEWORK == 'qb-core' then
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `citizenid` varchar(50) NOT NULL,
                `reputation` json DEFAULT '{}',
                PRIMARY KEY (`citizenid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.reputation.sql.table_name)
    elseif FRAMEWORK == 'esx_legacy' then 
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `identifier` varchar(60) NOT NULL,
                `reputation` json DEFAULT '{}',
                PRIMARY KEY (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.reputation.sql.table_name)              
    elseif FRAMEWORK == 'ox_core' then
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `charId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `userId` INT UNSIGNED NOT NULL,
                `reputation` json DEFAULT '{}',
                PRIMARY KEY (`charId`) USING BTREE,
                KEY `FK_%s_users` (`userId`) USING BTREE,
                CONSTRAINT `FK_%s_users` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON UPDATE CASCADE ON DELETE CASCADE
            );
        ]], config.reputation.sql.table_name, config.reputation.sql.table_name, config.reputation.sql.table_name)
    elseif FRAMEWORK == 'custom' then
        -- Add the table schema required for your custom framework here
    end
    MySQL.update(query, {})
end
create_rep_tables()

-- Function to create sql table on load if not created already
-- This runs internally meaning it is not a exportable function it simply creates tables required for the utils sections
local function create_licence_tables()
    utils.debug.info("Creating licence table if not exists...")
    local query
    if FRAMEWORK == 'boii_base' then
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
    elseif FRAMEWORK == 'qb-core' then
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `citizenid` varchar(50) NOT NULL,
                `licences` json DEFAULT '{}',
                PRIMARY KEY (`citizenid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.licences.sql.table_name)
    elseif FRAMEWORK == 'esx_legacy' then 
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `identifier` varchar(60) NOT NULL,
                `licences` json DEFAULT '{}',
                PRIMARY KEY (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config.licences.sql.table_name)              
    elseif FRAMEWORK == 'ox_core' then
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `charId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `userId` INT UNSIGNED NOT NULL,
                `licences` json DEFAULT '{}',
                PRIMARY KEY (`charId`) USING BTREE,
                KEY `FK_%s_users` (`userId`) USING BTREE,
                CONSTRAINT `FK_%s_users` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON UPDATE CASCADE ON DELETE CASCADE
            );
        ]], config.licences.sql.table_name, config.licences.sql.table_name, config.licences.sql.table_name)
    elseif FRAMEWORK == 'custom' then
        -- Add the table schema required for your custom framework here
    end
    MySQL.update(query, {})
end
create_licence_tables()


--- @section Assign local functions

utils.fw = utils.fw or {}

utils.fw.get_player = get_player
utils.fw.get_player_id = get_player_id
utils.fw.get_id_params = get_id_params
utils.fw.get_insert_params = get_insert_params
utils.fw.has_item = has_item
utils.fw.get_balances = get_balances
utils.fw.get_balance_by_type = get_balance_by_type
utils.fw.adjust_balance = adjust_balance
utils.fw.adjust_inventory = adjust_inventory
utils.fw.get_identity = get_identity
utils.fw.get_identity_by_id = get_identity_by_id
