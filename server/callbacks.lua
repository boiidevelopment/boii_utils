
--- This script provides server-side callback utilities.
-- It includes functions to register and handle server-side callbacks.
-- @script server/callbacks.lua

--- @section Variables

--- Local variable to keep track of callback IDs.
-- @field callback_id number: Stores the current callback ID.
local callback_id = 0

--- @section Local functions

--- Registers a server-side callback.
-- @function register_callback
-- @param name string: The name of the callback event.
-- @param cb function: The callback function to be executed.
-- @usage utils.callback.register('event_name', [callback])
local function register_callback(name, cb)
    utils.callbacks[name] = cb
end

--- Generates a new unique callback ID.
-- Note: This function is used internally to generate unique callback IDs and is not intended for direct usage.
-- @function generate_callback_id
-- @return number: A new unique callback ID.
local function generate_callback_id()
    callback_id = callback_id + 1
    return callback_id
end

--- @section Events

--- Event handler for server-side callbacks.
-- This event is automatically triggered when a client requests a callback and should not be used directly.
-- @event boii_utils:sv:trigger_callback
-- @param name string: The name of the callback event.
-- @param data table: The data passed from the client.
-- @param client_cb_id number: The callback ID generated on the client side.
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
        utils.debug.err('Callback not found:', name)
    end
end)

--- @section Assign local functions

utils.callback = utils.callback or {}

utils.callback.register = register_callback
