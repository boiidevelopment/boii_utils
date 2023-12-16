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
    if framework == 'boii_base' then
        player_data = fw.get_data(key)
    elseif framework == 'qb-core' then
        player_data = fw.Functions.GetPlayerData()
    end
end

--[[
    ASSIGN LOCALS
]]

utils.fw = utils.fw or {}
utils.fw.get_data = get_data