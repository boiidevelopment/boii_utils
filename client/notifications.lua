----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    FUNCTIONS
]]

local notifications = config.notifications

local function send(options)
    if notifications == 'boii_ui' then
        TriggerEvent('boii_ui:notify', { type = options.type, header = options.header, message = options.message, duration = options.duration })
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
    elseif notifications == 'ox_lib' then
        if options.type == 'information' then
            options.type = 'info'
        end
        TriggerEvent('ox_lib:notify', { type = options.type, title = options.header, description = options.message })
    end
end


--[[
    ASSIGN LOCALS
]]

utils.notify = utils.notify or {}

utils.notify.send = send
