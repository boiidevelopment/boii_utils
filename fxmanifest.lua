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
version '1.6.0'
description 'BOII | Development - Developer Utility Library'
author 'boiidevelopment'
repository 'https://github.com/boiidevelopment/boii_utils'
lua54 'yes'

shared_scripts {
    'shared/main.lua',
    'shared/debug/debug.lua',
    'shared/general/general.lua',
    'shared/geometry/geometry.lua',
    'shared/maths/maths.lua',
    'shared/strings/strings.lua',
    'shared/tables/tables.lua',
    'shared/validation/validation.lua',
    'shared/networking/networking.lua',
    'shared/serialization/serialization.lua',
    'shared/keys/keys.lua',
    'shared/data/default_ped_styles.lua',
    'shared/exports.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/config.lua',
    'server/version/version.lua',
    'server/ui/*',
    'server/notifications/notifications.lua',
    'server/database/database.lua',
    'server/connections/connections.lua',
    'server/date_time/date_time.lua',
    'server/networking/networking.lua',
    'server/scopes/scopes.lua',
    'server/buckets/buckets.lua',
    'server/callbacks/callbacks.lua',
    'server/frameworks/frameworks.lua',
    'server/cooldowns/cooldowns.lua',
    'server/conversions/conversions.lua',
    'server/groups/groups.lua',
    'server/skills/skills.lua',
    'server/reputation/reputation.lua',
    'server/licences/licences.lua',
    'server/items/items.lua',
    'server/commands/commands.lua',
    'server/commands/commands_list.lua'
}

client_scripts {
    'client/config.lua',
    'client/ui/*',
    'client/notifications/notifications.lua',
    'client/requests/requests.lua',
    'client/player/player.lua',
    'client/entities/entities.lua',
    'client/peds/peds.lua',
    'client/blips/blips.lua',
    'client/vehicles/vehicles.lua',
    'client/draw/draw.lua',
    'client/environment/environment.lua',
    'client/developer/developer.lua',
    'client/groups/groups.lua',
    'client/callbacks/callbacks.lua',
    'client/frameworks/frameworks.lua',
    'client/cooldowns/cooldowns.lua',
    'client/conversions/conversions.lua',
    'client/skills/skills.lua',
    'client/reputation/reputation.lua',
    'client/licences/licences.lua',
    'client/commands/commands.lua',
    'client/character_creation/creation.lua',
    'client/zones/zones.lua',
    'client/test_commands.lua'
}

escrow_ignore {
    'shared/**/*',
    'client/**/*',
    'server/**/*'
}
