----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

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

-- Function to get a players data
local function get_data(key)
    local player_data
    if framework == 'boii_base' then
        player_data = fw.get_data(key)
        return player_data
    elseif framework == 'qb-core' then
        player_data = fw.Functions.GetPlayerData()
        return player_data
    elseif framework == 'esx_legacy' then
        -- TO DO:
    elseif framework == 'ox_core' then  
        -- TO DO:
    elseif framework == 'custom' then
        
    end
end

-- Function to return a players name
local function get_player_name()
    local p_data = get_data()
    if not p_data then return false end
    local first_name, lastname
    
    if framework == 'boii_base' then
        first_name = p_data.identity.first_name
        last_name = p_data.identity.last_name
        return first_name, last_name
    elseif framework == 'qb-core' then
        first_name = p_data.charinfo.firstname
        last_name = p_data.charinfo.lastname
        return first_name, last_name
    elseif framework == 'esx_legacy' then
        -- TO DO:
    elseif framework == 'ox_core' then  
        -- TO DO:
    elseif framework == 'custom' then
        -- add code for your own framework here
    end
end

-- Function to get a players identity information depending on framework
local function get_identity(_src)
    local p_data = get_data()
    if not p_data then return false end

    local player_data

    if framework == 'boii_base' then
        player_data = {
            first_name = p_data.identity.first_name,
            last_name = p_data.identity.last_name,
            dob = p_data.identity.dob,
            sex = p_data.identity.sex,
            nationality = p_data.identity.nationality
        }
        return player_data
    elseif framework == 'qb-core' then
        player_data = {
            first_name = p_data.charinfo.firstname,
            last_name = p_data.charinfo.lastname,
            dob = p_data.charinfo.birthdate,
            sex = p_data.charinfo.gender,
            nationality = p_data.charinfo.nationality
        }
        return player_data
    elseif framework == 'esx_legacy' then
        -- TO DO:
    elseif framework == 'ox_core' then  
        -- TO DO:
    elseif framework == 'custom' then
        -- Add your own custom framework code here
    end
end

--[[
    ASSIGN LOCALS
]]

utils.fw = utils.fw or {}
utils.fw.get_data = get_data
utils.fw.get_player_name = get_player_name
