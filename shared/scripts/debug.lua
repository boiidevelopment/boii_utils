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

--- Debug functions.
-- @script shared/scripts/debug.lua

--- @section Debugging functions

--- Prints a formatted message for debugging purposes.
--- @function print_message
--- @param colour string: The color code for the message.
--- @param label string: The label for the message type (e.g., 'LOG', 'INFO').
--- @param message string: The content of the message.
local function print_message(colour, label, message)
    local invoking_resource = GetInvokingResource() or 'unknown'
    print("^" .. colour .. "[" .. label .. "] ^7- Resource: '" .. invoking_resource .. "' ^7- " .. message)
end

--- Logs debug messages.
--- @function log
--- @param message string: The message to log.
local function log(message)
    print_message('6', 'LOG', message)
end

exports('debug_log', log)
utils.debug.log = log

--- Logs informational messages.
--- @function info
--- @param message string: The informational message to log.
local function info(message)
    print_message('3', 'INFO', message)
end

exports('debug_info', info)
utils.debug.info = info

--- Logs warning messages.
--- @function warn
--- @param message string: The warning message to log.
local function warn(message)
    print_message('1', 'WARN', message)
end

exports('debug_warn', warn)
utils.debug.warn = warn

--- Logs error messages.
--- @function err
--- @param message string: The error message to log.
local function err(message)
    print_message('8', 'ERROR', message)
end

exports('debug_err', err)
utils.debug.err = err

--- Conditionally logs messages based on a condition.
--- @function conditional
--- @param condition boolean: The condition to evaluate.
--- @param message string: The message to log if the condition is true.
local function conditional(condition, message)
    if condition then
        log(message)
    end
end

exports('debug_conditional', conditional)
utils.debug.conditional = conditional

--- Logs messages with a custom label.
--- @function custom
--- @param colour string: The color code for the message.
--- @param label string: The custom label for the message.
--- @param message string: The content of the message.
local function custom(colour, label, message)
    print_message(colour, label, message)
end

exports('debug_custom', custom)
utils.debug.custom = custom

--- Logs the status of a specific resource.
--- @function resource_status_log
--- @param res string: The resource name to check the status of.
local function resource_status_log(res)
    if GetResourceState(res) then
        custom('3', 'RESOURCE', res .. ' is currently ' .. GetResourceState(res))
    else
        custom('8', 'RESOURCE', 'Resource ' .. res .. ' not found!')
    end
end

exports('debug_resource_status_log', resource_status_log)
utils.debug.resource_status_log = resource_status_log

--- Logs the execution time of a block or function.
--- @function log_execution_time
--- @param start_time number: The start time of the execution block (obtained via GetGameTimer()).
local function log_execution_time(start_time)
    local end_time = GetGameTimer()
    local time_taken = end_time - start_time
    custom('5', 'EXECUTION TIME', 'Block/function took ' .. time_taken .. 'ms to execute.')
end

exports('debug_log_execution_time', log_execution_time)
utils.debug.log_execution_time = log_execution_time

--- Logs a stack trace for debugging purposes.
--- @function log_stack_trace
--- @param label string: An optional label for the stack trace log.
local function log_stack_trace(label)
    label = label or 'STACK TRACE'
    custom('7', label, debug.traceback())
end

exports('debug_log_stack_trace', log_stack_trace)
utils.debug.log_stack_trace = log_stack_trace

--- Dumps the content of a variable.
--- @function dump
--- @param label string: An optional label for the variable dump.
--- @param var any: The variable to dump.
local function dump(label, var)
    label = label or 'DUMP'
    local serialized_var = json.encode(var)
    custom('9', label, serialized_var)
end

exports('debug_dump', dump)
utils.debug.dump = dump

--- Measures the execution time of a function.
--- @function measure_execution_time
--- @param func function: The function to measure.
--- @param ... any: Arguments to pass to the function.
local function measure_execution_time(func, ...)
    local start_time = GetGameTimer()
    func(...)
    local end_time = GetGameTimer()
    local time_taken = end_time - start_time
    custom('5', 'EXECUTION TIME', 'Function took ' .. time_taken .. 'ms to execute.')
end

exports('debug_measure_execution_time', measure_execution_time)
utils.debug.measure_execution_time = measure_execution_time

--- Logs the current resource usage of the server.
--- @function log_resource_usage
local function log_resource_usage()
    local resources = GetNumResources()
    for i = 0, resources - 1 do
        local resource_name = GetResourceByFindIndex(i)
        local resource_state = GetResourceState(resource_name)
        custom('4', 'RESOURCE USAGE', resource_name .. ' is ' .. resource_state)
    end
end

exports('debug_log_resource_usage', log_resource_usage)
utils.debug.log_resource_usage = log_resource_usage

--- Emulates try-catch behavior in Lua.
--- @function try_catch
--- @param try_func function: The function to execute.
--- @param catch_func function: The function to execute if an error occurs in try_func.
local function try_catch(try_func, catch_func)
    local status, err = pcall(try_func)
    if not status and catch_func then
        catch_func(err)
    end
end

exports('debug_try_catch', try_catch)
utils.debug.try_catch = try_catch

--- Ensures a function is called only once.
--- @function once
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

exports('debug_once', once)
utils.debug.once = once

--- Throttles function execution.
--- @function throttle
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

exports('debug_throttle', throttle)
utils.debug.throttle = throttle

--- Checks if a given value is a number.
-- @function debug_is_number
-- @param value any: The value to be checked.
-- @return boolean: Returns true if the value is a number.
local function is_number(value)
    return type(value) == "number"
end

exports('debug_is_number', is_number)
utils.debug.is_number = is_number

--- Checks if a given value is a table.
-- @function debug_is_table
-- @param value any: The value to be checked.
-- @return boolean: Returns true if the value is a table.
local function is_table(value)
    return type(value) == "table"
end

exports('debug_is_table', is_table)
utils.debug.is_table = is_table

--- Checks if a given value is a string.
-- @function debug_is_string
-- @param value any: The value to be checked.
-- @return boolean: Returns true if the value is a string.
local function is_string(value)
    return type(value) == "string"
end

exports('debug_is_string', is_string)
utils.debug.is_string = is_string

--- Checks if a given value is a function.
-- @function debug_is_function
-- @param value any: The value to be checked.
-- @return boolean: Returns true if the value is a function.
local function is_function(value)
    return type(value) == "function"
end

exports('debug_is_function', is_function)
utils.debug.is_function = is_function

--- Checks if a given value is a boolean.
-- @function debug_is_boolean
-- @param value any: The value to be checked.
-- @return boolean: Returns true if the value is a boolean.
local function is_boolean(value)
    return type(value) == "boolean"
end

exports('debug_is_boolean', is_boolean)
utils.debug.is_boolean = is_boolean

--- Returns the first non-nil value from the given arguments.
-- @function debug_coalesce
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

exports('debug_coalesce', coalesce)
utils.debug.coalesce = coalesce

--- Checks if a given value is empty (table or string).
-- @function debug_is_empty
-- @param value any: The value to check.
-- @return boolean: Returns true if the value is empty.
local function is_empty(value)
    if type(value) == "table" then
        return next(value) == nil
    elseif type(value) == "string" then
        return value == ""
    end
    return false
end

exports('debug_is_empty', is_empty)
utils.debug.is_empty = is_empty

--- Creates a debounced version of a function.
-- @function debug_debounce
-- @param func function: The function to debounce.
-- @param delay number: The delay in milliseconds.
-- @return function: The debounced function.
local function debounce(func, delay)
    local timer
    return function(...)
        local args = {...}
        if timer then
            timer:cancel()
        end
        timer = SetTimeout(delay, function()
            func(table.unpack(args))
        end)
    end
end

exports('debug_debounce', debounce)
utils.debug.debounce = debounce