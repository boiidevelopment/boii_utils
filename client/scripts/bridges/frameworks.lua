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
--- @script client/scripts/bridges/framework.lua
--- @todo Add support for other frameworks { nd_core, qbox, ?? }

--- @section Constants

--- @field FRAMEWORK: Stores framework string name for use in conversions.
local FRAMEWORK = nil

--- Initializes the connection to the specified framework when the resource starts.
CreateThread(function()
    if GetResourceState('boii_core') == 'started' then
        FRAMEWORK = 'boii_core'
    elseif GetResourceState('qb-core') == 'started' then
        FRAMEWORK = 'qb-core'
    elseif GetResourceState('es_extended') == 'started' then
        FRAMEWORK = 'es_extended'
    elseif GetResourceState('ox_core') == 'started' then
        FRAMEWORK = 'ox_core'
    end

    while not FRAMEWORK do
        Wait(500)
    end
    
    if FRAMEWORK == 'boii_core' then
        fw = exports.boii_core:get()
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
        --- Custom framework initialization
    end

    return
end)


--- @section Functions

--- Retrieves a player's client-side data based on the active framework.
--- @function get_data
--- @param key string (optional): The key of the data to retrieve.
--- @return table: The requested player data.
--- @usage local data = utils.fw.get_data('key') -- Using a key is not required
local function get_data(key)
    local player_data
    if FRAMEWORK == 'boii_core' then
        player_data = fw.get_data(key)
    elseif FRAMEWORK == 'qb-core' then
        player_data = fw.Functions.GetPlayerData()
    elseif FRAMEWORK == 'es_extended' then
        player_data = fw.GetPlayerData()
    elseif FRAMEWORK == 'ox_core' then
        player_data = fw.GetPlayerData()
    elseif FRAMEWORK == 'custom' then
        --- Custom framework logic
    end

    if not player_data then
        print('No player data found in get_data()')
    end

    return player_data
end

exports('fw_get_data', get_data)
utils.fw.get_data = get_data

--- Retrieves a player's identity information based on the active framework.
--- @function get_identity
--- @return table: The player's identity information (first name, last name, date of birth, sex, nationality).
--- @usage local identity = utils.fw.get_identity()
local function get_identity()
    local player = get_data()
    if not player then return false end

    local player_data

    if FRAMEWORK == 'boii_core' then
        player_data = {
            first_name = player.identity.first_name,
            last_name = player.identity.last_name,
            dob = player.identity.dob,
            sex = player.identity.sex,
            nationality = player.identity.nationality
        }
    elseif FRAMEWORK == 'qb-core' then
        player_data = {
            first_name = player.charinfo.firstname,
            last_name = player.charinfo.lastname,
            dob = player.charinfo.birthdate,
            sex = player.charinfo.gender,
            nationality = player.charinfo.nationality
        }
    elseif FRAMEWORK == 'es_extended' then
        player_data = {
            first_name = fw.GetPlayerData().firstName or 'firstName missing',
            last_name = fw.GetPlayerData().lastName or 'lastName missing',
            dob = fw.GetPlayerData().dateofbirth or 'dateofbirth missing',
            sex = fw.GetPlayerData().sex or 'sex missing',
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
        --- Custom framework logic
    end
    return player_data
end

exports('fw_get_identity', get_identity)
utils.fw.get_identity = get_identity

--- Retrieves player id from the server based on the framework.
--- @param _src Player source identifier.
--- @return Players main identifier.
--- @usage local player = utils.fw.get_player_id()
local function get_player_id()
    local player = get_data()
    if not player then
        print('No player data found')
        return false
    end
    local player_id

    if FRAMEWORK == 'boii_core' then
        player_id = player.passport
    elseif FRAMEWORK == 'qb-core' then 
        player_id = player.citizenid
    elseif FRAMEWORK == 'es_extended' then
        player_id = player.identifier
    elseif FRAMEWORK == 'ox_core' then
        player_id = player.stateId
    elseif FRAMEWORK == 'custom' then
        --- Custom framework logic
    end

    if not player_id then
        print('player_id is nil')
    end

    return player_id
end

exports('fw_get_player_id', get_player_id)
utils.fw.get_player_id = get_player_id

RegisterCommand('get_player_id', function()
    local player_id = get_player_id()
    print('player_id is: ' .. player_id)
end)

--- @section Callback functions

--- Callback function to check if a player has a required job.
--- @param jobs table: A table of job names to check against.
--- @param on_duty boolean: Toggle to only return true if player is on duty.
--- @param cb function: Callback function.
local function player_has_job(jobs, on_duty, cb)
    utils.callback.cb('boii_utils:sv:player_has_job', { jobs = jobs, on_duty = on_duty }, function(has_job)
        cb(has_job)
    end)
end

exports('fw_player_has_job', player_has_job)
utils.fw.player_has_job = player_has_job

--- Callback function to check if a player has a required job.
--- @param jobs: A table of job names to check against.
--- @param on_duty: Toggle to only return true if player is on duty.
--- @param cb: Callback function.
local function get_player_job_grade(job, cb)
    utils.callback.cb('boii_utils:sv:get_player_job_grade', { job = job }, function(players_grade)
        cb(players_grade)
    end)
end

exports('fw_get_player_job_grade', get_player_job_grade)
utils.fw.get_player_job_grade = get_player_job_grade

--- Callback function to get a players inventory data.
--- @param cb: Callback function.
local function get_inventory(cb)
    utils.callback.cb('boii_utils:sv:get_inventory', {}, function(inventory)
        cb(inventory)
    end)
end

exports('fw_get_inventory', get_inventory)
utils.fw.get_inventory = get_inventory

--- Callback function to get a specific item.
--- @param item: The item ID to check.
--- @param cb: Callback function.
local function get_item(item, cb)
    local item = tostring(item)
    utils.callback.cb('boii_utils:sv:get_item', { item_name = item }, function(item)
        cb(item)
    end)
end

exports('fw_get_item', get_item)
utils.fw.get_item = get_item

--- Callback function to check if a player has a required item and quantity.
--- @param item: The item ID to check.
--- @param amount: The amount of the item they should have.
--- @param cb: Callback function.
local function has_item(item, amount, cb)
    local item = tostring(item)
    local amount = tonumber(amount) or 1
    utils.callback.cb('boii_utils:sv:has_item', { item_name = item, item_amount = amount }, function(has_item)
        cb(has_item)
    end)
end

exports('fw_has_item', has_item)
utils.fw.has_item = has_item
