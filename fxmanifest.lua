--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|             DEVELOPER UTILS
]]

fx_version 'cerulean'
games { 'gta5', 'rdr3' }

name 'boii_utils'
version '1.8.0'
description 'BOII | Development - Developer Utility Library'
author 'boiidevelopment'
repository 'https://github.com/boiidevelopment/boii_utils'
lua54 'yes'

shared_scripts {
    --'@ox_lib/init.lua', -- Uncomment if using ox lib
    'shared/init.lua',
    'shared/scripts/debug.lua',
    'shared/scripts/general.lua',
    'shared/scripts/geometry.lua',
    'shared/scripts/keys.lua',
    'shared/scripts/maths.lua',
    'shared/scripts/serialization.lua',
    'shared/scripts/strings.lua',
    'shared/scripts/tables.lua',
    'shared/scripts/validation.lua',
    'shared/data/*',
    'shared/scripts/exports.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/config.lua',
    'server/init.lua',
    'server/scripts/buckets.lua',
    'server/scripts/callbacks.lua',
    'server/scripts/bridges/notifications.lua',
    'server/scripts/bridges/frameworks.lua',
    'server/scripts/commands.lua',
    'server/scripts/connections.lua',
    'server/scripts/conversions.lua',
    'server/scripts/cooldowns.lua',
    'server/scripts/database.lua',
    'server/scripts/date_time.lua',
    'server/scripts/groups.lua',
    'server/scripts/items.lua',
    'server/scripts/licences.lua',
    'server/scripts/networking.lua',
    'server/scripts/reputation.lua',
    'server/scripts/scopes.lua',
    'server/scripts/skills.lua',
    'server/scripts/version.lua',
    'server/scripts/zones.lua',
}

client_scripts {
    'client/init.lua',
    'client/scripts/blips.lua',
    'client/scripts/callbacks.lua',
    'client/scripts/character_creation.lua',
    'client/scripts/commands.lua',
    'client/scripts/conversions.lua',
    'client/scripts/cooldowns.lua',
    'client/scripts/draw.lua',
    'client/scripts/developer.lua',
    'client/scripts/entities.lua',
    'client/scripts/environment.lua',
    'client/scripts/networking.lua',
    'client/scripts/bridges/notifications.lua',
    'client/scripts/bridges/frameworks.lua',
    'client/scripts/bridges/progressbar.lua',
    'client/scripts/bridges/drawtext.lua',
    'client/scripts/bridges/target.lua',
    'client/scripts/groups.lua',
    'client/scripts/licences.lua',
    'client/scripts/peds.lua',
    'client/scripts/player.lua',
    'client/scripts/reputation.lua',
    'client/scripts/requests.lua',
    'client/scripts/skills.lua',
    'client/scripts/vehicles.lua',
    'client/scripts/zones.lua',
}

escrow_ignore {
    'shared/**/**/*',
    'client/**/**/**/*',
    'server/**/**/**/*'
}
