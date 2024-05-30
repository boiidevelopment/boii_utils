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

local PROGRESSBAR = config.ui.progressbar

local progressbars = {
    boii_ui = {
        show_progress = function(data, callback)
            exports.boii_ui:show_progress({
                header = data.header or '',
                icon = data.icon or '',
                duration = data.duration or 1000,
                disabled_controls = data.disabled_controls,
                animation = data.animation,
                props = data.props
            }, callback)
        end
    }
}

-- Internal Helper function to handle triggering events and notifications
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
-- @param data: Data table for the bar.
local function progressbar(data)
    if progress_active or not data then 
        print("Progress bar already active or data is missing")
        return 
    end
    progress_active = true

    local system = progressbars[PROGRESSBAR]
    if system and system.show_progress then
        system.show_progress(data, function(success)
            if success and data.on_success then
                handle_event(data.on_success)
            elseif not success and data.on_cancel then
                handle_event(data.on_cancel)
            else
                progress_active = false
            end
        end)
    else
        progress_active = false
    end
end

--- @section Assign local functions

utils.ui.progressbar = progressbar
