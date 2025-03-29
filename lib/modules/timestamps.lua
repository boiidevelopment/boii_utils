--- @section Module

local timestamps = {}

if ENV.IS_SERVER then

    --- Gets the current timestamp and its formatted version.
    --- @return A table containing raw timestamp and formatted date-time string.
    local function get_timestamp()
        local ts = os.time()

        return { 
            timestamp = ts, 
            formatted = os.date("%Y-%m-%d %H:%M:%S", ts)
        }
    end

    --- Converts a UNIX timestamp to a human-readable date and time format.
    --- @param timestamp A UNIX timestamp.
    --- @return A table containing date, time, and formatted date-time string based on the input timestamp.
    local function convert_timestamp(timestamp)

        return { 
            date = os.date("%Y-%m-%d", timestamp), 
            time = os.date("%H:%M:%S", timestamp), 
            both = os.date("%Y-%m-%d %H:%M:%S", timestamp) 
        }
    end

    --- Gets the current date and time.
    --- @return A table containing the current date, time, timestamp, and formatted date-time string.
    local function get_current_date_time()
        local ts = os.time()

        return { 
            timestamp = ts,
            date = os.date("%Y-%m-%d", ts), 
            time = os.date("%H:%M:%S", ts), 
            both = os.date("%Y-%m-%d %H:%M:%S", ts)
        }
    end

    --- Adds a specified number of days to a given date.
    --- @param date The original date in "YYYY-MM-DD" format.
    --- @param days The number of days to add.
    --- @return The new date after adding the specified number of days.
    local function add_days_to_date(date, days)
        local pattern = "(%d+)-(%d+)-(%d+)"
        local year, month, day = date:match(pattern)
        local time = os.time{year=year, month=month, day=day}
        local new_time = time + (days * 24 * 60 * 60)

        return os.date("%Y-%m-%d", new_time)
    end

    --- Calculates the difference in days between two dates.
    --- @param start_date The start date in "YYYY-MM-DD" format.
    --- @param end_date The end date in "YYYY-MM-DD" format.
    --- @return A table containing the difference in days between the two dates.
    local function date_difference(start_date, end_date)
        local pattern = "(%d+)-(%d+)-(%d+)"
        local start_year, start_month, start_day = start_date:match(pattern)
        local end_year, end_month, end_day = end_date:match(pattern)
        local start = os.time{year=start_year, month=start_month, day=start_day}
        local finish = os.time{year=end_year, month=end_month, day=end_day}

        return { days = math.abs(os.difftime(finish, start) / (24 * 60 * 60)) }
    end

    --- Converts a UNIX timestamp in milliseconds to a human-readable date-time format.
    --- @param timestamp_ms A UNIX timestamp in milliseconds.
    --- @return A table containing date, time, and both date-time string based on the input timestamp in milliseconds.
    local function convert_timestamp_ms(timestamp_ms)
        local timestamp_seconds = math.floor(timestamp_ms / 1000)
        
        return { 
            date = os.date("%Y-%m-%d", timestamp_seconds), 
            time = os.date("%H:%M:%S", timestamp_seconds), 
            both = os.date("%Y-%m-%d %H:%M:%S", timestamp_seconds) 
        }
    end

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

end

return timestamps