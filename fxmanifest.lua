----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

fx_version 'cerulean'
game {'gta5', 'rdr3'}

author 'boiidevelopment'

description 'BOII | Development - Utility Library'

version '1.3.0'

lua54 'yes'

shared_scripts {
    'shared/main.lua',
    'shared/debug.lua',
    'shared/general.lua',
    'shared/geometry.lua',
    'shared/maths.lua',
    'shared/strings.lua',
    'shared/tables.lua',
    'shared/validation.lua',
    'shared/networking.lua',
    'shared/serialization.lua',
    'shared/keys.lua',
    'shared/data/default_ped_styles.lua',
    'shared/test_commands.lua',
    'shared/exports.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/config.lua',
    'server/version.lua',
    'server/notifications.lua',
    'server/database.lua',
    'server/connections.lua',
    'server/date_time.lua',
    'server/networking.lua',
    'server/scopes.lua',
    'server/buckets.lua',
    'server/callbacks.lua',
    'server/frameworks.lua',
    'server/conversions.lua',
    'server/groups.lua',
    'server/skills.lua',
    'server/reputation.lua',
    'server/licences.lua',
    'server/items.lua',
    'server/commands.lua',
    'server/commands_list.lua',
}

client_scripts {
    'client/config.lua',
    'client/notifications.lua',
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
    'client/callbacks.lua',
    'client/frameworks.lua',
    'client/conversions.lua',
    'client/skills.lua',
    'client/reputation.lua',
    'client/licences.lua',
    'client/commands.lua',
    'client/character_creation.lua',
    'client/test_commands.lua',
}

escrow_ignore {
    'shared/**/*',
    'client/*',
    'server/*'
}
