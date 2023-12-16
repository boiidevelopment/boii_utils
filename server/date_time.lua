----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    DATE & TIME UTILITIES
]]

-- Get the current timestamp in seconds and its formatted version
-- Usage: local time_data = utils.dates.get_timestamp()
-- time_data.timestamp for raw value and time_data.formatted for the formatted version
local function get_timestamp()
    local ts = os.time()
    return {
        timestamp = ts,
        formatted = os.date('%Y-%m-%d %H:%M:%S', ts)
    }
end

-- Converts a UNIX timestamp to a readable date and time format
-- Usage: local date_data = utils.dates.convert_timestamp(1628759592)
-- date_data.date for date, date_data.time for time and date_data.formatted for full date-time
local function convert_timestamp(timestamp)
    return {
        date = os.date('%Y-%m-%d', timestamp),
        time = os.date('%H:%M:%S', timestamp),
        formatted = os.date('%Y-%m-%d %H:%M:%S', timestamp)
    }
end

-- Get the current date and time
-- Usage: local current_data = utils.dates.get_current_date_time()
-- current_data.date for date, current_data.time for time, current_data.timestamp for raw timestamp
local function get_current_date_time()
    local ts = os.time()
    return {
        date = os.date('%Y-%m-%d', ts),
        time = os.date('%H:%M:%S', ts),
        timestamp = ts
    }
end

-- Get the difference between two dates in days
-- Usage: local days_diff_data = utils.dates.date_difference("2023-10-01", "2023-10-19")
-- days_diff_data.days for the difference in days
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

-- Add days to a given date
-- Usage: local new_date = add_days_to_date("2023-10-01", 10) -- Returns "2023-10-11"
local function add_days_to_date(date, days)
    local pattern = "(%d+)-(%d+)-(%d+)"
    local year, month, day = date:match(pattern)
    local time = os.time{year=year, month=month, day=day}
    local new_time = time + (days * 24 * 60 * 60)
    return os.date('%Y-%m-%d', new_time)
end

-- Convert a UNIX timestamp in milliseconds to a readable date-time format
-- Usage: local date_time_data = utils.dates.convert_timestamp_ms(1628759592000)
-- date_time_data.date for date, date_time_data.time for time, date_time_data.formatted for full date-time
local function convert_timestamp_ms(timestamp_ms)
    local timestamp_seconds = math.floor(timestamp_ms / 1000)
    return {
        date = os.date('%Y-%m-%d', timestamp_seconds),
        time = os.date('%H:%M:%S', timestamp_seconds),
        formatted = os.date('%Y-%m-%d %H:%M:%S', timestamp_seconds)
    }
end

-- Get the difference between two timestamps in milliseconds
-- Usage: local diff_ms = timestamp_difference_ms(timestamp_ms1, timestamp_ms2)
local function timestamp_difference_ms(timestamp_ms1, timestamp_ms2)
    return math.abs(timestamp_ms1 - timestamp_ms2)
end

-- Add milliseconds to a given timestamp
-- Usage: local new_timestamp_ms = add_ms_to_timestamp(timestamp_ms, milliseconds)
local function add_ms_to_timestamp(timestamp_ms, milliseconds)
    return timestamp_ms + milliseconds
end

utils.dates = utils.dates or {}

utils.dates.get_timestamp = get_timestamp
utils.dates.convert_timestamp = convert_timestamp
utils.dates.get_current_date_time = get_current_date_time
utils.dates.date_difference = date_difference
utils.dates.add_days_to_date = add_days_to_date
utils.dates.convert_timestamp_ms = convert_timestamp_ms
utils.dates.timestamp_difference_ms = timestamp_difference_ms
utils.dates.add_ms_to_timestamp = add_ms_to_timestamp