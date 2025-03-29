return { 

    example_licence = { -- Licence unique ID.
        label = "Example", -- Label for the licence
        category = "example_category", -- Categorization
        theory = false, -- Change to true for players to start with theory passed.
        practical = false, -- Change to true for players to start with practical passed.
        points = 0, -- Starting amount of points on new licence.
        max_points = 12, -- Max amount of points before a licence is marked "revoked" if "revocable".
        revocable = true, -- If true licence will be marked "revoked" when "max_points" is reached.
    }

}