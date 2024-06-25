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

--- Blip manager.
--- @script client/scripts/blips.lua

--- @section Constants

--- @field BLIPS_ENABLED: Toggle to track whether a player has blips enabled or not
local BLIPS_ENABLED = true

--- @section Objects

--- @table created_blips: Used to store blips created by scripts 
local created_blips = {}

--- @table category_state: Used to store states of blip categories to show / hide based on category
local category_state = {}

--- Create a single blip and add it to the created_blips table.
--- @function create_blip
--- @param blip_data table: Contains data for the blip creation like coordinates, sprite, color, scale, label, and category.
--- @usage utils.blips.create_blip({ coords = vector3(100.0, 200.0, 30.0), sprite = 1, colour = 1, scale = 1.5, label = 'Blip 1', category = 'shop', show = true })
local function create_blip(blip_data)
    if blip_data.show then
        local blip = AddBlipForCoord(blip_data.coords.x, blip_data.coords.y, blip_data.coords.z)
        SetBlipSprite(blip, blip_data.sprite)
        SetBlipColour(blip, blip_data.colour)
        SetBlipScale(blip, blip_data.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(blip_data.label)
        EndTextCommandSetBlipName(blip)
        created_blips[#created_blips + 1] = {
            blip = blip, 
            category = blip_data.category,
            label = blip_data.label,
            coords = blip_data.coords,
            sprite = blip_data.sprite,
            colour = blip_data.colour,
            scale = blip_data.scale
        }
        category_state[blip_data.category] = true
    end
end

exports('blips_create_blip', create_blip)
utils.blips.create_blip = create_blip

--- Show or hide all blips.
--- @function toggle_all_blips
--- @param visible boolean: Indicates whether to show (true) or hide (false) all blips.
--- @usage utils.blips.toggle_all_blips(true) -- Show all blips
local function toggle_all_blips(visible)
    local id = visible and 2 or 0
    for _, blip_data in ipairs(created_blips) do
        SetBlipDisplay(blip_data.blip, id)
    end
    BLIPS_ENABLED = visible
end

exports('blips_toggle_all_blips', toggle_all_blips)
utils.blips.toggle_all_blips = toggle_all_blips

--- Toggle blips based on their category.
--- @function toggle_blips_by_category
--- @param category string: The category of blips to show or hide.
--- @param state boolean: The new state of the blips in the specified category.
--- @usage utils.blips.toggle_blips_by_category('shop', false) -- Hide blips in the 'shop' category
local function toggle_blips_by_category(category, state)
    for _, blip_data in ipairs(created_blips) do
        if blip_data.category == category then
            SetBlipDisplay(blip_data.blip, state and 3 or 0)
        end
    end
    category_state[category] = state
end

exports('blips_toggle_blips_by_category', toggle_blips_by_category)
utils.blips.toggle_blips_by_category = toggle_blips_by_category

--- Create multiple blips from a data table.
--- @function create_blips
--- @param blip_config table: A table of blip data configurations.
--- @usage utils.blips.create_blips(blip_config) -- blip_config should contain a list of blip data tables
--[[
    local blip_config = {
        { coords = vector3(100.0, 200.0, 30.0), sprite = 1, colour = 1, scale = 1.5, label = 'Blip 1', category = 'shop', show = true },
        -- Add more blips as needed
    }
    utils.blips.create_blips(blip_config)
]]
local function create_blips(blip_config)
    for _, blip_data in pairs(blip_config) do
        create_blip(blip_data)
    end
end

exports('blips_create_blips', create_blips)
utils.blips.create_blips = create_blips

--- Remove a single blip.
--- @function remove_blip
--- @param blip number: The blip to remove.
--- @usage utils.blips.remove_blip(blip)
local function remove_blip(blip)
    RemoveBlip(blip)
end

exports('blips_remove_blip', remove_blip)
utils.blips.remove_blip = remove_blip

--- Remove all created blips.
--- @function remove_all_blips
--- @usage utils.blips.remove_all_blips()
local function remove_all_blips()
    for _, blip_data in ipairs(created_blips) do
        remove_blip(blip_data.blip)
    end
    created_blips = {}
end

exports('blips_remove_all_blips', remove_all_blips)
utils.blips.remove_all_blips = remove_all_blips

--- Remove blips based on their category.
--- @function remove_blips_by_categories
--- @param categories table: A list of categories to remove blips from.
--- @usage utils.blips.remove_blips_by_categories({'shop', 'house'}) -- Remove blips in the 'shop' and 'house' categories
local function remove_blips_by_categories(categories)
    local initialCount = #created_blips
    for i = #created_blips, 1, -1 do
        local blip_data = created_blips[i]
        for _, category in pairs(categories) do
            if blip_data.category == category then
                remove_blip(blip_data.blip)
                table.remove(created_blips, i)
                break
            end
        end
    end
    utils.debug.log(string.format("Removed %d blips. Remaining blips: %d", initialCount - #created_blips, #created_blips))
end

exports('blips_remove_blips_by_categories', remove_blips_by_categories)
utils.blips.remove_blips_by_categories = remove_blips_by_categories

--- Create a blip with customizable alpha and duration, and optional color palette.
--- @function create_blip_alpha
--- @param options table: A table containing the following keys:
--- @field coords vector3: The coordinates where the blip should be created.
--- @field sprite number: The sprite ID for the blip.
--- @field colour number: The initial color ID for the blip.
--- @field scale number: The scale of the blip.
--- @field label string: The label for the blip.
--- @field alpha number: The initial alpha level for the blip.
--- @field duration number: The duration in seconds for the blip to stay before fading.
--- @field colour_palette table: Optional table of color IDs to cycle through.
--- @usage
--[[
    utils.blips.create_blip_alpha({
        coords = vector3(100.0, 200.0, 30.0),
        sprite = 161,
        colour = 1, 
        scale = 1.5, 
        label = 'Example Blip',
        alpha = 250,
        duration = 10,
        colour_palette = {1, 3}
    })
]]
local function create_blip_alpha(options)
    local blip = AddBlipForCoord(options.coords)
    SetBlipSprite(blip, options.sprite)
    SetBlipColour(blip, options.colour)
    SetBlipScale(blip, options.scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(options.label)
    EndTextCommandSetBlipName(blip)
    local alpha = options.alpha
    local duration = options.duration * 1000
    local start_time = GetGameTimer()
    local step_time = 100
    local steps = duration / step_time
    local alpha_decrement = alpha / steps
    local colour_palette = options.colour_palette or {options.colour}
    local current_color_index = 1
    CreateThread(function()
        while alpha > 0 do
            alpha = alpha - alpha_decrement
            if alpha <= 0 then
                RemoveBlip(blip)
                return
            end
            SetBlipAlpha(blip, math.floor(alpha))
            Wait(step_time)
        end
    end)
    CreateThread(function()
        while alpha > 0 do
            if #colour_palette > 1 then
                current_color_index = current_color_index % #colour_palette + 1
                SetBlipColour(blip, colour_palette[current_color_index])
            end
            Wait(750)
        end
    end)
end

exports('blips_create_blip_alpha', create_blip_alpha)
utils.blips.create_blip_alpha = create_blip_alpha

--- Update the label of a blip.
--- @function update_blip_label
--- @param blip number: The blip whose label should be updated.
--- @param new_label string: The new label for the blip.
--- @usage utils.blips.update_blip_label(blip, 'New Label')
local function update_blip_label(blip, new_label)
    if DoesBlipExist(blip) then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(new_label)
        EndTextCommandSetBlipName(blip)
        for _, blip_data in ipairs(created_blips) do
            if blip_data.blip == blip then
                blip_data.label = new_label
                break
            end
        end
    end
end

exports('blips_update_blip_label', update_blip_label)
utils.blips.update_blip_label = update_blip_label

--- Update the sprite of a blip.
--- @function update_blip_sprite
--- @param blip number: The blip whose sprite should be updated.
--- @param new_sprite number: The new sprite ID for the blip.
--- @usage utils.blips.update_blip_sprite(blip, 162)
local function update_blip_sprite(blip, new_sprite)
    if DoesBlipExist(blip) then
        SetBlipSprite(blip, new_sprite)
        for _, blip_data in ipairs(created_blips) do
            if blip_data.blip == blip then
                blip_data.sprite = new_sprite
                break
            end
        end
    end
end

exports('blips_update_blip_sprite', update_blip_sprite)
utils.blips.update_blip_sprite = update_blip_sprite

--- Update the color of a blip.
--- @function update_blip_colour
--- @param blip number: The blip whose color should be updated.
--- @param new_colour number: The new color ID for the blip.
--- @usage utils.blips.update_blip_colour(blip, 2)
local function update_blip_colour(blip, new_colour)
    if DoesBlipExist(blip) then
        SetBlipColour(blip, new_colour)
        for _, blip_data in ipairs(created_blips) do
            if blip_data.blip == blip then
                blip_data.colour = new_colour
                break
            end
        end
    end
end

exports('blips_update_blip_colour', update_blip_colour)
utils.blips.update_blip_colour = update_blip_colour

--- Update the scale of a blip.
--- @function update_blip_scale
--- @param blip number: The blip whose scale should be updated.
--- @param new_scale number: The new scale for the blip.
--- @usage utils.blips.update_blip_scale(blip, 2.0)
local function update_blip_scale(blip, new_scale)
    if DoesBlipExist(blip) then
        SetBlipScale(blip, new_scale)
        for _, blip_data in ipairs(created_blips) do
            if blip_data.blip == blip then
                blip_data.scale = new_scale
                break
            end
        end
    end
end

exports('blips_update_blip_scale', update_blip_scale)
utils.blips.update_blip_scale = update_blip_scale

--- Check if blips are currently enabled.
--- @function are_blips_enabled
--- @return boolean: True if blips are enabled, false otherwise.
--- @usage local enabled = utils.blips.are_blips_enabled()
local function are_blips_enabled()
    return BLIPS_ENABLED
end

exports('blips_are_blips_enabled', are_blips_enabled)
utils.blips.are_blips_enabled = are_blips_enabled

--- Get the category state (visible or hidden) for a category.
--- @function get_category_state
--- @param category string: The category to check the state for.
--- @return boolean: True if the category is visible, false if hidden.
--- @usage local state = utils.blips.get_category_state('shop')
local function get_category_state(category)
    return category_state[category] or false
end

exports('blips_get_category_state', get_category_state)
utils.blips.get_category_state = get_category_state

--- Get all created blips.
--- @function get_all_blips
--- @return table: A table of all created blips.
--- @usage local all_blips = utils.blips.get_all_blips()
local function get_all_blips()
    return created_blips
end

exports('blips_get_all_blips', get_all_blips)
utils.blips.get_all_blips = get_all_blips

--- Get blips in a specific category.
--- @function get_blips_by_category
--- @param category string: The category of blips to retrieve.
--- @return table: A table of blips in the specified category.
--- @usage local shop_blips = utils.blips.get_blips_by_category('shop')
local function get_blips_by_category(category)
    local blips = {}
    for _, blip_data in ipairs(created_blips) do
        if blip_data.category == category then
            blips[#blips+1] = blip_data.blip
        end
    end
    return blips
end

exports('blips_get_blips_by_category', get_blips_by_category)
utils.blips.get_blips_by_category = get_blips_by_category

--- Get the label of a blip.
--- @function get_blip_label
--- @param blip number: The blip to retrieve the label from.
--- @return string: The label of the blip.
--- @usage local label = utils.blips.get_blip_label(blip)
local function get_blip_label(blip)
    for _, blip_data in ipairs(created_blips) do
        if blip_data.blip == blip then
            return blip_data.label
        end
    end
    return ''
end

exports('blips_get_blip_label', get_blip_label)
utils.blips.get_blip_label = get_blip_label

--- Pulses a blip.
--- @function pulse_blip
--- @param blip number: The blip to pulse.
--- @usage utils.blips.pulse_blip(blip)
local function pulse_blip(blip)
    if DoesBlipExist(blip) then
        PulseBlip(blip)
    end
end

exports('blips_pulse_blip', pulse_blip)
utils.blips.pulse_blip = pulse_blip

--- Flashes a blip for a certain duration.
--- @function flash_blip
--- @param blip number: The blip to flash.
--- @param duration number: The duration in seconds for the blip to flash.
--- @usage utils.blips.flash_blip(blip, 5)
local function flash_blip(blip, duration)
    if DoesBlipExist(blip) then
        BeginTextCommandSetBlipFlashes("STRING")
        AddTextComponentString(" ")
        EndTextCommandSetBlipFlashes(blip)
        Citizen.SetTimeout(duration * 1000, function()
            EndTextCommandSetBlipFlashes(blip)
        end)
    end
end

exports('blips_flash_blip', flash_blip)
utils.blips.flash_blip = flash_blip

--- Set a route to the blip on the minimap.
--- @function set_blip_route
--- @param blip number: The blip to set the route for.
--- @param enable boolean: Whether to enable (true) or disable (false) the route.
--- @usage utils.blips.set_blip_route(blip, true)
local function set_blip_route(blip, enable)
    if DoesBlipExist(blip) then
        SetBlipRoute(blip, enable)
    end
end

exports('blips_set_blip_route', set_blip_route)
utils.blips.set_blip_route = set_blip_route

--- Set the priority of a blip.
--- @function set_blip_priority
--- @param blip number: The blip to set the priority for.
--- @param priority number: The priority to set (0-3).
--- @usage utils.blips.set_blip_priority(blip, 2)
local function set_blip_priority(blip, priority)
    if DoesBlipExist(blip) then
        SetBlipPriority(blip, priority)
    end
end

exports('blips_set_blip_priority', set_blip_priority)
utils.blips.set_blip_priority = set_blip_priority

--- Remove a blip by its label.
--- @function remove_blip_by_label
--- @param label string: The label of the blip to remove.
--- @usage utils.blips.remove_blip_by_label('Blip Label')
local function remove_blip_by_label(label)
    for i = #created_blips, 1, -1 do
        if created_blips[i].label == label then
            remove_blip(created_blips[i].blip)
            table.remove(created_blips, i)
        end
    end
end

exports('blips_remove_blip_by_label', remove_blip_by_label)
utils.blips.remove_blip_by_label = remove_blip_by_label