--- @section Modules

local NOTIFICATIONS = get("modules.notifications")

--- @section Events

if not ENV.IS_SERVER then

    --- Send notifications.
    --- @param options table: Options for notification.
    RegisterNetEvent("boii_utils:cl:send_notification", function(options)
        NOTIFICATIONS.send(options)
    end)
    
end
