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

--- Progressbar bridge.
--- @script client/scripts/bridges/progressbar.lua

local progressbar = config.ui.progressbar
local progress_active = false

--- Internal Helper function to handle triggering events and notifications
--- @function handle_event
--- @param outcome table: The outcome data containing event and notification details.
local function handle_event(outcome)
    if not outcome then return end
    if outcome.event.event_type == 'server' then
        TriggerServerEvent(outcome.event.event, outcome.event.params)
    elseif outcome.event.event_type == 'client' then
        TriggerEvent(outcome.event.event, outcome.event.params)
    end
    if outcome.notify then
        utils.ui.notify({
            type = outcome.notify.type,
            header = outcome.notify.header,
            message = outcome.notify.message,
            duration = outcome.notify.duration
        })
    end
    progress_active = false
end

--- Runs a progressbar depending on config settings.
--- @function progressbar
--- @param data table: Data table for the progress bar.
local function progressbar(data)
    if progress_active or not data then 
        print('Progress bar already active or data is missing')
        return 
    end
    progress_active = true

    if PROGRESSBAR == 'boii_ui' then
        exports.boii_ui:show_progress({
            header = data.header or '',
            icon = data.icon or '',
            duration = data.duration or 1000,
            disabled_controls = data.disabled_controls,
            animation = data.animation,
            props = data.props
        }, function(success)
            if success and data.on_success then
                handle_event(data.on_success)
            elseif not success and data.on_cancel then
                handle_event(data.on_cancel)
            else
                progress_active = false
            end
        end)
    else
        print('No suitable progress bar resource found or its not started')
        progress_active = false
    end
end

exports('ui_progressbar', progressbar)
utils.ui.progressbar = progressbar