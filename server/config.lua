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

--- Script Configuration.
--- @script server/config.lua

--- @section Global tables and objects

--- Global configuration table.
--- @field config: Stores config settings.
config = config or {}

--- @section Developer settings

--- Debug
--- @field debug: Toggle debug prints for the library
config.debug = true

--- @section Resource settings

--- UI Bridge settings
--- @field drawtext: Specifies the active progressbar system. Options: 'boii_ui', 'qb-core', 'es_extended', 'ox_lib', 'okokTextUI', 'custom'.
--- @field notify: Specifies the active notification system. Options: 'boii_ui', 'qb-core', 'es_extended', 'ox_lib', 'okokNotify', 'custom'.
--- @field progressbar: Specifies the active progressbar system. Options: 'boii_ui', 'custom'.
config.ui = {
    drawtext = 'boii_ui',
    notify = 'boii_ui',
    progressbar = 'boii_ui'
}

--- @section Script settings

--- Group settings
--- @field max_groups: Maximum amount of groups a player can be in at once.
--- @field max_members: Default max amount of members who can join a group.
config.groups = {
    max_groups = 1,
    max_members = 6,
}

--- Reputation settings
--- @field sql: SQL settings for reputation data.
--- @field table_name: Name of the table for storing player reputations.
--- @field list: List of reputations.
--- @field id: Unique identifier for the reputation.
--- @field category: Category to which the reputation belongs.
--- @field label: Display name of the reputation.
--- @field level: Starting level for the reputation.
--- @field start_rep: Starting reputation points.
--- @field first_level_rep: Reputation points required to reach the first level.
--- @field growth_factor: Factor by which the reputation points increase per level.
--- @field max_level: Maximum level that can be achieved for the reputation.
config.reputation = {
    trucker = {
        id = 'trucker',
        category = 'civilian',
        label = 'Truck Driver',
        level = 1,
        start_ep = 0,
        first_level_rep = 1000,
        growth_factor = 1.5,
        max_level = 10
    }
}

--- Skills settings
--- @field sql: SQL settings for skill data.
--- @field table_name: Name of the table for storing player skills.
--- @field list: List of skills.
--- @field id: Unique identifier for the skill.
--- @field category: Category to which the skill belongs.
--- @field label: Display name of the skill.
--- @field level: Starting level for the skill.
--- @field start_xp: Starting experience points.
--- @field first_level_xp: Experience points required to reach the first level.
--- @field growth_factor: Factor by which the experience points increase per level.
--- @field max_level: Maximum level that can be achieved for the skill.
config.skills = {

    -- BOII Resources
    begging = { -- Used by: boii_hobolife
        id = 'begging',
        category = 'survival',
        label = 'Begging',
        level = 1,
        start_xp = 0,
        first_level_xp = 1000,
        growth_factor = 1.5,
        max_level = 20
    },
    scavenging = { -- Used by: boii_hobolife
        id = 'scavenging',
        category = 'survival',
        label = 'Scavenging',
        level = 1,
        start_xp = 0,
        first_level_xp = 1000,
        growth_factor = 1.5,
        max_level = 20
    },
    cooking = { -- Used by: boii_hobolife
        id = 'cooking',
        category = 'survival',
        label = 'Cooking',
        level = 1,
        start_xp = 0,
        first_level_xp = 1000,
        growth_factor = 1.5,
        max_level = 20
    },
    companionship = { -- Used by: boii_hobolife
        id = 'companionship',
        category = 'pets',
        label = 'Companionship',
        level = 1,
        start_xp = 0,
        first_level_xp = 1000,
        growth_factor = 1.5,
        max_level = 20
    },

    drug_dealing = { -- Used by: boii_drugsales
        id = 'drug_dealing',
        category = 'drugs',
        label = 'Drug Dealing',
        level = 1,
        start_xp = 0,
        first_level_xp = 1000,
        growth_factor = 1.5,
        max_level = 20
    },

    crafting = { -- Used by: boii_crafting
        id = 'crafting',
        category = 'crafting',
        label = 'Crafting',
        level = 1,
        start_xp = 0,
        first_level_xp = 1000,
        growth_factor = 1.5,
        max_level = 20
    }
}

--- Licences settings
--- @field sql: SQL settings for licence data.
--- @field table_name: Name of the table for storing player licences.
--- @field list: List of licences.
--- @field id: Unique identifier for the licence.
--- @field label: Display name of the licence.
--- @field theory: Default setting for licence theory completion.
--- @field practical: Default setting for licence practical completion.
config.licences = {
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