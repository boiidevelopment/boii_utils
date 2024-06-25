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

--- Server initialization.
--- @script server/init.lua

--- @field testing: Toggle testing mode. 
TESTING = true

--- @field utils: Main utils object to export entire library.
utils = utils or {}

--- @field buckets: Stores all callback functions for use externally.
utils.buckets = utils.buckets or {}

--- @field callback: Stores all callback functions for use externally.
utils.callback = utils.callback or {}

--- @field commands: Stores all commands functions for use externally.
utils.commands = utils.commands or {}

--- @field connections: Stores all connections functions for use externally.
utils.connections = utils.connections or {}

--- @field cooldowns: Stores all cooldowns functions for use externally.
utils.cooldowns = utils.cooldowns or {}

--- @field fw: Stores all fw bridge functions for use externally.
utils.fw = utils.fw or {}

--- @field db: Stores all database functions for use externally.
utils.db = utils.db or {}

--- @field dates: Stores all date and time functions for use externally.
utils.dates = utils.dates or {}

--- @field groups: Stores all groups functions for use externally.
utils.groups = utils.groups or {}

--- @field items: Stores all items functions for use externally.
utils.items = utils.items or {}

--- @field licences: Stores all licences functions for use externally.
utils.licences = utils.licences or {}

--- @field networking: Stores all networking functions for use externally.
utils.networking = utils.networking or {}

--- @field reputation: Stores all reputation functions for use externally.
utils.reputation = utils.reputation or {}

--- @field scopes: Stores all scope functions for use externally.
utils.scope = utils.scope or {}

--- @field skills: Stores all skills functions for use externally.
utils.skills = utils.skills or {}

--- @field ui: Stores all ui functions for use externally.
utils.ui = utils.ui or {}

--- @field version: Stores all version functions for use externally.
utils.version = utils.version or {}

--- @field zones: Stores all zones functions for use externally.
utils.zones = utils.zones or {}

--- @section Local functions

--- Sends config to client on resource load.
local function send_config()
    TriggerClientEvent('boii_utils:cl:receive_config', -1, utils.tables.deep_copy(config))
end
send_config()

--- @section Events

--- Sends config to client.
RegisterServerEvent('boii_utils:sv:request_config', function()
    local _src = source
    TriggerClientEvent('boii_utils:cl:receive_config', _src, utils.tables.deep_copy(config))
end)