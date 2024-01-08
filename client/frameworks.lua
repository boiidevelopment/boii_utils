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

local function get_player_name()
    local player_data = get_data()
    local player_name
    
    if framework == 'boii_base' then
        player_name = player_data.identity.first_name .. ' ' .. player_data.identity.last_name
        return player_name
    elseif framework == 'qb-core' then
        player_name = player_data.charinfo.firstname .. ' ' .. player_data.charinfo.lastname
        return player_name
    elseif framework == 'esx_legacy' then
        -- TO DO:
    elseif framework == 'ox_core' then  
        -- TO DO:
    elseif framework == 'custom' then
        -- add code for your own framework here
    end
end

--[[
    ASSIGN LOCALS
]]

utils.fw = utils.fw or {}
utils.fw.get_data = get_data
utils.fw.get_player_name = get_player_name
