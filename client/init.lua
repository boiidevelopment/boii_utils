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

--- Client initialization.
--- @script client/init.lua

--- @field testing: Toggle testing mode. 
TESTING = true

--- @field config: Receives server side config data.
config = config or {}

--- @field utils: Main utils object to export entire library.
utils = utils or {}

--- @field blips: Stores all blips functions for use externally.
utils.blips = utils.blips or {}

--- @field callback: Stores all callback functions for use externally.
utils.callback = utils.callback or {}

--- @field character_creation: Stores all character_creation functions for use externally.
utils.character_creation = utils.character_creation or {}

--- @field commands: Stores all commands functions for use externally.
utils.commands = utils.commands or {}

--- @field cooldowns: Stores all cooldowns functions for use externally.
utils.cooldowns = utils.cooldowns or {}

--- @field draw: Stores all draw functions for use externally.
utils.draw = utils.draw or {}

--- @field developer: Stores all developer functions for use externally.
utils.developer = utils.developer or {}

--- @field entities: Stores all entities functions for use externally.
utils.entities = utils.entities or {}

--- @field environment: Stores all environment functions for use externally.
utils.environment = utils.environment or {}

--- @field ui: Stores all ui bridge functions for use externally.
utils.ui = utils.ui or {}

--- @field fw: Stores all framework bridge functions for use externally.
utils.fw = utils.fw or {}

--- @field groups: Stores all groups functions for use externally.
utils.groups = utils.groups or {}

--- @field licences: Stores all licences functions for use externally.
utils.licences = utils.licences or {}

--- @field peds: Stores all peds functions for use externally.
utils.peds = utils.peds or {}

--- @field player: Stores all licences functions for use externally.
utils.player = utils.player or {}

--- @field reputation: Stores all reputation functions for use externally.
utils.reputation = utils.reputation or {}

--- @field requests: Stores all requests functions for use externally.
utils.requests = utils.requests or {}

--- @field skills: Stores all skills functions for use externally.
utils.skills = utils.skills or {}

--- @field target: Stores all target bridge functions for use externally.
utils.target = utils.target or {}

--- @field vehicles: Stores all vehicles functions for use externally.
utils.vehicles = utils.vehicles or {}

--- @field zones: Stores all zones functions for use externally.
utils.zones = utils.zones or {}

--- @field networking: Stores all networking functions for use externally.
utils.networking = utils.networking or {}

--- @field target: Stores all target bridge functions for use externally.
utils.target = utils.target or {}

--- @section Global functions

--- Logs debug messages for the reputation section.
--- This function is used internally for debugging purposes.
--- @function debug_log
--- @param type string: The type of log (e.g., 'info', 'err').
--- @param message string: The message to log.
function debug_log(type, message)
    if config.debug and utils.debug[type] then
        utils.debug[type](message)
    end
end

--- @section Internal functions

--- Function to request script config on network session active.
--- @function request_config
local function request_config()
    CreateThread(function()
        while true do
            Wait(10)
            if NetworkIsSessionActive() or NetworkIsPlayerActive(PlayerId()) then
                TriggerServerEvent('boii_utils:sv:request_config')
                break
            end
        end
    end)
end
request_config()

--- @section Events

--- Receives config from server side.
--- @param client_config table: Server side config table shared to client.
RegisterNetEvent('boii_utils:cl:receive_config', function(client_config)
    config = client_config
end)
