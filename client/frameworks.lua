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

--- @section Functions

--- Retrieves a player's client-side data based on the active framework.
-- @function get_data
-- @param key string (optional): The key of the data to retrieve.
-- @return table: The requested player data.
-- @usage local data = utils.fw.get_data('key') -- Using a key is not required
local function get_data(key)
    local player_data
    if FRAMEWORK == 'boii_base' then
        player_data = fw.get_data(key)
    elseif FRAMEWORK == 'qb-core' then
        player_data = fw.Functions.GetPlayerData()
    elseif FRAMEWORK == 'esx_legacy' then
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
            first_name = player.charinfo.firstname,
            last_name = player.charinfo.lastname,
            dob = player.charinfo.birthdate,
            sex = player.charinfo.gender,
            nationality = player.charinfo.nationality
        }
    elseif FRAMEWORK == 'esx_legacy' then
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

--- @section Assigning to utils table

utils.fw = utils.fw or {}

utils.fw.get_data = get_data
utils.fw.get_identity = get_identity
