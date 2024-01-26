--- This script manages client-side notifications for various notification resources.
-- @script client/notifications.lua
-- @todo Add additional support for a wider variety of notification resources out of the box.

--- @section Constants

--- Assigning config.notifications to NOTIFICATIONS for brevity.
-- Notification type can be set in the config files
-- @see client/config.lua & server/config.lua
local NOTIFICATIONS = config.notifications

--- Sends a notification to player based on current notification settings
-- @param options table: Table of notification data to be used by notification systems 
local function send(options)
    if NOTIFICATIONS == 'boii_ui' then
        TriggerEvent('boii_ui:notify', { type = options.type, header = options.header, message = options.message, duration = options.duration })
    elseif NOTIFICATIONS == 'qb-core' then
        if options.type == 'information' then
            options.type = 'primary'
        end
        TriggerEvent('QBCore:Notify', options.message, options.type, options.duration)
    elseif NOTIFICATIONS == 'esx_legacy' then
        if options.type == 'information' then
            options.type = 'info'
        end
        TriggerEvent("ESX:Notify", options.type, options.duration, options.message)
    elseif NOTIFICATIONS == 'ox_lib' then
        if options.type == 'information' then
            options.type = 'info'
        end
        TriggerEvent('ox_lib:notify', { type = options.type, title = options.header, description = options.message })
    end
end

--- @section Assign local functions

utils.notify = utils.notify or {}

utils.notify.send = send