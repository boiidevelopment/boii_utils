--- This script provides debugging utilities to aid in the development process.
-- @script shared/debug.lua

--- @section Debugging functions

--- Prints a formatted message for debugging purposes.
-- @function print_message
-- @param colour string: The color code for the message.
-- @param label string: The label for the message type (e.g., 'LOG', 'INFO').
-- @param message string: The content of the message.
local function print_message(colour, label, message)
    print('^' .. colour .. '[' .. label .. '] ^7- ' .. message)
end

--- Logs general messages.
-- @function log
-- @param message string: The message to log.
local function log(message)
    print_message('6', 'LOG', message)
end

--- Logs informational messages.
-- @function info
-- @param message string: The informational message to log.
local function info(message)
    print_message('3', 'INFO', message)
end

--- Logs warning messages.
-- @function warn
-- @param message string: The warning message to log.
local function warn(message)
    print_message('1', 'WARN', message)
end

--- Logs error messages.
-- @function err
-- @param message string: The error message to log.
local function err(message)
    print_message('8', 'ERROR', message)
end

--- Conditionally logs messages based on a condition.
-- @function conditional
-- @param condition boolean: The condition to evaluate.
-- @param message string: The message to log if the condition is true.
local function conditional(condition, message)
    if condition then
        log(message)
    end
end

--- Logs messages with a custom label.
-- @function custom
-- @param colour string: The color code for the message.
-- @param label string: The custom label for the message.
-- @param message string: The content of the message.
local function custom(colour, label, message)
    print_message(colour, label, message)
end

--- Logs the status of a specific resource.
-- @function resource_status_log
-- @param res string: The resource name to check the status of.
local function resource_status_log(res)
    if GetResourceState(res) then
        custom('3', 'RESOURCE', res .. ' is currently ' .. GetResourceState(res))
    else
        custom('8', 'RESOURCE', 'Resource ' .. res .. ' not found!')
    end
end

--- Logs the execution time of a block or function.
-- @function log_execution_time
-- @param start_time number: The start time of the execution block (obtained via GetGameTimer()).
local function log_execution_time(start_time)
    local end_time = GetGameTimer()
    local time_taken = end_time - start_time
    custom('5', 'EXECUTION TIME', 'Block/function took ' .. time_taken .. 'ms to execute.')
end

--- @section Assign local functions

utils.debug = utils.debug or {}

utils.debug.log = log
utils.debug.info = info
utils.debug.warn = warn
utils.debug.err = err
utils.debug.custom = custom
utils.debug.conditional = conditional
utils.debug.resource_status_log = resource_status_log
utils.debug.log_execution_time = log_execution_time
