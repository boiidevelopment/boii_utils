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

--- Notifications bridge.
-- @script server/notifications.lua
-- @todo Add additional support for a wider variety of notification resources out of the box.

--- @section Constants

--- Assigning config.notifications to NOTIFICATIONS for brevity.
-- Notification type can be set in the config files
-- @see client/config.lua & server/config.lua
local NOTIFICATIONS = config.notifications

--- Sends a notification to player based on current notification settings
-- @param _src: The players source.
-- @param options table: Table of notification data to be used by notification systems 
local function send(_src, options)
    if NOTIFICATIONS == 'boii_ui' then
        if options.type == 'information' or options.type == 'primary' then
            options.type = 'info'
        end
        TriggerClientEvent('boii_ui:notify', _src, { type = options.type, header = options.header, message = options.message, duration = options.duration })
    elseif NOTIFICATIONS == 'qb-core' then
        if options.type == 'information' or options.type == 'info' then
            options.type = 'primary'
        end
        TriggerClientEvent('QBCore:Notify', _src, options.message, options.type, options.duration)
    elseif NOTIFICATIONS == 'esx_legacy' then
        if options.type == 'information' or options.type == 'primary' then
            options.type = 'info'
        end
        TriggerClientEvent("ESX:Notify", _src, options.type, options.duration, options.message)
    elseif NOTIFICATIONS == 'ox_lib' then
        if options.type == 'information' or options.type == 'primary' then
            options.type = 'info'
        end
        TriggerClientEvent('ox_lib:notify', _src, { type = options.type, title = options.header, description = options.message })
    end
end

--- @section Assign local functions

utils.notify.send = send