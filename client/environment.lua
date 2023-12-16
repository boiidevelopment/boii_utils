----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    ENVIRONMENT UTILITIES
]]

-- Function to get the human-readable name of the weather from its hash
-- Usage: local weather_name = utils.weather.get_weather_name(weather_hash)
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

-- Function to retrieve the current game time and its formatted version
-- Usage: local time_data = utils.environment.get_game_time()
-- time_data.time for the raw values and time_data.formatted for the formatted version
local function get_game_time()
    local hour = GetClockHours()
    local minute = GetClockMinutes()
    return {
        time = {hour = hour, minute = minute},
        formatted = string.format('%02d:%02d', hour, minute)
    }
end

-- Function to retrieve the game's current date and its formatted version
-- Usage: local date_data = utils.environment.get_game_date()
-- date_data.date for the raw values and date_data.formatted for the formatted version
local function get_game_date()
    local day = GetClockDayOfMonth()
    local month = GetClockMonth()
    local year = GetClockYear()
    return {
        date = {day = day, month = month, year = year},
        formatted = string.format('%02d/%02d/%04d', day, month, year)
    }
end

--[[
    ASSIGN LOCALS
]]

utils.environment = utils.environment or {}

utils.environment.get_weather_name = get_weather_name
utils.environment.get_game_time = get_game_time
utils.environment.get_game_date = get_game_date

--[[
    TESTING
]]

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
