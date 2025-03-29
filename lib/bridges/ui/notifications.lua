--- @module Notifications Bridge


local notifications = {}

if ENV.IS_SERVER then

    --- Send notification to a specific client.
    --- @param source number: The ID of the target player.
    --- @param options table: The notification options (type, message, header, duration).
    local function notify(source, options)
        if not source or not options or not (options.type and options.message) then return false end

        TriggerClientEvent("boii_utils:cl:send_notification", source, options)
    end

    --- @section Function Assignments

    notifications.send = notify

    --- @section Exports

    exports("send_notification", notify)

else

    --- @section Handlers
    local HANDLERS <const> = {
        default = function(options)
            TriggerEvent("boii_utils:cl:notify", { type = options.type, header = options.header, message = options.message, duration = options.duration })
        end,
        boii = function(options)
            TriggerEvent("boii_ui:notify", { type = options.type, header = options.header, message = options.message, duration = options.duration })
        end,
        esx = function(options)
            TriggerEvent("ESX:Notify", options.type, options.duration, options.message)
        end,
        okok = function(options)
            TriggerEvent("okokNotify:Alert", options.header, options.message, options.type, options.duration)
        end,
        ox = function(options)
            TriggerEvent("ox_lib:notify", { type = options.type, title = options.header, description = options.message })
        end,
        qb = function(options)
            local type_mapping = { information = "primary", info = "primary" }
            options.type = type_mapping[options.type] or options.type
            TriggerEvent("QBCore:Notify", options.message, options.type, options.duration)
        end
    }

    --- Notification bridge function.
    --- @param options table: The notification options (type, message, header, duration).
    local function notify(options)
        if not options or not options.type or not options.message then return false end

        local handler = HANDLERS[NOTIFICATIONS] or HANDLERS.default

        handler(options)
    end

    --- @section Function Assignments

    notifications.send = notify

    --- @section Exports

    exports("send_notification", notify)

end

return notifications