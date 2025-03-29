--- @module Environment

local environment = {}

if not IS_SERVER then

    --- Retrieves the human-readable name of the weather from its hash.
    --- @function get_weather_name
    --- @param hash number: The hash key of the weather type.
    --- @return string: The human-readable name of the weather.
    --- @usage local weather_name = utils.environment.get_weather_name(weather_hash)
    local function get_weather_name(hash)
        local weather_names = {
            [GetHashKey("EXTRASUNNY")] = "EXTRASUNNY",
            [GetHashKey("CLEAR")] = "CLEAR",
            [GetHashKey("CLOUDS")] = "CLOUDS",
            [GetHashKey("OVERCAST")] = "OVERCAST",
            [GetHashKey("RAIN")] = "RAIN",
            [GetHashKey("THUNDER")] = "THUNDER",
            [GetHashKey("CLEARING")] = "CLEARING",
            [GetHashKey("NEUTRAL")] = "NEUTRAL",
            [GetHashKey("SNOW")] = "SNOW",
            [GetHashKey("BLIZZARD")] = "BLIZZARD",
            [GetHashKey("SNOWLIGHT")] = "SNOWLIGHT",
            [GetHashKey("XMAS")] = "XMAS",
            [GetHashKey("HALLOWEEN")] = "HALLOWEEN",
        }

        return weather_names[hash] or "UNKNOWN"
    end

    --- Retrieves the current game time and its formatted version.
    --- @return table: Contains raw time data and formatted time string.
    local function get_game_time()
        local hour, minute = GetClockHours(), GetClockMinutes()

        return {
            time = {hour = hour, minute = minute},
            formatted = string.format("%02d:%02d", hour, minute)
        }
    end

    --- Retrieves the game"s current date and its formatted version.
    --- @return table: Contains raw date data and formatted date string.
    local function get_game_date()
        local day, month, year = GetClockDayOfMonth(), GetClockMonth(), GetClockYear()

        return {
            date = {day = day, month = month, year = year},
            formatted = string.format("%02d/%02d/%04d", day, month, year)
        }
    end

    --- Retrieves sunrise and sunset times based on weather.
    --- @param weather string: The current weather type.
    --- @return table: Sunrise and sunset times.
    local function get_sunrise_sunset_times(weather)
        local times = {
            CLEAR = { sunrise = "06:00", sunset = "18:00" },
            CLOUDS = { sunrise = "06:15", sunset = "17:45" },
            OVERCAST = { sunrise = "06:30", sunset = "17:30" },
            RAIN = { sunrise = "07:00", sunset = "17:00" },
            THUNDER = { sunrise = "07:00", sunset = "17:00" },
            SNOW = { sunrise = "08:00", sunset = "16:00" },
            BLIZZARD = { sunrise = "09:00", sunset = "15:00" },
        }

        return times[weather] or {sunrise = "06:00", sunset = "18:00"}
    end

    --- Checks if the current time is daytime.
    --- @return boolean: True if daytime, false otherwise.
    local function is_daytime()
        return GetClockHours() >= 6 and GetClockHours() < 18
    end

    --- Retrieves the current season.
    --- @return string: The current season.
    local function get_current_season()
        local month = GetClockMonth()

        local seasons = {
            [0] = "Winter", 
            [1] = "Winter", 
            [2] = "Winter",
            [3] = "Spring", 
            [4] = "Spring", 
            [5] = "Spring",
            [6] = "Summer", 
            [7] = "Summer", 
            [8] = "Summer",
            [9] = "Autumn", 
            [10] = "Autumn", 
            [11] = "Autumn"
        }

        return seasons[month] or "Unknown"
    end

    --- Get the distance from the player to the nearest water body.
    --- @return number: The distance to the nearest water body.
    local function get_distance_to_water()
        local player_coords = GetEntityCoords(PlayerPedId())
        local water_test_result, water_height = TestVerticalProbeAgainstAllWater(player_coords.x, player_coords.y, player_coords.z, 0)

        return water_test_result and #(player_coords - vector3(player_coords.x, player_coords.y, water_height)) or -1
    end

    --- Gets the scumminess level of the player"s current zone.
    --- @return integer: The scumminess level (0-5) or -1 if unknown.
    local function get_zone_scumminess()
        local player_coords = GetEntityCoords(PlayerPedId())
        local zone_id = GetZoneAtCoords(player_coords.x, player_coords.y, player_coords.z)

        return zone_id and GetZoneScumminess(zone_id) or -1
    end

    --- Retrieves the ground material type at the player"s position.
    --- @return material_hash: Ground type hash
    local function get_ground_material()
        local coords = GetEntityCoords(PlayerPedId())
        local shape_test = StartShapeTestCapsule(coords.x, coords.y, coords.z + 1.0, coords.x, coords.y, coords.z - 2.0, 2, 1, PlayerPedId(), 7)
        local _, _, _, _, material_hash = GetShapeTestResultEx(shape_test)

        return material_hash
    end

    --- Retrieves the wind direction as a readable compass value.
    --- @return string: Compass direction (N, NE, E, SE, S, SW, W, NW)
    local function get_wind_direction()
        local wind_vector = GetWindDirection()
        local angle = math.deg(math.atan2(wind_vector.y, wind_vector.x)) + 180
        local directions = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }

        return directions[math.floor(((angle + 22.5) % 360) / 45) + 1] or "Unknown"
    end

    --- Retrieves the player"s altitude above sea level.
    --- @return number: Altitude value.
    local function get_altitude()
        return GetEntityCoords(PlayerPedId()).z
    end

    --- Retrieves environment details.
    --- @return table: Detailed environment information.
    local function get_environment_details()
        return {
            weather = get_weather_name(GetPrevWeatherTypeHashName()),
            time = get_game_time(),
            date = get_game_date(),
            season = get_current_season(),
            sunrise_sunset = get_sunrise_sunset_times(get_weather_name(GetPrevWeatherTypeHashName())),
            is_daytime = is_daytime(),
            distance_to_water = get_distance_to_water(),
            scumminess = get_zone_scumminess(),
            ground_material = get_ground_material(),
            rain_level = GetRainLevel(),
            wind_speed = GetWindSpeed(),
            wind_direction = get_wind_direction(),
            snow_level = GetSnowLevel(),
            altitude = get_altitude()
        }
    end

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

end

return environment