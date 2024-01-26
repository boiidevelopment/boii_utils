--- This script handles conversion of meta data based on the chosen framework.
-- It ensures framework-specific data is processed and converted as needed.
-- @script client/conversions.lua

--- @section Conversions

--- QB-Core specific conversions.
-- Runs conversions specific to the QB-Core framework once the player state is logged in.
if framework == 'qb-core' then
    
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