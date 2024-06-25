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

--- Player functions.
--- @script client/scripts/player.lua

--- @section Local functions

--- Gets a player's cardinal direction based on their current heading.
--- @function get_cardinal_direction
--- @param player number: The player entity.
--- @return string: The cardinal direction the player is facing.
--- @usage local direction = utils.player.get_cardinal_direction('target player')
local function get_cardinal_direction(player)
    local heading = GetEntityHeading(player)
    local directions = {
        'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'
    }
    local index = math.floor(((heading + 22.5) % 360) / 45) + 1
    return directions[index]
end

exports('player_get_cardinal_direction', get_cardinal_direction)
utils.player.get_cardinal_direction = get_cardinal_direction

--- Retrieves the street name and area where a player is currently located.
--- @function get_street_name
--- @param player number: The player entity.
--- @return string: The street and area name the player is on.
--- @usage local street = utils.player.get_street_name(player)
local function get_street_name(player)
    local player_coords = GetEntityCoords(player)
    local street_hash, _ = GetStreetNameAtCoord(player_coords.x, player_coords.y, player_coords.z)
    local street_name = GetStreetNameFromHashKey(street_hash)
    local area_name = GetLabelText(GetNameOfZone(player_coords.x, player_coords.y, player_coords.z))
    if street_name and area_name then
        return street_name .. ', ' .. area_name
    elseif street_name then
        return street_name
    elseif area_name then
        return area_name
    else
        return 'Unknown'
    end
end

exports('player_get_street_name', get_street_name)
utils.player.get_street_name = get_street_name

--- Retrieves the name of the region a player is currently in.
--- @function get_region
--- @param player number: The player entity.
--- @return string: The region name the player is in.
--- @usage local region = utils.player.get_region(player)
local function get_region(player)
    local player_coords = GetEntityCoords(player)
    return GetNameOfZone(player_coords.x, player_coords.y, player_coords.z)
end

exports('player_get_region', get_region)
utils.player.get_region = get_region

--- Retrieves detailed information about a player.
--- @function get_player_details
--- @param player number: The player entity.
--- @return table: A table containing detailed information about the player.
--- @usage local player_details = utils.player.get_player_details(player)
local function get_player_details(player)
    local data = {}
    data.server_id = GetPlayerServerId(player)
    data.name = GetPlayerName(player)
    data.max_stamina = GetPlayerMaxStamina(player)
    data.stamina = GetPlayerStamina(player)
    data.health = GetEntityHealth(player)
    data.armor = GetPedArmour(player)
    data.melee_damage_modifier = GetPlayerMeleeWeaponDamageModifier(player)
    data.melee_defense_modifier = GetPlayerMeleeWeaponDefenseModifier(player)
    data.vehicle_damage_modifier = GetPlayerVehicleDamageModifier(player)
    data.vehicle_defense_modifier = GetPlayerVehicleDefenseModifier(player)
    data.weapon_damage_modifier = GetPlayerWeaponDamageModifier(player)
    data.weapon_defense_modifier = GetPlayerWeaponDefenseModifier(player)
    local player_coords = GetEntityCoords(player)
    data.coords = vector4(player_coords.x, player_coords.y, player_coords.z, GetEntityHeading(player))
    data.model_hash = GetEntityModel(player)
    return data
end

exports('player_get_player_details', get_player_details)
utils.player.get_player_details = get_player_details

--- Retrieves the entity a player is targeting (if they are aiming at one).
--- @function get_target_entity
--- @param player number: The player entity.
--- @return number: The entity that the player is targeting.
--- @usage local target_entity = utils.player.get_target_entity(player)
local function get_target_entity(player)
    local entity = 0
    if IsPlayerFreeAiming(player) then
        local success, target = GetEntityPlayerIsFreeAimingAt(player)
        if success then
            entity = target
        end
    end
    return entity
end

exports('player_get_target_entity', get_target_entity)
utils.player.get_target_entity = get_target_entity

--- Retrieves the current weapon held by a player.
--- @function get_current_weapon
--- @param player number: The player entity.
--- @return number: The hash of the current weapon held by the player, nil if none.
--- @usage local weapon = utils.player.get_current_weapon(player)
local function get_current_weapon(player)
    local has_weapon, current_weapon = GetCurrentPedWeapon(player, true)
    if has_weapon then
        return current_weapon
    else
        return nil
    end
end

exports('player_get_current_weapon', get_current_weapon)
utils.player.get_current_weapon = get_current_weapon

--- Calculates the distance between a player and an entity.
--- @function get_distance_to_entity
--- @param player number: The player entity.
--- @param entity number: The target entity.
--- @return number: The distance between the player and the entity.
--- @usage local distance = utils.player.get_distance_to_entity(player, entity)
local function get_distance_to_entity(player, entity)
    local player_coords = GetEntityCoords(player)
    local entity_coords = GetEntityCoords(entity)
    return #(player_coords - entity_coords)
end

exports('player_get_distance_to_entity', get_distance_to_entity)
utils.player.get_distance_to_entity = get_distance_to_entity

--- Runs animation on the player with params.
--- @function play_animation
--- @param player number: The player entity.
--- @param options table: Table of options to run when playing.
--- @param callback function: Callback function to run when animation has finished.
--- @usage 
--[[
    local player_ped = PlayerPedId()
    utils.player.play_animation(player_ped, {
        dict = 'missheistdockssetup1clipboard@base',
        anim = 'base',
        flags = 49,
        duration = 5000,
        freeze = true,
        continuous = true, -- Set to true for continuous animation
        prop = {
            model = 'prop_tool_broom',
            bone = 57005,
            offset = {x = 0.1, y = 0.0, z = -0.01},
            rotation = {x = 90.0, y = 0.0, z = 90.0}
        }
    }, function()
        print('animation finished')
    end)
]]
local function play_animation(player, options, callback)
    if not player then
        print('player ped is missing')
        return
    end
    if not options or not options.dict or not options.anim then 
        print('Options or animation dictionary/animation name is missing')
        return
    end
    utils.requests.anim(options.dict)
    if options.freeze then
        FreezeEntityPosition(player, true)
    end
    local duration = options.duration or 2000
    local prop
    if options.prop then
        utils.requests.model(options.prop.model)
        prop = CreateObject(GetHashKey(options.prop.model), GetEntityCoords(player), true, true, true)
        AttachEntityToEntity(prop, player, GetPedBoneIndex(player, options.prop.bone), options.prop.coords.x, options.prop.coords.y, options.prop.coords.z, options.prop.rotation.x, options.prop.rotation.y, options.prop.rotation.z, true, true, false, true, 1, true)
    end
    if options.continuous then
        TaskPlayAnim(player, options.dict, options.anim, options.blend_in or 8.0, options.blend_out or -8.0, -1, options.flags or 49, options.playback or 0, options.lock_x or 0, options.lock_y or 0, options.lock_z or 0)
    else
        TaskPlayAnim(player, options.dict, options.anim, options.blend_in or 8.0, options.blend_out or -8.0, duration, options.flags or 49, options.playback or 0, options.lock_x or 0, options.lock_y or 0, options.lock_z or 0)
        Wait(duration)
        ClearPedTasks(player)
        if options.freeze then
            FreezeEntityPosition(player, false)
        end
        if prop then
            DeleteObject(prop)
        end
        if callback then
            callback()
        end
    end
end

exports('player_play_animation', play_animation)
utils.player.play_animation = play_animation

--- Checks if the player is in water.
--- @function is_player_in_water
--- @param player number: The player entity.
--- @return boolean: True if the player is in water, false otherwise.
--- @usage local in_water = utils.player.is_player_in_water(player)
local function is_player_in_water(player)
    return IsEntityInWater(player)
end

exports('player_is_player_in_water', is_player_in_water)
utils.player.is_player_in_water = is_player_in_water

--- Retrieves the player's height from the nearest water surface.
--- @function get_player_height_from_water
--- @param player number: The player entity.
--- @return number: The height from the water surface. Returns nil if the player is not near water.
--- @usage local height_from_water = utils.player.get_player_height_from_water(player)
local function get_player_height_from_water(player)
    local player_coords = GetEntityCoords(player)
    local water_height = GetWaterHeight(player_coords.x, player_coords.y, player_coords.z)
    if water_height then
        return player_coords.z - water_height
    else
        return nil
    end
end

exports('player_get_player_height_from_water', get_player_height_from_water)
utils.player.get_player_height_from_water = get_player_height_from_water

--- Checks if the player is near water.
--- @function is_player_near_water
--- @param player number: The player entity.
--- @param radius number: The radius to check for water around the player.
--- @return boolean: True if the player is near water, false otherwise.
--- @usage local near_water = utils.player.is_player_near_water(player, 5.0)
local function is_player_near_water(player, radius)
    local player_coords = GetEntityCoords(player)
    return TestProbeAgainstWater(player_coords.x, player_coords.y, player_coords.z, player_coords.x, player_coords.y, player_coords.z - radius)
end

exports('player_is_player_near_water', is_player_near_water)
utils.player.is_player_near_water = is_player_near_water
