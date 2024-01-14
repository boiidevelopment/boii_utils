----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    FUNCTIONS
]]

local notifications = config.notifications

local function send(options)
    if notifications == 'boii_ui' then
        TriggerEvent('boii_ui:notify', options.type, options.header, options.message, options.duration)
    elseif notifications == 'qb-core' then
        if options.type == 'information' then
            options.type = 'primary'
        end
        TriggerEvent('QBCore:Notify', options.message, options.type, options.duration)
    elseif notifications == 'esx_legacy' then
        if options.type == 'information' then
            options.type = 'info'
        end
        TriggerEvent("ESX:Notify", options.type, options.duration, options.message)
    end
end


--[[
    ASSIGN LOCALS
]]

utils.notify = utils.notify or {}

utils.notify.send = send
