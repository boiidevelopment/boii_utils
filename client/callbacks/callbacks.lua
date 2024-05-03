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

--- Callback system.
-- @script client/callbacks.lua

--- @section Local functions

--- Trigger a server callback.
-- Triggers a server-side callback and handles the response asynchronously.
-- @function callback
-- @param name string: The event name of the callback.
-- @param data table: The data to send to the server.
-- @param cb function: The callback function to handle the response.
-- @usage utils.callback.cb('event_name', data_to_send, function(response) ... end)
local function callback(name, data, cb)
    local cb_id = math.random(1, 1000000)
    callbacks[cb_id] = cb
    TriggerServerEvent('boii_utils:sv:trigger_callback', name, data, cb_id)
end

--- @section Events

--- Handle server callbacks.
-- Listens for server callback responses and executes the corresponding client-side callback.
-- @event boii_utils:cl:client_callback
-- @param client_cb_id number: The client callback ID.
-- @param server_cb_id number: The server callback ID (not directly used but can be logged or used for validation).
-- @param ... multiple: The data returned by the server callback.
RegisterNetEvent('boii_utils:cl:client_callback')
AddEventHandler('boii_utils:cl:client_callback', function(client_cb_id, server_cb_id, ...)
    local callback = callbacks[client_cb_id]
    if callback then
        callback(...)
        callbacks[client_cb_id] = nil
    else
        utils.debug.err('Client callback not found: ', client_cb_id)
    end
end)

--- @section Assign local functions

utils.callback.cb = callback