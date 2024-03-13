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

--- Cooldown system.
-- @script client/cooldowns.lua

--- @section Local functions

--- Checks if a specific cooldown_type of action is currently on cooldown for either the player or globally, based on the parameters provided.
-- @param cooldown_type The cooldown_type of action to check for cooldown. This should match the identifier used when setting the cooldown on the server side.
-- @param is_global A boolean value indicating whether the cooldown check is for a global cooldown (`true`) or a player-specific cooldown (`false`).
-- @param cb A callback function that takes a boolean argument. The callback will be called with `true` if the action is currently on cooldown, or `false` otherwise.
-- The callback allows client-side scripts to react appropriately based on the cooldown status (e.g., displaying notifications or disabling actions).
local function check_cooldown(cooldown_type, is_global, cb)
    utils.callback.cb('boii_utils:sv:check_cooldown', { cooldown_type = cooldown_type, is_global = is_global }, function(active_cooldown)
        if active_cooldown then
            cb(true)
        else
            cb(false)
        end
    end)
end

--- @section Assign local functions

utils.cooldowns = utils.cooldowns or {}

utils.cooldowns.check = check_cooldown