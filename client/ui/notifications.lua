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
    },
    okokNotify = {
        
    }
}

--- @section Local functions

-- Unified notify function
local function notify(options)
    if not options or not options.type or not options.message then
        print("Invalid notification data provided")
        return
    end
    local notif = notifications[NOTIFICATIONS] or notifications.boii_ui
    options.type = notif.type_mapping[options.type] or options.type
    local args = notif.prepare_args(options)
    local notify_params = notif.unpack_args and table.unpack(args) or args
    TriggerEvent(notif.event_name, notify_params)
end

utils.ui.notify = notify
