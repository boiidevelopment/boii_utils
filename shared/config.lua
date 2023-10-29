----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    INIT
]]

utils = utils or {}
utils.callbacks = {}

--[[
    SHARED CONFIG
]]

config = config or {}

-- Framework setting
config.framework = 'boii_base' -- Choose your framework here. Available options; 'boii_base', 'qb-core', 'ox_core', 'esx_legacy', 'custom'

-- Debug settings
config.debug = {
    reputation = true, -- Toggle debug prints for reputation system
    skills = true, -- Toggle debug prints for skill system
}