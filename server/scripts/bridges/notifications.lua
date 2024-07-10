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

--- Notification system.
--- @script client/scripts/bridges/notifications.lua

--- @section Local functions

--- Notification bridge function.
--- @function notify
--- @param options table: The notification options (type, message, header, duration).
local function notify(_src, options)
    if not options or not options.type or not options.message then
        print('Invalid notification data provided')
        return
    end

    if NOTIFICATIONS == 'boii_ui' then
        TriggerEvent('boii_ui:notify', _src, { type = options.type, header = options.header, message = options.message, duration = options.duration })
    elseif NOTIFICATIONS == 'ox_lib' then
        TriggerEvent('ox_lib:notify', _src, { type = options.type, title = options.header, description = options.message })
    elseif NOTIFICATIONS == 'es_extended' then
        TriggerEvent('ESX:Notify', _src, options.type, options.duration, options.message)
    elseif NOTIFICATIONS == 'qb-core' then
        local type_mapping = { information = 'primary', info = 'primary' }
        options.type = type_mapping[options.type] or options.type
        TriggerEvent('QBCore:Notify', _src, options.message, options.type, options.duration)
    elseif NOTIFICATIONS == 'okokNotify' then
        TriggerEvent('okokNotify:Alert', _src, options.header or 'Notification', options.message, options.type, options.duration or 5000)
    else
        TriggerEvent('boii_ui:notify', _src, { type = options.type, header = options.header, message = options.message, duration = options.duration })
    end
end

exports('ui_notify', notify)
utils.ui.notify = notify
