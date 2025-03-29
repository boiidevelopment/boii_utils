return {

    example_skill = { -- Skill unique ID.
        type = "skill", -- Type for xp, default options: "work", "skill" or "reputation" - Update database ENUM values to add additional.
        label = "Example Skill", -- Readable label.   
        category = "example_category", -- Categorization, can be anything, its not important just useful for grouping.
        level = 1, -- Start level.
        max_level = 20, -- Max level; you may want to adjust the growth factor and start xp if using more than 20 levels with default settings 1 -> 20 is over 3 million xp..
        xp = 0, -- Amount of xp to start with.
        first_level_xp = 1000, -- Amount of xp required for level 1 -> 2, other levels will then follow growth factor.
        growth_factor = 1.5, -- Growth factor per level: level 1 -> 2 1000xp, 2 -> 3 1500xp, 3 -> 4 2250xp, 9 -> 10 25628xp .. so on.
    },

    example_work = { type = "work" --[[Using work type]], label = "Example Work", category = "example_category", level = 1, max_level = 20, xp = 0, first_level_xp = 1000, growth_factor = 1.5 },
    example_rep = { type = "reputation" --[[Using reputation type]], label = "Example Rep", category = "example_category", level = 1, max_level = 20, xp = 0, first_level_xp = 1000, growth_factor = 1.5 },

    scrap = {
        type = "work",
        label = "Scrap",   
        category = "boii_drivingjobs",
        level = 1,
        max_level = 20,
        xp = 0,
        first_level_xp = 1000, 
        growth_factor = 1.5
    },
}