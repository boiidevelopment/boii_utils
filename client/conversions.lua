----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

if framework == 'qb-core' then
    
    -- Thread to run qb conversions when player state is logged in
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