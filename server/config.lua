----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

config_sv = config_sv or {}

-- SQL settings
config_sv.sql = {
    wrapper = 'oxmysql', -- Available options: 'oxmysql', 'mysql-async', 'ghmattimysql', 'custom'
}

-- Group settings
config_sv.groups = {
    max_groups = 1, -- Maximum amount of groups a play can be in at once
    max_members = 6, -- Default max amount of members who can join a group
}

-- Reputation settings
config_sv.reputation = {
    sql = {
        ['table_name'] = 'player_reputation'
    },
    reputation_list = {
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
config_sv.skills = {
    sql = {
        ['table_name'] = 'player_skills'
    },
    skill_list = {
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
