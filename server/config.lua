----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

config = config or {}
utils = utils or {}
utils.callbacks = {}

-- Framework settings
config.framework = 'boii_base' -- Choose your framework here. Available options; 'boii_base', 'qb-core', 'ox_core', 'esx_legacy', 'custom': For custom frameworks you need to edit the included frameworks.lua files.

-- SQL settings
config.sql = {
    wrapper = 'oxmysql', -- Available options: 'oxmysql', 'mysql-async', 'ghmattimysql', 'custom'
}

-- Debug settings
config.debug = {
    reputation = true, -- Toggle debug prints for reputation system
    skills = true, -- Toggle debug prints for skill system
    licence = true -- Toggle debug prints for licence system
}

-- Group settings
config.groups = {
    max_groups = 1, -- Maximum amount of groups a play can be in at once
    max_members = 6, -- Default max amount of members who can join a group
}

-- Reputation settings
config.reputation = {
    sql = {
        ['table_name'] = 'player_reputation'
    },
    list = {
        ['garbage'] = { 
            ['id'] = 'garbage', -- ID used to match reputation
            ['category'] = 'civilian_job',  -- Category used to categorize different reputation types
            ['label'] = 'Garbage Collection', -- Human readable label for the reputation
            ['level'] = 1, -- Level players will start at
            ['start_rep'] = 0, -- Amount of rep players will start with
            ['first_level_rep'] = 1000, -- Amount of rep required for the first level
            ['growth_factor'] = 1.5, -- Growth factor to increase rep per level based on first level rep default; level 1 -> 2 = 1000rep, 2 -> 3 = 1500rep, 3 -> 4 = 2250rep, 4 -> 5 = 3375rep.. and so on
            ['max_level'] = 10  -- Max level players can achieve for reputation
        }
    }
}

-- Skills settings
config.skills = {
    sql = {
        ['table_name'] = 'player_skills'
    },
    list = {
        ['driving'] = { 
            ['id'] = 'driving', -- ID used to match skill
            ['category'] = 'base',  -- Category used to categorize different skill types
            ['label'] = 'Driving', -- Human readable label for the skill
            ['level'] = 1, -- Level players will start at
            ['start_xp'] = 0, -- Amount of xp players will start with
            ['first_level_xp'] = 1000, -- Amount of XP required for the first level
            ['growth_factor'] = 1.5, -- Growth factor to increase XP per level based on first level xp default; level 1 -> 2 = 1000xp, 2 -> 3 = 1500xp, 3 -> 4 = 2250xp, 4 -> 5 = 3375xp.. and so on
            ['max_level'] = 10  -- Max level players can achieve for skill
        }
    }
}

-- Licences settings
config.licences = {
    sql = {
        ['table_name'] = 'player_licences'
    },
    list = {
        ['car'] = { 
            ['id'] = 'car', -- ID used to match licence
            ['label'] = 'Car Driving Licence', -- Human readable label for the licence
            ['theory'] = false, -- Default setting for licence theory completion
            ['practical'] = false, -- Default setting for licence practical completion
        },
        ['motorcycle'] = { 
            ['id'] = 'motorcycle', -- ID used to match licence
            ['label'] = 'Motorcycle Driving Licence', -- Human readable label for the licence
            ['theory'] = false, -- Default setting for licence theory completion
            ['practical'] = false, -- Default setting for licence practical completion
        },
        ['truck'] = { 
            ['id'] = 'truck', -- ID used to match licence
            ['label'] = 'Truck Driving Licence', -- Human readable label for the licence
            ['theory'] = false, -- Default setting for licence theory completion
            ['practical'] = false, -- Default setting for licence practical completion
        },
        ['plane'] = { 
            ['id'] = 'plane', -- ID used to match licence
            ['label'] = 'Pilots Licence', -- Human readable label for the licence
            ['theory'] = false, -- Default setting for licence theory completion
            ['practical'] = false, -- Default setting for licence practical completion
        },
        ['helicopter'] = { 
            ['id'] = 'helicopter', -- ID used to match licence
            ['label'] = 'Helicopter Licence', -- Human readable label for the licence
            ['theory'] = false, -- Default setting for licence theory completion
            ['practical'] = false, -- Default setting for licence practical completion
        },
        ['boat'] = { 
            ['id'] = 'boat', -- ID used to match licence
            ['label'] = 'Boating Licence', -- Human readable label for the licence
            ['theory'] = false, -- Default setting for licence theory completion
            ['practical'] = false, -- Default setting for licence practical completion
        },
        ['firearms'] = { 
            ['id'] = 'firearms', -- ID used to match licence
            ['label'] = 'Firearms Licence', -- Human readable label for the licence
            ['theory'] = false, -- Default setting for licence theory completion
            ['practical'] = false, -- Default setting for licence practical completion
        },
    }
}

-- Vehicle keys settings
config.vehicle_keys = {
    sql = {
        table_name = 'owned_vehicles'
    }
}
