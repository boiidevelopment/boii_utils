----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    DRAWING UTILITIES
]]

-- Draws text on the screen
-- Usage: 
--[[
    utils.draw.text({
        coords = vector3(0.5, 0.5, 0.0),
        content = 'Hello World',
        scale = 1.0,
        colour = {255, 0, 0, 255},
        font = 0,
        alignment = 'center', -- options: 'left', 'center', 'right'
        drop_shadow = {0, 0, 0, 0, 255},
        text_edge = {2, 0, 0, 0, 150},
        local mode = '2d' -- '2d', '3d'
    })
]]
local function text(params)
    local coords = params.coords or vector3(0.5, 0.5, 0.0)
    local content = params.content or ""
    local scale = params.scale or 1.0
    local colour = params.colour or {255, 255, 255, 255}
    local font = params.font or 0
    local alignment = params.alignment or 'left'
    local drop_shadow = params.drop_shadow or {0, 0, 0, 0, 255}
    local text_edge = params.text_edge or {2, 0, 0, 0, 150}
    local mode = params.mode or '2d'
    if alignment == 'center' then
        SetTextCentre(true)
    elseif alignment == 'right' then
        SetTextRightJustify(true)
        SetTextWrap(0.0, coords.x)
    end
    SetTextFont(font)
    SetTextProportional(1)
    SetTextColour(table.unpack(colour))
    SetTextDropShadow(table.unpack(drop_shadow))
    SetTextEdge(table.unpack(text_edge))
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(content)
    if mode == '2d' then
        SetTextScale(scale, scale)
        DrawText(coords.x, coords.y)
    elseif mode == '3d' then
        local cam_coords = GetGameplayCamCoords()
        local dist = #(cam_coords - coords)
        local fov = (1 / GetGameplayCamFov()) * 100
        local scale_multiplier = scale * fov * (1 / dist) * 2
        SetTextScale(0.0 * scale_multiplier, 0.55 * scale_multiplier)
        SetDrawOrigin(coords.x, coords.y, coords.z, 0)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
    end
end

-- Draws a line between two points
-- Usage: 
--[[
    utils.draw.line({
        start_pos = vector3(0,0,0),
        end_pos = vector3(10,10,10),
        colour = {255,0,0,255}
    })
]]
local function line(params)
    local start_pos = params.start_pos
    local end_pos = params.end_pos
    local colour = params.colour or {255, 255, 255, 255}
    if not start_pos or not end_pos then
        return utils.debugging.warn("Invalid vector3 coordinates provided to utils.draw.line function.")
    end
    DrawLine(start_pos.x, start_pos.y, start_pos.z, end_pos.x, end_pos.y, end_pos.z, table.unpack(colour))
end

-- Draws a 2D line on the screen
-- Usage: 
--[[
    utils.draw.line_2d({
        start_pos = {x = 0.1, y = 0.1},
        end_pos = {x = 0.9, y = 0.1},
        width = 0.05,
        colour = {255, 0, 0, 255}
    })
]]
local function line_2d(params)
    local start_pos = params.start_pos
    local end_pos = params.end_pos
    local width = params.width
    local colour = params.colour or {255, 255, 255, 255}
    if not start_pos or not start_pos.x or not start_pos.y or not end_pos or not end_pos.x or not end_pos.y then
        return utils.debugging.warn("Invalid 2D coordinates provided to utils.draw.line_2d function.")
    end
    DrawLine_2d(start_pos.x, start_pos.y, end_pos.x, end_pos.y, width, table.unpack(colour))
end

-- Draws a 3D marker in the world
-- Usage:
--[[
    utils.draw.marker({
        type = 1,
        coords = vector3(0.0, 0.0, 0.0),
        dir = vector3(0.0, 0.0, 1.0),
        rot = vector3(0.0, 0.0, 0.0),
        scale = vector3(1.0, 1.0, 1.0),
        colour = {255, 0, 0, 255},
        bob = false,
        face_cam = false,
        p19 = 2,
        rotate = false,
        texture_dict = nil,
        texture_name = nil,
        draw_on_ents = false
    })
]]
local function marker(params)
    local coords = params.coords or vector3(0.0, 0.0, 0.0)
    local dir = params.dir or vector3(0.0, 0.0, 1.0)
    local rot = params.rot or vector3(0.0, 0.0, 0.0)
    local scale = params.scale or vector3(1.0, 1.0, 1.0)
    local colour = params.colour or {255, 0, 0, 255}
    DrawMarker(params.type, coords.x, coords.y, coords.z, dir.x, dir.y, dir.z, rot.x, rot.y, rot.z, scale.x, scale.y, scale.z, colour[1], colour[2], colour[3], colour[4], params.bob, params.face_cam, params.p19, params.rotate, params.texture_dict, params.texture_name, params.draw_on_ents)
end

-- Plays and draws a BINK movie on the screen until completion.
-- Usage: 
--[[
    utils.draw.movie({
        bink = binkint, 
        coords = {x = 0.5, y = 0.5}, 
        scale = {x = 1.0, y = 1.0}, 
        rotation = 0.0, 
        colour = {255, 255, 255, 255}
    })
]]
local function movie(params)
    local bink = params.bink
    local coords = params.coords or {x = 0.5, y = 0.5}
    local scale = params.scale or {x = 1.0, y = 1.0}
    local rotation = params.rotation or 0.0
    local colour = params.colour or {255, 255, 255, 255}
    CreateThread(function()
        SetBinkMovieTime(bink, 0.0) -- Seeks to 0%, just in case of errors.
        while (GetBinkMovieTime(bink) < 100.0) do
            PlayBinkMovie(bink)
            DrawBinkMovie(bink, coords.x, coords.y, scale.x, scale.y, rotation, table.unpack(colour))
            Wait(0)
        end
    end)
end

-- Draws a 3D box between two points
-- Usage: 
--[[
    utils.draw.box({
        start_coords = vector3(0, 0, 0), 
        end_coords = vector3(10, 10, 10), 
        colour = {255, 0, 0, 255}
    })
]]
local function box(params)
    local start_coords = params.start_coords
    local end_coords = params.end_coords
    local colour = params.colour or {255, 255, 255, 255}
    if not start_coords or not end_coords then
        return utils.debugging.warn("Invalid vector3 coordinates provided to utils.draw.box function.")
    end
    DrawBox(start_coords.x, start_coords.y, start_coords.z, end_coords.x, end_coords.y, end_coords.z, table.unpack(colour))
end

-- Draws a rotated 3D box using lines between the calculated corners after rotation
-- Usage:
--[[
    local center = vector3(0, 0, 0) -- The center of the box
    local width = 5.0 -- The width of the box
    local length = 10.0 -- The length of the box
    local heading = 45.0 -- The heading for the box rotation in degrees
    local colour = {255, 0, 0, 255} -- RGBA color for the box lines
    local rotated_corners = rotate_box(center, width, length, heading)
    draw_rotated_box(rotated_corners, colour)
]]
local function draw_rotated_box(corners, colour)
    if not (type(corners) == 'table' and #corners > 0) then
        return utils.debugging.warn("Invalid corners table provided to utils.draw.draw_rotated_box function.")
    end
    if not (type(colour) == 'table' and #colour == 4) then
        return utils.debugging.warn("Invalid colour table provided to utils.draw.draw_rotated_box function.")
    end
    for i=1, #corners do
        local next_index = i % #corners + 1
        DrawLine(corners[i].x, corners[i].y, corners[i].z, corners[next_index].x, corners[next_index].y, corners[next_index].z, colour[1], colour[2], colour[3], colour[4])
    end
end

-- Draws a 3D cuboid around a point in space based on given dimensions and heading
-- Usage:
--[[
    local center = vector3(0, 0, 0) -- The center of the cuboid
    local dimensions = {width = 5.0, length = 10.0, height = 3.0} -- example dimensions
    local heading = 45.0 -- The heading for the cuboid in degrees
    local colour = {255, 0, 0, 255} -- RGBA color for the cuboid edges
    draw_3d_cuboid(center, dimensions, heading, colour)
]]
local function draw_3d_cuboid(center, dimensions, heading, colour)
    if not center or not dimensions or not colour then
        return utils.debugging.warn("Invalid parameters provided to utils.draw.draw_3d_cuboid function.")
    end
    local bottom_center = vector3(center.x, center.y, center.z - dimensions.height / 2)
    local bottom_corners = utils.geometry.rotate_box(bottom_center, dimensions.width, dimensions.length, heading)
    local top_corners = {}
    for i, corner in ipairs(bottom_corners) do
        top_corners[i] = vector3(corner.x, corner.y, corner.z + dimensions.height)
    end
    draw_rotated_box(bottom_corners, colour)
    draw_rotated_box(top_corners, colour)
    for i=1, #bottom_corners do
        DrawLine(bottom_corners[i].x, bottom_corners[i].y, bottom_corners[i].z,
                 top_corners[i].x, top_corners[i].y, top_corners[i].z,
                 colour[1], colour[2], colour[3], colour[4])
    end
end

-- Draws an interactive sprite on the screen
-- Usage:
--[[
    utils.draw.interactive_sprite({
        texture_dict = "prop_screen_biker_laptop", 
        texture_name = "example_texture_name",
        coords = vector3(0.5, 0.5, 0.0),
        size = {width = 1.0, height = 1.0},
        rotation = 0.0,
        colour = {255, 255, 255, 255}
    })
]]
local function interactive_sprite(params)
    local texture_dict = params.texture_dict
    local texture_name = params.texture_name
    local coords = params.coords or vector3(0.5, 0.5, 0.0)
    local size = params.size or {width = 1.0, height = 1.0}
    local rotation = params.rotation or 0.0
    local colour = params.colour or {255, 255, 255, 255}
    if not texture_dict or not texture_name then
        return utils.debugging.warn("Invalid texture dictionary or name provided to utils.draw.interactive_sprite function.")
    end
    utils.requests.texture(texture_dict, true)
    DrawInteractiveSprite(texture_dict, texture_name, coords.x, coords.y, size.width, size.height, rotation, table.unpack(colour))
end

-- Draws a light with a specified range, with an optional shadow
-- Usage:
--[[
    utils.draw.light({
        coords = vector3(0.0, 0.0, 0.0),
        colour = {255, 255, 255},
        range = 10.0,
        intensity = 1.0,
        shadow = 2.5 -- optional
    })
]]
local function light(params)
    local coords = params.coords or vector3(0.0, 0.0, 0.0)
    local colour = params.colour or {255, 255, 255}
    local range = params.range or 10.0
    local intensity = params.intensity or 1.0    
    if params.shadow then
        local shadow = params.shadow or 2.5
        DrawLightWithRangeAndShadow(coords.x, coords.y, coords.z, colour[1], colour[2], colour[3], range, intensity, shadow)
    else
        DrawLightWithRange(coords.x, coords.y, coords.z, colour[1], colour[2], colour[3], range, intensity)
    end
end

-- Draws a polygon in the world
-- Usage:
--[[
    utils.draw.poly({
        vertex1 = vector3(0.0, 0.0, 0.0),
        vertex2 = vector3(10.0, 10.0, 0.0),
        vertex3 = vector3(20.0, 0.0, 0.0),
        colour = {255, 0, 0, 255}
    })
]]
local function poly(params)
    local vertex1 = params.vertex1 or vector3(0.0, 0.0, 0.0)
    local vertex2 = params.vertex2 or vector3(0.0, 0.0, 0.0)
    local vertex3 = params.vertex3 or vector3(0.0, 0.0, 0.0)
    local colour = params.colour or {255, 0, 0, 255}
    DrawPoly(vertex1.x, vertex1.y, vertex1.z, vertex2.x, vertex2.y, vertex2.z, vertex3.x, vertex3.y, vertex3.z, colour[1], colour[2], colour[3], colour[4])
end

-- Draws a rectangle on the screen
-- Usage: 
--[[
    utils.draw.rect({
        coords = vector2(0.0, 0.0),
        width = 0.1,
        height = 0.05,
        colour = {255, 0, 0, 255}
    })
]]
local function rect(params)
    local coords = params.coords or vector2(0.0, 0.0)
    local width = params.width or 0.1
    local height = params.height or 0.05
    local colour = params.colour or {255, 255, 255, 255}
    DrawRect(coords.x, coords.y, width, height, table.unpack(colour))
end

-- Draws a Scaleform movie
-- Usage:
--[[
    utils.draw.scaleform_movie({
        mode = "fullscreen", -- "3d", "3d_solid", "fullscreen", "fullscreen_masked"
        scaleform = scaleformHandle,
        coords = vector3(0.5, 0.5, 0.0), -- Only for 3d and 3d_solid
        rotation = vector3(0.0, 0.0, 0.0), -- Only for 3d and 3d_solid
        scale = vector3(1.0, 1.0, 1.0), -- Only for 3d and 3d_solid
        colour = {255, 255, 255, 255},
        width = 1.0, -- Only for default mode
        height = 1.0, -- Only for default mode
        sharpness = 15.0, -- Only for 3d and 3d_solid
        scale_form_mask = scaleformHandle2 -- Only for fullscreen_masked
    })
]]
local function scaleform_movie(params)
    local mode = params.mode or "fullscreen"
    local scaleform = params.scaleform
    local colour = params.colour or {255, 255, 255, 255}
    if mode == "3d" or mode == "3d_solid" then
        local coords = params.coords or vector3(0.0, 0.0, 0.0)
        local rotation = params.rotation or vector3(0.0, 0.0, 0.0)
        local scale = params.scale or vector3(1.0, 1.0, 1.0)
        local sharpness = params.sharpness or 15.0
        if mode == "3d" then
            DrawScaleformMovie_3d(scaleform, coords.x, coords.y, coords.z, rotation.x, rotation.y, rotation.z, 2.0, sharpness, 2.0, scale.x, scale.y, scale.z, 2)
        else
            DrawScaleformMovie_3dSolid(scaleform, coords.x, coords.y, coords.z, rotation.x, rotation.y, rotation.z, 2.0, sharpness, 2.0, scale.x, scale.y, scale.z, 2)
        end
    elseif mode == "fullscreen" then
        local width = params.width or 1.0
        local height = params.height or 1.0
        DrawScaleformMovie(scaleform, 0.5, 0.5, width, height, colour[1], colour[2], colour[3], colour[4], 0)
    elseif mode == "fullscreen_masked" then
        local scale_form_mask = params.scale_form_mask
        DrawScaleformMovieFullscreenMasked(scaleform, scale_form_mask, colour[1], colour[2], colour[3], colour[4])
    end
end

-- Draws a showroom
-- Usage:
--[[
    utils.draw.showroom({
        p0 = "CELEBRATION_WINNER",
        ped = PlayerPedId(),
        p2 = 0,
        coords = vector3(0.5, 0.5, 0.0)
    })
]]
local function showroom(params)
    local p0 = params.p0 or "CELEBRATION_WINNER"
    local ped = params.ped or PlayerPedId()
    local p2 = params.p2 or 0
    local coords = params.coords or vector3(0.5, 0.5, 0.0)
    DrawShowroom(params.p0, params.ped, params.p2, params.coords.x, params.coords.y, params.coords.z)
end

-- Draws a sphere
-- Usage:
--[[
    utils.draw.sphere({
        coords = vector3(0.5, 0.5, 0.0),
        radius = 1.0,
        colour = {255, 0, 0, 255},
        opacity = 1.0
    })
]]
local function sphere(params)
    local coords = params.coords or vector3(0.5, 0.5, 0.0)
    local radius = params.radius or 1.0
    local colour = params.colour or {255, 0, 0, 255}

    -- Convert opacity from 0-255 range to 0.0-1.0 range
    local opacity = (colour[4] / 255)

    -- Ensure opacity is within the 0.0 to 1.0 range
    opacity = math.min(math.max(opacity, 0.0), 1.0)

    DrawSphere(coords.x, coords.y, coords.z, radius, colour[1], colour[2], colour[3], opacity)
end


-- Draws a spotlight, with or without shadow based on provided parameters
-- Usage without shadow:
--[[
    utils.draw.spot_light({
        coords = vector3(0.5, 0.5, 0.0),
        direction = vector3(1.0, 0.0, 0.0),
        colour = {255, 0, 0},
        distance = 100.0,
        brightness = 1.0,
        hardness = 0.0,
        radius = 13.0,
        falloff = 1.0,
        -- shadow_id = 0 -- optional
    })
]]
local function spot_light(params)
    local coords = params.coords or vector3(0.5, 0.5, 0.0)
    local direction = params.direction or vector3(1.0, 0.0, 0.0)
    local colour = params.colour or {255, 0, 0}
    local distance = params.distance or 100.0
    local brightness = params.brightness or 1.0
    local hardness = params.hardness or 0.0
    local radius = params.radius or 13.0
    local falloff = params.falloff or 1.0
    if params.shadow_id then
        DrawSpotLightWithShadow(params.coords.x, params.coords.y, params.coords.z, params.direction.x, params.direction.y, params.direction.z, params.colour[1], params.colour[2], params.colour[3], params.distance, params.brightness, params.roundness, params.radius, params.falloff, params.shadow_id)
    else
        DrawSpotLight(params.coords.x, params.coords.y, params.coords.z, params.direction.x, params.direction.y, params.direction.z, params.colour[1], params.colour[2], params.colour[3], params.distance, params.brightness, params.hardness, params.radius, params.falloff)
    end
end

-- Draws a 2D sprite on the screen
-- Usage:
--[[
    utils.draw.sprite({
        texture_dict = "CommonMenu",
        texture_name = "last_team_standing_icon",
        coords = vector2(0.5, 0.5),
        size = {width = 1.0, height = 1.0},
        rotation = 0.0,
        colour = {255, 255, 255, 255}
    })
]]
local function sprite(params)
    local texture_dict = params.texture_dict or "CommonMenu"
    local texture_name = params.texture_name or "last_team_standing_icon"
    local coords = params.coords or vector2(0.5, 0.5)
    local size = params.size or {width = 1.0, height = 1.0}
    local rotation = params.rotation or 0.0
    local colour = params.colour or {255, 255, 255, 255}
    DrawSprite(texture_dict, texture_name, coords.x, coords.y, size.width, size.height, rotation, table.unpack(colour))
end

-- Draws a sprite polygon in the world
-- Usage:
--[[
    utils.draw.sprite_poly({
        vertices = {vector3(0.0, 0.0, 0.0), vector3(10.0, 10.0, 0.0), vector3(20.0, 0.0, 0.0)},
        colour = {255, 0, 0, 255},
        texture_dict = "deadline",
        texture_name = "deadline_trail",
        UVW = {{0.0, 0.0, 0.0}, {1.0, 1.0, 1.0}, {0.5, 0.5, 0.5}}
    })
]]
local function sprite_poly(params)
    local vertices = params.vertices or {vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0)}
    local colour = params.colour or {255, 0, 0, 255}
    local texture_dict = params.texture_dict or "deadline"
    local texture_name = params.texture_name or "deadline_trail"
    local UVW = params.UVW or {{0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}}
    DrawSpritePoly(vertices[1].x, vertices[1].y, vertices[1].z, vertices[2].x, vertices[2].y, vertices[2].z, vertices[3].x, vertices[3].y, vertices[3].z, colour[1], colour[2], colour[3], colour[4], texture_dict, texture_name, UVW[1][1], UVW[1][2], UVW[1][3], UVW[2][1], UVW[2][2], UVW[2][3], UVW[3][1], UVW[3][2], UVW[3][3])
end

-- Draws a sprite polygon in the world with individual vertex colors
-- Usage:
--[[
    utils.draw.sprite_poly2({
        vertices = {vector3(0.0, 0.0, 0.0), vector3(10.0, 10.0, 0.0), vector3(20.0, 0.0, 0.0)},
        colours = {{255, 0, 0, 255}, {0, 255, 0, 255}, {0, 0, 255, 255}},
        texture_dict = "deadline",
        texture_name = "deadline_trail",
        UVW = {{0.0, 0.0, 0.0}, {1.0, 1.0, 1.0}, {0.5, 0.5, 0.5}}
    })
]]
local function sprite_poly2(params)
    local vertices = params.vertices or {vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0)}
    local colours = params.colours or {{255, 255, 255, 255}, {255, 255, 255, 255}, {255, 255, 255, 255}}
    local texture_dict = params.texture_dict or "deadline"
    local texture_name = params.texture_name or "deadline_trail"
    local UVW = params.UVW or {{0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}}
    DrawSpritePoly_2(vertices[1].x, vertices[1].y, vertices[1].z, vertices[2].x, vertices[2].y, vertices[2].z, vertices[3].x, vertices[3].y, vertices[3].z, colours[1][1], colours[1][2], colours[1][3], colours[1][4], colours[2][1], colours[2][2], colours[2][3], colours[2][4], colours[3][1], colours[3][2], colours[3][3], colours[3][4], texture_dict, texture_name, UVW[1][1], UVW[1][2], UVW[1][3], UVW[2][1], UVW[2][2], UVW[2][3], UVW[3][1], UVW[3][2], UVW[3][3])
end

-- Draws a 2D sprite with specific UV coordinates on the screen
-- Usage:
--[[
    utils.draw.sprite_uv({
        texture_dict = "CommonMenu",
        texture_name = "last_team_standing_icon",
        coords = vector2(0.5, 0.5),
        size = {width = 1.0, height = 1.0},
        uv_coords = {top_left = {u = 0.0, v = 0.0}, bottom_right = {u = 1.0, v = 1.0}},
        rotation = 0.0,
        colour = {255, 255, 255, 255}
    })
]]
local function sprite_uv(params)
    local texture_dict = params.texture_dict or "CommonMenu"
    local texture_name = params.texture_name or "last_team_standing_icon"
    local coords = params.coords or vector2(0.5, 0.5)
    local size = params.size or {width = 1.0, height = 1.0}
    local uv_coords = params.uv_coords or {top_left = {u = 0.0, v = 0.0}, bottom_right = {u = 1.0, v = 1.0}}
    local rotation = params.rotation or 0.0
    local colour = params.colour or {255, 255, 255, 255}
    DrawSpriteUv(texture_dict, texture_name, coords.x, coords.y, size.width, size.height, uv_coords.top_left.u, uv_coords.top_left.v, uv_coords.bottom_right.u, uv_coords.bottom_right.v, rotation, table.unpack(colour))
end

-- Draws a TV channel on the screen
-- Usage:
--[[
    utils.draw.tv_channel({
        coords = vector2(0.5, 0.5),
        size = {width = 1.0, height = 1.0},
        rotation = 0.0,
        colour = {255, 255, 255, 255}
    })
]]
local function tv_channel(params)
    local coords = params.coords or vector2(0.5, 0.5)
    local size = params.size or {width = 1.0, height = 1.0}
    local rotation = params.rotation or 0.0
    local colour = params.colour or {255, 255, 255, 255}
    DrawTvChannel(coords.x, coords.y, size.width, size.height, rotation, table.unpack(colour))
end

--[[
    ASSIGN LOCALS
]]

utils.draw = utils.draw or {}

utils.draw.text = text
utils.draw.line = line
utils.draw.line_2d = line_2d
utils.draw.marker = marker
utils.draw.movie = movie
utils.draw.box = box
utils.draw.draw_rotated_box = draw_rotated_box
utils.draw.draw_3d_cuboid = draw_3d_cuboid
utils.draw.interactive_sprite = interactive_sprite
utils.draw.light = light
utils.draw.poly = poly
utils.draw.rect = rect
utils.draw.scaleform_movie = scaleform_movie
utils.draw.showroom = showroom
utils.draw.sphere = sphere
utils.draw.spot_light = spot_light
utils.draw.sprite = sprite
utils.draw.sprite_poly = sprite_poly
utils.draw.sprite_poly2 = sprite_poly2
utils.draw.sprite_uv = sprite_uv
utils.draw.tv_channel = tv_channel
