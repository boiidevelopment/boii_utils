----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    PED UTILITIES
]]

local created_peds = {}

-- Function to give a weapon to a ped with optional configurations.
-- Usage: 
-- utils.peds.give_weapon(ped, 'WEAPON_PISTOL', 100, true, false, 100.0, true)
local function give_weapon(ped, weapon_name, ammo, equip_now, is_hidden, accuracy, invincible)
    if ped and weapon_name then
        local weapon_hash = GetHashKey(weapon_name)
        GiveWeaponToPed(ped, weapon_hash, ammo or 0, is_hidden or false, equip_now or false)
        if accuracy then
            SetPedAccuracy(ped, math.floor(accuracy))
        end
        if invincible then
            SetEntityInvincible(ped, true)
        end
    end
end

-- Extended create_ped function
-- Usage: utils.peds.create_ped(ped_data)
local function create_ped(data)
    local base_data = data.base_data or {}
    utils.requests.model(GetHashKey(base_data.model))
    local ped = CreatePed(4, GetHashKey(base_data.model), base_data.coords.x, base_data.coords.y, base_data.coords.z - 1, base_data.coords.w, base_data.networked or false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    if data.animation_data then
        utils.requests.anim(animation_data.dict)
        TaskPlayAnim(
            ped, 
            data.animation_data.dict, 
            data.animation_data.anim, 
            data.animation_data.blend_in or 8.0, 
            data.animation_data.blend_out or -8.0, 
            data.animation_data.duration or -1, 
            data.animation_data.flag or 0, 
            data.animation_data.playback_rate or 1.0,
            false, 
            false, 
            false
        )
    elseif base_data.scenario then
        TaskStartScenarioInPlace(ped, base_data.scenario, 0, true)
    end
    local weapon_data = data.weapon_data or {}
    if weapon_data.weapon_name then
        give_weapon(ped, weapon_data.weapon_name, weapon_data.ammo, weapon_data.equip_now, weapon_data.is_hidden, weapon_data.accuracy, weapon_data.invincible)
    end
    created_peds[#created_peds + 1] = { ped = ped, category = base_data.category }
    return ped
end

-- Creates multiple peds from a data table.
-- Usage: utils.peds.create_peds(peds)
local function create_peds(ped_config)
    for _, ped_data in ipairs(ped_config) do
        create_ped(ped_data)
    end
end

-- Removes a single ped and also removes it from the created_peds table.
-- Usage: utils.peds.remove_ped(ped)
local function remove_ped(ped)
    DeletePed(ped)
    for i = #created_peds, 1, -1 do
        if created_peds[i].ped == ped then
            table.remove(created_peds, i)
            break
        end
    end
end

-- Removes all created peds.
-- Usage: utils.peds.remove_all_peds()
local function remove_all_peds()
    for _, ped_data in ipairs(created_peds) do
        remove_ped(ped_data.ped)
    end
    created_peds = {}
end

-- Removes peds based on their category.
-- Usage: utils.peds.remove_peds_by_categories({'workers', 'guards'})
local function remove_peds_by_categories(categories)
    for i = #created_peds, 1, -1 do
        local ped_data = created_peds[i]
        for _, category in ipairs(categories) do
            if ped_data.category == category then
                remove_ped(ped_data.ped)
                table.remove(created_peds, i)
                break
            end
        end
    end
end

--[[
    ASSIGN LOCALS
]]

utils.peds = utils.peds or {}

utils.peds.create_ped = create_ped
utils.peds.create_peds = create_peds
utils.peds.remove_ped = remove_ped
utils.peds.remove_all_peds = remove_all_peds
utils.peds.remove_peds_by_categories = remove_peds_by_categories