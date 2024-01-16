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
    elseif notifications == 'qb-core' then
        if options.type == 'information' then
            options.type = 'primary'
        end
        TriggerClientEvent('QBCore:Notify', _src, options.message, options.type, options.duration)
    elseif notifications == 'esx_legacy' then
        if options.type == 'information' then
            options.type = 'info'
        end
        TriggerClientEvent("ESX:Notify", _src, options.type, options.duration, options.message)
    elseif notifications == 'ox_lib' then
        if options.type == 'information' then
            options.type = 'info'
        end
        TriggerClientEvent('ox_lib:notify', _src, { type = options.type, title = options.header, description = options.message })
    end
end

--[[
    ASSIGN LOCALS
]]

utils.notify = utils.notify or {}

utils.notify.send = send
