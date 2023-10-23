--[[
    BLIP COMMANDS
]]

-- Test command to create a blip
RegisterCommand('test_create_blip', function()
    local blip_data = {
        coords = vector3(100.0, 200.0, 30.0),
        sprite = 1,
        colour = 1,
        scale = 1.5,
        label = 'Test Blip',
        category = 'shop',
        show = true
    }
    utils.blips.create_blip(blip_data)
    utils.debugging.info("Blip created!")
end)

-- Test command to toggle all blips
RegisterCommand('test_toggle_all_blips', function()
    utils.blips.toggle_all_blips(not utils.blips.are_blips_enabled())
    utils.debugging.info("Toggled all blips!")
end)

-- Test command to toggle blips by category
RegisterCommand('test_toggle_shop_blips', function()
    local current_state = utils.blips.get_category_state('shop')
    utils.blips.toggle_blips_by_category('shop', not current_state)
    utils.debugging.info("Toggled shop blips!")
end)

-- Test command to create multiple blips
RegisterCommand('test_create_multiple_blips', function()
    local blip_config = {
        { coords = vector3(200.0, 800.0, 30.0), sprite = 1, colour = 1, scale = 1.5, label = 'Blip 1', category = 'shop', show = true },
        { coords = vector3(550.0, 150.0, 30.0), sprite = 41, colour = 2, scale = 1.5, label = 'Blip 2', category = 'store', show = true }
    }
    utils.blips.create_blips(blip_config)
    utils.debugging.info("Multiple blips created!")
end)

-- Test command to remove all blips
RegisterCommand('test_remove_all_blips', function()
    utils.blips.remove_all_blips()
    utils.debugging.info("All blips removed!")
end)

-- Test command to get all created blips and print their labels
RegisterCommand('test_get_all_blips', function()
    local all_blips = utils.blips.get_all_blips()
    for _, blip_data in ipairs(all_blips) do
        utils.debugging.info(blip_data.label)
    end
end)

-- Test command to get blips in the 'shop' category and print their labels
RegisterCommand('test_get_shop_blips', function()
    local shop_blips = utils.blips.get_blips_by_category('shop')
    for _, blip in ipairs(shop_blips) do
        local label = utils.blips.get_blip_label(blip)
        utils.debugging.info(label)
    end
end)

-- Test command to update the label of the first created blip
RegisterCommand('test_update_blip_label', function()
    local all_blips = utils.blips.get_all_blips()
    if #all_blips > 0 then
        utils.blips.update_blip_label(all_blips[1].blip, 'Updated Label')
        utils.debugging.info("Updated label of the first blip!")
    else
        utils.debugging.err("No blips found!")
    end
end)

-- Test command to update the sprite of the first blip
RegisterCommand('test_update_sprite', function()
    local all_blips = utils.blips.get_all_blips()
    if #all_blips > 0 then
        utils.blips.update_blip_sprite(all_blips[1].blip, 162)
        utils.debugging.info("Updated sprite of the first blip!")
    else
        utils.debugging.err("No blips found!")
    end
end)

-- Test command to update the color of the first blip
RegisterCommand('test_update_colour', function()
    local all_blips = utils.blips.get_all_blips()
    if #all_blips > 0 then
        utils.blips.update_blip_colour(all_blips[1].blip, 2)
        utils.debugging.info("Updated color of the first blip!")
    else
        utils.debugging.err("No blips found!")
    end
end)

-- Test command to update the scale of the first blip
RegisterCommand('test_update_scale', function()
    local all_blips = utils.blips.get_all_blips()
    if #all_blips > 0 then
        utils.blips.update_blip_scale(all_blips[1].blip, 2.0)
        utils.debugging.info("Updated scale of the first blip!")
    else
        utils.debugging.err("No blips found!")
    end
end)

-- Test command to check if blips are currently enabled
RegisterCommand('test_are_blips_enabled', function()
    local status = utils.blips.are_blips_enabled()
    utils.debugging.info("Blips are " .. (status and "enabled" or "disabled"))
end)

-- Test command to get the category state for 'shop'
RegisterCommand('test_get_shop_category_state', function()
    local state = utils.blips.get_category_state('shop')
    utils.debugging.info("Shop category blips are " .. (state and "visible" or "hidden"))
end)

-- Test command to get all created blips and print their labels
RegisterCommand('test_get_all_blips_labels', function()
    local all_blips = utils.blips.get_all_blips()
    for _, blip_data in ipairs(all_blips) do
        utils.debugging.info(blip_data.label)
    end
end)

-- Test command to get blips in the 'shop' category and print their labels
RegisterCommand('test_get_shop_blips_labels', function()
    local shop_blips = utils.blips.get_blips_by_category('shop')
    for _, blip in ipairs(shop_blips) do
        local label = utils.blips.get_blip_label(blip)
        print(label)
    end
end)

-- Test command to get the label of the first blip
RegisterCommand('test_get_first_blip_label', function()
    local all_blips = utils.blips.get_all_blips()
    if #all_blips > 0 then
        local label = utils.blips.get_blip_label(all_blips[1].blip)
        print("Label of the first blip: " .. label)
    else
        print("No blips found!")
    end
end)

--[[
    DEVELOPER COMMANDS
]]

-- Registering the test command to toggle displaying of coordinates
RegisterCommand('test_toggle_coords', function()
    utils.developer.toggle_coords()
    utils.debugging.info("Toggled display of coordinates!")
end, false)

-- Registering the test command to toggle displaying of vehicle info
RegisterCommand('test_toggle_vehicle_info', function()
    utils.developer.toggle_vehicle_info()
    utils.debugging.info("Toggled display of vehicle info!")
end, false)

-- Registering the test command to toggle displaying of player info
RegisterCommand('test_toggle_player_info', function()
    utils.developer.toggle_player_info()
    utils.debugging.info("Toggled display of player info!")
end, false)

-- Registering the test command to toggle displaying of environment info
RegisterCommand('test_toggle_environment_info', function()
    utils.developer.toggle_environment_info()
    utils.debugging.info("Toggled display of environment info!")
end, false)


--[[
    DRAW COMMANDS
]]

local draw_flags = {
    text_draw_active = false,
    line_draw_active = false,
    line_2d_draw_active = false,
    marker_draw_active = false,
    movie_draw_active = false,
    box_draw_active = false,
    interactive_sprite_draw_active = false,
    light_draw_active = false,
    poly_draw_active = false,
    rect_draw_active = false,
    scaleform_movie_draw_active = false,
    showroom_draw_active = false,
    sphere_draw_active = false,
    spot_light_draw_active = false,
    sprite_draw_active = false,
    sprite_poly_draw_active = false,
    sprite_poly2_draw_active = false,
    sprite_uv_draw_active = false,
    tv_channel_draw_active = false
}

local player_ped_id = PlayerPedId()

-- Test the text drawing function
RegisterCommand("test_text_draw", function()
    draw_flags.text_draw_active = not draw_flags.text_draw_active
    local player_coords = GetEntityCoords(player_ped_id)
    CreateThread(function()
        while draw_flags.text_draw_active do
            utils.draw.text({
                coords = vector3(player_coords.x, player_coords.y, player_coords.z + 2.0),
                content = 'Hello World',
                scale = 1.0,
                colour = {255, 0, 0, 255},
                font = 0,
                alignment = 'center',
                mode = '3d'
            })
            Wait(0)
        end
    end)
end, false)

-- Test the line drawing function
RegisterCommand("test_line_draw", function()
    draw_flags.line_draw_active = not draw_flags.line_draw_active
    local player_coords = GetEntityCoords(player_ped_id)
    CreateThread(function()
        while draw_flags.line_draw_active do
            utils.draw.line({
                start_pos = player_coords,
                end_pos = vector3(player_coords.x + 10, player_coords.y + 10, player_coords.z + 10),
                colour = {255, 0, 0, 255}
            })
            Wait(0)
        end
    end)
end, false)

-- Test the 2D line drawing function
RegisterCommand("test_line_2d_draw", function()
    draw_flags.line_2d_draw_active = not draw_flags.line_2d_draw_active
    CreateThread(function()
        while draw_flags.line_2d_draw_active do
            utils.draw.line_2d({
                start_pos = {x = 0.1, y = 0.1},
                end_pos = {x = 0.9, y = 0.1},
                width = 0.05,
                colour = {255, 0, 0, 255}
            })
            Wait(0)
        end
    end)
end, false)

-- Test the 3D marker drawing function
RegisterCommand("test_marker_draw", function()
    draw_flags.marker_draw_active = not draw_flags.marker_draw_active
    local player_coords = GetEntityCoords(player_ped_id)
    CreateThread(function()
        while draw_flags.marker_draw_active do
            utils.draw.marker({
                type = 1,
                coords = vector3(player_coords.x, player_coords.y, player_coords.z + 2.0), -- Displaying slightly above the player
                dir = vector3(0.0, 0.0, 1.0),
                rot = vector3(0.0, 0.0, 0.0),
                scale = vector3(1.0, 1.0, 1.0),
                colour = {255, 0, 0, 255}
            })
            Wait(0)
        end
    end)
end, false)

-- Test the movie drawing function
-- Note: You'll need to provide a valid BINK movie index for this command to work.
RegisterCommand("test_movie_draw", function()
    local binkint = 0 -- TODO: replace with a valid BINK movie index
    draw_flags.movie_draw_active = not draw_flags.movie_draw_active
    local player_coords = GetEntityCoords(player_ped_id)
    CreateThread(function()
        while draw_flags.movie_draw_active do
            utils.draw.movie({
                bink = binkint,
                coords = {x = player_coords.x, y = player_coords.y, z = player_coords.z + 2.0}, -- Displaying slightly above the player
                scale = {x = 1.0, y = 1.0},
                rotation = 0.0,
                colour = {255, 255, 255, 255}
            })
            Wait(0)
        end
    end)
end, false)


-- Test the box drawing function
RegisterCommand("test_box_draw", function()
    draw_flags.box_draw_active = not draw_flags.box_draw_active
    local player_coords = GetEntityCoords(player_ped_id)
    CreateThread(function()
        while draw_flags.box_draw_active do
            utils.draw.box({
                start_coords = player_coords,
                end_coords = vector3(player_coords.x + 10, player_coords.y + 10, player_coords.z + 10),
                colour = {255, 0, 0, 255}
            })
            Wait(0)
        end
    end)
end, false)

-- Test the interactive sprite drawing function
RegisterCommand("test_interactive_sprite_draw", function()
    draw_flags.interactive_sprite_draw_active = not draw_flags.interactive_sprite_draw_active
    local player_coords = GetEntityCoords(player_ped_id)
    CreateThread(function()
        while draw_flags.interactive_sprite_draw_active do
            utils.draw.interactive_sprite({
                texture_dict = "prop_screen_biker_laptop",
                texture_name = "example_texture_name",
                coords = vector3(player_coords.x, player_coords.y, player_coords.z + 2.0), -- Displaying slightly above the player
                size = {width = 1.0, height = 1.0},
                rotation = 0.0,
                colour = {255, 255, 255, 255}
            })
            Wait(0)
        end
    end)
end, false)

-- Test the light drawing function
RegisterCommand("test_light_draw", function()
    draw_flags.light_draw_active = not draw_flags.light_draw_active
    local player_coords = GetEntityCoords(player_ped_id)
    CreateThread(function()
        while draw_flags.light_draw_active do
            utils.draw.light({
                coords = player_coords,
                colour = {255, 255, 255},
                range = 10.0,
                intensity = 1.0,
                shadow = 2.5
            })
            Wait(0)
        end
    end)
end, false)

-- Test the poly drawing function
RegisterCommand("test_poly_draw", function()
    draw_flags.poly_draw_active = not draw_flags.poly_draw_active
    local player_coords = GetEntityCoords(player_ped_id)
    CreateThread(function()
        while draw_flags.poly_draw_active do
            utils.draw.poly({
                vertex1 = player_coords,
                vertex2 = vector3(player_coords.x + 10, player_coords.y + 10, player_coords.z),
                vertex3 = vector3(player_coords.x + 20, player_coords.y, player_coords.z),
                colour = {255, 0, 0, 255}
            })
            Wait(0)
        end
    end)
end, false)

-- Test the rectangle drawing function
RegisterCommand("test_rect_draw", function()
    draw_flags.rect_draw_active = not draw_flags.rect_draw_active
    CreateThread(function()
        while draw_flags.rect_draw_active do
            utils.draw.rect({
                coords = vector2(0.5, 0.5),
                width = 0.1,
                height = 0.05,
                colour = {255, 0, 0, 255}
            })
            Wait(0)
        end
    end)
end, false)

-- Test the scaleform_movie drawing function
RegisterCommand("test_scaleform_movie_draw", function()
    draw_flags.scaleform_movie_draw_active = not draw_flags.scaleform_movie_draw_active
    CreateThread(function()
        while draw_flags.scaleform_movie_draw_active do
            local player_coords = GetEntityCoords(player_ped_id)
            -- TODO: Ensure the scaleform handle is valid
            local scaleformHandle = 0
            utils.draw.scaleform_movie({
                mode = "3d",
                scaleform = scaleformHandle,
                coords = player_coords,
                rotation = vector3(0.0, 0.0, 0.0),
                scale = vector3(1.0, 1.0, 1.0),
                colour = {255, 255, 255, 255}
            })
            Wait(0)
        end
    end)
end, false)

-- Test the showroom drawing function
RegisterCommand("test_showroom_draw", function()
    draw_flags.showroom_draw_active = not draw_flags.showroom_draw_active
    CreateThread(function()
        while draw_flags.showroom_draw_active do
            local player_coords = GetEntityCoords(player_ped_id)
            utils.draw.showroom({
                p0 = "CELEBRATION_WINNER",
                ped = player_ped_id,
                p2 = 0,
                coords = player_coords
            })
            Wait(0)
        end
    end)
end, false)

-- Test the sphere drawing function
RegisterCommand("test_sphere_draw", function()
    draw_flags.sphere_draw_active = not draw_flags.sphere_draw_active
    CreateThread(function()
        while draw_flags.sphere_draw_active do
            local player_coords = GetEntityCoords(player_ped_id)
            utils.draw.sphere({
                coords = player_coords,
                radius = 1.0,
                color = {255, 0, 0, 255},
                opacity = 1.0
            })
            Wait(0)
        end
    end)
end, false)

-- Test the spot_light drawing function
RegisterCommand("test_spot_light_draw", function()
    draw_flags.spot_light_draw_active = not draw_flags.spot_light_draw_active
    CreateThread(function()
        while draw_flags.spot_light_draw_active do
            local player_coords = GetEntityCoords(player_ped_id)
            local direction = vector3(0.0, 0.0, -1.0)  -- Assuming spotlight shines downwards
            utils.draw.spot_light({
                coords = vector3(player_coords.x, player_coords.y, player_coords.z + 5.0),  -- Position light above player
                direction = direction,
                color = {255, 0, 0},
                distance = 100.0,
                brightness = 1.0,
                hardness = 0.0,
                radius = 13.0,
                falloff = 1.0
            })
            Wait(0)
        end
    end)
end, false)

-- Test the sprite drawing function
RegisterCommand("test_sprite_draw", function()
    draw_flags.sprite_draw_active = not draw_flags.sprite_draw_active
    CreateThread(function()
        while draw_flags.sprite_draw_active do
            utils.draw.sprite({
                texture_dict = "CommonMenu",
                texture_name = "last_team_standing_icon",
                coords = vector2(0.5, 0.5),
                size = {width = 1.0, height = 1.0},
                rotation = 0.0,
                colour = {255, 255, 255, 255}
            })
            Wait(0)
        end
    end)
end, false)

-- Test the sprite_poly drawing function
RegisterCommand("test_sprite_poly_draw", function()
    draw_flags.sprite_poly_draw_active = not draw_flags.sprite_poly_draw_active
    CreateThread(function()
        while draw_flags.sprite_poly_draw_active do
            utils.draw.sprite_poly({
                vertices = {vector3(0.0, 0.0, 0.0), vector3(10.0, 10.0, 0.0), vector3(20.0, 0.0, 0.0)},
                colour = {255, 0, 0, 255},
                texture_dict = "deadline",
                texture_name = "deadline_trail",
                UVW = {{0.0, 0.0, 0.0}, {1.0, 1.0, 1.0}, {0.5, 0.5, 0.5}}
            })
            Wait(0)
        end
    end)
end, false)

-- Test the sprite_poly2 drawing function
RegisterCommand("test_sprite_poly2_draw", function()
    draw_flags.sprite_poly2_draw_active = not draw_flags.sprite_poly2_draw_active
    CreateThread(function()
        while draw_flags.sprite_poly2_draw_active do
            utils.draw.sprite_poly2({
                vertices = {vector3(0.0, 0.0, 0.0), vector3(10.0, 10.0, 0.0), vector3(20.0, 0.0, 0.0)},
                colours = {{255, 0, 0, 255}, {0, 255, 0, 255}, {0, 0, 255, 255}},
                texture_dict = "deadline",
                texture_name = "deadline_trail",
                UVW = {{0.0, 0.0, 0.0}, {1.0, 1.0, 1.0}, {0.5, 0.5, 0.5}}
            })
            Wait(0)
        end
    end)
end, false)

-- Test the sprite_uv drawing function
RegisterCommand("test_sprite_uv_draw", function()
    draw_flags.sprite_uv_draw_active = not draw_flags.sprite_uv_draw_active
    CreateThread(function()
        while draw_flags.sprite_uv_draw_active do
            utils.draw.sprite_uv({
                texture_dict = "CommonMenu",
                texture_name = "last_team_standing_icon",
                coords = vector2(0.5, 0.5),
                size = {width = 1.0, height = 1.0},
                uv_coords = {top_left = {u = 0.0, v = 0.0}, bottom_right = {u = 1.0, v = 1.0}},
                rotation = 0.0,
                colour = {255, 255, 255, 255}
            })
            Wait(0)
        end
    end)
end, false)

-- Test the tv_channel drawing function
RegisterCommand("test_tv_channel_draw", function()
    draw_flags.tv_channel_draw_active = not draw_flags.tv_channel_draw_active
    CreateThread(function()
        while draw_flags.tv_channel_draw_active do
            utils.draw.tv_channel({
                coords = vector2(0.5, 0.5),
                size = {width = 1.0, height = 1.0},
                rotation = 0.0,
                colour = {255, 255, 255, 255}
            })
            Wait(0)
        end
    end)
end, false)

--[[
    ENTITY COMMANDS
]]

-- Test the get_nearby_objects function
RegisterCommand("test_nearby_objects", function()
    local player_coords = GetEntityCoords(PlayerPedId())
    local nearby_objects = utils.entities.get_nearby_objects(player_coords, 10.0)
    print("Found " .. #nearby_objects .. " nearby objects.")
end, false)

-- Test the get_nearby_peds function
RegisterCommand("test_nearby_peds", function()
    local player_coords = GetEntityCoords(PlayerPedId())
    local nearby_peds = utils.entities.get_nearby_peds(player_coords, 10.0)
    print("Found " .. #nearby_peds .. " nearby peds.")
end, false)

-- Test the get_nearby_vehicles function
RegisterCommand("test_nearby_vehicles", function()
    local player_coords = GetEntityCoords(PlayerPedId())
    local nearby_vehicles = utils.entities.get_nearby_vehicles(player_coords, 10.0, true)
    print("Found " .. #nearby_vehicles .. " nearby vehicles.")
end, false)

-- Test the get_closest_object function
RegisterCommand("test_closest_object", function()
    local player_coords = GetEntityCoords(PlayerPedId())
    local closest_object, closest_coords = utils.entities.get_closest_object(player_coords, 10.0)
    if closest_object then
        print("Found a closest object at " .. tostring(closest_coords))
    else
        print("No objects found nearby.")
    end
end, false)

-- Test the get_closest_ped function
RegisterCommand("test_closest_ped", function()
    local player_coords = GetEntityCoords(PlayerPedId())
    local closest_ped, closest_coords = utils.entities.get_closest_ped(player_coords, 10.0)
    if closest_ped then
        print("Found a closest ped at " .. tostring(closest_coords))
    else
        print("No peds found nearby.")
    end
end, false)

-- Test the get_closest_vehicle function
RegisterCommand("test_closest_vehicle", function()
    local player_coords = GetEntityCoords(PlayerPedId())
    local closest_vehicle, closest_coords = utils.entities.get_closest_vehicle(player_coords, 10.0, true)
    if closest_vehicle then
        print("Found a closest vehicle at " .. tostring(closest_coords))
    else
        print("No vehicles found nearby.")
    end
end, false)

-- Test the get_entities_in_front_of_player function
RegisterCommand("test_entities_in_front", function()
    local entity_in_front = utils.entities.get_entities_in_front_of_player(45.0, 10.0)
    if entity_in_front then
        print("Found an entity in front of the player.")
    else
        print("No entities found in front of the player.")
    end
end, false)

--[[
    PED COMMANDS
]]

-- Test command to create a ped without a weapon
RegisterCommand("test_create_ped_no_weapon", function()
    local ped_data = {
        base_data = {
            model = "a_m_m_bevhills_01",
            coords = vector4(GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId())),
            networked = false,
            scenario = "WORLD_HUMAN_STAND_MOBILE"
        }
    }
    local ped = utils.peds.create_ped(ped_data)
    print("Ped created without a weapon!")
end, false)

-- Test command to create a ped with a weapon
RegisterCommand("test_create_ped_with_weapon", function()
    local ped_data = {
        base_data = {
            model = "a_m_m_bevhills_01",
            coords = vector4(GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId())),
            networked = false,
            scenario = "WORLD_HUMAN_STAND_MOBILE"
        },
        weapon_data = {
            weapon_name = "WEAPON_PISTOL",
            ammo = 100
        }
    }
    local ped = utils.peds.create_ped(ped_data)
    print("Ped created with a weapon!")
end, false)

-- Test the create_peds function with weapon options
RegisterCommand("test_create_multiple_peds", function()
    local ped_configs = {
        {
            base_data = {
                model = "a_m_m_bevhills_01",
                coords = vector4(GetEntityCoords(PlayerPedId()) + vector3(1.0, 0.0, 0.0), GetEntityHeading(PlayerPedId())),
                networked = false,
                scenario = "WORLD_HUMAN_STAND_MOBILE"
            },
            weapon_data = {
                weapon_name = "WEAPON_PISTOL",
                ammo = 50
            }
        },
        {
            base_data = {
                model = "a_m_m_bevhills_02",
                coords = vector4(GetEntityCoords(PlayerPedId()) + vector3(-1.0, 0.0, 0.0), GetEntityHeading(PlayerPedId())),
                networked = false,
                scenario = "WORLD_HUMAN_STAND_MOBILE"
            }
        }
    }
    utils.peds.create_peds(ped_configs)
    print("Created multiple peds with weapons!")
end, false)

-- Test the remove_ped function
RegisterCommand("test_remove_last_ped", function()
    if #created_peds > 0 then
        local ped = created_peds[#created_peds].ped
        utils.peds.remove_ped(ped)
        print("Removed the last created ped!")
    else
        print("No created peds found!")
    end
end, false)

-- Test the remove_all_peds function
RegisterCommand("test_remove_all_peds", function()
    utils.peds.remove_all_peds()
    print("Removed all created peds!")
end, false)

--[[
    GROUPS COMMANDS
]]

-- Test command to check if the player is in a specific group
RegisterCommand("check_group", function(source, args, rawCommand)
    local group_name = args[1]
    if not group_name then
        print("Please specify a group name.")
        return
    end

    local inGroup = utils.groups.in_group(group_name)
    if inGroup then
        print("You are in the group: " .. group_name)
    else
        print("You are not in the group: " .. group_name)
    end
end, false)

-- Test command to get all groups the player is in
RegisterCommand("my_groups", function(source, args, rawCommand)
    local myGroups = utils.groups.get_player_groups()
    print("You are in the following groups:")
    for _, group_name in ipairs(myGroups) do
        print(group_name)
    end
end, false)

--[[
    PLAYER COMMANDS
]]

-- Test command to retrieve a player's cardinal direction
RegisterCommand("test_cardinal_direction", function()
    local direction = utils.player.get_cardinal_direction(PlayerPedId())
    print("Player's Cardinal Direction: " .. direction)
end, false)

-- Test command to get the street a player is on
RegisterCommand("test_street_name", function()
    local street = utils.player.get_street_name(PlayerPedId())
    print("Player's Street: " .. street)
end, false)

-- Test command to retrieve the current region name
RegisterCommand("test_region", function()
    local region = utils.player.get_region(PlayerPedId())
    print("Player's Region: " .. region)
end, false)

-- Test command to get detailed player data
RegisterCommand("test_player_details", function()
    local details = utils.player.get_player_details(PlayerPedId())
    for key, value in pairs(details) do
        print(key .. ": " .. tostring(value))
    end
end, false)

-- Test command to get the player's target entity
RegisterCommand("test_target_entity", function()
    local entity = utils.player.get_target_entity(PlayerPedId())
    if entity ~= 0 then
        print("Player's Target Entity: " .. entity)
    else
        print("Player is not aiming at any entity.")
    end
end, false)

-- Test command to get the player's current weapon
RegisterCommand("test_current_weapon", function()
    local weapon = utils.player.get_current_weapon(PlayerPedId())
    if weapon then
        print("Player's Current Weapon: " .. weapon)
    else
        print("Player does not have a weapon equipped.")
    end
end, false)

-- Test command to calculate distance between player and a target entity
RegisterCommand("test_distance_to_entity", function()
    local entity = utils.player.get_target_entity(PlayerPedId())
    if entity ~= 0 then
        local distance = utils.player.get_distance_to_entity(PlayerPedId(), entity)
        print("Distance to Target Entity: " .. distance)
    else
        print("Player is not aiming at any entity.")
    end
end, false)

--[[
    VEHICLE COMMANDS
]]

-- Test command to retrieve a vehicle's plate number
RegisterCommand("test_vehicle_plate", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle then
        local plate = utils.vehicles.get_vehicle_plate(vehicle)
        print("Vehicle Plate: " .. plate)
    else
        print("Player is not in a vehicle.")
    end
end, false)

-- Test command to get the model name of a vehicle
RegisterCommand("test_vehicle_model", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle then
        local model_name = utils.vehicles.get_vehicle_model(vehicle)
        print("Vehicle Model: " .. model_name)
    else
        print("Player is not in a vehicle.")
    end
end, false)

-- Test command to retrieve broken doors of a vehicle
RegisterCommand("test_doors_broken", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle then
        local doors_broken = utils.vehicles.get_doors_broken(vehicle)
        for door, status in pairs(doors_broken) do
            print("Door " .. door .. " broken status: " .. tostring(status))
        end
    else
        print("Player is not in a vehicle.")
    end
end, false)

-- Test command to retrieve broken windows of a vehicle
RegisterCommand("test_windows_broken", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle then
        local windows_broken = utils.vehicles.get_windows_broken(vehicle)
        for window, status in pairs(windows_broken) do
            print("Window " .. window .. " broken status: " .. tostring(status))
        end
    else
        print("Player is not in a vehicle.")
    end
end, false)

-- Test command to retrieve burst tyres of a vehicle
RegisterCommand("test_tyre_burst", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle then
        local tyre_burst = utils.vehicles.get_tyre_burst(vehicle)
        for tyre, status in pairs(tyre_burst) do
            print("Tyre " .. tyre .. " burst status: " .. tostring(status))
        end
    else
        print("Player is not in a vehicle.")
    end
end, false)

-- Test command to retrieve the extras enabled on a vehicle
RegisterCommand("test_vehicle_extras", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle then
        local extras = utils.vehicles.get_vehicle_extras(vehicle)
        for extra, status in pairs(extras) do
            print("Extra " .. extra .. " status: " .. tostring(status))
        end
    else
        print("Player is not in a vehicle.")
    end
end, false)

-- Test command to retrieve a vehicle's class
RegisterCommand("test_vehicle_class", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle then
        local class_name = utils.vehicles.get_vehicle_class(vehicle)
        print("Vehicle Class: " .. class_name)
    else
        print("Player is not in a vehicle.")
    end
end, false)

-- Test command to retrieve a vehicle's detailed information
RegisterCommand("test_vehicle_details", function()
    local vehicle_details = utils.vehicles.get_vehicle_details(true)
    for key, value in pairs(vehicle_details) do
        print(key .. ": " .. tostring(value))
    end
end, false)

-- Test command to retrieve a vehicle's mods and maintenance data
RegisterCommand("test_vehicle_mods_maintenance", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle then
        local mods, maintenance = utils.vehicles.get_vehicle_mods_and_maintenance(vehicle)
        print("Mods: ")
        for key, value in pairs(mods) do
            print(key .. ": " .. tostring(value))
        end
        print("\nMaintenance: ")
        for key, value in pairs(maintenance) do
            print(key .. ": " .. tostring(value))
        end
    else
        print("Player is not in a vehicle.")
    end
end, false)