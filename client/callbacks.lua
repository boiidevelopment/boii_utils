----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    FUNCTIONS
]]

-- Function to trigger a server callback
-- Usage: utils.callback.cb('event_name', data_to_send, [callback])
local function callback(name, data, cb)
    local cb_id = math.random(1, 1000000)
    utils.callbacks[cb_id] = cb
    TriggerServerEvent('boii_utils:sv:trigger_callback', name, data, cb_id)
end

--[[
    EVENTS
]]

-- Event to handle server callbacks
-- Note: This event is automatically triggered when the server sends a callback response. No direct usage needed.
RegisterNetEvent('boii_utils:cl:client_callback')
AddEventHandler('boii_utils:cl:client_callback', function(client_cb_id, server_cb_id, ...)
    local callback = utils.callbacks[client_cb_id]
    if callback then
        callback(...)
        utils.callbacks[client_cb_id] = nil
    else
        print('Client callback not found: ', client_cb_id)
    end
end)

--[[
    ASSIGN LOCALS
]]

-- Assigns the callback function to the utils.callback table for easier access
utils.callback = utils.callback or {}
utils.callback.cb = callback
