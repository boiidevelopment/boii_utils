----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

config = config or {}
utils = utils or {}
utils.callbacks = {}

-- Framework settings
config.framework = 'boii_base' -- Choose your framework here. Available options; 'boii_base', 'qb-core', 'ox_core', 'esx_legacy', 'custom': For custom frameworks you need to edit the included frameworks.lua files.
config.notifications = 'boii_ui' -- Choose your notifications here; Available options; 'boii_ui', 'qb-core', 'ox_lib', 'custom': For notification scripts not listed by default you can fill in your own in the notifications.lua files

-- Debug settings
config.debug = {
    reputation = true, -- Toggle debug prints for reputation system
    skills = true, -- Toggle debug prints for skill system
    licence = true -- Toggle debug prints for licence system
}
