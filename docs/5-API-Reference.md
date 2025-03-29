# 5 - API Reference

Below is a quick outline of the functions available in each module.  
Modules can be accessed in two ways:

1. Requiring the module: 

```lua
local CORE <const> = exports.boii_utils:get("modules.core")

CORE.get_players()
``` 

2. Exports: 

```lua
exports.boii_utils:get_players()
```

For more detailed API instructions each module has its own API file, this is simply a quick reference.

# Framework Bridge

## Server

```lua
    --- @section Function Assignments

    core.get_players = get_players
    core.get_player = get_player
    core.get_id_params = get_id_params
    core.get_insert_params = get_insert_params
    core.get_player_id = get_player_id
    core.get_identity = get_identity
    core.get_inventory = get_inventory
    core.get_item = get_item
    core.has_item = has_item
    core.add_item = add_item
    core.remove_item = remove_item
    core.update_item_data = update_item_data
    core.get_balances = get_balances
    core.get_balance_by_type = get_balance_by_type
    core.add_balance = add_balance
    core.remove_balance = remove_balance
    core.get_player_jobs = get_player_jobs
    core.player_has_job = player_has_job
    core.get_player_job_grade = get_player_job_grade
    core.count_players_by_job = count_players_by_job
    core.get_player_job_name = get_player_job_name
    core.adjust_statuses = adjust_statuses
    core.register_item = register_item

    --- @section Exports

    exports("get_players", get_players)
    exports("get_player", get_player)
    exports("get_id_params", get_id_params)
    exports("get_insert_params", get_insert_params)
    exports("get_player_id", get_player_id)
    exports("get_identity", get_identity)
    exports("get_inventory", get_inventory)
    exports("get_item", get_item)
    exports("has_item", has_item)
    exports("add_item", add_item)
    exports("remove_item", remove_item)
    exports("update_item_data", update_item_data)
    exports("get_balances", get_balances)
    exports("get_balance_by_type", get_balance_by_type)
    exports("add_balance", add_balance)
    exports("remove_balance", remove_balance)
    exports("get_player_jobs", get_player_jobs)
    exports("player_has_job", player_has_job)
    exports("get_player_job_grade", get_player_job_grade)
    exports("count_players_by_job", count_players_by_job)
    exports("get_player_job_name", get_player_job_name)
    exports("adjust_statuses", adjust_statuses)
    exports("fw_register_item", register_item) -- Registered as fw_register_item so does not conflict with internal item system.
```

## Client

```lua
    --- @section Function Assignments
    
    core.get_data = get_data
    core.get_identity = get_identity
    core.get_player_id = get_player_id
    
    --- @section Exports

    exports("get_data", get_data)
    exports("get_identity", get_identity)
    exports("get_player_id", get_player_id)
```

# DrawText UI Bridge

## Server

```lua
    --- @section Function Assignments

    drawtext.show = show_drawtext
    drawtext.hide = hide_drawtext

    --- @section Exports

    exports("drawtext_show", show_drawtext)
    exports("drawtext_hide", hide_drawtext)
```

## Client

```lua
    --- @section Function Assignments

    drawtext.show = show_drawtext
    drawtext.hide = hide_drawtext

    --- @section Exports

    exports("drawtext_show", show_drawtext)
    exports("drawtext_hide", hide_drawtext)
```

# Notifications Bridge

## Server

```lua
    --- @section Function Assignments

    notifications.send = notify

    --- @section Exports

    exports("send_notification", notify)
```

## Client

```lua
    --- @section Function Assignments

    notifications.send = notify

    --- @section Exports

    exports("send_notification", notify)
```

# Callbacks

## Server

```lua
    --- @section Function Assignments

    callbacks.register = register_callback

    --- @section Exports

    exports("register_callback", register_callback)
```

## Client

```lua
    --- @section Function Assignments

    callbacks.trigger = callback

    --- @section Exports

    exports("trigger_callback", callback)
```

# Characters

## Client

```lua
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
```

# Commands

## Server

```lua
    --- @section Function Assignments

    commands.register = register_command

    --- @section Exports

    exports("register_command", register_command)
```

## Client

```lua
    --- @section Function Assignments

    commands.get_chat_suggestions = get_chat_suggestions

    --- @section Exports

    exports("get_chat_suggestions", get_chat_suggestions)
```

# Cooldowns

## Server

```lua
    --- @section Function Assignments
    
    cooldowns.add = add_cooldown
    cooldowns.check = check_cooldown
    cooldowns.clear = clear_cooldown
    cooldowns.clear_expired_cooldowns = clear_expired_cooldowns
    cooldowns.clear_resource_cooldowns = clear_resource_cooldowns

    --- @section Exports

    exports("add_cooldown", add_cooldown)
    exports("check_cooldown", check_cooldown)
    exports("clear_cooldown", clear_cooldown)
    exports("clear_expired_cooldowns", clear_expired_cooldowns)
    exports("clear_resource_cooldowns", clear_resource_cooldowns)
```

# Debugging

## Shared

```lua
    --- @section Function Assignments

    debugging.print = debug_print

    --- @section Exports

    exports("debug_print", debug_print)
```

# Entities

## Client

```lua
    --- @section Function Assignments
    
    entities.get_nearby_objects = get_nearby_objects
    entities.get_nearby_peds = get_nearby_peds
    entities.get_nearby_players = get_nearby_players
    entities.get_nearby_vehicles = get_nearby_vehicles
    entities.get_closest_object = get_closest_object
    entities.get_closest_ped = get_closest_ped
    entities.get_closest_player = get_closest_player
    entities.get_closest_vehicle = get_closest_vehicle
    entities.get_entities_in_front_of_player = get_entities_in_front_of_player
    entities.get_target_ped = get_target_ped

    --- @section Exports

    exports("get_nearby_objects", get_nearby_objects)
    exports("get_nearby_peds", get_nearby_peds)
    exports("get_nearby_players", get_nearby_players)
    exports("get_nearby_vehicles", get_nearby_vehicles)
    exports("get_closest_object", get_closest_object)
    exports("get_closest_ped", get_closest_ped)
    exports("get_closest_player", get_closest_player)
    exports("get_closest_vehicle", get_closest_vehicle)
    exports("get_entities_in_front_of_player", get_entities_in_front_of_player)
    exports("get_target_ped", get_target_ped)
```

# Environment

## Client

```lua
    --- @section Function Assignments
    
    environment.get_weather_name = get_weather_name
    environment.get_game_time = get_game_time
    environment.get_game_date = get_game_date
    environment.get_sunrise_sunset_times = get_sunrise_sunset_times
    environment.is_daytime = is_daytime
    environment.get_current_season = get_current_season
    environment.get_distance_to_water = get_distance_to_water
    environment.get_zone_scumminess = get_zone_scumminess
    environment.get_ground_material = get_ground_material
    environment.get_wind_direction = get_wind_direction
    environment.get_altitude = get_altitude
    environment.get_environment_details = get_environment_details

    --- @section Exports

    exports("get_weather_name", get_weather_name)
    exports("get_game_time", get_game_time)
    exports("get_game_date", get_game_date)
    exports("get_sunrise_sunset_times", get_sunrise_sunset_times)
    exports("is_daytime", is_daytime)
    exports("get_current_season", get_current_season)
    exports("get_distance_to_water", get_distance_to_water)
    exports("get_zone_scumminess", get_zone_scumminess)
    exports("get_ground_material", get_ground_material)
    exports("get_wind_direction", get_wind_direction)
    exports("get_altitude", get_altitude)
    exports("get_environment_details", get_environment_details)
```

# Geometry

## Shared

```lua
    --- @section Function Assignments

    geometry.distance_2d = distance_2d
    geometry.distance_3d = distance_3d
    geometry.midpoint = midpoint
    geometry.is_point_in_rect = is_point_in_rect
    geometry.is_point_in_box = is_point_in_box
    geometry.is_point_on_line_segment = is_point_on_line_segment
    geometry.project_point_on_line = project_point_on_line
    geometry.calculate_slope = calculate_slope
    geometry.angle_between_points = angle_between_points
    geometry.angle_between_3_points = angle_between_3_points
    geometry.do_circles_intersect = do_circles_intersect
    geometry.is_point_in_circle = is_point_in_circle
    geometry.do_lines_intersect = do_lines_intersect
    geometry.line_intersects_circle = line_intersects_circle
    geometry.does_rect_intersect_line = does_rect_intersect_line
    geometry.closest_point_on_line_segment = closest_point_on_line_segment
    geometry.triangle_area_3d = triangle_area_3d
    geometry.is_point_in_sphere = is_point_in_sphere
    geometry.do_spheres_intersect = do_spheres_intersect
    geometry.is_point_in_convex_polygon = is_point_in_convex_polygon
    geometry.rotate_point_around_point_2d = rotate_point_around_point_2d
    geometry.distance_point_to_plane = distance_point_to_plane
    geometry.rotation_to_direction = rotation_to_direction
    geometry.rotate_box = rotate_box
    geometry.calculate_rotation_matrix = calculate_rotation_matrix
    geometry.translate_point_to_local_space = translate_point_to_local_space
    geometry.is_point_in_oriented_box = is_point_in_oriented_box

    --- @section Exports

    exports("distance_2d", distance_2d)
    exports("distance_3d", distance_3d)
    exports("midpoint", midpoint)
    exports("is_point_in_rect", is_point_in_rect)
    exports("is_point_in_box", is_point_in_box)
    exports("is_point_on_line_segment", is_point_on_line_segment)
    exports("project_point_on_line", project_point_on_line)
    exports("calculate_slope", calculate_slope)
    exports("angle_between_points", angle_between_points)
    exports("angle_between_3_points", angle_between_3_points)
    exports("do_circles_intersect", do_circles_intersect)
    exports("is_point_in_circle", is_point_in_circle)
    exports("do_lines_intersect", do_lines_intersect)
    exports("line_intersects_circle", line_intersects_circle)
    exports("does_rect_intersect_line", does_rect_intersect_line)
    exports("closest_point_on_line_segment", closest_point_on_line_segment)
    exports("triangle_area_3d", triangle_area_3d)
    exports("is_point_in_sphere", is_point_in_sphere)
    exports("do_spheres_intersect", do_spheres_intersect)
    exports("is_point_in_convex_polygon", is_point_in_convex_polygon)
    exports("rotate_point_around_point_2d", rotate_point_around_point_2d)
    exports("distance_point_to_plane", distance_point_to_plane)
    exports("rotation_to_direction", rotation_to_direction)
    exports("rotate_box", rotate_box)
    exports("calculate_rotation_matrix", calculate_rotation_matrix)
    exports("translate_point_to_local_space", translate_point_to_local_space)
    exports("is_point_in_oriented_box", is_point_in_oriented_box)
```

# Items

## Server

```lua
    --- @section Function Assignments

    items.register = register
    items.use = use_item

    --- @section Exports

    exports("register_item", register)
    exports("use_item", use_item)
```

# Keys

## Shared

```lua
    --- @section Function Assignments

    keys.get_keys = get_keys
    keys.get_key = get_key
    keys.get_key_name = get_key_name
    keys.print_key_list = print_key_list
    keys.key_exists = key_exists

    --- @section Exports

    exports("get_keys", get_keys)
    exports("get_key", get_key)
    exports("get_key_name", get_key_name)
    exports("print_key_list", print_key_list)
    exports("key_exists", key_exists)
```

# Licences

## Server

```lua
    --- @section Function Assignments

    licences.get_all = get_licences
    licences.get = get_licence
    licences.add = add_licence
    licences.remove = remove_licence
    licences.add_points = add_points
    licences.remove_points = remove_points
    licences.update = update_licence

    --- @section Exports

    exports('get_licences', get_licences)
    exports('add_licence', add_licence)
    exports('remove_licence', remove_licence)
    exports('add_points', add_points)
    exports('remove_points', remove_points)
    exports('update_licence', update_licence)
```

## Client

```lua
    --- @section Function Assignments

    licences.get_all = get_licences

    --- @section Exports

    exports('get_licences', get_licences)
```

# Maths

## Shared

```lua
    --- @section Function Assignment

    maths.round = round
    maths.calculate_distance = calculate_distance
    maths.clamp = clamp
    maths.lerp = lerp
    maths.factorial = factorial
    maths.deg_to_rad = deg_to_rad
    maths.rad_to_deg = rad_to_deg
    maths.circle_circumference = circle_circumference
    maths.circle_area = circle_area
    maths.triangle_area = triangle_area
    maths.mean = mean
    maths.median = median
    maths.mode = mode
    maths.standard_deviation = standard_deviation
    maths.linear_regression = linear_regression

    --- @section Exports

    exports('round', round)
    exports('calculate_distance', calculate_distance)
    exports('clamp', clamp)
    exports('lerp', lerp)
    exports('factorial', factorial)
    exports('deg_to_rad', deg_to_rad)
    exports('rad_to_deg', rad_to_deg)
    exports('circle_circumference', circle_circumference)
    exports('circle_area', circle_area)
    exports('triangle_area', triangle_area)
    exports('mean', mean)
    exports('median', median)
    exports('mode', mode)
    exports('standard_deviation', standard_deviation)
    exports('linear_regression', linear_regression)
```

# Player

## Shared

```lua
    --- @section Function Assignments

    player.get_distance_to_entity = get_distance_to_entity
    player.get_cardinal_direction = get_cardinal_direction

    --- @section Exports

    exports('get_distance_to_entity', get_distance_to_entity)
    exports('get_cardinal_direction', get_cardinal_direction)
```

## Client

```lua
    --- @section Function Assignments

    player.get_street_name = get_street_name
    player.get_region = get_region
    player.get_player_details = get_player_details
    player.get_target_entity = get_target_entity
    player.play_animation = play_animation

    --- @section Exports

    exports('get_street_name', get_street_name)
    exports('get_region', get_region)
    exports('get_player_details', get_player_details)
    exports('get_target_entity', get_target_entity)
    exports('play_animation', play_animation)
```

# Requests

## Client

```lua
    --- @section Function Assignments

    requests.model = request_model
    requests.interior = request_interior
    requests.texture = request_texture
    requests.collision = request_collision
    requests.anim = request_anim
    requests.anim_set = request_anim_set
    requests.clip_set = request_clip_set
    requests.audio_bank = request_audio_bank
    requests.scaleform_movie = request_scaleform_movie
    requests.cutscene = request_cutscene
    requests.ipl = request_ipl

    --- @section Exports

    exports('request_model', request_model)
    exports('request_interior', request_interior)
    exports('request_texture', request_texture)
    exports('request_collision', request_collision)
    exports('request_anim', request_anim)
    exports('request_anim_set', request_anim_set)
    exports('request_clip_set', request_clip_set)
    exports('request_audio_bank', request_audio_bank)
    exports('request_scaleform_movie', request_scaleform_movie)
    exports('request_cutscene', request_cutscene)
    exports('request_ipl', request_ipl)
```

# Strings

## Shared

```lua
    --- @section Function Assignments

    strings.capitalize = capitalize
    strings.random_string = random_string
    strings.split = split
    strings.trim = trim

    --- @section Exports

    exports('capitalize', capitalize)
    exports('random_string', random_string)
    exports('split', split)
    exports('trim', trim)
```

# Tables

## Shared

```lua
    --- @section Function Assignments

    tables.print = print_table
    tables.contains = table_contains
    tables.deep_copy = deep_copy
    tables.compare = deep_compare

    --- @section Exports

    exports('print_table', print_table)
    exports('table_contains', table_contains)
    exports('deep_copy', deep_copy)
    exports('deep_compare', deep_compare)
```

# Timestamps

## Server

```lua
    --- @section Function Assignments

    timestamps.get_timestamp = get_timestamp
    timestamps.convert_timestamp = convert_timestamp
    timestamps.get_current_date_time = get_current_date_time
    timestamps.add_days_to_date = add_days_to_date
    timestamps.date_difference = date_difference
    timestamps.convert_timestamp_ms = convert_timestamp_ms

    --- @section Exports

    exports("get_timestamp", get_timestamp)
    exports("convert_timestamp", convert_timestamp)
    exports("get_current_date_time", get_current_date_time)
    exports("add_days_to_date", add_days_to_date)
    exports("date_difference", date_difference)
    exports("convert_timestamp_ms", convert_timestamp_ms)
```

# Vehicles

## Client

```lua
    --- @section Function Assignments

    vehicles.get_vehicle_plate = get_vehicle_plate
    vehicles.get_vehicle_model = get_vehicle_model
    vehicles.get_doors_broken = get_doors_broken
    vehicles.get_windows_broken = get_windows_broken
    vehicles.get_tyre_burst = get_tyre_burst
    vehicles.get_vehicle_extras = get_vehicle_extras
    vehicles.get_custom_xenon_color = get_custom_xenon_color
    vehicles.get_vehicle_mod = get_vehicle_mod
    vehicles.get_vehicle_properties = get_vehicle_properties
    vehicles.get_vehicle_mods_and_maintenance = get_vehicle_mods_and_maintenance
    vehicles.get_vehicle_class = get_vehicle_class
    vehicles.get_vehicle_class_details = get_vehicle_class_details
    vehicles.get_vehicle_details = get_vehicle_details
    vehicles.spawn_vehicle = spawn_vehicle

    --- @section Exports

    exports('get_vehicle_plate', get_vehicle_plate)
    exports('get_vehicle_model', get_vehicle_model)
    exports('get_doors_broken', get_doors_broken)
    exports('get_windows_broken', get_windows_broken)
    exports('get_tyre_burst', get_tyre_burst)
    exports('get_vehicle_extras', get_vehicle_extras)
    exports('get_custom_xenon_color', get_custom_xenon_color)
    exports('get_vehicle_mod', get_vehicle_mod)
    exports('get_vehicle_properties', get_vehicle_properties)
    exports('get_vehicle_mods_and_maintenance', get_vehicle_mods_and_maintenance)
    exports('get_vehicle_class', get_vehicle_class)
    exports('get_vehicle_class_details', get_vehicle_class_details)
    exports('get_vehicle_details', get_vehicle_details)    
    exports('spawn_vehicle', spawn_vehicle)
```

# Version

## Server

```lua
    --- @section Function Assignments

    version.check = check_version

    --- @section Exports

    exports('check_version', check_version)
```

# XP

## Server

```lua
    --- @section Function Assignments

    xp.get_all = get_all_xp
    xp.get = get_xp
    xp.set = set_xp
    xp.add = add_xp
    xp.remove = remove_xp

    --- @section Exports

    exports('get_all_xp', get_all_xp)
    exports('get_xp', get_xp)
    exports('set_xp', set_xp)
    exports('add_xp', add_xp)
    exports('remove_xp', remove_xp)
```

## Client

```lua
    --- @section Function Assignments

    xp.get_all = get_all_xp

    --- @section Exports

    exports('get_all_xp', get_all_xp)
```