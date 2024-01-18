----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    COMMAND LIST
]]


-- Command to display player id
utils.commands.register('utils:id', nil, 'Display your current server ID.', {{ name = 'show_id', help = ''}}, function(source, args, raw)
    local _src = source
    utils.notify.send( _src, { 
        header = 'STATE ID',
        message = 'Your current ID is: {' .. _src .. '}',
        type = 'information',
        duration = 3500
    })
end)