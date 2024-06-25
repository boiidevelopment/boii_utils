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

--- Environment functions.
--- @script client/environment.lua

--- @section Local functions

--- Retrieves the human-readable name of the weather from its hash.
--- @function get_weather_name
--- @param hash number: The hash key of the weather type.
--- @return string: The human-readable name of the weather.
--- @usage local weather_name = utils.environment.get_weather_name(weather_hash)
local function get_weather_name(hash)
    local weather_names = {
        [GetHashKey('EXTRASUNNY')] = 'EXTRASUNNY',
        [GetHashKey('CLEAR')] = 'CLEAR',
        [GetHashKey('CLOUDS')] = 'CLOUDS',
        [GetHashKey('OVERCAST')] = 'OVERCAST',
        [GetHashKey('RAIN')] = 'RAIN',
        [GetHashKey('THUNDER')] = 'THUNDER',
        [GetHashKey('CLEARING')] = 'CLEARING',
        [GetHashKey('NEUTRAL')] = 'NEUTRAL',
        [GetHashKey('SNOW')] = 'SNOW',
        [GetHashKey('BLIZZARD')] = 'BLIZZARD',
        [GetHashKey('SNOWLIGHT')] = 'SNOWLIGHT',
        [GetHashKey('XMAS')] = 'XMAS'
    }
    return weather_names[hash] or 'UNKNOWN'
end

exports('environment_get_weather_name', get_weather_name)
utils.environment.get_weather_name = get_weather_name

--- Retrieves the current game time and its formatted version.
--- @function get_game_time
--- @return table: Contains raw time data and formatted time string.
--- @usage local time_data = utils.environment.get_game_time()
local function get_game_time()
    local hour = GetClockHours()
    local minute = GetClockMinutes()
    return {
        time = {hour = hour, minute = minute},
        formatted = string.format('%02d:%02d', hour, minute)
    }
end

exports('environment_get_game_time', get_game_time)
utils.environment.get_game_time = get_game_time

--- Retrieves the game's current date and its formatted version.
--- @function get_game_date
--- @return table: Contains raw date data and formatted date string.
--- @usage local date_data = utils.environment.get_game_date()
local function get_game_date()
    local day = GetClockDayOfMonth()
    local month = GetClockMonth()
    local year = GetClockYear()
    return {
        date = {day = day, month = month, year = year},
        formatted = string.format('%02d/%02d/%04d', day, month, year)
    }
end

exports('environment_get_game_date', get_game_date)
utils.environment.get_game_date = get_game_date

--- Sets the current weather.
--- @function set_weather
--- @param weather string: The name of the weather type to set.
--- @usage utils.environment.set_weather('CLEAR')
local function set_weather(weather)
    SetWeatherTypeOvertimePersist(weather, 1.0)
end

exports('environment_set_weather', set_weather)
utils.environment.set_weather = set_weather

--- Sets the current game time.
--- @function set_game_time
--- @param hour number: The hour to set (0-23).
--- @param minute number: The minute to set (0-59).
--- @usage utils.environment.set_game_time(12, 0)
local function set_game_time(hour, minute)
    NetworkOverrideClockTime(hour, minute, 0)
end

exports('environment_set_game_time', set_game_time)
utils.environment.set_game_time = set_game_time

--- Retrieves the current wind speed.
--- @function get_wind_speed
--- @return number: The current wind speed.
--- @usage local wind_speed = utils.environment.get_wind_speed()
local function get_wind_speed()
    return GetWindSpeed()
end

exports('environment_get_wind_speed', get_wind_speed)
utils.environment.get_wind_speed = get_wind_speed

--- Retrieves the current wind direction.
--- @function get_wind_direction
--- @return vector3: The current wind direction.
--- @usage local wind_direction = utils.environment.get_wind_direction()
local function get_wind_direction()
    return GetWindDirection()
end

exports('environment_get_wind_direction', get_wind_direction)
utils.environment.get_wind_direction = get_wind_direction

--- Sets the wind speed.
--- @function set_wind_speed
--- @param speed number: The wind speed to set.
--- @usage utils.environment.set_wind_speed(10.0)
local function set_wind_speed(speed)
    SetWindSpeed(speed)
end

exports('environment_set_wind_speed', set_wind_speed)
utils.environment.set_wind_speed = set_wind_speed

--- Sets the wind direction.
--- @function set_wind_direction
--- @param direction vector3: The wind direction to set.
--- @usage utils.environment.set_wind_direction(vector3(1.0, 0.0, 0.0))
local function set_wind_direction(direction)
    SetWindDirection(direction)
end

exports('environment_set_wind_direction', set_wind_direction)
utils.environment.set_wind_direction = set_wind_direction

--- Retrieves the sunrise and sunset times based on the weather type.
--- @function get_sunrise_sunset_times
--- @param weather string: The current weather type.
--- @return table: Sunrise and sunset times.
--- @usage local times = utils.environment.get_sunrise_sunset_times('CLEAR')
local function get_sunrise_sunset_times(weather)
    local times = {
        CLEAR = {sunrise = '06:00', sunset = '18:00'},
        CLOUDS = {sunrise = '06:15', sunset = '17:45'},
        OVERCAST = {sunrise = '06:30', sunset = '17:30'},
        RAIN = {sunrise = '07:00', sunset = '17:00'},
        THUNDER = {sunrise = '07:00', sunset = '17:00'},
        SNOW = {sunrise = '08:00', sunset = '16:00'},
        BLIZZARD = {sunrise = '09:00', sunset = '15:00'},
    }
    return times[weather] or {sunrise = '06:00', sunset = '18:00'}
end

exports('environment_get_sunrise_sunset_times', get_sunrise_sunset_times)
utils.environment.get_sunrise_sunset_times = get_sunrise_sunset_times

--- Checks if the current time is day or night.
--- @function is_daytime
--- @return boolean: True if its daytime, false if its nighttime.
--- @usage local is_day = utils.environment.is_daytime()
local function is_daytime()
    local hour = GetClockHours()
    return hour >= 6 and hour < 18
end

exports('environment_is_daytime', is_daytime)
utils.environment.is_daytime = is_daytime

--- Retrieves the current season based on the in-game date.
--- @function get_current_season
--- @return string: The current season.
--- @usage local season = utils.environment.get_current_season()
local function get_current_season()
    local month = GetClockMonth()
    if month >= 3 and month <= 5 then
        return 'Spring'
    elseif month >= 6 and month <= 8 then
        return 'Summer'
    elseif month >= 9 and month <= 11 then
        return 'Autumn'
    else
        return 'Winter'
    end
end

exports('environment_get_current_season', get_current_season)
utils.environment.get_current_season = get_current_season

--- Get the distance from the player to the nearest water body.
--- @function get_distance_to_water
--- @return number: The distance to the nearest water body.
--- @usage local distance_to_water = utils.water.get_distance_to_water()
local function get_distance_to_water()
    local player_coords = GetEntityCoords(PlayerPedId())
    local water_test_result, water_height = TestVerticalProbeAgainstAllWater(player_coords.x, player_coords.y, player_coords.z, 0)
    if water_test_result then
        return #(player_coords - vector3(player_coords.x, player_coords.y, water_height))
    else
        return -1
    end
end

exports('environment_get_distance_to_water', get_distance_to_water)
utils.environment.get_distance_to_water = get_distance_to_water

--- Get the water height at a specific location.
--- @function get_water_height_at_coords
--- @param coords vector3: The coordinates to check the water height.
--- @return number: The height of the water at the specified coordinates, or -1 if no water found.
--- @usage local water_height = utils.water.get_water_height_at_coords(vector3(0, 0, 0))
local function get_water_height_at_coords(coords)
    local water_test_result, water_height = GetWaterHeight(coords.x, coords.y, coords.z)
    if water_test_result then
        return water_height
    else
        return -1
    end
end

exports('environment_get_water_height_at_coords', get_water_height_at_coords)
utils.environment.get_water_height_at_coords = get_water_height_at_coords

--- Retrieves comprehensive environment details including current season, time, weather, sunrise/sunset times, wind direction and speed, etc.
--- @function get_environment_details
--- @return table: A table containing detailed environment information.
--- @usage local env_details = utils.environment.get_environment_details()
local function get_environment_details()
    local weather_hash = GetPrevWeatherTypeHashName()
    local weather_name = get_weather_name(weather_hash)
    local game_time = get_game_time()
    local game_date = get_game_date()
    local current_season = get_current_season()
    local sunrise_sunset_times = get_sunrise_sunset_times(weather_name)
    local wind_speed = get_wind_speed()
    local wind_direction = get_wind_direction()
    local is_daytime_now = is_daytime()
    local distance_to_water = get_distance_to_water()
    return {
        weather = weather_name,
        time = game_time,
        date = game_date,
        season = current_season,
        sunrise = sunrise_sunset_times.sunrise,
        sunset = sunrise_sunset_times.sunset,
        wind_speed = wind_speed,
        wind_direction = wind_direction,
        is_daytime = is_daytime_now,
        distance_to_water = distance_to_water
    }
end

exports('environment_get_environment_details', get_environment_details)
utils.environment.get_environment_details = get_environment_details