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

--- Routing buckets.
-- @script server/buckets.lua

--- @section Tables

--- Local table to store settings for each bucket.
-- @field bucket_settings table: Stores settings for each bucket.
local bucket_settings = {}

--- @section Local functions

--- Sets a player into a specific bucket and applies the provided settings.
-- @function set_player_bucket
-- @param player_id number: The server ID of the player.
-- @param params table: A table containing bucket settings such as bucket_id, enable_population, lockdown_mode, max_players, and spawn_coords.
-- @usage utils.buckets.set_player_bucket(player_id, {bucket_id = 1, enable_population = true, lockdown_mode = "strict", max_players = 30, spawn_coords = vector4(0.0, 0.0, 0.0, 0.0)})
-- @example
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

--- Retrieves settings for a specific bucket.
-- @function get_bucket_settings
-- @param bucket_id number: The ID of the bucket.
-- @usage local settings = utils.buckets.get_bucket_settings(bucket_id)
local function get_bucket_settings(bucket_id)
    return bucket_settings[bucket_id] or {}
end

--- Retrieves the bucket ID that a player is currently in.
-- @function get_player_bucket
-- @param player_id number: The server ID of the player.
-- @usage local bucket_id = utils.buckets.get_player_bucket(player_id)
local function get_player_bucket(player_id)
    return GetPlayerRoutingBucket(player_id)
end

--- Retrieves all players in a specific routing bucket.
-- @function get_players_in_bucket
-- @param bucket_id number: The ID of the bucket.
-- @usage local players_in_bucket = utils.buckets.get_players_in_bucket(bucket_id)
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

--- Resets a player's routing bucket to the default (bucket ID 0).
-- @function reset_player_bucket
-- @param player_id number: The server ID of the player.
-- @usage utils.buckets.reset_player_bucket(player_id)
local function reset_player_bucket(player_id)
    SetPlayerRoutingBucket(player_id, 0)
end

--- Temporarily moves a player to a specified bucket for a duration, then returns them to their original bucket.
-- @function temp_bucket
-- @param player_id number: The server ID of the player.
-- @param temporary_bucket_id number: The temporary bucket ID to move the player to.
-- @param duration number: Duration in seconds to keep the player in the temporary bucket.
-- @usage utils.buckets.temp_bucket(player_id, temporary_bucket_id, duration_in_seconds)
local function temp_bucket(player_id, temporary_bucket_id, duration)
    local original_bucket = get_player_bucket(player_id)
    set_player_bucket(player_id, temporary_bucket_id)
    SetTimeout(duration * 1000, function() 
        if get_player_bucket(player_id) == temporary_bucket_id then
            set_player_bucket(player_id, original_bucket)
        end
    end)
end

--- @section Assign local functions

utils.buckets = utils.buckets or {}

utils.buckets.set_player_bucket = set_player_bucket
utils.buckets.get_bucket_settings = get_bucket_settings
utils.buckets.get_player_bucket = get_player_bucket
utils.buckets.get_players_in_bucket = get_players_in_bucket
utils.buckets.reset_player_bucket = reset_player_bucket
utils.buckets.temp_bucket = temp_bucket