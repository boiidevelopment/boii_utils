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

--- Framework conversions.
--- @script client/scripts/conversions.lua

--- @section Constants

--- @field FRAMEWORK: Stores framework string name for use in conversions.
local FRAMEWORK = nil

--- @section Conversions

--- QB-Core specific conversions.
--- Runs conversions specific to the QB-Core framework once the player state is logged in.
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

    if FRAMEWORK == 'qb-core' then
    
        --- Thread to run qb conversions when LocalPlayer.state.isLoggedIn
        CreateThread(function()
            while true do
                if LocalPlayer.state.isLoggedIn then
                    TriggerServerEvent('boii_utils:sv:run_qb_meta_convert')
                    break
                end
                Wait(0)
            end
        end)
    
    end

    return
end)