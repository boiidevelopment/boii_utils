----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

local created_blips = {}
local category_state = {}
local blips_enabled = true

-- Function to create a single blip and add it to the created_blips table
-- Usage: utils.blips.create_blip({ coords = vector3(100.0, 200.0, 30.0), sprite = 1, colour = 1, scale = 1.5, label = 'Blip 1', category = 'shop', show = true })
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

-- Function to show or hide all blips
-- Usage: utils.blips.toggle_all_blips(true) -- Show all blips
local function toggle_all_blips(visible)
    local displayId = visible and 2 or 0  -- Use 2 to show on both main map and minimap, and 0 to hide
    for _, blip_data in ipairs(created_blips) do
        SetBlipDisplay(blip_data.blip, displayId)
    end
    blips_enabled = visible
end


-- Function to toggle blips based on their category
-- Usage: utils.blips.toggle_blips_by_category('shop', false) -- Hide blips in the 'shop' category
local function toggle_blips_by_category(category, state)
    for _, blip_data in ipairs(created_blips) do
        if blip_data.category == category then
            SetBlipDisplay(blip_data.blip, state and 3 or 0)
        end
    end
    category_state[category] = state
end

-- Function to create multiple blips from a data table
-- Usage:
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

-- Function to remove a single blip
-- Usage:
-- local blip = GetBlipFromEntity(PlayerPedId())
-- remove_blip(blip)
local function remove_blip(blip)
    RemoveBlip(blip)
end

-- Function to remove all created blips
-- Usage: remove_all_blips()
local function remove_all_blips()
    for _, blip_data in ipairs(created_blips) do
        remove_blip(blip_data.blip)
    end
    created_blips = {}
end

-- Function to remove blips based on their category
-- Usage: remove_blips_by_categories({'shop', 'house'}) -- Remove blips in the 'shop' and 'house' categories
local function remove_blips_by_categories(categories)
    for i = #created_blips, 1, -1 do
        local blip_data = created_blips[i]
        for _, category in ipairs(categories) do
            if blip_data.category == category then
                remove_blip(blip_data.blip)
                table.remove(created_blips, i)
                break
            end
        end
    end
end

-- Function to create a blip with customizable alpha and duration
-- Usage: create_blip_with_alpha(vector3(100.0, 200.0, 30.0), 161, 1, 1.5, 'Example Blip', 250, 5)
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

-- Function to update the label of a blip
-- Usage: utils.blips.update_blip_label(myBlip, 'New Label')
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

-- Function to update the sprite of a blip
-- Usage: utils.blips.update_blip_sprite(myBlip, 162)
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

-- Function to update the color of a blip
-- Usage: utils.blips.update_blip_colour(myBlip, 2)
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

-- Function to update the scale of a blip
-- Usage: utils.blips.update_blip_scale(myBlip, 2.0)
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

-- Function to check if blips are currently enabled
-- Usage: local enabled = utils.blips.are_blips_enabled()
local function are_blips_enabled()
    return blips_enabled
end

-- Function to get the category state (visible or hidden) for a category
-- Usage: local state = utils.blips.get_category_state('shop')
local function get_category_state(category)
    return category_state[category] or false
end

-- Function to get all created blips
-- Usage: local all_blips = utils.blips.get_all_blips()
local function get_all_blips()
    return created_blips
end

-- Function to get blips in a specific category
-- Usage: local shop_blips = utils.blips.get_blips_by_category('shop')
local function get_blips_by_category(category)
    local blips = {}
    for _, blip_data in ipairs(created_blips) do
        if blip_data.category == category then
            table.insert(blips, blip_data.blip)
        end
    end
    return blips
end

-- Function to get the label of a blip
-- Usage: local label = utils.blips.get_blip_label(myBlip)
local function get_blip_label(blip)
    for _, blip_data in ipairs(created_blips) do
        if blip_data.blip == blip then
            return blip_data.label
        end
    end
    return ''
end

--[[
    ASSIGN LOCALS
]]

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

