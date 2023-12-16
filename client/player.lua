----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    PLAYER UTILITIES
]]

-- Function to get a player's cardinal direction
-- Usage: local direction = utils.player.get_cardinal_direction('target player')
local function get_cardinal_direction(player)
    local heading = GetEntityHeading(player)
    local directions = {
        'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'
    }
    local index = math.floor(((heading + 22.5) % 360) / 45) + 1
    return directions[index]
end

-- Function to get the street a player is on
-- Usage: local street = utils.player.get_street_name(player)
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

-- Function to retrieve the current region name
-- Usage: local region = utils.player.get_region(player)
local function get_region(player)
    local player_coords = GetEntityCoords(player)
    return GetNameOfZone(player_coords.x, player_coords.y, player_coords.z)
end

-- Function to get detailed player data
-- Usage: local player_details = utils.player.get_player_details(player)
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

-- Function to get the player's target entity (if they are aiming at one)
-- Usage: local target_entity = utils.player.get_target_entity(player)
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

-- Function to get the player's current weapon
-- Usage: local weapon = utils.player.get_current_weapon(player)
local function get_current_weapon(player)
    local has_weapon, current_weapon = GetCurrentPedWeapon(player, true)
    if has_weapon then
        return current_weapon
    else
        return nil
    end
end

-- Function to calculate distance between player and an entity
-- Usage: local distance = utils.player.get_distance_to_entity(player, entity)
local function get_distance_to_entity(player, entity)
    local player_coords = GetEntityCoords(player)
    local entity_coords = GetEntityCoords(entity)
    return #(player_coords - entity_coords)
end

--[[
    ASSIGN LOCALS
]]

utils.player = utils.player or {}

utils.player.get_cardinal_direction = get_cardinal_direction
utils.player.get_street_name = get_street_name
utils.player.get_region = get_region
utils.player.get_player_details = get_player_details
utils.player.get_target_entity = get_target_entity
utils.player.get_current_weapon = get_current_weapon
utils.player.get_distance_to_entity = get_distance_to_entity