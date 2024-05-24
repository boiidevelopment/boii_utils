local PROGRESSBAR = config.ui.progressbar

--- Progressbars
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
    },
    ['qb-core'] = {
        show_progress = function(data, callback)
            local props = data.props or {}
            local prop = props[1] or {}
            local prop_2 = props[2] or {}
            local animation = data.animation or {}
            local disabled_controls = data.disabled_controls or {}
            exports['progressbar']:Progress({
                name = data.header .. GetGameTimer(),
                duration = data.duration or 5000,
                label = data.header or "Processing",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = disabled_controls.movement or false,
                    disableCarMovement = disabled_controls.car_movement or false,
                    disableMouse = disabled_controls.mouse or false,
                    disableCombat = disabled_controls.combat or true,
                },
                animation = {
                    animDict = animation.dict or "",
                    anim = animation.anim or "",
                    flags = animation.flags or 49,
                },
                prop = {
                    model = prop.model or '',
                    bone = prop.bone or 0,
                    coords = prop.coords or vector3(0,0,0),
                    rotation = prop.rotation or vector3(0,0,0),
                },
                prop_2 = {
                    model = prop_2.model or '',
                    bone = prop_2.bone or 0,
                    coords = prop_2.coords or vector3(0,0,0),
                    rotation = prop_2.rotation or vector3(0,0,0),
                }
            }, function(cancelled)
                if not cancelled then
                    callback(true)  -- success
                else
                    callback(false)  -- cancelled
                end
            end)
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
        notify(outcome.notify)
    end
    progress_active = false
end

--- Runs a progressbar depending on config settings.
-- @param data: Data table for the bar.
local function progressbar(data)
    if progress_active or not data then return end
    progress_active = true

    local system = progressbars[PROGRESSBAR]
    if system and system.show_progress then
        system.show_progress(data, function(success)
            if success and data.on_success then
                handle_event(data.on_success)
            elseif not success and data.on_cancel then
                handle_event(data.on_cancel)
            end
        end)
    else
        print("Progress bar system not configured or not found.")
        progress_active = false
    end
end

--- @section Assign local functions

utils.ui.progressbar = progressbar

--- Creates a test progressbar using the unified progress function.
RegisterCommand('utils:test_prog', function()
    local data = {
        progressbar = {
            header = 'Trimming Buds..',
            icon = 'fa-solid fa-cannabis',
            duration = 15000,
            disable_controls = { -- COntrol disables added in for ease of use with bridging qb-progressbar along with providing that extra familiarity.
                mouse = false, -- Disables mouse controls
                movement = false, -- Movement controls
                car_movement = false, -- In vehicle movement controls
                combat = false -- Disables firing
            },
            animation = {
                dict = 'amb@prop_human_parking_meter@female@base',
                anim = 'base_female',
                flags = 49
            },
            props = {
                {
                    model = 'h4_prop_h4_weed_bud_02b',
                    bone = 28422,
                    coords = vector3(0.09, -0.075, 0.0),
                    rotation = vector3(-90.0, 0.0, 0.0)
                }
            },
            on_success = {
                notify = {
                    type = 'success',
                    header = 'TRIMMING',
                    message = 'You have successfully trimmed the buds.',
                    duration = 3000
                }
            },
            on_cancel = {
                notify = {
                    type = 'error',
                    header = 'TRIMMING',
                    message = 'Trimming cancelled.',
                    duration = 3000
                }
            }
        }
    }

    utils.ui.progressbar(data)
end)
