----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    BUCKET UTILITIES
]]

local bucket_settings = {}

-- Function to set a player into a bucket with params
-- Usage: 
-- utils.buckets.set_player_bucket(player_id, {
--     bucket_id = 1,
--     enable_population = true,
--     lockdown_mode = "strict",
--     max_players = 30,
--     spawn_coords = vector4(0.0, 0.0, 0.0, 0.0)
-- })
local function set_player_bucket(player_id, params)
    SetPlayerRoutingBucket(player_id, params.bucket_id)
    if params.enable_population ~= nil then
        SetRoutingBucketPopulationEnabled(params.bucket_id, params.enable_population)
    end
    if params.lockdown_mode then
        SetRoutingBucketEntityLockdownMode(params.bucket_id, params.lockdown_mode)
    end
    bucket_settings[params.bucket_id] = {
        max_players = params.max_players,
        spawn_coords = params.spawn_coords
    }
end

-- Function to get settings for a specific bucket
-- Usage: local settings = utils.buckets.get_bucket_settings(bucket_id)
local function get_bucket_settings(bucket_id)
    return bucket_settings[bucket_id] or {}
end

-- Get a player's routing bucket
-- Usage: local bucket_id = utils.buckets.get_player_bucket(source)
local function get_player_bucket(player_id)
    return GetPlayerRoutingBucket(player_id)
end

-- Get all players in a specific routing bucket
-- Usage: local players_in_bucket = utils.buckets.get_players_in_bucket(bucket_id)
local function get_players_in_bucket(bucket_id)
    local players = GetPlayers()
    local players_in_bucket = {}
    for _, player_id in ipairs(players) do
        if get_player_bucket(player_id) == bucket_id then
            players_in_bucket[#players_in_bucket + 1] = player_id
        end
    end
    return players_in_bucket
end

-- Reset a player's routing bucket to the default
-- Usage: utils.buckets.reset_player_bucket(source)
local function reset_player_bucket(player_id)
    SetPlayerRoutingBucket(player_id, 0)
end

-- Move a player to a temporary bucket for a specified duration, then return them to their original bucket
-- Usage: utils.buckets.temp_bucket(player_id, temporary_bucket_id, duration_in_seconds)
local function temp_bucket(player_id, temporary_bucket_id, duration)
    local original_bucket = get_player_bucket(player_id)
    set_player_bucket(player_id, temporary_bucket_id)
    SetTimeout(duration * 1000, function() 
        if get_player_bucket(player_id) == temporary_bucket_id then
            set_player_bucket(player_id, original_bucket)
        end
    end)
end

--[[
    ASSIGN LOCALS
]]

utils.buckets = utils.buckets or {}

utils.buckets.set_player_bucket = set_player_bucket
utils.buckets.get_bucket_settings = get_bucket_settings
utils.buckets.get_player_bucket = get_player_bucket
utils.buckets.get_players_in_bucket = get_players_in_bucket
utils.buckets.reset_player_bucket = reset_player_bucket
utils.buckets.temp_bucket = temp_bucket