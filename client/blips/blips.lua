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
-- @script client/blips.lua

--- @section Constants

--- @field BLIPS_ENABLED: Toggle to track whether a player has blips enabled or not
local BLIPS_ENABLED = true


--- @section Objects

--- @table created_blips: Used to store blips created by scripts 
local created_blips = {}

--- @table category_state: Used to store states of blip categories to show / hide based on category
local category_state = {}

--- @section Local functions

--- Create a single blip and add it to the created_blips table.
-- @function create_blip
-- @param blip_data table: Contains data for the blip creation like coordinates, sprite, color, scale, label, and category.
-- @usage utils.blips.create_blip({ coords = vector3(100.0, 200.0, 30.0), sprite = 1, colour = 1, scale = 1.5, label = 'Blip 1', category = 'shop', show = true })
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

--- Show or hide all blips.
-- @function toggle_all_blips
-- @param visible boolean: Indicates whether to show (true) or hide (false) all blips.
-- @usage utils.blips.toggle_all_blips(true) -- Show all blips
local function toggle_all_blips(visible)
    local displayId = visible and 2 or 0  -- Use 2 to show on both main map and minimap, and 0 to hide
    for _, blip_data in ipairs(created_blips) do
        SetBlipDisplay(blip_data.blip, displayId)
    end
    BLIPS_ENABLED = visible
end


--- Toggle blips based on their category.
-- @function toggle_blips_by_category
-- @param category string: The category of blips to show or hide.
-- @param state boolean: The new state of the blips in the specified category.
-- @usage utils.blips.toggle_blips_by_category('shop', false) -- Hide blips in the 'shop' category
local function toggle_blips_by_category(category, state)
    for _, blip_data in ipairs(created_blips) do
        if blip_data.category == category then
            SetBlipDisplay(blip_data.blip, state and 3 or 0)
        end
    end
    category_state[category] = state
end

--- Create multiple blips from a data table.
-- @function create_blips
-- @param blip_config table: A table of blip data configurations.
-- @usage utils.blips.create_blips(blip_config) -- blip_config should contain a list of blip data tables
--[[
    local blip_config = {
        { coords = vector3(100.0, 200.0, 30.0), sprite = 1, colour = 1, scale = 1.5, label = 'Blip 1', category = 'shop', show = true },
        -- Add more blips as needed
    }
    utils.blips.create_blips(blip_config)
]]
local function create_blips(blip_config)
    for _, blip_data in ipairs(blip_config) do
        create_blip(blip_data)
    end
end

--- Remove a single blip.
-- @function remove_blip
-- @param blip number: The blip to remove.
-- @usage utils.blips.remove_blip(blip)
local function remove_blip(blip)
    RemoveBlip(blip)
end

--- Remove all created blips.
-- @function remove_all_blips
-- @usage utils.blips.remove_all_blips()
local function remove_all_blips()
    for _, blip_data in ipairs(created_blips) do
        remove_blip(blip_data.blip)
    end
    created_blips = {}
end

--- Remove blips based on their category.
-- @function remove_blips_by_categories
-- @param categories table: A list of categories to remove blips from.
-- @usage utils.blips.remove_blips_by_categories({'shop', 'house'}) -- Remove blips in the 'shop' and 'house' categories
local function remove_blips_by_categories(categories)
    print("Starting blip removal for categories:", table.concat(categories, ", "))
    local initialCount = #created_blips
    for i = #created_blips, 1, -1 do
        local blip_data = created_blips[i]
        for _, category in ipairs(categories) do
            if blip_data.category == category then
                remove_blip(blip_data.blip)
                table.remove(created_blips, i)
                print("Removed blip:", blip_data.label, "Category:", category)
                break
            end
        end
    end

    print(string.format("Removed %d blips. Remaining blips: %d", initialCount - #created_blips, #created_blips))
end

--- Create a blip with customizable alpha and duration.
-- @function create_blip_alpha
-- @param coords vector3: The coordinates where the blip should be created.
-- @param sprite number: The sprite ID for the blip.
-- @param colour number: The color ID for the blip.
-- @param scale number: The scale of the blip.
-- @param label string: The label for the blip.
-- @param alpha number: The alpha level for the blip.
-- @param duration number: The duration for the blip to stay before fading.
-- @usage utils.blips.create_blip_alpha(vector3(100.0, 200.0, 30.0), 161, 1, 1.5, 'Example Blip', 250, 5)
local function create_blip_alpha(coords, sprite, colour, scale, label, alpha, duration)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    local step = alpha / (duration * 4)
    while alpha > 0 do
        Wait(120 * 4)
        alpha = alpha - step
        SetBlipAlpha(blip, alpha)
        if alpha <= 0 then
            RemoveBlip(blip)
            return
        end
    end
end

--- Update the label of a blip.
-- @function update_blip_label
-- @param blip number: The blip whose label should be updated.
-- @param new_label string: The new label for the blip.
-- @usage utils.blips.update_blip_label(blip, 'New Label')
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

--- Update the sprite of a blip.
-- @function update_blip_sprite
-- @param blip number: The blip whose sprite should be updated.
-- @param new_sprite number: The new sprite ID for the blip.
-- @usage utils.blips.update_blip_sprite(blip, 162)
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

--- Update the color of a blip.
-- @function update_blip_colour
-- @param blip number: The blip whose color should be updated.
-- @param new_colour number: The new color ID for the blip.
-- @usage utils.blips.update_blip_colour(blip, 2)
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

--- Update the scale of a blip.
-- @function update_blip_scale
-- @param blip number: The blip whose scale should be updated.
-- @param new_scale number: The new scale for the blip.
-- @usage utils.blips.update_blip_scale(myBlip, 2.0)
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

--- Check if blips are currently enabled.
-- @function are_blips_enabled
-- @return boolean: True if blips are enabled, false otherwise.
-- @usage local enabled = utils.blips.are_blips_enabled()
local function are_blips_enabled()
    return BLIPS_ENABLED
end

--- Get the category state (visible or hidden) for a category.
-- @function get_category_state
-- @param category string: The category to check the state for.
-- @return boolean: True if the category is visible, false if hidden.
-- @usage local state = utils.blips.get_category_state('shop')
local function get_category_state(category)
    return category_state[category] or false
end

--- Get all created blips.
-- @function get_all_blips
-- @return table: A table of all created blips.
-- @usage local all_blips = utils.blips.get_all_blips()
local function get_all_blips()
    return created_blips
end

--- Get blips in a specific category.
-- @function get_blips_by_category
-- @param category string: The category of blips to retrieve.
-- @return table: A table of blips in the specified category.
-- @usage local shop_blips = utils.blips.get_blips_by_category('shop')
local function get_blips_by_category(category)
    local blips = {}
    for _, blip_data in ipairs(created_blips) do
        if blip_data.category == category then
            table.insert(blips, blip_data.blip)
        end
    end
    return blips
end

--- Get the label of a blip.
-- @function get_blip_label
-- @param blip number: The blip to retrieve the label from.
-- @return string: The label of the blip.
-- @usage local label = utils.blips.get_blip_label(blip)
local function get_blip_label(blip)
    for _, blip_data in ipairs(created_blips) do
        if blip_data.blip == blip then
            return blip_data.label
        end
    end
    return ''
end

--- @section Assign local functions

utils.blips = utils.blips or {}


utils.blips.create_blip = create_blip
utils.blips.create_blips = create_blips
utils.blips.remove_all_blips = remove_all_blips
utils.blips.remove_blips_by_categories = remove_blips_by_categories
utils.blips.toggle_all_blips = toggle_all_blips
utils.blips.toggle_blips_by_category = toggle_blips_by_category
utils.blips.create_blip_alpha = create_blip_alpha
utils.blips.update_blip_label = update_blip_label
utils.blips.update_blip_sprite = update_blip_sprite
utils.blips.update_blip_colour = update_blip_colour
utils.blips.update_blip_scale = update_blip_scale
utils.blips.are_blips_enabled = are_blips_enabled
utils.blips.get_category_state = get_category_state
utils.blips.get_all_blips = get_all_blips
utils.blips.get_blips_by_category = get_blips_by_category
utils.blips.get_blip_label = get_blip_label