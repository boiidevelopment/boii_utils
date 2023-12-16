----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

-- Locals
local key_list = {}

--[[
    FUNCTIONS
]]

-- Function to get key list
local function get_key_list()
    utils.callback.cb('boii_utils:sv:get_all_vehicle_keys', {}, function(keys_list)
        key_list = keys_list
    end)
end

-- Function to check if player has keys to vehicle
local function has_vehicle_keys(plate)
    local vehicle_data = key_list[plate]
    if vehicle_data then
        return vehicle_data.has_key, vehicle_data.locked
    else
        return nil, nil
    end
end

-- Function to check vehicle access
local function check_vehicle_access()
    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            if DoesEntityExist(ped) and not IsEntityDead(ped) then
                local vehicle = GetVehiclePedIsTryingToEnter(ped)
                if vehicle and vehicle ~= 0 then
                    local plate = GetVehicleNumberPlateText(vehicle)
                    local has_key, locked = has_vehicle_keys(plate)
                    if locked ~= nil then
                        if tonumber(locked) == 1 then
                            SetVehicleDoorsLocked(vehicle, 1)
                        elseif tonumber(locked) == 2 then
                            SetVehicleDoorsLocked(vehicle, 2)
                        end
                    end                    
                end
            end
            Wait(100)
        end
    end)
end

local function toggle_vehicle_lock()
    local vehicle_data
    if IsPedInAnyVehicle(PlayerPedId()) then
        vehicle_data = utils.vehicles.get_vehicle_details(true) 
    else
        vehicle_data = utils.vehicles.get_vehicle_details(false) 
    end
    if vehicle_data.vehicle and vehicle_data.vehicle ~= 0 then
        if has_vehicle_keys(vehicle_data.plate) then
            if distance <= 5.0 then  -- Adjust the distance as per your requirement
                local lock_state = GetVehicleDoorLockStatus(vehicle_data.vehicle)
                utils.requests.anim("anim@mp_player_intmenu@key_fob@")
                TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, -8, -1, 48, 0, 0, 0, 0)
                if lock_state == 1 then
                    PlaySoundFrontend(-1, "BUTTON", "MP_PROPERTIES_ELEVATOR_DOORS", 1)
                    SetVehicleDoorsLocked(vehicle_data.vehicle, 2)
                    SetVehicleIndicatorLights(vehicle_data.vehicle, 0, true)
                    SetVehicleIndicatorLights(vehicle_data.vehicle, 1, true)
                    Wait(400)
                    SetVehicleIndicatorLights(vehicle_data.vehicle, 0, false)
                    SetVehicleIndicatorLights(vehicle_data.vehicle, 1, false)
                    key_list[vehicle_data.plate].locked = 2
                    print('locked vehicle_data.vehicle')
                    TriggerServerEvent('boii_utils:sv:update_vehicle_lock_state', NetworkGetNetworkIdFromEntity(vehicle_data.vehicle), vehicle_data.plate, 2)
                elseif lock_state == 2 then
                    PlaySoundFrontend(-1, "BUTTON", "MP_PROPERTIES_ELEVATOR_DOORS", 1)
                    SetVehicleDoorsLocked(vehicle_data.vehicle, 1)
                    SetVehicleIndicatorLights(vehicle_data.vehicle, 0, true)
                    SetVehicleIndicatorLights(vehicle_data.vehicle, 1, true)
                    Wait(400)
                    SetVehicleIndicatorLights(vehicle_data.vehicle, 0, false)
                    SetVehicleIndicatorLights(vehicle_data.vehicle, 1, false)
                    key_list[vehicle_data.plate].locked = 1
                    print('unlocked vehicle_data.vehicle')
                    TriggerServerEvent('boii_utils:sv:update_vehicle_lock_state', NetworkGetNetworkIdFromEntity(vehicle_data.vehicle), vehicle_data.plate, 1)
                end
            else
                print('out of range')
            end
        end
    end
end

--[[ 
    EVENTS 
]]

RegisterNetEvent('boii_utils:cl:update_vehicle_lock_state', function(plate, state)
    if key_list[plate] then
        key_list[plate].locked = tonumber(state)
    end
end)

RegisterNetEvent('boii_utils:cl:give_key_to_player', function(target_player)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local plate = GetVehicleNumberPlateText(vehicle)
    if not target_player then
        local receivers = {}
        local max_seats = GetVehicleMaxNumberOfPassengers(vehicle)
        for seat = -1, max_seats - 1 do
            local player_in_seat = GetPedInVehicleSeat(vehicle, seat)
            if player_in_seat and player_in_seat ~= 0 and player_in_seat ~= ped then
                local player_id = NetworkGetPlayerIndexFromPed(player_in_seat)
                if player_id and player_id >= 0 then
                    receivers[#receivers + 1] = GetPlayerServerId(player_id)
                end
            end
        end
        if #receivers > 0 then
            TriggerServerEvent('boii_utils:sv:give_key_to_player', receivers, plate)
        else
            print('vehicle is empty')
        end
    else
        TriggerServerEvent('boii_utils:sv:give_key_to_player', {target_player}, plate)
    end
end)

RegisterKeyMapping('toggle_vehicle_lock', 'Toggle Vehicle Lock', 'keyboard', 'L')
RegisterCommand('toggle_vehicle_lock', function()
    print('toggle lock')
    toggle_vehicle_lock()
end, false)

-- Function to initialize keys
local function init_keys()
    CreateThread(function()
        while true do
            local p_data = utils.fw.get_data()
            if p_data then
                get_key_list()
                check_vehicle_access()
                break
            end
            Wait(500)
        end
    end)
end
init_keys()