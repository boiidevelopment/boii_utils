--- Client Configuration.
-- This script contains essential configuration settings.
-- @script client/config.lua

--- @section Global tables and objects

--- Global configuration table.
-- Contains settings for the framework and notification system.
-- @table config
config = config or {}

--- Utilities tables.
utils = utils or {}

utils.blips = utils.blips or {}
utils.callback = utils.callback or {}
utils.character_creation = utils.character_creation or {}
utils.cooldowns = utils.cooldowns or {}
utils.developer = utils.developer or {}
utils.draw = utils.draw or {}
utils.entities = utils.entities or {}
utils.environment = utils.environment or {}
utils.fw = utils.fw or {}
utils.groups = utils.groups or {}
utils.licences = utils.licences or {}
utils.notify = utils.notify or {} -- This is going to be removed just allowing time for people to switch out old functions for new. Please use utils.ui.notify instead.
utils.peds = utils.peds or {}
utils.player = utils.player or {}
utils.reputation = utils.reputation or {}
utils.requests = utils.requests or {}
utils.skills = utils.skills or {}
utils.ui = utils.ui or {} -- This section now contains notifications please use this in favour of utils.notify as utils.notify is set to be removed entirely.
utils.vehicles = utils.vehicles or {}
utils.zones = utils.zones or {}

--- Callbacks table within utilities.
-- @field callbacks Table for storing callbacks.
callbacks = {}

--- @section Settings

--- Framework configuration.
-- @field config.framework: Specifies the active framework. Options: 'boii_core', 'qb-core', 'ox_core', 'es_extended', 'custom'.
config.framework = 'boii_core'

--- Notification system configuration.
-- @field config.notifications: Specifies the active notification system. Options: 'boii_ui', 'qb-core', 'ox_lib', 'custom'.
config.notifications = 'boii_ui'

--- UI Bridge settings
-- @field notify: Specifies the active notification system. Options: 'boii_ui', 'qb-core', 'ox_lib', 'custom'.
-- @field progressbar: Specifies the active progressbar system. Options: 'boii_ui', 'qb-core' -- qb is untested right now.
config.ui = {
    notify = 'boii_ui',
    progressbar = 'boii_ui'
}

--- Disable settings
-- @field frameworks: Disables framework bridge functions to allow resource to be entirely standalone
config.disable = {
    frameworks = false, 
}

--- Debug configuration settings.
-- Contains toggleable debug settings for different systems within the framework.
-- @table config.debug
-- @field reputation boolean: If true, enables debug prints for the reputation system.
-- @field skills boolean: If true, enables debug prints for the skill system.
-- @field licence boolean: If true, enables debug prints for the licence system.
-- @field character_creation boolean: If true, enables debug prints for the character creation functions.
config.debug = {
    reputation = true,
    skills = true,
    licence = true,
    character_creation = true
}
