----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

fx_version 'cerulean'
game {'gta5', 'rdr3'}

author 'boiidevelopment'

description 'BOII | Development - Utility Library'

version '0.0.1'

lua54 'yes'

shared_scripts {
    'shared/init.lua',
    'shared/debug.lua',
    'shared/general.lua',
    'shared/geometry.lua',
    'shared/maths.lua',
    'shared/strings.lua',
    'shared/tables.lua',
    'shared/validation.lua',
    'shared/networking.lua',
    'shared/serialization.lua',
    'shared/test_commands.lua',
    'shared/exports.lua',
}

server_scripts {
    --'@mysql-async/lib/MySQL.lua',
    'server/config.lua',
    'server/date_time.lua',
    'server/database.lua',
    'server/networking.lua',
    'server/scopes.lua',
    'server/buckets.lua',
    'server/groups.lua',
}

client_scripts {
    'client/requests.lua',
    'client/player.lua',
    'client/entities.lua',
    'client/peds.lua',
    'client/blips.lua',
    'client/vehicles.lua',
    'client/draw.lua',
    'client/environment.lua',
    'client/developer.lua',
    'client/groups.lua',
    'client/test_commands.lua',
}
