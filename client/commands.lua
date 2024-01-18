----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    COMMANDS
]]

-- Function to nitialize character creation on active session
local function request_chat_suggestions()
    CreateThread(function()
        while true do
            Wait(10)
            if NetworkIsSessionActive() or NetworkIsPlayerActive(PlayerId()) then
                TriggerServerEvent('boii_utils:sv:request_chat_suggestions')
                break
            end
        end
    end)
end
request_chat_suggestions()

-- Event to add chat suggestions
RegisterNetEvent('boii_utils:cl:register_chat_suggestion', function(command, help, params)
    TriggerEvent('chat:addSuggestion', '/' .. command, help, params)
end)