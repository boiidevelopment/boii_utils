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

--- General use funtions.
-- @script server/general/general.lua

--- @section Type Checking Functions

--- Checks if a given value is a number.
-- @function is_number
-- @param value any: The value to be checked.
-- @return boolean: Returns true if the value is a number.
local function is_number(value)
    return type(value) == "number"
end

--- Checks if a given value is a table.
-- @function is_table
-- @param value any: The value to be checked.
-- @return boolean: Returns true if the value is a table.
local function is_table(value)
    return type(value) == "table"
end

--- Checks if a given value is a string.
-- @function is_string
-- @param value any: The value to be checked.
-- @return boolean: Returns true if the value is a string.
local function is_string(value)
    return type(value) == "string"
end

--- Checks if a given value is a function.
-- @function is_function
-- @param value any: The value to be checked.
-- @return boolean: Returns true if the value is a function.
local function is_function(value)
    return type(value) == "function"
end

--- Checks if a given value is a boolean.
-- @function is_boolean
-- @param value any: The value to be checked.
-- @return boolean: Returns true if the value is a boolean.
local function is_boolean(value)
    return type(value) == "boolean"
end

--- @section Utility Functions

--- Returns the first non-nil value from the given arguments.
-- @function coalesce
-- @param ... any: A variable number of arguments.
-- @return any: The first non-nil argument.
local function coalesce(...)
    for _, value in ipairs({...}) do
        if value ~= nil then
            return value
        end
    end
    return ""
end

--- Converts a boolean value to its corresponding string representation.
-- @function bool_to_string
-- @param value boolean: The boolean value to convert.
-- @return string: "true" if value is true, otherwise "false".
local function bool_to_string(value)
    return value and "true" or "false"
end

--- Converts RGB color values to a HEX string.
-- @function rgb_to_hex
-- @param r number: Red component (0-255).
-- @param g number: Green component (0-255).
-- @param b number: Blue component (0-255).
-- @return string: The HEX color string (e.g., "#FF0000").
local function rgb_to_hex(r, g, b)
    return string.format("#%02X%02X%02X", r, g, b)
end

--- Emulates try-catch behavior in Lua.
-- @function try_catch
-- @param try_func function: The function to execute.
-- @param catch_func function: The function to execute if an error occurs in try_func.
local function try_catch(try_func, catch_func)
    local status, err = pcall(try_func)
    if not status and catch_func then
        catch_func(err)
    end
end

--- Ensures a function is called only once.
-- @function once
-- @param func function: The function to be executed.
-- @return function: A function that executes the given func only once.
local function once(func)
    local called = false
    return function(...)
        if not called then
            called = true
            return func(...)
        end
    end
end

--- Throttles function execution.
-- @function throttle
-- @param func function: The function to be executed.
-- @param delay number: The minimum delay between function calls in milliseconds.
-- @return function: A function that executes the given func not more frequently than the specified delay.
local function throttle(func, delay)
    local last = 0
    return function(...)
        local now = GetGameTimer()
        if now - last >= delay then
            last = now
            return func(...)
        end
    end
end

--- @section Assign local functions

utils.general = utils.general or {}

utils.general.is_number = is_number
utils.general.is_table = is_table
utils.general.is_string = is_string
utils.general.is_function = is_function
utils.general.is_boolean = is_boolean
utils.general.coalesce = coalesce
utils.general.bool_to_string = bool_to_string
utils.general.rgb_to_hex = rgb_to_hex
utils.general.try_catch = try_catch
utils.general.once = once
utils.general.throttle = throttle
