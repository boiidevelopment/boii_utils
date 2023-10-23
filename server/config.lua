config_sv = config_sv or {}

-- SQL settings
config_sv.sql = {
    wrapper = 'custom', -- Available options: 'oxmysql', 'mysql-async', 'ghmattimysql', 'custom'
}

-- Group settings
config_sv.groups = {
    max_groups = 1, -- Maximum amount of groups a play can be in at once
    max_members = 6, -- Default max amount of members who can join a group
}