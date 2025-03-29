--- @section Modules

local DEBUG <const> = get("modules.debugging")
local TABLES <const> = get("modules.tables")
local REQUESTS <const> = get("modules.requests")

--- @section Customisation Mapping

--- Facial feature identifiers and corresponding data keys.
local FACIAL_FEATURES <const> = {
    { id = 0, value = "nose_width" }, 
    { id = 1, value = "nose_peak_height" }, 
    { id = 2, value = "nose_peak_length" },
    { id = 3, value = "nose_bone_height" }, 
    { id = 4, value = "nose_peak_lower" }, 
    { id = 5, value = "nose_twist" },
    { id = 6, value = "eyebrow_height" }, 
    { id = 7, value = "eyebrow_depth" }, 
    { id = 8, value = "cheek_bone" },
    { id = 9, value = "cheek_sideways_bone" }, 
    { id = 10, value = "cheek_bone_width" },
    { id = 11, value = "eye_opening" }, 
    { id = 12, value = "lip_thickness" }, 
    { id = 13, value = "jaw_bone_width" },
    { id = 14, value = "jaw_bone_shape" }, 
    { id = 15, value = "chin_bone" }, 
    { id = 16, value = "chin_bone_length" },
    { id = 17, value = "chin_bone_shape" }, 
    { id = 18, value = "chin_hole" }, 
    { id = 19, value = "neck_thickness" }
}

--- Overlay identifiers and corresponding data keys for style, opacity, and colour.
local OVERLAYS <const> = {
    { index = 2, style = "eyebrow", opacity = "eyebrow_opacity", colour = "eyebrow_colour" },
    { index = 1, style = "facial_hair", opacity = "facial_hair_opacity", colour = "facial_hair_colour" },
    { index = 10, style = "chest_hair", opacity = "chest_hair_opacity", colour = "chest_hair_colour" },
    { index = 4, style = "make_up", opacity = "make_up_opacity", colour = "make_up_colour" },
    { index = 5, style = "blush", opacity = "blush_opacity", colour = "blush_colour" },
    { index = 8, style = "lipstick", opacity = "lipstick_opacity", colour = "lipstick_colour" },
    { index = 0, style = "blemish", opacity = "blemish_opacity" },
    { index = 11, style = "moles", opacity = "moles_opacity" },
    { index = 3, style = "ageing", opacity = "ageing_opacity" },
    { index = 6, style = "complexion", opacity = "complexion_opacity" },
    { index = 7, style = "sun_damage", opacity = "sun_damage_opacity" },
    { index = 9, style = "body_blemish", opacity = "body_blemish_opacity" }
}

--- Clothing item identifiers and corresponding data keys for style, texture, and prop status.
local CLOTHING_ITEMS <const> = {
    { index = 1, style = "mask_style", texture = "mask_texture" },
    { index = 11, style = "jacket_style", texture = "jacket_texture" },
    { index = 8, style = "shirt_style", texture = "shirt_texture" },
    { index = 9, style = "vest_style", texture = "vest_texture" },
    { index = 4, style = "legs_style", texture = "legs_texture" },
    { index = 6, style = "shoes_style", texture = "shoes_texture" },
    { index = 3, style = "hands_style", texture = "hands_texture" },
    { index = 5, style = "bag_style", texture = "bag_texture" },
    { index = 10, style = "decals_style", texture = "decals_texture" },
    { index = 7, style = "neck_style", texture = "neck_texture" },
    { index = 0, style = "hats_style", texture = "hats_texture", is_prop = true },
    { index = 1, style = "glasses_style", texture = "glasses_texture", is_prop = true },
    { index = 2, style = "earwear_style", texture = "earwear_texture", is_prop = true },
    { index = 6, style = "watches_style", texture = "watches_texture", is_prop = true },
    { index = 7, style = "bracelets_style", texture = "bracelets_texture", is_prop = true }
}

--- @section Style Data

local ped_styles = { 
    m = { 
        genetics = { mother = 0, father = 0, resemblance = 0, skin = 0, eye_colour = 1, eye_opening = 0, eyebrow_height = 0, eyebrow_depth = 0, nose_width = 0, nose_peak_height = 0, nose_peak_length = 0, nose_bone_height = 0, nose_peak_lower = 0, nose_twist = 0, cheek_bone = 0, cheek_bone_sideways = 0, cheek_bone_width = 0, lip_thickness = 0, jaw_bone_width = 0, jaw_bone_shape = 0, chin_bone = 0, chin_bone_length = 0, chin_bone_shape = 0, chin_hole = 0, neck_thickness = 0 },
        barber = { hair = -1, hair_colour = 0, highlight_colour = 0, fade = -1, fade_colour = 0, eyebrow = -1, eyebrow_opacity = 1.0, eyebrow_colour = 0, facial_hair = -1, facial_hair_opacity = 1.0, facial_hair_colour = 0, chest_hair = -1, chest_hair_opacity = 1.0, chest_hair_colour = 0, make_up = -1, make_up_opacity = 1.0, make_up_colour = 0, blush = -1, blush_opacity = 1.0, blush_colour = 0, lipstick = -1, lipstick_opacity = 1.0, lipstick_colour = 0, blemish = -1, blemish_opacity = 1.0, body_blemish = -1, body_blemish_opacity = 1.0, ageing = -1, ageing_opacity = 1.0, complexion = -1, complexion_opacity = 1.0, sun_damage = -1, sun_damage_opacity = 1.0, moles = -1, moles_opacity = 0 },
        clothing = { mask_style = -1, mask_texture = 0, jacket_style = 15, jacket_texture = 0, shirt_style = 15, shirt_texture = 0, vest_style = -1, vest_texture = 0, legs_style = 21, legs_texture = 0, shoes_style = 34, shoes_texture = 0, hands_style = 15, hands_texture = 0, bag_style = -1, bag_texture = 0, decals_style = -1, decals_texture = 0, hats_style = -1, hats_texture = 0, glasses_style = -1, glasses_texture = 0, earwear_style = -1, earwear_texture = 0, watches_style = -1, watches_texture = 0, bracelets_style = -1, bracelets_texture = 0, neck_style = -1, neck_texture = 0 },
        tattoos = { ZONE_HEAD = { name = "", label = "", hash_m = "", hash_f = "", collection = "" }, ZONE_TORSO = { name = "", label = "", hash_m = "", hash_f = "", collection = "" }, ZONE_LEFT_ARM = { name = "", label = "", hash_m = "", hash_f = "", collection = "" }, ZONE_RIGHT_ARM = { name = "", label = "", hash_m = "", hash_f = "", collection = "" }, ZONE_LEFT_LEG = { name = "", label = "", hash_m = "", hash_f = "", collection = "" }, ZONE_RIGHT_LEG = { name = "", label = "", hash_m = "", hash_f = "", collection = "" } }
    },
    f = { 
        genetics = { mother = 0, father = 0, resemblance = 0, skin = 0, eye_colour = 1, eye_opening = 0, eyebrow_height = 0, eyebrow_depth = 0, nose_width = 0, nose_peak_height = 0, nose_peak_length = 0, nose_bone_height = 0, nose_peak_lower = 0, nose_twist = 0, cheek_bone = 0, cheek_bone_sideways = 0, cheek_bone_width = 0, lip_thickness = 0, jaw_bone_width = 0, jaw_bone_shape = 0, chin_bone = 0, chin_bone_length = 0, chin_bone_shape = 0, chin_hole = 0, neck_thickness = 0 },
        barber = { hair = -1, hair_colour = 0, highlight_colour = 0, fade = -1, fade_colour = 0, eyebrow = -1, eyebrow_opacity = 1.0, eyebrow_colour = 0, facial_hair = -1, facial_hair_opacity = 1.0, facial_hair_colour = 0, chest_hair = -1, chest_hair_opacity = 1.0, chest_hair_colour = 0, make_up = -1, make_up_opacity = 1.0, make_up_colour = 0, blush = -1, blush_opacity = 1.0, blush_colour = 0, lipstick = -1, lipstick_opacity = 1.0, lipstick_colour = 0, blemish = -1, blemish_opacity = 1.0, body_blemish = -1, body_blemish_opacity = 1.0, ageing = -1, ageing_opacity = 1.0, complexion = -1, complexion_opacity = 1.0, sun_damage = -1, sun_damage_opacity = 1.0, moles = -1, moles_opacity = 0 },
        clothing = { mask_style = -1, mask_texture = 0, jacket_style = -1, jacket_texture = 0, shirt_style = 10, shirt_texture = -1, vest_style = -1, vest_texture = 0, legs_style = 15, legs_texture = 0, shoes_style = 5, shoes_texture = 0, hands_style = 15, hands_texture = 0, bag_style = -1, bag_texture = 0, decals_style = -1, decals_texture = 0, hats_style = -1, hats_texture = 0, glasses_style = -1, glasses_texture = 0, earwear_style = -1, earwear_texture = 0, watches_style = -1, watches_texture = 0, bracelets_style = -1, bracelets_texture = 0, neck_style = -1, neck_texture = 0 },
        tattoos = { ZONE_HEAD = { name = "", label = "", hash_m = "", hash_f = "", collection = "" }, ZONE_TORSO = { name = "", label = "", hash_m = "", hash_f = "", collection = "" }, ZONE_LEFT_ARM = { name = "", label = "", hash_m = "", hash_f = "", collection = "" }, ZONE_RIGHT_ARM = { name = "", label = "", hash_m = "", hash_f = "", collection = "" }, ZONE_LEFT_LEG = { name = "", label = "", hash_m = "", hash_f = "", collection = "" }, ZONE_RIGHT_LEG = { name = "", label = "", hash_m = "", hash_f = "", collection = "" } }
    }
}

--- @module Characters

local characters = {}

if not IS_SERVER then 

    --- @section Variables

    local current_sex = "m" -- Current sex of the player, used to determine specific appearance settings.
    local preview_ped = (current_sex == "m") and "mp_m_freemode_01" or "mp_f_freemode_01" -- Model identifier for the preview ped.
    local cam = nil -- Camera object for viewing the ped.
    local default_styles = TABLES.deep_copy(ped_styles) -- Store default styles for resets.

    --- @section Helper Functions

    --- Apply an overlay to the ped.
    --- @param player PlayerPedId(): The players ped instance.
    --- @param overlay table: Overlay configuration containing index, style, opacity, and color keys.
    --- @param barber_data table: Barber data containing overlay values.
    local function apply_overlay(player, overlay, barber_data)
        local style = tonumber(barber_data[overlay.style]) or 0
        local opacity = (tonumber(barber_data[overlay.opacity]) or 0) / 100

        SetPedHeadOverlay(player, overlay.index, style, opacity)

        if overlay.colour then
            local colour = tonumber(barber_data[overlay.colour])
            if colour then
                SetPedHeadOverlayColor(player, overlay.index, 1, colour, colour)
            else
                DEBUG.print("err", "Invalid overlay colour for " .. overlay.style)
            end
        end
    end

    --- Apply a clothing item to the ped.
    --- @param player PlayerPedId(): The players ped instance.
    --- @param item table: Clothing item configuration containing index, style, and texture keys.
    --- @param clothing_data table: Clothing data containing item values.
    local function apply_clothing(player, item, clothing_data)

        local style = tonumber(clothing_data[item.style]) or -1
        local texture = tonumber(clothing_data[item.texture]) or 0

        if style >= 0 then
            if item.is_prop then
                SetPedPropIndex(player, item.index, style, texture, true)
            else
                SetPedComponentVariation(player, item.index, style, texture, 0)
            end
        end
    end

    --- Apply tattoos to the ped.
    --- @param player PlayerPedId(): The players ped instance.
    --- @param tattoos table: Table of tattoo data containing zones and tattoo info.
    --- @param sex string: The sex of the ped ("m" or "f").
    local function apply_tattoos(player, tattoos, sex)
        if not tattoos then DEBUG.print("err", "No tattoo data found in character data.") return end

        for zone, tattoo_info in pairs(tattoos) do
            if tattoo_info and tattoo_info.name and tattoo_info.name ~= "none" then
                local tattoo_hash = sex == "m" and GetHashKey(tattoo_info.hash_m) or GetHashKey(tattoo_info.hash_f)
                if tattoo_hash and tattoo_info.collection then
                    SetPedDecoration(player, GetHashKey(tattoo_info.collection), tattoo_hash)
                else
                    DEBUG.print("err", "Invalid tattoo hash or collection in zone: " .. zone)
                end
            end
        end
    end

    --- @section Module Functions

    --- Retreives updated style data.
    --- @param sex: Sex of ped to retrieve correct style.
    local function get_style(sex)
        if not sex then return false end
        return ped_styles[sex]
    end

    --- Reset styles to defaults.
    local function reset_styles()
        ped_styles = default_styles
    end

    --- Gets clothing and prop values for UI inputs.
    --- @param sex string: The sex of the current ped model ("m" or "f").
    --- @return table: A table with the maximum values for each clothing and prop item.
    local function get_clothing_and_prop_values(sex)
        if not sex == "m" or not sex == "f" then DEBUG.print("err", "Function: get_clothing_and_prop_values failed | Reason: Invalid parameters for sex. - Use m or f only.") return end
        local data = ped_styles[sex]

        local values = {
            hair = GetNumberOfPedDrawableVariations(PlayerPedId(), 2) - 1,
            fade = GetNumberOfPedTextureVariations(PlayerPedId(), 2, tonumber(data.barber.hair)) - 1,
            eyebrow = GetPedHeadOverlayNum(2) - 1,
            mask = GetNumberOfPedDrawableVariations(PlayerPedId(), 1) - 1,
            mask_texture = GetNumberOfPedTextureVariations(PlayerPedId(), 1, tonumber(data.clothing.mask_style) - 1)
        }

        return values
    end

    --- Set ped hair, makeup, genetics, and clothing etc.
    --- @param player PlayerPedId(): The players ped instance.
    --- @param data table: The data object containing appearance settings for genetics, hair, makeup, tattoos, and clothing.
    local function set_ped_appearance(player, data)
        if not player or not data then DEBUG.print("err", "Function: set_ped_appearance failed | Reason: Missing required parameters (player or data).") return end

        local genetics = data.genetics
        SetPedHeadBlendData(player, genetics.mother, genetics.father, nil, genetics.mother, genetics.father, nil, genetics.resemblence, genetics.skin, nil, true)
        SetPedEyeColor(player, genetics.eye_colour)

        local barber = data.barber
        SetPedComponentVariation(player, 2, barber.hair, 0, 0)
        SetPedHairColor(barber.hair_colour, barber.highlight_colour)

        for _, feature in ipairs(FACIAL_FEATURES) do
            SetPedFaceFeature(player, feature.id, tonumber(genetics[feature.value]) or 0)
        end

        for _, overlay in ipairs(OVERLAYS) do
            apply_overlay(player, overlay, barber)
        end

        for _, item in ipairs(CLOTHING_ITEMS) do
            apply_clothing(player, item, data.clothing)
        end

        ClearPedDecorations(player)

        apply_tattoos(player, data.tattoos, data.sex)

        DEBUG.print("info", "Ped appearance successfully updated.")
    end

    --- Updates ped_styles with new values to be displayed on the player.
    --- @param sex string: The sex to select from creation style.
    --- @param data_type string: The type of data being updated (e.g., "genetics", "barber").
    --- @param index string: The specific index within the data type being updated.
    --- @param data table: The new values to be set.
    local function update_ped_data(sex, category, id, value)
        if not sex or not category or not id or not value then  DEBUG.print("err", "Function: update_ped_data failed | Reason: Missing one or more required parameters. - sex, category, id, or value.")  return end
        
        if id == "resemblance" or id == "skin" then
            value = value / 100
        end

        if type(ped_styles[sex][category][id]) == "table" then -- 198
            for k, _ in pairs(ped_styles[sex][category][id]) do
                ped_styles[sex][category][id][k] = value[k]
            end
        else
            ped_styles[sex][category][id] = value
        end

        current_sex = sex
        preview_ped = (sex == "m") and "mp_m_freemode_01" or "mp_f_freemode_01"

        set_ped_appearance(PlayerPedId(), ped_styles[sex])
    end

    --- Change the players ped model based on the selected sex.
    --- @param sex string: The sex of the ped model to switch to ("m" or "f").
    local function change_player_ped(sex)
        if not sex then DEBUG.print("err", "Function: change_player_ped failed. | Reason: Player sex was not provided.") return end

        current_sex = sex
        preview_ped = (sex == "m") and "mp_m_freemode_01" or "mp_f_freemode_01"

        local model = GetHashKey(preview_ped)

        REQUESTS.model(model)

        SetPlayerModel(PlayerId(), model)

        set_ped_appearance(PlayerPedId(), ped_styles[sex])
    end

    --- Rotate the players ped in a specific direction.
    --- @param direction string: The direction to rotate the ped ("right", "left", "flip", "reset").
    local function rotate_ped(direction)
        if not direction then return DEBUG.print("err", "Function: rotate_ped failed. | Reason: Direction parameter is missing.") end

        local player_ped = PlayerPedId()
        local current_heading = GetEntityHeading(player_ped)
        original_heading = original_heading or current_heading

        local rotations = {
            right = current_heading + 45,
            left = current_heading - 45,
            flip = current_heading + 180,
            reset = original_heading
        }

        local new_heading = rotations[direction]
        if not new_heading then
            return DEBUG.print("err", "Function: rotate_ped failed. | Reason: Invalid direction parameter - Use right, left, flip, reset.")
        end

        if direction == "rotate_ped_reset" then
            original_heading = nil
        end

        SetEntityHeading(player_ped, new_heading)
    end

    --- Load and apply a character model.
    --- @function load_character_model
    --- @param data table: All the data for the players character to be set on the ped.
    local function load_character_model(data)
        if not data.identity or not data.style.genetics or not data.style.barber or not data.style.clothing or not data.style.tattoos then DEBUG.print("err", "Function: load_character_model failed. | Reason: One or more required parameters are missing.") return end

        current_sex = data.identity.sex
        
        local model = GetHashKey(preview_ped)
        if not REQUESTS.model(model) then DEBUG.print("err", "Function: load_character_model failed. | Reason: Failed to request model: " .. preview_ped) return end

        local player_id = PlayerId()
        local player_ped = PlayerPedId()

        SetPlayerModel(player_id, model)
        SetPedComponentVariation(player_ped, 0, 0, 0, 1)

        ped_styles[current_sex].genetics = data.style.genetics
        ped_styles[current_sex].barber = data.style.barber
        ped_styles[current_sex].clothing = data.style.clothing
        ped_styles[current_sex].tattoos = data.style.tattoos

        set_ped_appearance(player_ped, ped_styles[current_sex])
    end

    --- @section Functions Assignments

    characters.get_style = get_style
    characters.reset_styles = reset_styles
    characters.get_clothing_and_prop_values = get_clothing_and_prop_values
    characters.set_ped_appearance = set_ped_appearance
    characters.update_ped_data = update_ped_data
    characters.change_player_ped = change_player_ped
    characters.rotate_ped = rotate_ped
    characters.load_character_model = load_character_model

    --- @section Exports

    exports("get_style", get_style)
    exports("reset_styles", reset_styles)
    exports("get_clothing_and_prop_values", get_clothing_and_prop_values)
    exports("set_ped_appearance", set_ped_appearance)
    exports("update_ped_data", update_ped_data)
    exports("change_player_ped", change_player_ped)
    exports("rotate_ped", rotate_ped)
    exports("load_character_model", load_character_model)

end

return characters