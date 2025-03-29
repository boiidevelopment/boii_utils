--- @section Constants

--- Debug note levels and colour.
--- You can add aditional levels if you like here then just access as normal.
--- Uses standard ^1 - ^9 colour codes.
--- @type table<number, string>: A table of kvp debug levels and colour.
local DEBUG_COLOURS <const> = {
    reset = "^7", -- White
    debug = "^6", -- Violet
    info = "^5", -- Cyan
    success = "^2", -- Green
    warn = "^3", -- Yellow
    error = "^8" -- Red 
}

--- @section Native Assignments

local GetLocalTime = GetLocalTime

--- @module Debugging

local debugging = {}

--- Get the current time for logging.
--- @return string: The formatted current time in "YYYY-MM-DD HH:MM:SS" format.
local function get_current_time()
    return ENV.IS_SERVER and os.date("%Y-%m-%d %H:%M:%S") or (GetLocalTime and string.format("%04d-%02d-%02d %02d:%02d:%02d", GetLocalTime()) or "0000-00-00 00:00:00")
end

exports("get_current_time", get_current_time)
debugging.get_current_time = get_current_time

--- Logs debug messages with levels and optional data.
--- @param level string: The log level ("debug", "info", "success", "warn", "error").
--- @param message string: The message to log.
--- @param data table|nil: Optional data to include in the log.
local function debug_print(level, message, data)
    local resource_name = GetInvokingResource() or "UTILS"
    -- For some reason mapmanager invokes internal logs on load? 
    -- Not looked into why, dont really care why, but now it doesnt.
    if resource_name == "mapmanager" then return end 

    print(("%s[%s][%s]: %s%s"):format(DEBUG_COLOURS[level] or "^7", resource_name:upper(), level:upper(), DEBUG_COLOURS.reset or "^7", message), data and json.encode(data) or "")
end

--- @section Function Assignments

debugging.print = debug_print

--- @section Exports

exports("debug_print", debug_print)

return debugging