----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    FUNCTIONS
]]

local notifications = config.notifications

local function send(_src, options)
    if notifications == 'boii_ui' then
        TriggerClientEvent('boii_ui:notify', _src, options.type, options.header, options.message, options.duration)
    end
end

--[[
    ASSIGN LOCALS
]]

utils.notify = utils.notify or {}

utils.notify.send = send