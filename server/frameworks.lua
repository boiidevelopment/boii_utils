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
        ]], config_sv.skills.sql.table_name, config_sv.skills.sql.table_name)
    elseif framework == 'qb-core' then
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `citizenid` varchar(50) NOT NULL,
                `skills` json DEFAULT '{}',
                PRIMARY KEY (`citizenid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config_sv.skills.sql.table_name)
    elseif framework == 'esx_legacy' then 
        query = string.format([[
            CREATE TABLE IF NOT EXISTS `%s` (
                `identifier` varchar(60) NOT NULL,
                `skills` json DEFAULT '{}',
                PRIMARY KEY (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], config_sv.skills.sql.table_name)              
    elseif framework == 'ox_core' then
        -- TO DO:
    elseif framework == 'custom' then
        -- Add the table schema required for your custom framework here
    end
    MySQL.update(query, {})
    utils.debugging.info("Skills tables created if not exists...")
end
create_skill_tables()

--[[
    ASSIGN LOCALS
]]

utils.fw = utils.fw or {}

utils.fw.get_player = get_player
utils.fw.get_id_params = get_id_params
utils.fw.get_insert_params = get_insert_params