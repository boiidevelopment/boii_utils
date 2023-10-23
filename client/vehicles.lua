-- Extracts the vehicle plate number.
-- Usage: local plate = utils.vehicles.get_vehicle_plate(vehicle)
local function get_vehicle_plate(vehicle)
    if vehicle == 0 then return end
    return utils.strings.trim(GetVehicleNumberPlateText(vehicle))
end

-- Retrieves the model name of the vehicle the player is in.
-- Usage: local model_name = utils.vehicles.get_vehicle_model(vehicle)
local function get_vehicle_model(vehicle)
    local hash = GetEntityModel(vehicle)
    local name = GetDisplayNameFromVehicleModel(hash)
    return string.lower(name)
end

-- Retrieves a list of broken doors of a vehicle.
-- Usage: local doors_broken = utils.vehicles.get_doors_broken(vehicle)
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

-- Retrieves a list of broken windows of a vehicle.
-- Usage: local windows_broken = utils.vehicles.get_windows_broken(vehicle)
local function get_windows_broken(vehicle)
    local windows_broken = {}
    for window_id = 0, 13 do
        windows_broken[tostring(window_id)] = not IsVehicleWindowIntact(vehicle, window_id)
    end
    return windows_broken
end

-- Retrieves a list of burst tyres of a vehicle.
-- Usage: local tyre_burst = utils.vehicles.get_tyre_burst(vehicle)
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

-- Retrieves the extras enabled on a vehicle.
-- Usage: local extras = utils.vehicles.get_vehicle_extras(vehicle)
local function get_vehicle_extras(vehicle)
    local extras = {}
    for extra_id = 0, 20 do
        if DoesExtraExist(vehicle, extra_id) then
            extras[tostring(extra_id)] = IsVehicleExtraTurnedOn(vehicle, extra_id)
        end
    end
    return extras
end

-- Retrieves the custom xenon color of a vehicle if available.
-- Usage: local xenon_color = utils.vehicles.get_custom_xenon_color(vehicle)
local function get_custom_xenon_color(vehicle)
    local has_custom_xenon_color, r, g, b = GetVehicleXenonLightsCustomColor(vehicle)
    if has_custom_xenon_color then
        return {r, g, b}
    else
        return nil
    end
end

-- Retrieves the modification of a specified type for a vehicle.
-- Usage: local mod = utils.vehicles.get_vehicle_mod(vehicle, mod_type)
local function get_vehicle_mod(vehicle, mod_type)
    return {
        index = GetVehicleMod(vehicle, mod_type),
        variation = GetVehicleModVariation(vehicle, mod_type)
    }
end

-- Retrieves various properties of a vehicle.
-- Usage: local properties = utils.vehicles.get_vehicle_properties(vehicle)
local function get_vehicle_properties(vehicle)
    if not DoesEntityExist(vehicle) then
        return
    end
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
        body_health = utils.maths.round_number(GetVehicleBodyHealth(vehicle), 1),
        engine_health = utils.maths.round_number(GetVehicleEngineHealth(vehicle), 1),
        tank_health = utils.maths.round_number(GetVehiclePetrolTankHealth(vehicle), 1),
        fuel_level = utils.maths.round_number(GetVehicleFuelLevel(vehicle), 1),
        dirt_level = utils.maths.round_number(GetVehicleDirtLevel(vehicle), 1),
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

-- Retrieves mods and maintenance data of a vehicle.
-- Usage: local mods, maintenance = utils.vehicles.get_vehicle_mods_and_maintenance(vehicle)
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

-- Retrieves the class of a vehicle as a string.
-- Usage: local class = utils.vehicles.get_vehicle_class(vehicle)
local function get_vehicle_class(vehicle)
    local classes = {
        [0] = "Compacts",
        [1] = "Sedans",
        [2] = "SUVs",
        [3] = "Coupes",
        [4] = "Muscle",
        [5] = "Sports Classics",
        [6] = "Sports",
        [7] = "Super",
        [8] = "Motorcycles",
        [9] = "Off-road",
        [10] = "Industrial",
        [11] = "Utility",
        [12] = "Vans",
        [13] = "Cycles",
        [14] = "Boats",
        [15] = "Helicopters",
        [16] = "Planes",
        [17] = "Service",
        [18] = "Emergency",
        [19] = "Military",
        [20] = "Commercial",
        [21] = "Trains",
    }
    local class_id = GetVehicleClass(vehicle)
    return classes[class_id] or "Unknown"
end

-- Retrieves detailed information about a vehicle's class.
-- Usage: local class_details = utils.vehicles.get_vehicle_class_details(vehicle)
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


-- Function to get detailed information about a vehicle.
-- Usage: 
-- local vehicle_data = utils.vehicles.get_vehicle_details(true) -- For the vehicle player is in
-- local vehicle_data = utils.vehicles.get_vehicle_details(false) -- For the closest vehicle to the player
local function get_vehicle_details(use_current_vehicle)
    local player = PlayerPedId()
    local player_coords = GetEntityCoords(player)
    local vehicle_data = {}
    local vehicle
    if use_current_vehicle and IsPedInAnyVehicle(player, false) then
        vehicle = GetVehiclePedIsIn(player, false)
    else
        vehicle, vehicle_data.distance = utils.entities.get_closest_vehicle(player_coords, 10.0, false)
    end
    if not vehicle then
        return nil
    end
    vehicle_data.vehicle = vehicle
    vehicle_data.plate = get_vehicle_plate(vehicle)
    vehicle_data.model = get_vehicle_model(vehicle)
    vehicle_data.category = get_vehicle_class(vehicle)
    vehicle_data.mods, vehicle_data.maintenance = get_vehicle_mods_and_maintenance(vehicle)
    return vehicle_data
end

--[[
    ASSIGN LOCALS
]]

utils.vehicles = utils.vehicles or {}

utils.vehicles.get_vehicle_plate = get_vehicle_plate
utils.vehicles.get_vehicle_model = get_vehicle_model
utils.vehicles.get_doors_broken = get_doors_broken
utils.vehicles.get_windows_broken = get_windows_broken
utils.vehicles.get_tyre_burst = get_tyre_burst
utils.vehicles.get_vehicle_extras = get_vehicle_extras
utils.vehicles.get_custom_xenon_color = get_custom_xenon_color
utils.vehicles.get_vehicle_mod = get_vehicle_mod
utils.vehicles.get_vehicle_properties = get_vehicle_properties
utils.vehicles.get_vehicle_mods_and_maintenance = get_vehicle_mods_and_maintenance
utils.vehicles.get_vehicle_class = get_vehicle_class
utils.vehicles.get_vehicle_class_details = get_vehicle_class_details
utils.vehicles.get_vehicle_details = get_vehicle_details