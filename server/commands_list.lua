--- This script provides a place to setup standalone commands for use in servers.
-- @script server/commands_list.lua


--- Example command to show a players ID in a notification
utils.commands.register('utils:id', nil, 'Display your current server ID.', {{ name = 'show_id', help = ''}}, function(source, args, raw)
    local _src = source
    utils.notify.send( _src, { 
        header = 'STATE ID',
        message = 'Your current ID is: {' .. _src .. '}',
        type = 'information',
        duration = 3500
    })
end)