----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    DEBUGGING UTILITIES
]]

-- Base function to print a formatted message
-- Usage: print_message('6', 'LOG', 'This is a test message.')
local function print_message(colour, label, message)
    print('^' .. colour ..'[' .. label .. '] ^7- ' .. message)
end

-- General logging function
-- Usage: log('This is a general log message.')
local function log(message)
    print_message('6', 'LOG', message)
end

-- Information logging function
-- Usage: info('This is an information log message.')
local function info(message)
    print_message('3', 'INFO', message)
end

-- Warning logging function
-- Usage: warn_log('This is a warning log message.')
local function warn(message)
    print_message('1', 'WARN', message)
end

-- Error logging function
-- Usage: error('This is an error log message.')
local function err(message)
    print_message('8', 'ERROR', message)
end

-- Conditional logging function
-- Usage: conditional(true, 'This will log.')
local function conditional(condition, message)
    if condition then
        log(message)
    end
end

-- Custom labeled logging function
-- Usage: custom('DATABASE', 'This is a database operation log.')
local function custom(colour, label, message)
    print_message(colour, label, message)
end

-- Log the status of a specific resource
-- Usage: resource_status_log('resource_name')
local function resource_status_log(res)
    if GetResourceState(res) then
        custom('3', 'RESOURCE', res .. ' is currently ' .. GetResourceState(res))
    else
        custom('8', 'RESOURCE', 'Resource ' .. res .. ' not found!')
    end
end

-- Log the time taken for a function/block to execute
-- Usage: 
-- local start = GetGameTimer()
-- -- Your code block/function here
-- log_execution_time(start)
local function log_execution_time(start_time)
    local end_time = GetGameTimer()
    local time_taken = end_time - start_time
    custom_log('5', 'EXECUTION TIME', 'Block/function took ' .. time_taken .. 'ms to execute.')
end

--[[
    ASSIGN LOCALS
]]

utils.debug = utils.debug or {}

utils.debug.log = log
utils.debug.info = info
utils.debug.warn = warn
utils.debug.err = err
utils.debug.custom = custom
utils.debug.conditional = conditional
utils.debug.resource_status_log = resource_status_log
utils.debug.log_execution_time = log_execution_time
