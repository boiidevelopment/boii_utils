--- This section covers client side character creation functions and events.
-- @script client/characters/creation.lua

--- @section Constants

--- Facial feature identifiers and corresponding data keys.
-- @table FACIAL_FEATURES
-- @see set_ped_appearance
local FACIAL_FEATURES = {
    { id = 0, value = 'nose_width' }, { id = 1, value = 'nose_peak_height' }, { id = 2, value = 'nose_peak_length' },
    { id = 3, value = 'nose_bone_height' }, { id = 4, value = 'nose_peak_lower' }, { id = 5, value = 'nose_twist' },
    { id = 6, value = 'eyebrow_height' }, { id = 7, value = 'eyebrow_depth' }, { id = 8, value = 'cheek_bone' },
    { id = 9, value = 'cheek_sideways_bone' }, { id = 10, value = 'cheek_bone_width' },
    { id = 11, value = 'eye_opening' }, { id = 12, value = 'lip_thickness' }, { id = 13, value = 'jaw_bone_width' },
    { id = 14, value = 'jaw_bone_shape' }, { id = 15, value = 'chin_bone' }, { id = 16, value = 'chin_bone_length' },
    { id = 17, value = 'chin_bone_shape' }, { id = 18, value = 'chin_hole' }, { id = 19, value = 'neck_thickness' }
}

--- Overlay identifiers and corresponding data keys for style, opacity, and colour.
-- @table OVERLAYS
-- @see set_ped_appearance
local OVERLAYS = {
    {index = 2, style = 'eyebrow', opacity = 'eyebrow_opacity', colour = 'eyebrow_colour' },
    {index = 1, style = 'facial_hair', opacity = 'facial_hair_opacity', colour = 'facial_hair_colour' },
    {index = 10, style = 'chest_hair', opacity = 'chest_hair_opacity', colour = 'chest_hair_colour' },
    {index = 4, style = 'make_up', opacity = 'make_up_opacity', colour = 'make_up_colour' },
    {index = 5, style = 'blush', opacity = 'blush_opacity', colour = 'blush_colour' },
    {index = 8, style = 'lipstick', opacity = 'lipstick_opacity', colour = 'lipstick_colour' },
    {index = 0, style = 'blemish', opacity = 'blemish_opacity' },
    {index = 11, style = 'moles', opacity = 'moles_opacity' },
    {index = 3, style = 'ageing', opacity = 'ageing_opacity' },
    {index = 6, style = 'complexion', opacity = 'complexion_opacity' },
    {index = 7, style = 'sun_damage', opacity = 'sun_damage_opacity' },
    {index = 9, style = 'body_blemish', opacity = 'body_blemish_opacity' }
}

--- Clothing item identifiers and corresponding data keys for style, texture, and prop status.
-- @table CLOTHING_ITEMS
-- @see set_ped_appearance
local CLOTHING_ITEMS = {
    {index = 1, style = 'mask_style', texture = 'mask_texture' },
    {index = 11, style = 'jacket_style', texture = 'jacket_texture' },
    {index = 8, style = 'shirt_style', texture = 'shirt_texture' },
    {index = 9, style = 'vest_style', texture = 'vest_texture' },
    {index = 4, style = 'legs_style', texture = 'legs_texture' },
    {index = 6, style = 'shoes_style', texture = 'shoes_texture' },
    {index = 3, style = 'hands_style', texture = 'hands_texture' },
    {index = 5, style = 'bag_style', texture = 'bag_texture' },
    {index = 10, style = 'decals_style', texture = 'decals_texture' },
    {index = 7, style = 'neck_style', texture = 'neck_texture' },
    {index = 0, style = 'hats_style', texture = 'hats_texture', is_prop = true},
    {index = 1, style = 'glasses_style', texture = 'glasses_texture', is_prop = true},
    {index = 2, style = 'earwear_style', texture = 'earwear_texture', is_prop = true},
    {index = 6, style = 'watches_style', texture = 'watches_texture', is_prop = true},
    {index = 7, style = 'bracelets_style', texture = 'bracelets_texture', is_prop = true}
}

--- Camera positions to be used throughout creation process
-- @table CAMERA_POSITIONS
-- @see change_camera_position
local CAMERA_POSITIONS = {
    face_cam = { offset = { x = 0, y = 1.05, z = 0 }, height_adjustment = 0.5 },
    body_cam = { offset = { x = 0, y = 1.75, z = 0 }, height_adjustment = 0 },
    leg_cam = { offset = { x = 0, y = 1.05, z = 0 }, height_adjustment = -0.5 },
    feet_cam = { offset = { x = 0, y = 1.05, z = 0 }, height_adjustment = -0.75 } 
}

--- @section Variables

--- Current sex of the player. Used to determine specific appearance settings.
-- This can be 'male' or 'female' and affects how certain appearance data is applied.
local current_sex = 'male'

--- Model identifier for the preview ped.
local preview_ped = (current_sex == 'male') and 'mp_m_freemode_01' or 'mp_f_freemode_01'

--- Camera object for viewing the ped.
local cam = nil

--- @section Internal helper functions

--- Function to handle debug logging for creation section.
-- @function debug_log
-- @param type string: The type of log (e.g., 'info', 'err'). Determines how the log is processed and where it's displayed.
-- @param message string: The actual log message to be recorded.
local function debug_log(type, message)
    if config.debug then
        local resource = GetCurrentResourceName()
        utils.debug[type]('['..resource..'] - '.. message)
    end
end

--- @section Local functions

--- Function to get clothing and prop values for UI inputs.
-- This function retrieves the maximum values for clothing and props based on the player's current ped model.
-- It's used to populate the UI with the correct range of values for each clothing and prop item.
-- @function get_clothing_and_prop_values
-- @param sex string: The sex of the current ped model ('male' or 'female').
-- @return table: A table with the maximum values for each clothing and prop item.
-- @usage 
--[[
    local values = get_clothing_and_prop_values(sex)
]]
-- @example
--[[
    local male_values = get_clothing_and_prop_values('male')
    local female_values = get_clothing_and_prop_values('female')
]]
-- @see SetNumberOfPedDrawableVariations, SetNumberOfPedTextureVariations
local function get_clothing_and_prop_values(sex)
    if not sex == 'male' or not sex == 'female' then  
        debug_log('err', "Function: get_clothing_and_prop_values failed | Reason: Invalid parameters for sex. - Use 'male' or 'female' only.") 
        return
    end
    local data = utils.shared.style[sex]
    local values = {
        hair = GetNumberOfPedDrawableVariations(PlayerPedId(), 2) - 1,
        fade = GetNumberOfPedTextureVariations(PlayerPedId(), 2, tonumber(data.barber.hair)) - 1, -- line 36
        eyebrow = GetPedHeadOverlayNum(2) - 1,
        facial_hair = GetPedHeadOverlayNum(1) - 1,
        chest_hair = GetPedHeadOverlayNum(10) - 1,
        make_up = GetPedHeadOverlayNum(4) - 1,
        blush = GetPedHeadOverlayNum(5) - 1,
        lipstick = GetPedHeadOverlayNum(8) - 1,
        blemish = GetPedHeadOverlayNum(0) - 1,
        body_blemish = GetPedHeadOverlayNum(11) - 1,
        ageing = GetPedHeadOverlayNum(3) - 1,
        complexion = GetPedHeadOverlayNum(6) - 1,
        sun_damage = GetPedHeadOverlayNum(7) - 1,
        moles = GetPedHeadOverlayNum(9) - 1,
        mask = GetNumberOfPedDrawableVariations(PlayerPedId(), 1) - 1,
        mask_texture = GetNumberOfPedTextureVariations(PlayerPedId(), 1, tonumber(data.clothing.mask_style) - 1),
        jacket = GetNumberOfPedDrawableVariations(PlayerPedId(), 3) - 1,
        jacket_texture = GetNumberOfPedTextureVariations(PlayerPedId(), 3, tonumber(data.clothing.jacket_style) - 1),
        shirt = GetNumberOfPedDrawableVariations(PlayerPedId(), 8) - 1,
        shirt_texture = GetNumberOfPedTextureVariations(PlayerPedId(), 8, tonumber(data.clothing.shirt_style) - 1),
        vest = GetNumberOfPedDrawableVariations(PlayerPedId(), 9) - 1,
        vest_texture = GetNumberOfPedTextureVariations(PlayerPedId(), 9, tonumber(data.clothing.vest_style) - 1),
        legs = GetNumberOfPedDrawableVariations(PlayerPedId(), 4) - 1,
        legs_texture = GetNumberOfPedTextureVariations(PlayerPedId(), 4, tonumber(data.clothing.legs_style) - 1),
        shoes = GetNumberOfPedDrawableVariations(PlayerPedId(), 6) - 1,
        shoes_texture = GetNumberOfPedTextureVariations(PlayerPedId(), 6, tonumber(data.clothing.shoes_style) - 1),
        hands = GetNumberOfPedDrawableVariations(PlayerPedId(), 5) - 1,
        hands_texture = GetNumberOfPedTextureVariations(PlayerPedId(), 5, tonumber(data.clothing.hands_style) - 1),
        bag = GetNumberOfPedDrawableVariations(PlayerPedId(), 7) - 1,
        bag_texture = GetNumberOfPedTextureVariations(PlayerPedId(), 7, tonumber(data.clothing.bag_style) - 1),
        decals = GetNumberOfPedDrawableVariations(PlayerPedId(), 10) - 1,
        decals_texture = GetNumberOfPedTextureVariations(PlayerPedId(), 10, tonumber(data.clothing.decals_style) - 1),
        neck = GetNumberOfPedDrawableVariations(PlayerPedId(), 2) - 1,
        neck_texture = GetNumberOfPedTextureVariations(PlayerPedId(), 2, tonumber(data.clothing.neck_style) - 1),
        hats = GetNumberOfPedPropDrawableVariations(PlayerPedId(), 0) - 1,
        hats_texture = GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, tonumber(data.clothing.hats_style) - 1),
        glasses = GetNumberOfPedPropDrawableVariations(PlayerPedId(), 1) - 1,
        glasses_texture = GetNumberOfPedPropTextureVariations(PlayerPedId(), 1, tonumber(data.clothing.glasses_style) - 1),
        earwear = GetNumberOfPedPropDrawableVariations(PlayerPedId(), 2) - 1,
        earwear_texture = GetNumberOfPedPropTextureVariations(PlayerPedId(), 2, tonumber(data.clothing.earwear_style) - 1),
        watches = GetNumberOfPedPropDrawableVariations(PlayerPedId(), 6) - 1,
        watches_texture = GetNumberOfPedPropTextureVariations(PlayerPedId(), 6, tonumber(data.clothing.watches_style) - 1),
        bracelets = GetNumberOfPedPropDrawableVariations(PlayerPedId(), 7) - 1,
        bracelets_texture = GetNumberOfPedPropTextureVariations(PlayerPedId(), 7, tonumber(data.clothing.bracelets_style) - 1),
    }
    return values
end

--- Function to set ped hair, makeup, genetics, and clothing based on the latest data.
-- This function applies the appearance settings to the player's ped model, including genetics, hair, makeup, tattoos, and clothing.
-- It utilizes the latest data stored in the utils.shared.style object.
-- @function set_ped_appearance
-- @param player PlayerPedId(): The player's ped instance.
-- @param data table: The data object containing appearance settings for genetics, hair, makeup, tattoos, and clothing.
-- @usage 
--[[
    set_ped_appearance(player, data)
]]
-- @example
--[[
    set_ped_appearance(PlayerPedId(), utils.shared.style['male'])
]]
-- @see SetPedHeadBlendData, SetPedFaceFeature, SetPedComponentVariation, SetPedPropIndex
local function set_ped_appearance(player, data)
    if not player or not data then 
        debug_log('err', 'Function: set_ped_appearance failed | Reason: Missing one or more required parameters. - player and data are required.') 
        return
    end
    SetPedHeadBlendData(player, tonumber(data.genetics.mother), tonumber(data.genetics.father), nil, tonumber(data.genetics.mother), tonumber(data.genetics.father), nil, tonumber(data.genetics.resemblence), tonumber(data.genetics.skin), nil, true)
    SetPedEyeColor(player, data.genetics.eye_colour)
    SetPedComponentVariation(player, 2, tonumber(data.barber.hair), 0, 0)
    SetPedHairColor(player, tonumber(data.barber.hair_colour), tonumber(data.barber.highlight_colour))
    for _, feature in ipairs(FACIAL_FEATURES) do
        SetPedFaceFeature(player, feature.index, tonumber(data.genetics[feature.value]))
    end
    for _, overlay in ipairs(OVERLAYS) do
        local style = tonumber(data.barber[overlay.style])
        local opacity = tonumber(data.barber[overlay.opacity])
        if opacity then
            opacity = opacity / 100
        end
        SetPedHeadOverlay(player, overlay.index, style, opacity)
        if overlay.colour and data.barber[overlay.colour] then
            local colour = tonumber(data.barber[overlay.colour])
            if colour then
                SetPedHeadOverlayColor(player, overlay.index, 1, colour, colour)
            else
                debug_log('err', 'Function: set_ped_appearance failed | Reason: Invalid overlay colour for ' .. overlay.style) 
            end
        end
    end
    for _, item in ipairs(CLOTHING_ITEMS) do
        local style = tonumber(data.clothing[item.style])
        local texture = tonumber(data.clothing[item.texture])
        if style and style >= 0 then
            if item.is_prop then
                SetPedPropIndex(player, item.index, style, texture, true)
            else 
                SetPedComponentVariation(player, item.index, style, texture, 0)
            end
        end
    end
    ClearPedDecorations(player)
    if data.tattoos then
        for zone, tattoo_info in pairs(data.tattoos) do
            if tattoo_info and tattoo_info.name and tattoo_info.name ~= 'none' then
                local tattoo_hash = data.sex == 'male' and GetHashKey(tattoo_info.hash_male) or GetHashKey(tattoo_info.hash_female)
                if tattoo_hash and tattoo_info.collection then
                    SetPedDecoration(player, GetHashKey(tattoo_info.collection), tattoo_hash)
                else
                    debug_log('err', 'Function: set_ped_appearance failed | Reason: Invalid tattoo hash or collection for tattoo in zone: ' .. zone) 
                end
            end
        end
    else
        debug_log('err', 'Function: set_ped_appearance failed | Reason: No tattoo data found in character data.') 
    end
    debug_log('info', 'Function: set_ped_appearance | Note: Success!')
end

--- Updates utils.shared.style with new values to be displayed on player.
-- This function is key for synchronizing player's ped appearance changes with the backend data.
-- @function update_ped_data
-- @param sex string: The sex to select from creation style.
-- @param data_type string: The type of data being updated (e.g., 'genetics', 'barber').
-- @param index string: The specific index within the data type being updated.
-- @param data table: The new values to be set.
-- @usage 
--[[
    update_ped_data(sex, data_type, index, data)
]]
-- @example
--[[
    update_ped_data('male', 'genetics', 'heritage', {mother = 5, father = 10})
    update_ped_data('male', 'barber', 'hair', {style = 2, colour = 10})
]]
-- @see set_ped_appearance
local function update_ped_data(sex, category, id, value)
    if not sex or not category or not id or not value then 
        debug_log('err', 'Function: update_ped_data failed | Reason: Missing one or more required parameters. - sex, category, id, or value.') 
        return 
    end
    if id == 'resemblance' or id == 'skin' then
        value = value / 100
    end
    if type(utils.shared.style[sex][category][id]) == 'table' then
        for k, _ in pairs(utils.shared.style[sex][category][id]) do
            utils.shared.style[sex][category][id][k] = value[k]
        end
    else
        utils.shared.style[sex][category][id] = value
    end
    current_sex = sex
    local player_ped = PlayerPedId()
    set_ped_appearance(player_ped, utils.shared.style[sex])
end

--- Function to change the player's ped model based on the selected sex.
-- Changes the player's ped model to correspond with the selected sex during character creation.
-- @function change_player_ped
-- @param sex string: The sex of the ped model to switch to ('male' or 'female').
-- @usage 
--[[
    change_player_ped(sex)
]]
-- @example
--[[
    change_player_ped('male')
    change_player_ped('female')
]]
local function change_player_ped(sex)
    if not sex then
        debug_log('err', 'Function: change_player_ped failed. | Reason: Player sex was not provided.')
        return
    end
    current_sex = sex
    local model = GetHashKey(preview_ped)
    utils.requests.model(model)
    local player_id = PlayerId()
    local player_ped = PlayerPedId()
    SetPlayerModel(player_id, model)
    set_ped_appearance(player_ped, utils.shared.style[sex])
end

--- Function to rotate the player's ped in a specific direction.
-- Rotates the player's ped based on the specified direction.
-- Supports right, left, 180 degrees rotation, and reset to original heading.
-- @function rotate_ped
-- @param direction string: The direction to rotate the ped ('rotate_ped_right', 'rotate_ped_left', 'rotate_ped_180', 'rotate_ped_reset').
-- @usage 
--[[
    rotate_ped(direction)
]]
-- @example
--[[
    rotate_ped('rotate_ped_right')  -- Rotates the ped 45 degrees to the right
    rotate_ped('rotate_ped_left')   -- Rotates the ped 45 degrees to the left
    rotate_ped('rotate_ped_180')    -- Rotates the ped 180 degrees
    rotate_ped('rotate_ped_reset')  -- Resets the ped to its original heading
]]
local function rotate_ped(direction)
    if not direction then
        debug_log('err', 'Function: rotate_ped failed. | Reason: Direction parameter is missing.')
        return
    end
    local player_ped = PlayerPedId()
    local current_heading = GetEntityHeading(player_ped)
    local new_heading
    if original_heading == nil then
        original_heading = current_heading
    end
    if direction == 'rotate_ped_right' then
        new_heading = current_heading + 45
    elseif direction == 'rotate_ped_left' then
        new_heading = current_heading - 45
    elseif direction == 'rotate_ped_180' then
        new_heading = original_heading + 180
    elseif direction == 'rotate_ped_reset' then
        new_heading = original_heading
        original_heading = nil
    else
        debug_log('err', "Function: rotate_ped failed. | Reason: Invalid direction parameter - Use 'rotate_ped_right', 'rotate_ped_left', 'rotate_ped_180' or 'rotate_ped_reset'.")
        return
    end
    new_heading = new_heading % 360
    SetEntityHeading(player_ped, new_heading)
end

--- Function to change camera position based on the given configuration.
-- Changes the camera to focus on the face, body, legs, or feet of the player's ped.
-- @function change_camera_position
-- @param cam_position table: The configuration for the camera position.
-- @usage 
--[[
    change_camera_position(cam_position)
]]
-- @example
--[[
    change_camera_position(CAMERA_POSITIONS['face_cam'])
    change_camera_position(CAMERA_POSITIONS['body_cam'])
]]
local function change_camera_position(cam_position)
    if not cam_position then
        debug_log('err', 'Function: change_camera_position failed. | Reason: Camera position parameter is missing.')
        return
    end
    local player_ped = PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(player_ped, cam_position.offset.x, cam_position.offset.y, cam_position.offset.z)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
    SetCamCoord(cam, coords.x, coords.y, coords.z + cam_position.height_adjustment)
    SetCamRot(cam, 0.0, 0.0, GetEntityHeading(player_ped) + 180)
end

--- Function to load and apply a character model.
-- Loads the specified character model and applies appearance settings.
-- Sets the character's genetics, barber, clothing, and tattoos.
-- @function load_character_model
-- @param data table: All the data for the players character to be set on the ped.
-- @usage 
--[[
    load_character_model(data)
]]
-- @example
--[[
    load_character_model(data)
]]
local function load_character_model(data)
    if not data.identity or not data.style.genetics or not data.style.barber or not data.style.clothing or not data.style.tattoos then
        debug_log('err', 'Function: load_character_model failed. | Reason: One or more required parameters are missing.')
        return
    end

    current_sex = data.identity.sex -- THIS WILL NEED TO BE UPDATED TO YOUR OWN METHOD OF GETTING THE PLAYERS SEX
    
    local model = GetHashKey(preview_ped)
    if not utils.requests.model(model) then
        debug_log('err', "Function: load_character_model failed. | Reason: Failed to request model: " .. preview_ped)
        return
    end
    local player_id = PlayerId()
    local player_ped = PlayerPedId()
    SetPlayerModel(player_id, model)
    SetPedComponentVariation(player_ped, 0, 0, 0, 1)
    utils.shared.style.genetics = data.style.genetics
    utils.shared.style.barber = data.style.barber
    utils.shared.style.clothing = data.style.clothing
    utils.shared.style.tattoos = data.style.tattoos
    set_ped_appearance(player_ped, utils.shared.style[current_sex])
end

--- @section Assign local functions

utils.character_creation = utils.character_creation or {}

utils.character_creation.get_clothing_and_prop_values = get_clothing_and_prop_values
utils.character_creation.set_ped_appearance = set_ped_appearance
utils.character_creation.update_ped_data = update_ped_data
utils.character_creation.change_player_ped = change_player_ped
utils.character_creation.rotate_ped = rotate_ped
utils.character_creation.change_camera_position = change_camera_position
utils.character_creation.load_character_model = load_character_model

RegisterCommand('test:char_create_setup', function()
    setup_character_create()
end)