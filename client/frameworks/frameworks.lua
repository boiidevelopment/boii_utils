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

--- Framework bridge.
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

--- Assigning config.boii_statuses to statuses for brevity.
-- boii_statuses setting can be changed within the config files.
-- @see server/config.lua
BOII_STATUSES = config.boii_statuses

--- Initializes the connection to the specified framework when the resource starts.
-- Supports 'boii_core', 'qb-core', 'es_extended', 'ox_core', and custom frameworks *(provided you fill this in of course)*.
CreateThread(function()
    while GetResourceState(FRAMEWORK) ~= 'started' do
        Wait(500)
    end

    -- Initialize the framework based on the configuration.
    -- Extend this if-block to add support for additional frameworks.
    if FRAMEWORK == 'boii_core' then
        fw = exports.boii_core:get_object()
    elseif FRAMEWORK == 'qb-core' then
        fw = exports['qb-core']:GetCoreObject()
    elseif FRAMEWORK == 'es_extended' then
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

--- Retrieves all players based on framework
-- @return players table
local function get_players()

    local players = {}
    if FRAMEWORK == 'boii_core' then
        players = fw.get_players()
    elseif FRAMEWORK == 'qb-core' then
        players = fw.Functions.GetPlayers()
    elseif FRAMEWORK == 'es_extended' then
        players = fw.GetPlayers()
    elseif FRAMEWORK == 'ox_core' then
        players = fw.GetPlayers()
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic
    end
    return players
end

--- Retrieves player data from the server based on the framework.
-- @param _src Player source identifier.
-- @return Player data object.
-- @usage local player = utils.fw.get_player(player_source)
local function get_player(_src)
    local player
    if FRAMEWORK == 'boii_core' then
        player = fw.get_player(_src)
    elseif FRAMEWORK == 'qb-core' then
        player = fw.Functions.GetPlayer(_src)
    elseif FRAMEWORK == 'es_extended' then
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
    if not player then print('No player found for source: '.._src) return false end

    local player_id
    if FRAMEWORK == 'boii_core' then
        player_id = player.passport
    elseif FRAMEWORK == 'qb-core' then 
        player_id = player.PlayerData.citizenid
    elseif FRAMEWORK == 'es_extended' then
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
    if FRAMEWORK == 'boii_core' then
        query = 'unique_id = ? AND char_id = ?'
        params = { player.unique_id, player.char_id }
    elseif FRAMEWORK == 'qb-core' then
        query = 'citizenid = ?'
        params = { player.PlayerData.citizenid }
    elseif FRAMEWORK == 'es_extended' then
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
    if FRAMEWORK == 'boii_core' then
        columns = {'unique_id', 'char_id', data_type}
        values = '?, ?, ?'
        params = { player.unique_id, player.char_id, json.encode(data) }
    elseif FRAMEWORK == 'qb-core' then
        columns = {'citizenid', data_type}
        values = '?, ?'
        params = { player.PlayerData.citizenid, json.encode(data) }
    elseif FRAMEWORK == 'es_extended' then
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
    
    if FRAMEWORK == 'boii_core' then
        return player.has_item(item_name, required_amount)
    elseif FRAMEWORK == 'qb-core' then
        local item = player.Functions.GetItemByName(item_name)
        return item ~= nil and item.amount >= required_amount
    elseif FRAMEWORK == 'es_extended' then
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

--- Retrieves an item from the player's inventory.
-- @param _src Player source identifier.
-- @param item_name Name of the item to retrieve.
-- @return Item object if found, nil otherwise.
-- @usage local item = utils.fw.get_item(_src, 'item_name')
local function get_item(_src, item_name)
    local player = get_player(_src)
    if not player then return nil end -- Player not found, return nil

    local item
    if FRAMEWORK == 'boii_core' then
        item = player.get_item(item_name)
    elseif FRAMEWORK == 'qb-core' then
        item = player.Functions.GetItemByName(item_name)
    elseif FRAMEWORK == 'es_extended' then
        item = player.getInventoryItem(item_name)
    elseif FRAMEWORK == 'ox_core' then
        local items = exports.ox_inventory:Search(_src, 'items', item_name)
        if items and #items > 0 then
            item = items[1] -- Assuming the first match is what we want
        end
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic to retrieve item
    end

    return item -- Returns nil if not found or the item object if found
end

--- Gets a players inventory data
local function get_inventory(_src, options)
    local player = get_player(_src)
    if not player then return false end

    local inventory
    if FRAMEWORK == 'boii_core' then
        inventory = player.get_inventory()
    elseif FRAMEWORK == 'qb-core' then
        inventory = player.PlayerData.inventory
    elseif FRAMEWORK == 'es_extended' then
        inventory = player.getInventory()
    elseif FRAMEWORK == 'ox_core' then
        inventory = exports.ox_inventory:GetInventory(_src, false)
    end

    return inventory
end

--- Adjusts a player's inventory based on given options.
-- Options include adding or removing items and setting item information.
-- @param _src Player source identifier.
-- @param options Options for inventory adjustment.
-- @usage
--[[
local items = {
    {item_id = 'burger', action = 'add', quantity = 3},
    {item_id = 'water', action = 'remove', quantity = 1},
}    
local validation_data = { location = vector3(100.0, 100.0, 20.0), distance = 10.0, drop_player = true }
utils.fw.adjust_inventory({
    items = items, 
    validation_data = validation_data, 
    note = 'Used a pawnshop.', 
    should_save = true
})
]]
local function adjust_inventory(_src, options)
    local player = get_player(_src)
    if not player then return false end
    local function proceed()
        if FRAMEWORK == 'boii_core' then
            player.modify_inventory(options.items, options.note, options.should_save)
        else
            for _, item in ipairs(options.items) do
                if item.action == 'add' then
                    if FRAMEWORK == 'qb-core' then
                        player.Functions.AddItem(item.item_id, item.quantity, nil, item.data)
                    elseif FRAMEWORK == 'es_extended' then
                        player.addInventoryItem(item.item_id, item.quantity)
                    elseif FRAMEWORK == 'ox_core' then
                        exports.ox_inventory:AddItem(_src, item.item_id, item.quantity, item.data)
                    elseif FRAMEWORK == 'custom' then
                        -- Custom logic here
                    end
                elseif item.action == 'remove' then
                    if FRAMEWORK == 'qb-core' then
                        player.Functions.RemoveItem(item.item_id, item.quantity)
                    elseif FRAMEWORK == 'es_extended' then
                        player.removeInventoryItem(item.item_id, item.quantity)
                    elseif FRAMEWORK == 'ox_core' then
                        exports.ox_inventory:RemoveItem(_src, item.item_id, item.quantity, item.data)
                    elseif FRAMEWORK == 'custom' then
                        -- Custom logic here
                    end
                end
            end
        end
    end
    if options.validation_data then
        utils.callback.validate_distance(_src, {location = options.validation_data.location, distance = options.validation_data.distance}, function(is_valid)
            if is_valid then
                proceed()
            else
                if options.validation_data.drop_player then
                    DropPlayer(_src, 'Suspected range exploits.')
                else
                    utils.notify.send(_src, {
                        header = 'Action Denied',
                        message = 'You are too far from the required location to perform this action.',
                        type = 'error',
                        duration = 3500
                    })
                end
            end
        end)
    else
        proceed()
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
    if FRAMEWORK == 'boii_core' then
        balances = player.data.balances
    elseif FRAMEWORK == 'qb-core' then
        balances = player.PlayerData.money
    elseif FRAMEWORK == 'es_extended' then
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
    if FRAMEWORK == 'boii_core' then
        if balance_type == 'cash' then
            local cash_item = get_item(_src, 'cash')
            balance = cash_item.quantity
        else
            balance = balances[balance_type].amount
        end
    elseif FRAMEWORK == 'qb-core' then
        balance = balances[balance_type]
    elseif FRAMEWORK == 'es_extended' then
        balance = balances[balance_type]
    elseif FRAMEWORK == 'ox_core' then  
        balance = balances
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic
    end
    return balance
end

--- Function to adjust a player's balance based on the framework and optional distance validation.
-- Supports adding or removing funds from different balance types with a single call.
-- Optionally validates the player's distance from a given location before proceeding.
-- @param _src Player source identifier.
-- @param options Table containing balance operations, validation data, reason for the adjustment, and whether to save the update.
-- @usage
--[[
local operations = {
    {balance_type = 'bank', action = 'remove', amount = 1000},
    {balance_type = 'savings', action = 'add', amount = 1000}
}
local validation_data = { location = vector3(100.0, 100.0, 20.0), distance = 10.0, drop_player = true }
utils.fw.adjust_balance(_src, {
    operations = operations, 
    validation_data = validation_data, 
    reason = 'Transfer from bank to savings', 
    should_save = true
})
]]
local function adjust_balance(_src, options)
    local player = get_player(_src)
    if not player then return false end
    local function proceed()
        if FRAMEWORK == 'boii_core' then
            player.modify_balances(options.operations, options.reason, options.should_save)
        else
            for _, op in ipairs(options.operations) do
                if op.action == 'add' then
                    if FRAMEWORK == 'qb-core' then
                        player.Functions.AddMoney(op.balance_type, op.amount, options.reason)
                    elseif FRAMEWORK == 'es_extended' then
                        player.addAccountMoney(op.balance_type, op.amount)
                    elseif FRAMEWORK == 'ox_core' then
                        exports.ox_inventory:AddItem(_src, 'money', op.amount)
                    elseif FRAMEWORK == 'custom' then
                        -- Custom logic goes here
                    end
                elseif op.action == 'remove' then
                    if FRAMEWORK == 'qb-core' then
                        player.Functions.RemoveMoney(op.balance_type, op.amount, options.reason)
                    elseif FRAMEWORK == 'es_extended' then
                        player.removeAccountMoney(op.balance_type, op.amount)
                    elseif FRAMEWORK == 'ox_core' then
                        exports.ox_inventory:RemoveItem(_src, 'money', op.amount)
                    elseif FRAMEWORK == 'custom' then
                        -- Custom logic goes here
                    end
                end
            end
        end
    end
    if options.validation_data then
        utils.callback.validate_distance(_src, options.validation_data, function(is_valid)
            if is_valid then
                proceed()
            else
                if options.validation_data.drop_player then
                    DropPlayer(_src, 'Suspected range exploits.')
                else
                    utils.notify.send(_src, {
                        header = 'Action Denied',
                        message = 'You are too far from the required location to perform this action.',
                        type = 'error',
                        duration = 8500
                    })
                end
            end
        end)
    else
        proceed()
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

    if FRAMEWORK == 'boii_core' then
        player_data = {
            first_name = player.data.identity.first_name,
            last_name = player.data.identity.last_name,
            dob = player.data.identity.dob,
            sex = player.data.identity.sex,
            nationality = player.data.identity.nationality
        }
    elseif FRAMEWORK == 'qb-core' then
        player_data = {
            first_name = player.PlayerData.charinfo.firstname,
            last_name = player.PlayerData.charinfo.lastname,
            dob = player.PlayerData.charinfo.birthdate,
            sex = player.PlayerData.charinfo.gender,
            nationality = player.PlayerData.charinfo.nationality
        }
    elseif FRAMEWORK == 'es_extended' then
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

--- Retrieves a player's identity information by their id (citizenid, unique_id+char_id, etc..)
-- @param user_id: The id of the user to retrieve identity information for.
-- @return A table of identity information.
-- @usage local identity = utils.fw.get_identity_by_id('boii_12345_1')
local function get_identity_by_id(user_id)
    local players = get_players()
    for _, player in ipairs(players) do
        local p_id = get_player_id(player)
        if p_id == user_id then
            local identity = get_identity(player)
            return identity
        end
    end
    return nil
end

--- Retrieves the job(s) of a player by their source identifier.
-- @param _src The player's source identifier.
-- @return A table containing the player's jobs and their on-duty status.
local function get_player_jobs(_src)
    local player_jobs = {}
    local player = get_player(_src)
    if player then
        if FRAMEWORK == 'boii_core' then
            player_jobs = player.data.jobs
        elseif FRAMEWORK == 'qb-core' then
            player_jobs = player.PlayerData.job
        elseif FRAMEWORK == 'es_extended' then
            player_jobs = player.getJob()
        elseif FRAMEWORK == 'ox_core' then
            player_jobs = player.getGroups()
        elseif FRAMEWORK == 'custom' then
            -- Custom framework logic here
        end
    end
    return player_jobs
end

--- Checks if a player has one of the specified jobs and optionally checks their on-duty status.
-- @param _src The player's source identifier.
-- @param job_names An array of job names to check against the player's jobs.
-- @param check_on_duty Optional boolean to also check if the player is on-duty for the job.
-- @return Boolean indicating if the player has any of the specified jobs and meets the on-duty condition.
local function player_has_job(_src, job_names, check_on_duty)
    local player_jobs = get_player_jobs(_src)
    local job_found = false
    local on_duty_status = false
    if FRAMEWORK == 'boii_core' then
        if player_jobs.primary and utils.tables.table_contains(job_names, player_jobs.primary.id) then
            job_found = true
            on_duty_status = player_jobs.primary.on_duty
            if check_on_duty and not on_duty_status then
                return false
            end
        end
        for _, secondary_job in ipairs(player_jobs.secondary or {}) do
            if utils.tables.table_contains(job_names, secondary_job.id) then
                job_found = true
                on_duty_status = secondary_job.on_duty
                if check_on_duty and not on_duty_status then
                    return false
                end
            end
        end
    elseif FRAMEWORK == 'qb-core' then
        if utils.tables.table_contains(job_names, player_jobs.name) then
            job_found = true
            on_duty_status = player_jobs.onduty
        end
    elseif FRAMEWORK == 'es_extended' then
        if utils.tables.table_contains(job_names, player_jobs.id) then
            job_found = true
            on_duty_status = player_jobs.onDuty
        end
    elseif FRAMEWORK == 'ox_core' then
        if utils.tables.table_contains(job_names, player_jobs) and player.hasGroup(job_names) then
            job_found = true
            on_duty_status = player.get('inService')
        end
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic here
    end
    return job_found and (not check_on_duty or on_duty_status)
end

--- Retrieves a player's job grade for a specified job.
-- @param _src The player's source identifier.
-- @param job_id The job ID to retrieve the grade for.
-- @return The grade of the player for the specified job, or nil if not found.
local function get_player_job_grade(_src, job_id)
    local player_jobs = get_player_jobs(_src)
    if not player_jobs then
        print('No job data found for player. ' .. _src)
        return nil
    end
    if FRAMEWORK == 'boii_core' then
        if player_jobs.primary and player_jobs.primary.id == job_id then
            return player_jobs.primary.grade
        end
        for _, job in ipairs(player_jobs.secondary or {}) do
            if job.id == job_id then
                return job.grade
            end
        end
    elseif FRAMEWORK == 'qb-core' then
        if player_jobs.name == job_id then
            return player_jobs.grade.level
        end
    elseif FRAMEWORK == 'es_extended' then
        if player_jobs.id == job_id then
            return player_jobs.grade
        end
    elseif FRAMEWORK == 'ox_core' then
        -- @todo add ox logic
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic goes here.
    end

    print('Job grade not found for player. ' .. _src .. ', Job ID: ' .. job_id)
    return nil
end

--- Counts players with a specific job and optionally filters by on-duty status.
-- @param job_names Table of job names to check against the players' jobs.
-- @param check_on_duty Optional boolean to also check if the player is on-duty for the job.
-- @return Two numbers: total players with the job, and total players with the job who are on-duty.
local function count_players_by_job(job_names, check_on_duty)
    local players = get_players()
    local total_with_job = 0
    local total_on_duty = 0
    for _, player_src in ipairs(players) do
        if player_has_job(player_src, job_names, false) then
            total_with_job = total_with_job + 1
            if player_has_job(player_src, job_names, true) then
                total_on_duty = total_on_duty + 1
            end
        end
    end
    return total_with_job, total_on_duty
end

--- Returns a players job name.
-- @param _src The player's source identifier.
local function get_player_job_name(_src)
    local player_jobs = get_player_jobs(_src)

    if player_jobs then
        if FRAMEWORK == 'boii_core' then
            job_name = player_jobs.primary.id
        elseif FRAMEWORK == 'qb-core' then
            job_name = player_jobs.name
        elseif FRAMEWORK == 'es_extended' or FRAMEWORK == 'ox_core' then
            job_name = player_jobs.id
        elseif FRAMEWORK == 'custom' then
            -- Custom framework logic here
        end
    end
    return job_name
end

--- Retrieves shared job data.
-- @param job_id: ID for the job to retreive details for.
local function get_shared_job_data(job_id)
    
    local job_details
    if FRAMEWORK == 'boii_core' then
        job_details = fw.shared.get_shared_data('jobs', job_id)
    elseif FRAMEWORK == 'qb-core' then
        job_details = fw.Shared.Jobs[job_id]
    end
    return job_details
end

--- Modifies a players server side statuses.
-- @param _src The player's source identifier.
-- @param statuses The statuses to modify.
local function adjust_statuses(_src, statuses)
    local player = get_player(_src)
    if not player then print('player not found') return end
    
    if FRAMEWORK == 'boii_core' or BOII_STATUSES == 'boii_statuses' then
        local player_statuses = exports.boii_statuses:get_player(_src)
        player_statuses.modify_statuses(statuses)
        return
    end
    
    if FRAMEWORK == 'qb-core' then
        for key, mod in pairs(statuses) do
            if player.PlayerData.metadata[key] then
                local current = player.PlayerData.metadata[key]
                local new_value = math.min(100, math.max(0, current + (mod.add or 0) - (mod.remove or 0)))
                player.Functions.SetMetaData(key, new_value)
            end
        end
    elseif FRAMEWORK == 'es_extended' then
        for key, mod in pairs(statuses) do
            TriggerEvent('esx_status:getStatus', _src, key, function(status)
                local new_val = math.max(0, status.getPercent() + (mod.add or 0) - (mod.remove or 0))
                status.setPercent(new_val)
            end)
        end
    elseif FRAMEWORK == 'ox_core' then
        -- @todo Add ox core status logic
    elseif FRAMEWORK == 'custom' then
        -- Add your own custom logic here
    end
end

--- Updates the item data for a player.
-- @param _src The player's source identifier.
-- @param item_id The ID of the item to update.
-- @param updates Table containing updates like ammo count, attachments etc.
local function update_item_data(_src, item_id, updates)
    local player = get_player(_src)
    if not player then
        print('Player not found')
        return
    end

    local item = get_item(_src, item_id)
    if not item then 
        print('Item not found:', item_id)
        return 
    end

    if FRAMEWORK == 'boii_core' then
        player.update_item_data(item_id, updates, true)
    end

    print(string.format("Inventory update completed for player %d: %s", _src, item_id))
end

--- @section Callbacks

--- Callback for checking if player has item by quantity.
utils.callback.register('boii_utils:sv:has_item', function(_src, data, cb)
    local item_name = data.item_name
    local item_amount = data.item_amount or 1
    local player_has_item = false
    if has_item(_src, item_name, item_amount) then
        player_has_item = true
    else
        player_has_item = false
    end
    cb(player_has_item)
end)

--- Callback for checking if player has the required job
utils.callback.register('boii_utils:sv:player_has_job', function(_src, data, cb)
    local jobs = data.jobs
    local on_duty = data.on_duty
    local player_has_job = false
    if player_has_job(_src, jobs, on_duty) then
        player_has_job = true
    else
        player_has_job = false
    end
    cb(player_has_job)
end)

--- Callback for checking if player has the required job
utils.callback.register('boii_utils:sv:player_has_job', function(_src, data, cb)
    local jobs = data.jobs
    local on_duty = data.on_duty
    local player_has_job = false
    if player_has_job(_src, jobs, on_duty) then
        player_has_job = true
    else
        player_has_job = false
    end
    cb(player_has_job)
end)

--- Callback for checking if player has the required job grade
utils.callback.register('boii_utils:sv:get_player_job_grade', function(_src, data, cb)
    local job = data.job
    local job_grade = get_player_job_grade(_src, job)
    cb(job_grade)
end)

--- @section Database tables

--- Function to create sql table on load if not created already
-- This runs internally meaning it is not a exportable function it simply creates tables required for the utils sections
local function create_skill_tables()
    utils.debug.info("Creating skills table if not exists...")
    local query
    if FRAMEWORK == 'boii_core' then
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
    elseif FRAMEWORK == 'es_extended' then 
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
    if FRAMEWORK == 'boii_core' then
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
    elseif FRAMEWORK == 'es_extended' then 
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
    if FRAMEWORK == 'boii_core' then
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
    elseif FRAMEWORK == 'es_extended' then 
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

utils.fw.get_players = get_players
utils.fw.get_player = get_player
utils.fw.get_player_id = get_player_id
utils.fw.get_id_params = get_id_params
utils.fw.get_insert_params = get_insert_params
utils.fw.get_item = get_item
utils.fw.has_item = has_item
utils.fw.get_balances = get_balances
utils.fw.get_balance_by_type = get_balance_by_type
utils.fw.adjust_balance = adjust_balance
utils.fw.get_inventory = get_inventory
utils.fw.adjust_inventory = adjust_inventory
utils.fw.get_identity = get_identity
utils.fw.get_identity_by_id = get_identity_by_id
utils.fw.get_player_jobs = get_player_jobs
utils.fw.get_player_job_name = get_player_job_name
utils.fw.get_shared_job_data = get_shared_job_data
utils.fw.player_has_job = player_has_job
utils.fw.get_player_job_grade = get_player_job_grade
utils.fw.count_players_by_job = count_players_by_job
utils.fw.adjust_statuses = adjust_statuses
utils.fw.update_item_data = update_item_data
