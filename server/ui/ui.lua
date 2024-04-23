--- @section Constants

local NOTIFICATIONS = config.ui.notify

--- @section Mapping

--- Notifications
local notifications = {
    boii_ui = {
        event_name = 'boii_ui:notify',
        type_mapping = { information = 'info', primary = 'info' },
        prepare_args = function(opts)
            return { type = opts.type, header = opts.header, message = opts.message, duration = opts.duration }
        end,
        unpack_args = false
    },
    ox_lib = {
        event_name = 'ox_lib:notify',
        type_mapping = { information = 'info', primary = 'info' },
        prepare_args = function(opts)
            return { type = opts.type, title = opts.header, description = opts.message }
        end,
        unpack_args = false
    },
    es_extended = {
        event_name = 'ESX:Notify',
        type_mapping = { information = 'info', primary = 'info' },
        prepare_args = function(opts)
            return { opts.type, opts.duration, opts.message }
        end,
        unpack_args = true
    },
    ['qb-core'] = {
        event_name = 'QBCore:Notify',
        type_mapping = { information = 'primary', info = 'primary' },
        prepare_args = function(opts)
            return { opts.message, opts.type, opts.duration }
        end,
        unpack_args = true
    }
}

--- @section Local functions

--- Triggers notifications depending on chosen setting.
-- @param _src: Souce player.
-- @param options: Table of notification options.
local function notify(_src, options)
    if not options or not options.type or not options.message then
        print("Invalid notification data provided")
        return
    end
    local notif = notifications[NOTIFICATIONS] or notifications.boii_ui
    options.type = notif.type_mapping[options.type] or options.type
    local args = notif.prepare_args(options)
    local notify_params = unpack_args and table.unpack(args) or args
    TriggerClientEvent(notif.event_name, _src, notify_params)
end

utils.ui = utils.ui or {}

utils.ui.notify = notify