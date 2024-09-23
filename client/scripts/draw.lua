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

--- Draw functions.
--- @script client/scripts/draw.lua

--- @section Local functions

--- Draws text on the screen with customizable properties.
--- @function text
--- @param params table: A table containing text drawing parameters.
--- @field coords vector3: Screen coordinates for the text (default: vector3(0.5, 0.5, 0.0)).
--- @field content string: The content of the text to draw.
--- @field scale number: The scale of the text (default: 1.0).
--- @field colour table: RGBA color of the text (default: {255, 255, 255, 255}).
--- @field font number: The font type to use (default: 0).
--- @field alignment string: Text alignment ('left', 'center', 'right') (default: 'left').
--- @field drop_shadow table: Drop shadow parameters (default: {0, 0, 0, 0, 255}).
--- @field text_edge table: Edge parameters (default: {2, 0, 0, 0, 150}).
--- @field mode string: Draw mode ('2d', '3d') (default: '2d').
--- @usage utils.draw.text({...})
local function text(params)
    local coords = params.coords or vector3(0.5, 0.5, 0.0)
    local content = params.content or ''
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
    SetTextEntry('STRING')
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

exports('draw_text', text)
utils.draw.text = text

--- Draws a line between two points in the world.
--- @function line
--- @param params table: A table containing line drawing parameters.
--- @field start_pos vector3: Starting position of the line.
--- @field end_pos vector3: Ending position of the line.
--- @field colour table: RGBA color of the line (default: {255, 255, 255, 255}).
--- @usage utils.draw.line({...})
local function line(params)
    local start_pos = params.start_pos
    local end_pos = params.end_pos
    local colour = params.colour or {255, 255, 255, 255}
    if not start_pos or not end_pos then
        return utils.debug.warn('Invalid vector3 coordinates provided to utils.draw.line function.')
    end
    DrawLine(start_pos.x, start_pos.y, start_pos.z, end_pos.x, end_pos.y, end_pos.z, table.unpack(colour))
end

exports('draw_line', line)
utils.draw.line = line

--- Draws a 2D line on the screen.
--- @function line_2d
--- @param params table: A table containing 2D line drawing parameters.
--- @field start_pos table: Starting position of the line on the screen (x, y).
--- @field end_pos table: Ending position of the line on the screen (x, y).
--- @field width number: The width of the line.
--- @field colour table: RGBA color of the line (default: {255, 255, 255, 255}).
--- @usage utils.draw.line_2d({...})
local function line_2d(params)
    local start_pos = params.start_pos
    local end_pos = params.end_pos
    local width = params.width
    local colour = params.colour or {255, 255, 255, 255}
    if not start_pos or not start_pos.x or not start_pos.y or not end_pos or not end_pos.x or not end_pos.y then
        return utils.debug.warn('Invalid 2D coordinates provided to utils.draw.line_2d function.')
    end
    DrawLine_2d(start_pos.x, start_pos.y, end_pos.x, end_pos.y, width, table.unpack(colour))
end

exports('draw_line_2d', line_2d)
utils.draw.line_2d = line_2d

--- Draws a 3D marker in the world.
--- @function marker
--- @param params table: A table containing marker drawing parameters.
--- @field type number: The type of marker to draw.
--- @field coords vector3: Position of the marker.
--- @field dir vector3: Direction of the marker.
--- @field rot vector3: Rotation of the marker.
--- @field scale vector3: Scale of the marker.
--- @field colour table: RGBA color of the marker (default: {255, 0, 0, 255}).
--- @field bob boolean: Whether the marker should bob up and down.
--- @field face_cam boolean: Whether the marker should face the camera.
--- @field p19 number: Unknown parameter, often used as 2.
--- @field rotate boolean: Whether the marker should rotate.
--- @field texture_dict string: Texture dictionary for the marker (optional).
--- @field texture_name string: Texture name for the marker (optional).
--- @field draw_on_ents boolean: Whether the marker should be drawn on entities.
--- @usage utils.draw.marker({...})
local function marker(params)
    local coords = params.coords or vector3(0.0, 0.0, 0.0)
    local dir = params.dir or vector3(0.0, 0.0, 1.0)
    local rot = params.rot or vector3(0.0, 0.0, 0.0)
    local scale = params.scale or vector3(1.0, 1.0, 1.0)
    local colour = params.colour or {255, 0, 0, 255}
    DrawMarker(params.type, coords.x, coords.y, coords.z, dir.x, dir.y, dir.z, rot.x, rot.y, rot.z, scale.x, scale.y, scale.z, colour[1], colour[2], colour[3], colour[4], params.bob, params.face_cam, params.p19, params.rotate, params.texture_dict, params.texture_name, params.draw_on_ents)
end

exports('draw_marker', marker)
utils.draw.marker = marker

--- Plays and draws a BINK movie on the screen until completion.
--- @function movie
--- @param params table: A table containing movie drawing parameters.
--- @field bink number: The handle of the BINK movie.
--- @field coords table: Screen coordinates for the movie (x, y).
--- @field scale table: Scale of the movie (width, height).
--- @field rotation number: Rotation of the movie.
--- @field colour table: RGBA color of the movie (default: {255, 255, 255, 255}).
--- @usage utils.draw.movie({...})
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

exports('draw_movie', movie)
utils.draw.movie = movie

--- Draws a 3D box between two points.
--- @function box
--- @param params table: A table containing box drawing parameters.
--- @field start_coords vector3: Starting coordinates of the box.
--- @field end_coords vector3: Ending coordinates of the box.
--- @field colour table: RGBA color of the box (default: {255, 255, 255, 255}).
--- @usage utils.draw.box({...})
local function box(params)
    local start_coords = params.start_coords
    local end_coords = params.end_coords
    local colour = params.colour or {255, 255, 255, 255}
    if not start_coords or not end_coords then
        return utils.debug.warn('Invalid vector3 coordinates provided to utils.draw.box function.')
    end
    DrawBox(start_coords.x, start_coords.y, start_coords.z, end_coords.x, end_coords.y, end_coords.z, table.unpack(colour))
end

exports('draw_box', box)
utils.draw.box = box

--- Draws a rotated 3D box using lines between the calculated corners after rotation.
--- @function draw_rotated_box
--- @param corners table: A table of corner points of the box.
--- @param colour table: RGBA color for the box lines (default: {255, 255, 255, 255}).
--- @usage utils.draw.draw_rotated_box(corners, colour)
local function draw_rotated_box(corners, colour)
    if not (type(corners) == 'table' and #corners > 0) then
        return utils.debug.warn('Invalid corners table provided to utils.draw.draw_rotated_box function.')
    end
    if not (type(colour) == 'table' and #colour == 4) then
        return utils.debug.warn('Invalid colour table provided to utils.draw.draw_rotated_box function.')
    end
    for i=1, #corners do
        local next_index = i % #corners + 1
        DrawLine(corners[i].x, corners[i].y, corners[i].z, corners[next_index].x, corners[next_index].y, corners[next_index].z, colour[1], colour[2], colour[3], colour[4])
    end
end

exports('draw_rotated_box', draw_rotated_box)
utils.draw.draw_rotated_box = draw_rotated_box

--- Draws a 3D cuboid around a point in space based on given dimensions and heading.
--- @function draw_3d_cuboid
--- @param center vector3: The center of the cuboid.
--- @param dimensions table: The dimensions of the cuboid (width, length, height).
--- @param heading number: The heading for the cuboid in degrees.
--- @param colour table: RGBA color for the cuboid edges (default: {255, 255, 255, 255}).
--- @usage utils.draw.draw_3d_cuboid(center, dimensions, heading, colour)
local function draw_3d_cuboid(center, dimensions, heading, colour)
    if not center or not dimensions or not colour then
        return utils.debug.warn('Invalid parameters provided to utils.draw.draw_3d_cuboid function.')
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
        DrawLine(bottom_corners[i].x, bottom_corners[i].y, bottom_corners[i].z, top_corners[i].x, top_corners[i].y, top_corners[i].z, colour[1], colour[2], colour[3], colour[4])
    end
end

exports('draw_3d_cuboid', draw_3d_cuboid)
utils.draw.draw_3d_cuboid = draw_3d_cuboid

--- Draws an interactive sprite on the screen.
--- @function interactive_sprite
--- @param params table: A table containing interactive sprite drawing parameters.
--- @field texture_dict string: Texture dictionary for the sprite.
--- @field texture_name string: Texture name for the sprite.
--- @field coords vector3: Screen coordinates for the sprite.
--- @field size table: Size of the sprite (width, height).
--- @field rotation number: Rotation of the sprite.
--- @field colour table: RGBA color of the sprite (default: {255, 255, 255, 255}).
--- @usage utils.draw.interactive_sprite({...})
local function interactive_sprite(params)
    local texture_dict = params.texture_dict
    local texture_name = params.texture_name
    local coords = params.coords or vector3(0.5, 0.5, 0.0)
    local size = params.size or {width = 1.0, height = 1.0}
    local rotation = params.rotation or 0.0
    local colour = params.colour or {255, 255, 255, 255}
    if not texture_dict or not texture_name then
        return utils.debug.warn('Invalid texture dictionary or name provided to utils.draw.interactive_sprite function.')
    end
    utils.requests.texture(texture_dict, true)
    DrawInteractiveSprite(texture_dict, texture_name, coords.x, coords.y, size.width, size.height, rotation, table.unpack(colour))
end

exports('draw_interactive_sprite', interactive_sprite)
utils.draw.interactive_sprite = interactive_sprite

--- Draws a light with a specified range, with an optional shadow.
--- @function light
--- @param params table: A table containing light drawing parameters.
--- @field coords vector3: Position of the light.
--- @field colour table: RGB color of the light.
--- @field range number: Range of the light.
--- @field intensity number: Intensity of the light.
--- @field shadow number (optional): Shadow intensity of the light.
--- @usage utils.draw.light({...})
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

exports('draw_light', light)
utils.draw.light = light

--- Draws a polygon in the world.
--- @function poly
--- @param params table: A table containing polygon drawing parameters.
--- @field vertex1 vector3: First vertex of the polygon.
--- @field vertex2 vector3: Second vertex of the polygon.
--- @field vertex3 vector3: Third vertex of the polygon.
--- @field colour table: RGBA color of the polygon (default: {255, 255, 255, 255}).
--- @usage utils.draw.poly({...})
local function poly(params)
    local vertex1 = params.vertex1 or vector3(0.0, 0.0, 0.0)
    local vertex2 = params.vertex2 or vector3(0.0, 0.0, 0.0)
    local vertex3 = params.vertex3 or vector3(0.0, 0.0, 0.0)
    local colour = params.colour or {255, 0, 0, 255}
    DrawPoly(vertex1.x, vertex1.y, vertex1.z, vertex2.x, vertex2.y, vertex2.z, vertex3.x, vertex3.y, vertex3.z, colour[1], colour[2], colour[3], colour[4])
end

exports('draw_poly', poly)
utils.draw.poly = poly

--- Draws a rectangle on the screen.
--- @function rect
--- @param params table: A table containing rectangle drawing parameters.
--- @field coords vector2: Screen coordinates for the rectangle.
--- @field width number: Width of the rectangle.
--- @field height number: Height of the rectangle.
--- @field colour table: RGBA color of the rectangle (default: {255, 255, 255, 255}).
--- @usage utils.draw.rect({...})
local function rect(params)
    local coords = params.coords or vector2(0.0, 0.0)
    local width = params.width or 0.1
    local height = params.height or 0.05
    local colour = params.colour or {255, 255, 255, 255}
    DrawRect(coords.x, coords.y, width, height, table.unpack(colour))
end

exports('draw_rect', rect)
utils.draw.rect = rect

--- Draws a Scaleform movie.
--- @function scaleform_movie
--- @param params table: A table containing Scaleform movie drawing parameters.
--- @field mode string: Drawing mode ('3d', '3d_solid', 'fullscreen', 'fullscreen_masked').
--- @field scaleform number: Scaleform handle.
--- @field coords vector3 (optional): Screen coordinates for 3d and 3d_solid modes.
--- @field rotation vector3 (optional): Rotation for 3d and 3d_solid modes.
--- @field scale vector3 (optional): Scale for 3d and 3d_solid modes.
--- @field colour table: RGBA color of the movie (default: {255, 255, 255, 255}).
--- @field width number (optional): Width for fullscreen mode.
--- @field height number (optional): Height for fullscreen mode.
--- @field sharpness number (optional): Sharpness for 3d and 3d_solid modes.
--- @field scale_form_mask number (optional): Scaleform handle for mask in fullscreen_masked mode.
--- @usage utils.draw.scaleform_movie({...})
local function scaleform_movie(params)
    local mode = params.mode or 'fullscreen'
    local scaleform = params.scaleform
    local colour = params.colour or {255, 255, 255, 255}
    if mode == '3d' or mode == '3d_solid' then
        local coords = params.coords or vector3(0.0, 0.0, 0.0)
        local rotation = params.rotation or vector3(0.0, 0.0, 0.0)
        local scale = params.scale or vector3(1.0, 1.0, 1.0)
        local sharpness = params.sharpness or 15.0
        if mode == '3d' then
            DrawScaleformMovie_3d(scaleform, coords.x, coords.y, coords.z, rotation.x, rotation.y, rotation.z, 2.0, sharpness, 2.0, scale.x, scale.y, scale.z, 2)
        else
            DrawScaleformMovie_3dSolid(scaleform, coords.x, coords.y, coords.z, rotation.x, rotation.y, rotation.z, 2.0, sharpness, 2.0, scale.x, scale.y, scale.z, 2)
        end
    elseif mode == 'fullscreen' then
        local width = params.width or 1.0
        local height = params.height or 1.0
        DrawScaleformMovie(scaleform, 0.5, 0.5, width, height, colour[1], colour[2], colour[3], colour[4], 0)
    elseif mode == 'fullscreen_masked' then
        local scale_form_mask = params.scale_form_mask
        DrawScaleformMovieFullscreenMasked(scaleform, scale_form_mask, colour[1], colour[2], colour[3], colour[4])
    end
end

exports('draw_scaleform_movie', scaleform_movie)
utils.draw.scaleform_movie = scaleform_movie

--- Draws a showroom.
--- @function showroom
--- @param params table: A table containing showroom drawing parameters.
--- @field p0 string: Showroom type.
--- @field ped number: Pedestrian identifier.
--- @field p2 number: Parameter 2 for showroom.
--- @field coords vector3: Screen coordinates for the showroom.
--- @usage utils.draw.showroom({...})
local function showroom(params)
    local p0 = params.p0 or 'CELEBRATION_WINNER'
    local ped = params.ped or PlayerPedId()
    local p2 = params.p2 or 0
    local coords = params.coords or vector3(0.5, 0.5, 0.0)
    DrawShowroom(params.p0, params.ped, params.p2, params.coords.x, params.coords.y, params.coords.z)
end

exports('draw_showroom', showroom)
utils.draw.showroom = showroom

--- Draws a sphere.
--- @function sphere
--- @param params table: A table containing sphere drawing parameters.
--- @field coords vector3: Center coordinates of the sphere.
--- @field radius number: Radius of the sphere.
--- @field colour table: RGBA color of the sphere.
--- @field opacity number: Opacity of the sphere.
--- @usage utils.draw.sphere({...})
local function sphere(params)
    local coords = params.coords or vector3(0.5, 0.5, 0.0)
    local radius = params.radius or 1.0
    local colour = params.colour or {255, 0, 0, 255}
    local opacity = (colour[4] / 255)
    opacity = math.min(math.max(opacity, 0.0), 1.0)
    DrawSphere(coords.x, coords.y, coords.z, radius, colour[1], colour[2], colour[3], opacity)
end

exports('draw_sphere', sphere)
utils.draw.sphere = sphere

--- Draws a spotlight, with or without shadow based on provided parameters.
--- @function spot_light
--- @param params table: A table containing spotlight drawing parameters.
--- @field coords vector3: Position of the spotlight.
--- @field direction vector3: Direction of the spotlight.
--- @field colour table: RGB color of the spotlight.
--- @field distance number: Distance of the spotlight.
--- @field brightness number: Brightness of the spotlight.
--- @field hardness number: Hardness of the spotlight.
--- @field radius number: Radius of the spotlight.
--- @field falloff number: Falloff of the spotlight.
--- @field shadow_id number (optional): Identifier for the shadow
--- @usage utils.draw.spot_light({...})
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

exports('draw_spot_light', spot_light)
utils.draw.spot_light = spot_light

--- Draws a 2D sprite on the screen.
--- @function sprite
--- @param params table: A table containing sprite drawing parameters.
--- @field texture_dict string: Texture dictionary for the sprite.
--- @field texture_name string: Texture name for the sprite.
--- @field coords vector2: Screen coordinates for the sprite.
--- @field size table: Size of the sprite (width, height).
--- @field rotation number: Rotation of the sprite.
--- @field colour table: RGBA color of the sprite.
--- @usage utils.draw.sprite({...})
local function sprite(params)
    local texture_dict = params.texture_dict or 'CommonMenu'
    local texture_name = params.texture_name or 'last_team_standing_icon'
    local coords = params.coords or vector2(0.5, 0.5)
    local size = params.size or {width = 1.0, height = 1.0}
    local rotation = params.rotation or 0.0
    local colour = params.colour or {255, 255, 255, 255}
    DrawSprite(texture_dict, texture_name, coords.x, coords.y, size.width, size.height, rotation, table.unpack(colour))
end

exports('draw_sprite', sprite)
utils.draw.sprite = sprite

--- Draws a sprite polygon in the world, optionally with per-vertex colors.
--- @function sprite_poly
--- @param params table: A table containing sprite polygon drawing parameters.
--- @field vertices table: Vertex points of the polygon.
--- @field colour table: RGBA color of the sprite polygon, used if colours is not provided.
--- @field colours table (optional): Individual RGBA colors for each vertex.
--- @field texture_dict string: Texture dictionary for the polygon.
--- @field texture_name string: Texture name for the polygon.
--- @field UVW table: UVW coordinates for the polygon.
--- @field mode string (optional): 'single' for single colour mode, 'multi' for multi-colour mode.
--- @usage utils.draw.sprite_poly({...})
local function sprite_poly(params)
    local vertices = params.vertices or {vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0)}
    local texture_dict = params.texture_dict or 'deadline'
    local texture_name = params.texture_name or 'deadline_trail'
    local UVW = params.UVW or {{0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}}
    local mode = params.mode or 'single'
    
    if mode == 'single' then
        local colour = params.colour or {255, 0, 0, 255}
        DrawSpritePoly(vertices[1].x, vertices[1].y, vertices[1].z, vertices[2].x, vertices[2].y, vertices[2].z, vertices[3].x, vertices[3].y, vertices[3].z, colour[1], colour[2], colour[3], colour[4], texture_dict, texture_name, UVW[1][1], UVW[1][2], UVW[1][3], UVW[2][1], UVW[2][2], UVW[2][3], UVW[3][1], UVW[3][2], UVW[3][3])
    elseif mode == 'multi' then
        local colours = params.colours or {{255, 255, 255, 255}, {255, 255, 255, 255}, {255, 255, 255, 255}}
        DrawSpritePoly_2(vertices[1].x, vertices[1].y, vertices[1].z, vertices[2].x, vertices[2].y, vertices[2].z, vertices[3].x, vertices[3].y, vertices[3].z, colours[1][1], colours[1][2], colours[1][3], colours[1][4], colours[2][1], colours[2][2], colours[2][3], colours[2][4], colours[3][1], colours[3][2], colours[3][3], colours[3][4], texture_dict, texture_name, UVW[1][1], UVW[1][2], UVW[1][3], UVW[2][1], UVW[2][2], UVW[2][3], UVW[3][1], UVW[3][2], UVW[3][3])
    end
end

exports('draw_sprite_poly', sprite_poly)
utils.draw.sprite_poly = sprite_poly

--- Draws a 2D sprite with specific UV coordinates on the screen.
--- @function sprite_uv
--- @param params table: A table containing sprite UV drawing parameters.
--- @field texture_dict string: Texture dictionary for the sprite.
--- @field texture_name string: Texture name for the sprite.
--- @field coords vector2: Screen coordinates for the sprite.
--- @field size table: Size of the sprite (width, height).
--- @field uv_coords table: UV coordinates for the sprite (top_left, bottom_right).
--- @field rotation number: Rotation of the sprite.
--- @field colour table: RGBA color of the sprite.
--- @usage utils.draw.sprite_uv({...})
local function sprite_uv(params)
    local texture_dict = params.texture_dict or 'CommonMenu'
    local texture_name = params.texture_name or 'last_team_standing_icon'
    local coords = params.coords or vector2(0.5, 0.5)
    local size = params.size or {width = 1.0, height = 1.0}
    local uv_coords = params.uv_coords or {top_left = {u = 0.0, v = 0.0}, bottom_right = {u = 1.0, v = 1.0}}
    local rotation = params.rotation or 0.0
    local colour = params.colour or {255, 255, 255, 255}
    DrawSpriteUv(texture_dict, texture_name, coords.x, coords.y, size.width, size.height, uv_coords.top_left.u, uv_coords.top_left.v, uv_coords.bottom_right.u, uv_coords.bottom_right.v, rotation, table.unpack(colour))
end

exports('draw_sprite_uv', sprite_uv)
utils.draw.sprite_uv = sprite_uv

--- Draws a TV channel on the screen.
--- @function tv_channel
--- @param params table: A table containing TV channel drawing parameters.
--- @field coords vector2: Screen coordinates for the TV channel.
--- @field size table: Size of the TV channel (width, height).
--- @field rotation number: Rotation of the TV channel.
--- @field colour table: RGBA color of the TV channel.
--- @usage utils.draw.tv_channel({...})
local function tv_channel(params)
    local coords = params.coords or vector2(0.5, 0.5)
    local size = params.size or {width = 1.0, height = 1.0}
    local rotation = params.rotation or 0.0
    local colour = params.colour or {255, 255, 255, 255}
    DrawTvChannel(coords.x, coords.y, size.width, size.height, rotation, table.unpack(colour))
end

exports('draw_tv_channel', tv_channel)
utils.draw.tv_channel = tv_channel
