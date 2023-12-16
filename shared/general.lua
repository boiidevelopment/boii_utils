----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    GENERAL UTILITIES
]]

-- Check if a given value is a number
-- Usage: local result = is_number(123) -- Returns true
local function is_number(value)
    return type(value) == "number"
end

-- Check if a given value is a table
-- Usage: local result = is_table({a = 1, b = 2}) -- Returns true
local function is_table(value)
    return type(value) == "table"
end

-- Check if a given value is a string
-- Usage: local result = is_string("Hello World") -- Returns true
local function is_string(value)
    return type(value) == "string"
end

-- Check if a given value is a function
-- Usage: local result = is_function(function() return end) -- Returns true
local function is_function(value)
    return type(value) == "function"
end

-- Check if a given value is a boolean
-- Usage: local result = is_boolean(true) -- Returns true
local function is_boolean(value)
    return type(value) == "boolean"
end

-- Coalesce function: Returns the first non-nil value in the arguments
-- Usage: local result = coalesce(nil, "Hello", "World") -- Returns "Hello"
local function coalesce(...)
    for _, value in ipairs({...}) do
        if value ~= nil then
            return value
        end
    end
    return ""
end

-- Converts a boolean to a string
-- Usage: local strValue = bool_to_string(true) -- Returns "true"
local function bool_to_string(value)
    return value and "true" or "false"
end

-- Converts RGB values to a HEX string
-- Usage: local hexColor = rgb_to_hex(255, 0, 0) -- Returns "#FF0000"
local function rgb_to_hex(r, g, b)
    return string.format("#%02X%02X%02X", r, g, b)
end

-- Emulate try-catch behavior
-- Usage: try_catch(function() error("Oops!") end, function(err) print("Caught error: " .. err) end)
local function try_catch(try_func, catch_func)
    local status, err = pcall(try_func)
    if not status and catch_func then
        catch_func(err)
    end
end

-- Ensure a function is called only once
-- Usage: local init = once(function() print("Initializing...") end); init(); init();
local function once(func)
    local called = false
    return function(...)
        if not called then
            called = true
            return func(...)
        end
    end
end

-- Throttle function execution
-- Usage: local throttled_print = throttle(function() print("Hello!") end, 1000); throttled_print(); throttled_print();
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


--[[
    ASSIGN LOCALS
]]

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