--- This script handles chat command suggestions, ensuring players are provided with suggestions for registered commands.
-- @script client/commands.lua
-- @see server/commands.lua & server/commands_list.lua for server side implementation and example command registration

--- @section Local functions

-- Function to initialize character creation on active session
-- This function waits for the player's session to become active before requesting chat suggestions from the server.
-- @function request_chat_suggestions
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

--- @section Events

-- Event to add chat suggestions
-- This event listens for the server's response to add chat command suggestions for the player.
-- @param command string: The command name.
-- @param help string: Description or help text for the command.
-- @param params table: Parameters for the command.
RegisterNetEvent('boii_utils:cl:register_chat_suggestion', function(command, help, params)
    TriggerEvent('chat:addSuggestion', '/' .. command, help, params)
end)
