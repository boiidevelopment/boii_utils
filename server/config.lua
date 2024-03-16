--- Server Configuration.
-- This script contains essential configuration settings.
-- @script server/config.lua

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
-- @field config.framework Specifies the active framework. Options: 'boii_rp', 'qb-core', 'ox_core', 'es_extended', 'custom'.
config.framework = 'boii_rp'

--- Notification system configuration.
-- @field config.notifications Specifies the active notification system. Options: 'boii_ui', 'qb-core', 'ox_lib', 'custom'.
config.notifications = 'boii_ui'

--- Disable settings
-- @field frameworks: Disables framework bridge functions to allow resource to be entirely standalone
config.disable = {
    frameworks = false,
}

--- Debug settings
-- @field reputation: Toggle debug prints for reputation system
-- @field skills: Toggle debug prints for skills system
-- @field licence: Toggle debug prints for licence system
-- @field conversions: Toggle debug prints for conversions system
config.debug = {
    reputation = true,
    skills = true,
    licence = true,
    conversions = true
}

--- Group settings
-- @field max_groups: Maximum amount of groups a play can be in at once
-- @field max_members: Default max amount of members who can join a group
config.groups = {
    max_groups = 1,
    max_members = 6,
}

--- Reputation settings
-- @field sql: SQL settings for reputation data.
-- @field table_name: Name of the table for storing player reputations.
-- @field list: List of reputations.
-- @field id: Unique identifier for the reputation.
-- @field category: Category to which the reputation belongs.
-- @field label: Display name of the reputation.
-- @field level: Starting level for the reputation.
-- @field start_rep: Starting reputation points.
-- @field first_level_rep: Reputation points required to reach the first level.
-- @field growth_factor: Factor by which the reputation points increase per level.
-- @field max_level: Maximum level that can be achieved for the reputation.
config.reputation = {
    sql = {
        table_name = 'player_reputation'
    },
    list = {
        trucker = {
            id = 'trucker',
            category = 'civilian_job',
            label = 'Truck Driver',
            level = 1,
            start_ep = 0,
            first_level_rep = 1000,
            growth_factor = 1.5,
            max_level = 10
        }
    }
}

--- Skills settings
-- @field sql: SQL settings for skill data.
-- @field table_name: Name of the table for storing player skills.
-- @field list: List of skills.
-- @field id: Unique identifier for the skill.
-- @field category: Category to which the skill belongs.
-- @field label: Display name of the skill.
-- @field level: Starting level for the skill.
-- @field start_xp: Starting experience points.
-- @field first_level_xp: Experience points required to reach the first level.
-- @field growth_factor: Factor by which the experience points increase per level.
-- @field max_level: Maximum level that can be achieved for the skill.
config.skills = {
    sql = {
        table_name = 'player_skills'
    },
    list = {
        craftingrep = {
            id = 'craftingrep',
            category = 'base',
            label = 'Crafting Rep',
            level = 1,
            start_xp = 0,
            first_level_xp = 1000,
            growth_factor = 1.5,
            max_level = 10
        },

        -- boii_hobosim skills
        scavenging = {
            id = 'scavenging',
            category = 'survival',
            label = 'Scavenging',
            level = 1,
            start_xp = 0,
            first_level_xp = 1000,
            growth_factor = 1.5,
            max_level = 10
        },
        cooking = {
            id = 'cooking',
            category = 'survival',
            label = 'Cooking',
            level = 1,
            start_xp = 0,
            first_level_xp = 1000,
            growth_factor = 1.5,
            max_level = 10
        }
    }
}

--- Licences settings
-- @field sql: SQL settings for licence data.
-- @field table_name: Name of the table for storing player licences.
-- @field list: List of licences.
-- @field id: Unique identifier for the licence.
-- @field label: Display name of the licence.
-- @field theory: Default setting for licence theory completion.
-- @field practical: Default setting for licence practical completion.
config.licences = {
    sql = {
        table_name = 'player_licences'
    },
    list = {
        car = {
            id = 'car',
            label = 'Car Driving Licence',
            theory = false,
            practical = false
        },
        motorcycle = {
            id = 'motorcycle',
            label = 'Motorcycle Driving Licence',
            theory = false,
            practical = false
        },
        truck = {
            id = 'truck',
            label = 'Truck Driving Licence',
            theory = false,
            practical = false
        },
        plane = {
            id = 'plane',
            label = 'Pilots Licence',
            theory = false,
            practical = false
        },
        helicopter = {
            id = 'helicopter',
            label = 'Helicopter Licence',
            theory = false,
            practical = false
        },
        boat = {
            id = 'boat',
            label = 'Boating Licence',
            theory = false,
            practical = false
        },
        firearms = {
            id = 'firearms',
            label = 'Firearms Licence',
            theory = false,
            practical = false
        }
    }
}

--- Vehicle keys settings
-- @field sql: SQL settings for vehicle keys data.
-- @field table_name: Name of the table for storing vehicle keys data.
config.vehicle_keys = {
    sql = {
        table_name = 'owned_vehicles'
    }
}
