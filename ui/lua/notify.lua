--- @section Local functions

--- Sends a notify.
--- @param options table: The options for the notify.
function notify(options)
    SendNUIMessage({
        action = 'notify',
        type = options.type or 'info',
        header = options.header or nil,
        message = options.message or 'No message provided',
        duration = options.duration or 3500,
        style = options.style or nil
    })
end

exports('notify', notify)

--- @section Events

--- Event to send notifys
--- @param options table: The options for the notify.
RegisterNetEvent('boii_utils:cl:notify', function(options)
    notify(options)
end)
