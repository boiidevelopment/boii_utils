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

--- Date & Time functions.
-- @script server/database.lua

--- @section Local functions

--- Gets the current timestamp and its formatted version.
-- @return A table containing raw timestamp and formatted date-time string.
-- @usage local time_data = utils.dates.get_timestamp()
local function get_timestamp()
    local ts = os.time()
    return {
        timestamp = ts,
        formatted = os.date('%Y-%m-%d %H:%M:%S', ts)
    }
end

--- Converts a UNIX timestamp to a human-readable date and time format.
-- @param timestamp A UNIX timestamp.
-- @return A table containing date, time, and formatted date-time string based on the input timestamp.
-- @usage local date_data = utils.dates.convert_timestamp(1628759592)
local function convert_timestamp(timestamp)
    return {
        date = os.date('%Y-%m-%d', timestamp),
        time = os.date('%H:%M:%S', timestamp),
        formatted = os.date('%Y-%m-%d %H:%M:%S', timestamp)
    }
end

--- Gets the current date and time.
-- @return A table containing the current date, time, and timestamp.
-- @usage local current_data = utils.dates.get_current_date_time()
local function get_current_date_time()
    local ts = os.time()
    return {
        date = os.date('%Y-%m-%d', ts),
        time = os.date('%H:%M:%S', ts),
        timestamp = ts
    }
end

--- Calculates the difference in days between two dates.
-- @param start_date The start date in "YYYY-MM-DD" format.
-- @param end_date The end date in "YYYY-MM-DD" format.
-- @return A table containing the difference in days between the two dates.
-- @usage local days_diff_data = utils.dates.date_difference("2023-10-01", "2023-10-19")
local function date_difference(start_date, end_date)
    local pattern = "(%d+)-(%d+)-(%d+)"
    local start_year, start_month, start_day = start_date:match(pattern)
    local end_year, end_month, end_day = end_date:match(pattern)
    local start = os.time{year=start_year, month=start_month, day=start_day}
    local finish = os.time{year=end_year, month=end_month, day=end_day}
    return {
        days = math.abs(os.difftime(finish, start) / (24 * 60 * 60))
    }
end

--- Adds a specified number of days to a given date.
-- @param date The original date in "YYYY-MM-DD" format.
-- @param days The number of days to add.
-- @return The new date after adding the specified number of days.
-- @usage local new_date = add_days_to_date("2023-10-01", 10) -- Returns "2023-10-11"
local function add_days_to_date(date, days)
    local pattern = "(%d+)-(%d+)-(%d+)"
    local year, month, day = date:match(pattern)
    local time = os.time{year=year, month=month, day=day}
    local new_time = time + (days * 24 * 60 * 60)
    return os.date('%Y-%m-%d', new_time)
end

--- Converts a UNIX timestamp in milliseconds to a human-readable date-time format.
-- @param timestamp_ms A UNIX timestamp in milliseconds.
-- @return A table containing date, time, and formatted date-time string based on the input timestamp in milliseconds.
-- @usage local date_time_data = utils.dates.convert_timestamp_ms(1628759592000)
local function convert_timestamp_ms(timestamp_ms)
    local timestamp_seconds = math.floor(timestamp_ms / 1000)
    return {
        date = os.date('%Y-%m-%d', timestamp_seconds),
        time = os.date('%H:%M:%S', timestamp_seconds),
        formatted = os.date('%Y-%m-%d %H:%M:%S', timestamp_seconds)
    }
end

--- Calculates the difference in milliseconds between two timestamps.
-- @param timestamp_ms1 The first timestamp in milliseconds.
-- @param timestamp_ms2 The second timestamp in milliseconds.
-- @return The absolute difference in milliseconds between the two timestamps.
-- @usage local diff_ms = timestamp_difference_ms(timestamp_ms1, timestamp_ms2)
local function timestamp_difference_ms(timestamp_ms1, timestamp_ms2)
    return math.abs(timestamp_ms1 - timestamp_ms2)
end

--- Adds a specified number of milliseconds to a given timestamp.
-- @param timestamp_ms The original timestamp in milliseconds.
-- @param milliseconds The number of milliseconds to add.
-- @return The new timestamp after adding the specified number of milliseconds.
-- @usage local new_timestamp_ms = add_ms_to_timestamp(timestamp_ms, milliseconds)
local function add_ms_to_timestamp(timestamp_ms, milliseconds)
    return timestamp_ms + milliseconds
end

--- @section Assign local functions

utils.dates.get_timestamp = get_timestamp
utils.dates.convert_timestamp = convert_timestamp
utils.dates.get_current_date_time = get_current_date_time
utils.dates.date_difference = date_difference
utils.dates.add_days_to_date = add_days_to_date
utils.dates.convert_timestamp_ms = convert_timestamp_ms
utils.dates.timestamp_difference_ms = timestamp_difference_ms
utils.dates.add_ms_to_timestamp = add_ms_to_timestamp