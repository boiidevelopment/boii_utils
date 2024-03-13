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
-- @script client/environment.lua

--- @section Local functions

--- Retrieves the human-readable name of the weather from its hash.
-- @function get_weather_name
-- @param hash number: The hash key of the weather type.
-- @return string: The human-readable name of the weather.
-- @usage local weather_name = utils.environment.get_weather_name(weather_hash)
local function get_weather_name(hash)
    local weather_names = {
        [GetHashKey('EXTRASUNNY')] = 'EXTRASUNNY',
        [GetHashKey('CLEAR')] = 'CLEAR',
        [GetHashKey('CLOUDS')] = 'CLOUDS',
        -- add other weather types here
        [GetHashKey('XMAS')] = 'XMAS'
    }
    return weather_names[hash] or 'UNKNOWN'
end

--- Retrieves the current game time and its formatted version.
-- @function get_game_time
-- @return table: Contains raw time data and formatted time string.
-- @usage local time_data = utils.environment.get_game_time()
local function get_game_time()
    local hour = GetClockHours()
    local minute = GetClockMinutes()
    return {
        time = {hour = hour, minute = minute},
        formatted = string.format('%02d:%02d', hour, minute)
    }
end

--- Retrieves the game's current date and its formatted version.
-- @function get_game_date
-- @return table: Contains raw date data and formatted date string.
-- @usage local date_data = utils.environment.get_game_date()
local function get_game_date()
    local day = GetClockDayOfMonth()
    local month = GetClockMonth()
    local year = GetClockYear()
    return {
        date = {day = day, month = month, year = year},
        formatted = string.format('%02d/%02d/%04d', day, month, year)
    }
end

--- @section Assigning local functions

utils.environment = utils.environment or {}

utils.environment.get_weather_name = get_weather_name
utils.environment.get_game_time = get_game_time
utils.environment.get_game_date = get_game_date

--- @section Testing

-- Test the get_weather_name function
RegisterCommand("test_weather_name", function()
    local current_weather_hash = GetNextWeatherTypeHashName()
    local weather_name = utils.environment.get_weather_name(current_weather_hash)
    print("Current weather: " .. weather_name)
end, false)

-- Test the get_game_time function
RegisterCommand("test_game_time", function()
    local time_data = utils.environment.get_game_time()
    print("Current game time (raw): " .. time_data.time.hour .. " hours, " .. time_data.time.minute .. " minutes")
    print("Current game time (formatted): " .. time_data.formatted)
end, false)

-- Test the get_game_date function
RegisterCommand("test_game_date", function()
    local date_data = utils.environment.get_game_date()
    print("Current game date (raw): " .. date_data.date.day .. "/" .. date_data.date.month .. "/" .. date_data.date.year)
    print("Current game date (formatted): " .. date_data.formatted)
end, false)
