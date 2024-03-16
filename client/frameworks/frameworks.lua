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
local FRAMEWORK = config.framework
local fw

--- Initializes the connection to the specified framework when the resource starts.
-- Supports 'boii_rp', 'qb-core', 'es_extended', 'ox_core', and custom frameworks *(provided you fill this in of course)*.
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

--- @section Functions

--- Retrieves a player's client-side data based on the active framework.
-- @function get_data
-- @param key string (optional): The key of the data to retrieve.
-- @return table: The requested player data.
-- @usage local data = utils.fw.get_data('key') -- Using a key is not required
local function get_data(key)
    local player_data
    if FRAMEWORK == 'boii_rp' then
        player_data = fw.get_data(key)
    elseif FRAMEWORK == 'qb-core' then
        player_data = fw.Functions.GetPlayerData()
    elseif FRAMEWORK == 'es_extended' then
        player_data = fw.GetPlayerData()
    elseif FRAMEWORK == 'ox_core' then
        player_data = fw.GetPlayerData()
    elseif FRAMEWORK == 'custom' then
        -- Custom framework logic
    end
    return player_data
end

--- Retrieves a player's identity information based on the active framework.
-- @function get_identity
-- @return table: The player's identity information (first name, last name, date of birth, sex, nationality).
-- @usage local identity = utils.fw.get_identity()
local function get_identity()
    local player = get_data()
    if not player then return false end

    local player_data

    if FRAMEWORK == 'boii_rp' then
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
            first_name = fw.PlayerData.firstName,
            last_name = fw.PlayerData.lastName,
            dob = fw.PlayerData.dateofbirth,
            sex = fw.PlayerData.sex,
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

--- @section Callback functions

--- Callback function to check if a player has a required item and quantity.
-- @param item: The item ID to check.
-- @param amount: The amount of the item they should have.
-- @param cb: Callback function.
local function has_item(item, amount, cb)
    local item = tostring(item)
    local amount = tonumber(amount) or 1
    utils.callback.cb('boii_utils:sv:has_item', { item_name = item, item_amount = amount }, function(has_item)
        cb(has_item)
    end)
end

--- Callback function to check if a player has a required job.
-- @param jobs: A table of job names to check against.
-- @param on_duty: Toggle to only return true if player is on duty.
-- @param cb: Callback function.
local function player_has_job(jobs, on_duty, cb)
    utils.callback.cb('boii_utils:sv:player_has_job', { jobs = jobs, on_duty = on_duty }, function(has_job)
        cb(has_job)
    end)
end

--- Callback function to check if a player has a required job.
-- @param jobs: A table of job names to check against.
-- @param on_duty: Toggle to only return true if player is on duty.
-- @param cb: Callback function.
local function get_player_job_grade(job, cb)
    utils.callback.cb('boii_utils:sv:get_player_job_grade', { job = job }, function(players_grade)
        cb(players_grade)
    end)
end

--- @section Assigning to utils table

utils.fw = utils.fw or {}

utils.fw.get_data = get_data
utils.fw.get_identity = get_identity
utils.fw.has_item = has_item
utils.fw.player_has_job = player_has_job
utils.fw.get_player_job_grade = get_player_job_grade
