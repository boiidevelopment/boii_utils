--- @section Modules 

local DEBUG <const> = get("modules.debugging")

if ENV.IS_SERVER then

    local callback_id = 0

    --- Generates a new unique callback ID.
    --- @return number: A new unique callback ID.
    local function generate_callback_id()
        callback_id = callback_id + 1
        return callback_id
    end
    
    --- @section Events
    
    --- Event handler for server-side callbacks.
    --- @param name string: The name of the callback event.
    --- @param data table: The data passed from the client.
    --- @param client_cb_id number: The callback ID generated on the client side.
    RegisterServerEvent("boii_utils:sv:trigger_callback")
    AddEventHandler("boii_utils:sv:trigger_callback", function(name, data, client_cb_id)
        local source = source
        local callback = stored_callbacks[name]
        local callback_names = {}
        for key in pairs(stored_callbacks) do
            callback_names[#callback_names  + 1] = key
        end
        DEBUG.print("info", ("Available callbacks: [%s]"):format(table.concat(callback_names, ", ")))
        if callback then
            local server_cb_id = generate_callback_id()
            callback(source, data, function(...)
                TriggerClientEvent("boii_utils:cl:client_callback", source, client_cb_id, server_cb_id, ...)
            end)
        else
            DEBUG.print("error", ("Callback not found: "%s". Available callbacks: [%s]"):format(name, table.concat(callback_names, ", ")))
        end
    end)

else

    --- Handle server callbacks.
    --- @param client_cb_id number: The client callback ID.
    --- @param server_cb_id number: The server callback ID (not directly used but can be logged or used for validation).
    --- @param ... multiple: The data returned by the server callback.
    RegisterNetEvent("boii_utils:cl:client_callback")
    AddEventHandler("boii_utils:cl:client_callback", function(client_cb_id, server_cb_id, ...)
        local callback = stored_callbacks[client_cb_id]
        if callback then
            callback(...)
            stored_callbacks[client_cb_id] = nil
        end
    end)

end