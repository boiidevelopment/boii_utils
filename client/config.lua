--- Client Configuration.
-- This script contains essential configuration settings.
-- @script client/config.lua

--- @section Global tables and objects

--- Global configuration table.
-- Contains settings for the framework and notification system.
-- @table config
config = config or {}

--- Global utilities table.
-- Contains utility functions and callback registrations.
-- @table utils
utils = utils or {}

--- Callbacks table within utilities.
-- Stores registered callbacks for server-client communication.
-- @field utils.callbacks Table for storing callbacks.
utils.callbacks = {}

--- @section Settings

--- Framework configuration.
-- @field config.framework Specifies the active framework. Options: 'boii_base', 'qb-core', 'ox_core', 'esx_legacy', 'custom'.
config.framework = 'qb-core'

--- Notification system configuration.
-- @field config.notifications Specifies the active notification system. Options: 'boii_ui', 'qb-core', 'ox_lib', 'custom'.
config.notifications = 'boii_ui'

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
