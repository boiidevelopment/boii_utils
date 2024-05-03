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
-- @script server/cooldowns.lua

-- @section Tables
local player_cooldowns = {}
local global_cooldowns = {}
local resource_cooldowns = {}

-- @section Local functions

--- Adds a cooldown for a specific action, optionally for a global scope or for a specific player, and tracks the invoking resource.
-- @param _src string: The server ID of the player, or any unique identifier for non-global cooldowns.
-- @param cooldown_type string: A string representing the type of cooldown being set (e.g., 'begging').
-- @param duration number: The duration of the cooldown in seconds.
-- @param is_global boolean: A boolean indicating whether the cooldown is to be set globally (true) or just for the specified player (_src) (false).
local function add_cooldown(_src, cooldown_type, duration, is_global)
    local cooldown_end = os.time() + duration
    local invoking_resource = GetInvokingResource() or 'unknown'
    local cooldown_info = {
        end_time = cooldown_end,
        resource = invoking_resource
    }
    if is_global then
        global_cooldowns[cooldown_type] = cooldown_info
    else
        player_cooldowns[_src] = player_cooldowns[_src] or {}
        player_cooldowns[_src][cooldown_type] = cooldown_info
    end
    resource_cooldowns[invoking_resource] = resource_cooldowns[invoking_resource] or {}
    table.insert(resource_cooldowns[invoking_resource], { _src = _src, cooldown_type = cooldown_type, is_global = is_global })
end


--- Checks if a cooldown is active for a player or globally.
-- This function determines whether a specific cooldown_type of action is currently under cooldown for either a specific player or globally.
-- @param _src The player's server ID or any unique identifier for non-global cooldowns.
-- @param cooldown_type A string representing the cooldown_type of cooldown to check (e.g., 'begging').
-- @param is_global A boolean indicating whether to check for a global cooldown (true) or a player-specific cooldown (false).
-- @return boolean Returns true if the cooldown is active, false otherwise.
local function check_cooldown(_src, cooldown_type, is_global)
    if is_global then
        return global_cooldowns[cooldown_type] and os.time() < global_cooldowns[cooldown_type].end_time
    elseif player_cooldowns[_src] and player_cooldowns[_src][cooldown_type] then
        return os.time() < player_cooldowns[_src][cooldown_type].end_time
    end
    return false
end

--- Clears a cooldown for a player or globally. 
-- This function removes a cooldown for a specific cooldown_type of action either for a specific player or globally.
-- @param _src The player's server ID or any unique identifier for non-global cooldowns.
-- @param cooldown_type A string representing the cooldown_type of cooldown to clear (e.g., 'begging').
-- @param is_global A boolean indicating whether to clear a global cooldown (true) or a player-specific cooldown (false).
local function clear_cooldown(_src, cooldown_type, is_global)
    if is_global then
        global_cooldowns[cooldown_type] = nil
        GlobalState['cooldown_' .. cooldown_type] = nil
    elseif player_cooldowns[_src] then
        player_cooldowns[_src][cooldown_type] = nil
    end
end

--- Periodically checks and clears expired cooldowns.
local function clear_expired_cooldowns()
    local current_time = os.time()
    for player_id, cooldowns in pairs(player_cooldowns) do
        for action_type, cooldown_info in pairs(cooldowns) do
            if current_time >= cooldown_info.end_time then
                cooldowns[action_type] = nil
                print("Cleared expired cooldown for player " .. player_id .. " for action cooldown_type: " .. action_type)
            end
        end
        if next(cooldowns) == nil then
            player_cooldowns[player_id] = nil
        end
    end
    for action_type, cooldown_info in pairs(global_cooldowns) do
        if current_time >= cooldown_info.end_time then
            global_cooldowns[action_type] = nil
            GlobalState['cooldown_' .. action_type] = nil
            print("Cleared expired global cooldown for action cooldown_type: " .. action_type)
        end
    end
end

--- Clears cooldowns set by a specific resource
local function clear_resource_cooldowns(resource_name)
    local cooldown_entries = resource_cooldowns[resource_name]
    if cooldown_entries then
        for _, entry in ipairs(cooldown_entries) do
            if entry.is_global then
                global_cooldowns[entry.cooldown_type] = nil
            else
                if player_cooldowns[entry._src] then
                    player_cooldowns[entry._src][entry.cooldown_type] = nil
                end
            end
        end
        resource_cooldowns[resource_name] = nil
    end
end

--- @section Event handlers

--- Clean up cooldowns on resource stop.
AddEventHandler('onResourceStop', function(resource)
    clear_resource_cooldowns(resource)
end)

--- @section Threads

--- Clean up expired cooldowns periodically.
CreateThread(function()
    while true do
        Wait(30 * 1000)
        clear_expired_cooldowns()
    end
end)

--- @section Callbacks

--- Fetches the cooldown status for a given cooldown_type of action for a player or globally and returns the result through a callback.
-- @param _src The player's server ID requesting the data.
-- @param data A table containing the parameters `cooldown_type` (string) representing the cooldown cooldown_type, and `is_global` (boolean) indicating whether the cooldown check is global.
-- @param cb A callback function that takes one argument: a boolean indicating whether the cooldown is active.
local function fetch_cooldown(_src, data, cb)
    local cooldown_type = data.cooldown_type
    local is_global = data.is_global
    local cooldown_active = check_cooldown(_src, cooldown_type, is_global)
    cb(cooldown_active)
end
utils.callback.register('boii_utils:sv:check_cooldown', fetch_cooldown)

--- @section Assign local functions

utils.cooldowns.add = add_cooldown
utils.cooldowns.check = check_cooldown
utils.cooldowns.clear = clear_cooldown
utils.cooldowns.clear_for_resource = clear_resource_cooldowns
