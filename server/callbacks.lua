----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    FUNCTIONS
]]

utils.callbacks = {}

local callback_id = 0

-- Function to register a server-side callback
-- Usage: utils.callback.register('event_name', [callback])
local function register_callback(name, cb)
    utils.callbacks[name] = cb
end

-- Function to generate a new callback ID
-- Note: This function is internally used to generate unique callback IDs. No direct usage needed.
local function generate_callback_id()
    callback_id = callback_id + 1
    return callback_id
end

--[[
    EVENTS
]]

-- Event to handle callbacks from client
-- Note: This event is automatically triggered when a client requests a callback. No direct usage needed.
RegisterServerEvent('boii_utils:sv:trigger_callback')
AddEventHandler('boii_utils:sv:trigger_callback', function(name, data, client_cb_id)
    local _src = source
    local callback = utils.callbacks[name]
    if callback then
        local server_cb_id = generate_callback_id()
        callback(_src, data, function(...)
            TriggerClientEvent('boii_utils:cl:client_callback', _src, client_cb_id, server_cb_id, ...)
        end)
    else
        utils.debugging.err('Callback not found:', name)
    end
end)

--[[
    ASSIGN LOCALS
]]
utils.callback = utils.callback or {}
utils.callback.register = register_callback
