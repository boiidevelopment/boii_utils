--- @section Modules

local DEBUG <const> = get("modules.debugging")

--- @module Callbacks

local callbacks = {}

if ENV.IS_SERVER then

    stored_callbacks = stored_callbacks or {}

    --- Registers a server-side callback.
    --- @param name string: The name of the callback event.
    --- @param cb function: The callback function to be executed.
    local function register_callback(name, cb)
        if not name or not cb then
            DEBUG.print("error", ("Failed to register callback: Invalid name or function. Name: %s"):format(name or "nil"))
            return
        end
        if stored_callbacks[name] then
            DEBUG.print("warning", ("Overwriting existing callback: %s"):format(name))
        end
        stored_callbacks[name] = cb
        local callback_keys = {}
        for key in pairs(stored_callbacks) do
            table.insert(callback_keys, key)
        end
    end

    --- @section Function Assignments

    callbacks.register = register_callback

    --- @section Exports

    exports("register_callback", register_callback)

else

    stored_callbacks = stored_callbacks or {}

    --- Trigger a server callback.
    --- @param name string: The event name of the callback.
    --- @param data table: The data to send to the server *(always validate server side if sending data)*.
    --- @param cb function: The callback function to handle the response.
    local function callback(name, data, cb)
        local cb_id = math.random(1, 1000000)
        stored_callbacks[cb_id] = cb
        TriggerServerEvent("boii_utils:sv:trigger_callback", name, data, cb_id)
    end

    --- @section Function Assignments

    callbacks.trigger = callback

    --- @section Exports

    exports("trigger_callback", callback)

end


return callbacks