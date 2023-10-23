----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    DEVELOPER UTILITIES
]]

-- Display current coords on screen
-- Usage: utils.developer.toggle_coords()
function toggle_coords()
    local x = 0.5  -- Centered
    show_coords = not show_coords
    CreateThread(function()
        while show_coords do
            local base_y = 0.025  -- Resetting the position here
            local increment_y = 0.025
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local c = {}
            c.x = utils.maths.round_number(coords.x, 2)
            c.y = utils.maths.round_number(coords.y, 2)
            c.z = utils.maths.round_number(coords.z, 2)
            heading = utils.maths.round_number(heading, 2)
            local display_data = {
                {label = 'Coords (vector2):', value = string.format('vector2(~w~%s~b~, ~w~%s~b~)', c.x, c.y)},
                {label = 'Coords (vector3):', value = string.format('vector3(~w~%s~b~, ~w~%s~b~, ~w~%s~b~)', c.x, c.y, c.z)},
                {label = 'Coords (vector4):', value = string.format('vector4(~w~%s~b~, ~w~%s~b~, ~w~%s~b~, ~w~%s~b~)', c.x, c.y, c.z, heading)}
            }
            for _, data in ipairs(display_data) do
                utils.draw.text({
                    coords = vector3(x, base_y, 0.0),
                    content = data.value,
                    scale = 0.4,
                    colour = {66, 182, 245, 255},
                    font = 4,
                    alignment = 'left', 
                    drop_shadow = {0, 0, 0, 0, 255},
                    text_edge = {2, 0, 0, 0, 150},
                    mode = '2d'
                })
                base_y = base_y + increment_y
            end
            Wait(0)
        end
    end)
end

-- Display relevant vehicle information on screen
-- Usage: utils.developer.toggle_vehicle_info()
local function toggle_vehicle_info()
    local x = 0.25
    vehicle_developer_mode = not vehicle_developer_mode
    CreateThread(function()
        while vehicle_developer_mode do
            local ped = PlayerPedId()
            Wait(0)
            if IsPedInAnyVehicle(ped, false) then
                local base_y = 0.588
                local increment_y = 0.025
                local vehicle = GetVehiclePedIsIn(ped, false)
                local net_id = VehToNet(vehicle)
                local hash = GetEntityModel(vehicle)
                local model_name = GetLabelText(GetDisplayNameFromVehicleModel(hash))
                local engine_health = GetVehicleEngineHealth(vehicle)
                local body_health = GetVehicleBodyHealth(vehicle)
                local speed_kmh = GetEntitySpeed(vehicle) * 3.6
                local speed_mph = speed_kmh * 0.621371
                local text_data = {
                    {label = 'Vehicle Data: ', value = ""},
                    {label = 'Entity ID:', value = vehicle},
                    {label = 'Net ID:', value = net_id},
                    {label = 'Model:', value = model_name},
                    {label = 'Hash:', value = hash},
                    {label = 'Engine Health:', value = utils.maths.round_number(engine_health, 2)},
                    {label = 'Body Health:', value = utils.maths.round_number(body_health, 2)},
                    {label = 'Speed (km/h):', value = utils.maths.round_number(speed_kmh, 1)},
                    {label = 'Speed (mph):', value = utils.maths.round_number(speed_mph, 1)}
                }
                for _, data in ipairs(text_data) do
                    utils.draw.text({
                        coords = vector3(x, base_y, 0),
                        content = string.format('%s ~b~%s~s~', data.label, data.value),
                        scale = 0.4,
                        font = 4
                    })
                    base_y = base_y + increment_y
                end
            end
        end
    end)
end

-- Display detailed player information on screen
-- Usage: utils.developer.toggle_player_info()
local function toggle_player_info()
    local x = 0.1
    local base_y = 0.2
    local increment_y = 0.025
    show_player_info = not show_player_info
    CreateThread(function()
        while show_player_info do
            local player = PlayerId()
            local data = utils.player.get_player_details(player)
            local y = base_y
            local text_data = {
                {label = 'Server ID:', value = data.server_id},
                {label = 'Name:', value = data.name},
                {label = 'Max Stamina:', value = data.max_stamina},
                {label = 'Stamina:', value = data.stamina},
                {label = 'Health:', value = data.health},
                {label = 'Armor:', value = data.armor},
                {label = 'Melee Dmg Mod:', value = data.melee_damage_modifier},
                {label = 'Melee Def Mod:', value = data.melee_defense_modifier},
                {label = 'Veh Dmg Mod:', value = data.vehicle_damage_modifier},
                {label = 'Veh Def Mod:', value = data.vehicle_defense_modifier},
                {label = 'Weapon Dmg Mod:', value = data.weapon_damage_modifier},
                {label = 'Weapon Def Mod:', value = data.weapon_defense_modifier},
                {label = 'Coords:', value = string.format('vector4(~w~%s~b~, ~w~%s~b~, ~w~%s~b~, ~w~%s~b~)', data.coords.x, data.coords.y, data.coords.z, data.coords.w)},
                {label = 'Model Hash:', value = data.model_hash},
                {label = 'Model Name:', value = data.model_name}
            }
            for _, entry in ipairs(text_data) do
                utils.draw.text({
                    coords = vector3(x, y, 0),
                    content = string.format('%s ~b~%s~s~', entry.label, entry.value),
                    scale = 0.4,
                    font = 4
                })
                y = y + increment_y
            end
            Wait(0)
        end
    end)
end

-- Display environment information on screen
-- Usage: utils.developer.toggle_environment_info()
function toggle_environment_info()
    local x = 0.8
    local base_y = 0.2
    local increment_y = 0.025
    show_environment_info = not show_environment_info
    CreateThread(function()
        while show_environment_info do
            local player = PlayerPedId()
            local current_time = utils.environment.get_game_time().formatted
            local weather_next_name = utils.environment.get_weather_name(weather_next)
            local weather_prev_name = utils.environment.get_weather_name(weather_prev)
            local direction = utils.player.get_cardinal_direction(player)
            local street = utils.player.get_street_name(player)
            local y = base_y
            local text_data = {
                {label = 'Time:', value = current_time},
                {label = 'Next Weather:', value = weather_next_name},
                {label = 'Previous Weather:', value = weather_prev_name},
                {label = 'Direction:', value = direction},
                {label = 'Street:', value = street}
            }
            for _, entry in ipairs(text_data) do
                utils.draw.text({
                    coords = vector3(x, y, 0),
                    content = string.format('%s ~b~%s~s~', entry.label, entry.value),
                    scale = 0.4,
                    font = 4
                })
                y = y + increment_y
            end
            Wait(0)
        end
    end)
end

--[[
    ASSIGN LOCALS
]]

utils.developer = utils.developer or {}

utils.developer.toggle_coords = toggle_coords
utils.developer.toggle_vehicle_info = toggle_vehicle_info
utils.developer.toggle_player_info = toggle_player_info
utils.developer.toggle_environment_info = toggle_environment_info
