----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

config = config or {}
utils = utils or {}
utils.callbacks = {}

-- Framework settings
config.framework = 'boii_base' -- Choose your framework here. Available options; 'boii_base', 'qb-core', 'ox_core', 'esx_legacy', 'custom': For custom frameworks you need to edit the included frameworks.lua files.

-- Debug settings
config.debug = {
    reputation = true, -- Toggle debug prints for reputation system
    skills = true, -- Toggle debug prints for skill system
    licence = true -- Toggle debug prints for licence system
}