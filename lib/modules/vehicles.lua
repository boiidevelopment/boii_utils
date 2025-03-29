--- @section Modules

local STRINGS <const> = get("modules.strings")
local MATHS <const> = get("modules.maths")
local ENTITIES <const> = get("modules.entities")
local REQUESTS <const> = get("modules.requests")

--- @section Module

local vehicles = {}

if not ENV.IS_SERVER then

    --- Retrieves the license plate number of a vehicle.
    --- @param vehicle number: The handle of the vehicle.
    local function get_vehicle_plate(vehicle)
        if vehicle == 0 then return end

        return STRINGS.trim(GetVehicleNumberPlateText(vehicle))
    end

    --- Retrieves the model name of a vehicle.
    --- @param vehicle number: The handle of the vehicle.
    local function get_vehicle_model(vehicle)
        local hash = GetEntityModel(vehicle)
        local name = GetDisplayNameFromVehicleModel(hash)

        return string.lower(name)
    end

    --- Retrieves a list of broken doors of a vehicle.
    --- @param vehicle number: The handle of the vehicle.
    local function get_doors_broken(vehicle)
        local doors_broken = {}
        local num_doors = GetNumberOfVehicleDoors(vehicle)

        if num_doors and num_doors > 0 then
            for door_id = 0, num_doors - 1 do
                doors_broken[tostring(door_id)] = IsVehicleDoorDamaged(vehicle, door_id)
            end
        end

        return doors_broken
    end

    --- Retrieves a list of broken windows of a vehicle.
    --- @param vehicle number: The handle of the vehicle.
    local function get_windows_broken(vehicle)
        local windows_broken = {}

        for window_id = 0, 13 do
            windows_broken[tostring(window_id)] = not IsVehicleWindowIntact(vehicle, window_id)
        end

        return windows_broken
    end

    --- Retrieves a list of burst tyres of a vehicle.
    --- @param vehicle number: The handle of the vehicle.
    local function get_tyre_burst(vehicle)
        local tyre_burst = {}
        
        local tyres_index = {
            ['2'] = {0, 4},
            ['3'] = {0, 1, 4, 5},
            ['4'] = {0, 1, 4, 5},
            ['6'] = {0, 1, 2, 3, 4, 5}
        }

        local num_wheels = tostring(GetVehicleNumberOfWheels(vehicle))

        if tyres_index[num_wheels] then
            for _, idx in pairs(tyres_index[num_wheels]) do
                tyre_burst[tostring(idx)] = IsVehicleTyreBurst(vehicle, idx, false)
            end
        end

        return tyre_burst
    end

    --- Retrieves the extras enabled on a vehicle.
    --- @param vehicle number: The handle of the vehicle.
    local function get_vehicle_extras(vehicle)
        local extras = {}

        for extra_id = 0, 20 do
            if DoesExtraExist(vehicle, extra_id) then
                extras[tostring(extra_id)] = IsVehicleExtraTurnedOn(vehicle, extra_id)
            end
        end

        return extras
    end

    --- Retrieves the custom xenon color of a vehicle if available.
    --- @param vehicle number: The handle of the vehicle.
    local function get_custom_xenon_color(vehicle)
        local has_custom_xenon_color, r, g, b = GetVehicleXenonLightsCustomColor(vehicle)

        if has_custom_xenon_color then
            return {r, g, b}
        else
            return nil
        end
    end

    --- Retrieves the modification of a specified type for a vehicle.
    --- @function get_vehicle_mod
    --- @param vehicle number: The handle of the vehicle.
    --- @param mod_type string: The type of modification.
    local function get_vehicle_mod(vehicle, mod_type)

        return {
            index = GetVehicleMod(vehicle, mod_type),
            variation = GetVehicleModVariation(vehicle, mod_type)
        }
    end

    --- Retrieves various properties of a vehicle.
    --- @param vehicle number: The handle of the vehicle.
    local function get_vehicle_properties(vehicle)
        if not DoesEntityExist(vehicle) then return nil end
        local color_primary, color_secondary = GetVehicleColours(vehicle)
        local pearlescent_color, wheel_color = GetVehicleExtraColours(vehicle)
        local has_custom_primary_color = GetIsVehiclePrimaryColourCustom(vehicle)
        local custom_primary_color = has_custom_primary_color and { GetVehicleCustomPrimaryColour(vehicle) } or nil
        local has_custom_secondary_color = GetIsVehicleSecondaryColourCustom(vehicle)
        local custom_secondary_color = has_custom_secondary_color and { GetVehicleCustomSecondaryColour(vehicle) } or nil

        local mods = {}
        for mod_type = 0, 49 do
            mods[mod_type] = get_vehicle_mod(vehicle, mod_type)
        end

        return {
            model = GetEntityModel(vehicle),
            doors_broken = get_doors_broken(vehicle),
            windows_broken = get_windows_broken(vehicle),
            tyre_burst = get_tyre_burst(vehicle),
            tyres_can_burst = GetVehicleTyresCanBurst(vehicle),
            plate = boii.trim_string(GetVehicleNumberPlateText(vehicle)),
            plate_index = GetVehicleNumberPlateTextIndex(vehicle),
            body_health = MATHS.round_number(GetVehicleBodyHealth(vehicle), 1),
            engine_health = MATHS.round_number(GetVehicleEngineHealth(vehicle), 1),
            tank_health = MATHS.round_number(GetVehiclePetrolTankHealth(vehicle), 1),
            fuel_level = MATHS.round_number(GetVehicleFuelLevel(vehicle), 1),
            dirt_level = MATHS.round_number(GetVehicleDirtLevel(vehicle), 1),
            color1 = color_primary,
            color2 = color_secondary,
            custom_primary_color = custom_primary_color,
            custom_secondary_color = custom_secondary_color,
            pearlescent_color = pearlescent_color,
            wheel_color = wheel_color,
            dashboard_color = GetVehicleDashboardColour(vehicle),
            interior_color = GetVehicleInteriorColour(vehicle),
            wheels = GetVehicleWheelType(vehicle),
            window_tint = GetVehicleWindowTint(vehicle),
            xenon_color = GetVehicleXenonLightsColor(vehicle),
            custom_xenon_color = get_custom_xenon_color(vehicle),
            neon_enabled = get_neon_enabled(vehicle),
            neon_color = table.pack(GetVehicleNeonLightsColour(vehicle)),
            extras = get_vehicle_extras(vehicle),
            tyre_smoke_color = table.pack(GetVehicleTyreSmokeColor(vehicle)),
            mods = mods
        }
    end

    --- Retrieves mods and maintenance data of a vehicle.
    --- @param vehicle number: The handle of the vehicle.
    local function get_vehicle_mods_and_maintenance(vehicle)
        if DoesEntityExist(vehicle) then
            local pearlescent_color, wheel_color = GetVehicleExtraColours(vehicle)
            local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
            if not (r and g and b) then
                r, g, b = 0, 0, 0
            end

            local colour_primary = {r = r, g = g, b = b}
            local r2, g2, b2 = GetVehicleCustomSecondaryColour(vehicle)
            if not (r2 and g2 and b2) then
                r2, g2, b2 = 0, 0, 0
            end

            local colour_secondary = {r = r2, g = g2, b = b2}
            local mod_livery = GetVehicleMod(vehicle, 48)
            if GetVehicleMod(vehicle, 48) == -1 and GetVehicleLivery(vehicle) ~= 0 then
                mod_livery = GetVehicleLivery(vehicle)
            end

            local extras = {}
            for extra_id = 0, 12 do
                if DoesExtraExist(vehicle, extra_id) then
                    local state = IsVehicleExtraTurnedOn(vehicle, extra_id) == 1
                    extras[tostring(extra_id)] = state
                end
            end

            local num_wheels = GetVehicleNumberOfWheels(vehicle)
            local tyre_health = {}
            for i = 0, num_wheels - 1 do
                tyre_health[i] = GetVehicleWheelHealth(vehicle, i)
            end

            local window_status = {}
            for i = 0, 7 do
                window_status[i] = IsVehicleWindowIntact(vehicle, i) == 1
            end

            local door_status = {}
            local num_doors = GetNumberOfVehicleDoors(vehicle)
            for i = 0, num_doors - 1 do
                door_status[i] = IsVehicleDoorDamaged(vehicle, i) == 1
            end

            local modifications = {
                model = GetEntityModel(vehicle),
                plate_index = GetVehicleNumberPlateTextIndex(vehicle),
                colour_primary = colour_primary,
                colour_secondary = colour_secondary,
                pearlescent_color = pearlescent_color,
                wheel_color = wheel_color,
                wheels = GetVehicleWheelType(vehicle),
                window_tint = GetVehicleWindowTint(vehicle),
                xenons = IsToggleModOn(vehicle, 22),
                xenon_color = GetVehicleXenonLightsColour(vehicle),
                neon_enabled = {
                    IsVehicleNeonLightEnabled(vehicle, 0),
                    IsVehicleNeonLightEnabled(vehicle, 1),
                    IsVehicleNeonLightEnabled(vehicle, 2),
                    IsVehicleNeonLightEnabled(vehicle, 3)
                },
                neon_color = table.pack(GetVehicleNeonLightsColour(vehicle)),
                headlight_color = GetVehicleHeadlightsColour(vehicle),
                tire_smoke_color = table.pack(GetVehicleTyreSmokeColor(vehicle)),
                livery = mod_livery,
                extras = extras
            }

            local maintenance = {
                mileage = 0,
                fuel = GetVehicleFuelLevel(vehicle),
                oil = GetVehicleOilLevel(vehicle),
                engine = GetVehicleEngineHealth(vehicle),
                body = GetVehicleBodyHealth(vehicle),
                gearbox = 1000,
                clutch = GetVehicleClutch(vehicle),
                suspension = 1000,
                petrol_tank = GetVehiclePetrolTankHealth(vehicle),
                dirt = GetVehicleDirtLevel(vehicle),
                door_status = {},
                window_status = {},
                tyres = {
                    burst_state = {},
                    burst_completely = {},
                }
            }

            for i = 0, num_wheels - 1 do
                maintenance.tyres.burst_state[i] = not not IsVehicleTyreBurst(vehicle, i, false)
                maintenance.tyres.burst_completely[i] = not not IsVehicleTyreBurst(vehicle, i, true)
            end

            maintenance.tyre_health = tyre_health
            maintenance.window_status = window_status
            maintenance.door_status = door_status

            return modifications, maintenance
        else
            return nil, nil
        end
    end

    --- Retrieves the class of a vehicle as a string.
    --- @param vehicle number: The handle of the vehicle.
    local function get_vehicle_class(vehicle)
        local classes = {
            [0] = 'compacts',
            [1] = 'sedans',
            [2] = 'suvs',
            [3] = 'coupes',
            [4] = 'muscle',
            [5] = 'sports classics',
            [6] = 'sports',
            [7] = 'super',
            [8] = 'motorcycles',
            [9] = 'off-road',
            [10] = 'industrial',
            [11] = 'utility',
            [12] = 'vans',
            [13] = 'cycles',
            [14] = 'boats',
            [15] = 'helicopters',
            [16] = 'planes',
            [17] = 'service',
            [18] = 'emergency',
            [19] = 'military',
            [20] = 'commercial',
            [21] = 'trains',
        }

        local class_id = GetVehicleClass(vehicle)

        return classes[class_id] or 'Unknown'
    end

    --- Retrieves detailed information about a vehicle's class.
    --- @param vehicle number: The handle of the vehicle.
    local function get_vehicle_class_details(vehicle)
        if not vehicle then return nil end
        local class_id = GetVehicleClass(vehicle)
        local class_details = {
            class_id = class_id,
            class_name = get_vehicle_class(vehicle), -- using the function we defined earlier
            estimated_max_speed = GetVehicleClassEstimatedMaxSpeed(class_id),
            max_acceleration = GetVehicleClassMaxAcceleration(class_id),
            max_agility = GetVehicleClassMaxAgility(class_id),
            max_braking = GetVehicleClassMaxBraking(class_id),
            max_traction = GetVehicleClassMaxTraction(class_id)
        }
        return class_details
    end

    --- Retrieves detailed information about a vehicle.
    --- @param use_current_vehicle boolean: Specifies whether to use the vehicle the player is currently in.
    local function get_vehicle_details(use_current_vehicle)
        local player = PlayerPedId()
        local player_coords = GetEntityCoords(player)
        local vehicle_data = {}
        local vehicle
        if use_current_vehicle and IsPedInAnyVehicle(player, false) then
            vehicle = GetVehiclePedIsIn(player, false)
        else
            vehicle, vehicle_data.distance = ENTITIES.get_closest_vehicle(player_coords, 10.0, false)
            vehicle_data.distance = #(player_coords - GetEntityCoords(vehicle))
        end
        if not vehicle then
            return nil
        end
        vehicle_data.vehicle = vehicle
        vehicle_data.plate = get_vehicle_plate(vehicle)
        vehicle_data.model = get_vehicle_model(vehicle)
        vehicle_data.class = get_vehicle_class(vehicle)
        vehicle_data.mods, vehicle_data.maintenance = get_vehicle_mods_and_maintenance(vehicle)
        local rear_engine_vehicles = {
            'comet', 'infernusclassic', '811', 're7b', '9f', '9fcabrio', 
            'osiris', 'tyrus', 'adder', 'stinger', 'reaper', 'spacedocker', 
            'cometsafari', 'krieger', 'f19', 'injection', 'tropos'
        }
        vehicle_data.is_rear_engine = false
        for _, model in ipairs(rear_engine_vehicles) do
            if string.lower(vehicle_data.model) == model then
                vehicle_data.is_rear_engine = true
                break
            end
        end
        return vehicle_data
    end

    --- Spawns a vehicle with specified properties and modifications.
    --- @param vehicle_data table: Data specifying the properties and modifications for the vehicle.
    --- @example
    --[[
    local spawn_vehicle_data = {
        model = 'adder', -- Vehicle model name
        coords = vector4(0.0, 0.0, 0.0, 0.0), -- Coordinates and heading for spawn
        is_network = false, -- Whether the vehicle is networked
        net_mission_entity = false, -- Whether the vehicle is a mission entity
        -- Optional data
        -- set_into_vehicle = true, -- Whether to set the player into a vehicle or not
        -- custom_plate = 'TEST VEH', -- Custom vehicle plate set if specified
        -- lock_doors = true, -- Whether vehicle doors should be locked or not
        -- invincible = false, -- Whether the vehicle should be invincible or not
        -- damages = { -- Remove to not apply any damages
            -- doors = { -- Remove this section to not damage any doors
                -- ids = {0, 1} -- IDs of doors to break
                -- all = true -- Uncomment to break all doors
                -- random = true -- Uncomment to randomly break some doors
            -- },
            -- windows = true, -- Set to true to break all windows // SmashVehicleWindow seems to just smash every window on spawn so this is just a boolean toggle
            -- tyres = { -- Remove this section to not damage any tyres
                -- ids = {0, 1}, -- IDs of tyres to burst
                -- burst_completely = true -- Set to true to completely burst the tyres
                -- all = true -- Uncomment to burst all tyres
                -- random = true -- Uncomment to randomly burst some tyres
            -- }
        -- },
        -- maintenance = { -- Remove to apply default maintenance
            -- fuel = 100.0, -- Set the fuel level of the vehicle (range from 0.0 to 100.0). Remove to use default value.
            -- oil = 1000.0, -- Set the oil level of the vehicle. Higher values represent better condition. Remove for default.
            -- engine = 1000.0, -- Set the engine health of the vehicle (range from -4000.0 to 1000.0). Remove to use default value.
            -- body = 1000.0, -- Set the body health of the vehicle (range from 0.0 to 1000.0). Remove for default condition.
            -- clutch = 1000.0, -- Set the clutch health of the vehicle. Higher values represent better condition. Remove for default.
            -- petrol_tank = 1000.0, -- Set the petrol tank health of the vehicle. Higher values are better. Remove for default.
            -- dirt = 0.0, -- Set the dirt level on the vehicle (range from 0.0 for clean to 15.0 for very dirty). Remove for default.
        -- },
        -- mods = { -- Remove to spawn default vehicle
            -- random = false, -- Set to true to apply random mods
            -- max_performance = true -- Set to true to apply max performance mods
            -- ids = { [15] = 2, [16] = 4 }, -- Specific mods to apply
            -- custom_paint = { -- Remove to apply default paint
                -- primary = { r = 255, g = 0, b = 0 }, -- Primary colour rgb
                -- secondary = { r = 0, g = 255, b = 0 }  -- Secondary colour rgb
            -- },
            -- neon_lights = { -- Remove to not apply neons
                -- colour = { r = 255, g = 255, b = 255 } -- Custom neon colour
            -- },
            -- xenon_lights = { -- Remove to not apply xenons
                -- colour = 2 -- Xenon light colour index
            -- },
            -- bulletproof_tyres = true, -- Wether vehicle has bullet proof tyres or not
            -- engine_audio = 'ADDER', -- Custom engine sound for vehicle
            -- top_speed = 156, -- Set top speed of vehicle
            -- livery = 2, -- Set a livery if available
            -- plate_style = 3, -- Set the plate style for the vehicle
            -- window_tint = 3, -- Set the vehicles window tint
            -- handling_tweaks = { -- Remove to apply default handling
                -- ['fSuspensionHeight'] = -1.0, -- Lower the vehicle closer to the ground
                -- ['fBrakeForce'] = 1.5, -- Increase brake force
                -- ['fTractionCurveMax'] = 2.5, -- Improve maximal traction
                -- ['fTractionCurveMin'] = 1.5, -- Improve minimal traction
                -- ['fTractionCurveLateral'] = 2.0, -- Improve lateral traction
                -- ['fInitialDriveForce'] = 2.0, -- Increase acceleration
                -- ['fDriveBiasFront'] = 0.5, -- Distribute power evenly between front and back
            -- },
        -- }
    }
    ]]
    local function spawn_vehicle(vehicle_data)
        local model = vehicle_data.model
        local coords = vehicle_data.coords
        local is_network = vehicle_data.is_network
        local net_mission_entity = vehicle_data.net_mission_entity
        local hash = GetHashKey(model)
        REQUESTS.model(hash)
        local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, coords.w, is_network, net_mission_entity)
        if vehicle_data.custom_plate then
            SetVehicleNumberPlateText(vehicle, vehicle_data.custom_plate)
        end
        if vehicle_data.damages then
            if damages.doors then
                for _, doorId in ipairs(damages.doors.ids) do
                    SetVehicleDoorBroken(vehicle, doorId, true)
                end
            end
            if damages.windows then
                for i = 0, 7 do
                    SmashVehicleWindow(vehicle, i)
                end
            end
            if damages.tyres then
                for _, tyreId in ipairs(damages.tyres.ids) do
                    SetVehicleTyreBurst(vehicle, tyreId, damages.tyres.burst_completely, 1000)
                end
            end
        end
        if vehicle_data.maintenance then
            local m = vehicle_data.maintenance
            SetVehicleFuelLevel(vehicle, m.fuel or 100.0)
            SetVehicleOilLevel(vehicle, m.oil or 1000.0)
            SetVehicleEngineHealth(vehicle, m.engine or 1000.0)
            SetVehicleBodyHealth(vehicle, m.body or 1000.0)
            SetVehiclePetrolTankHealth(vehicle, m.petrol_tank or 1000.0)
            SetVehicleDirtLevel(vehicle, m.dirt or 0.0)
        end
        if vehicle_data.mods then
            if vehicle_data.mods.random then
                for mod_type = 0, 49 do
                    local max = GetNumVehicleMods(vehicle, mod_type)
                    SetVehicleMod(vehicle, mod_type, math.random(0, max - 1), false)
                end
            end
            if vehicle_data.mods.max_performance then
                for mod_type = 0, 49 do
                    local max = GetNumVehicleMods(vehicle, mod_type)
                    SetVehicleMod(vehicle, mod_type, max - 1, false)
                end
            end
            if vehicle_data.mods.ids then
                for mod_type, modIndex in pairs(mods.ids) do
                    SetVehicleMod(vehicle, mod_type, modIndex, false)
                end
            end
            if vehicle_data.mods.custom_paint then
                local cp = vehicle_data.mods.custom_paint
                if cp.primary then
                    SetVehicleCustomPrimaryColour(vehicle, cp.primary.r, cp.primary.g, cp.primary.b)
                end
                if cp.secondary then
                    SetVehicleCustomSecondaryColour(vehicle, cp.secondary.r, cp.secondary.g, cp.secondary.b)
                end
            end
            if vehicle_data.mods.neon_lights then
                for i = 0, 3 do
                    SetVehicleNeonLightEnabled(vehicle, i, true)
                end
                SetVehicleNeonLightsColour(vehicle, vehicle_data.mods.neon_lights.colour.r, vehicle_data.mods.neon_lights.colour.g, vehicle_data.mods.neon_lights.colour.b)
            end
            if vehicle_data.mods.xenon_lights then
                ToggleVehicleMod(vehicle, 22, true)
                if vehicle_data.mods.xenon_lights.colour then
                    SetVehicleHeadlightsColour(vehicle, vehicle_data.mods.xenon_lights.colour)
                end
            end
            if vehicle_data.mods.bulletproof_tyres then
                SetVehicleTyresCanBurst(vehicle, false)
            end
            if vehicle_data.mods.engine_audio then
                ForceVehicleEngineAudio(vehicle, vehicle_data.mods.engine_audio)
            end
            if vehicle_data.mods.livery then
                SetVehicleLivery(vehicle, vehicle_data.mods.livery)
            end
            if vehicle_data.mods.plate_style then
                SetVehicleNumberPlateTextIndex(vehicle, vehicle_data.mods.plate_style)
            end
            if vehicle_data.mods.window_tint then
                SetVehicleWindowTint(vehicle, vehicle_data.mods.window_tint)
            end
            if vehicle_data.mods.top_speed then
                SetVehicleEnginePowerMultiplier(vehicle, vehicle_data.mods.top_speed)
            end
            if vehicle_data.mods.handling_tweaks then
                for property, value in pairs(vehicle_data.mods.handling_tweaks) do
                    SetVehicleHandlingFloat(vehicle, 'CHandlingData', property, value)
                end
            end
        end
        if vehicle_data.lock_doors then
            SetVehicleDoorsLocked(vehicle, 2)
        end
        if vehicle_data.invincible then
            SetEntityInvincible(vehicle, true)
        end
        PlaceObjectOnGroundProperly(vehicle)
        if vehicle_data.set_into_vehicle then
            local playerPed = PlayerPedId()
            SetPedIntoVehicle(playerPed, vehicle, -1)
        end
        return vehicle
    end

    --- @section Function Assignments

    vehicles.get_vehicle_plate = get_vehicle_plate
    vehicles.get_vehicle_model = get_vehicle_model
    vehicles.get_doors_broken = get_doors_broken
    vehicles.get_windows_broken = get_windows_broken
    vehicles.get_tyre_burst = get_tyre_burst
    vehicles.get_vehicle_extras = get_vehicle_extras
    vehicles.get_custom_xenon_color = get_custom_xenon_color
    vehicles.get_vehicle_mod = get_vehicle_mod
    vehicles.get_vehicle_properties = get_vehicle_properties
    vehicles.get_vehicle_mods_and_maintenance = get_vehicle_mods_and_maintenance
    vehicles.get_vehicle_class = get_vehicle_class
    vehicles.get_vehicle_class_details = get_vehicle_class_details
    vehicles.get_vehicle_details = get_vehicle_details
    vehicles.spawn_vehicle = spawn_vehicle

    --- @section Exports

    exports('get_vehicle_plate', get_vehicle_plate)
    exports('get_vehicle_model', get_vehicle_model)
    exports('get_doors_broken', get_doors_broken)
    exports('get_windows_broken', get_windows_broken)
    exports('get_tyre_burst', get_tyre_burst)
    exports('get_vehicle_extras', get_vehicle_extras)
    exports('get_custom_xenon_color', get_custom_xenon_color)
    exports('get_vehicle_mod', get_vehicle_mod)
    exports('get_vehicle_properties', get_vehicle_properties)
    exports('get_vehicle_mods_and_maintenance', get_vehicle_mods_and_maintenance)
    exports('get_vehicle_class', get_vehicle_class)
    exports('get_vehicle_class_details', get_vehicle_class_details)
    exports('get_vehicle_details', get_vehicle_details)    
    exports('spawn_vehicle', spawn_vehicle)

end

return vehicles
