--- @module Cooldowns

local cooldowns = {}

if ENV.IS_SERVER then
    
    --- @section Variables

    local player_cooldowns = {}
    local global_cooldowns = {}
    local resource_cooldowns = {}

    --- Adds a cooldown for a specific action, optionally for a global scope or for a specific player, and tracks the invoking resource.
    --- @param source number: The server ID of the player, or any unique identifier for non-global cooldowns.
    --- @param cooldown_type string: A string representing the type of cooldown being set (e.g., "begging").
    --- @param duration number: The duration of the cooldown in seconds.
    --- @param is_global boolean: A boolean indicating whether the cooldown is to be set globally (true) or just for the specified player (source) (false).
    local function add_cooldown(source, cooldown_type, duration, is_global)
        local cooldown_end = os.time() + duration
        local invoking_resource = GetInvokingResource() or "unknown"
        local cooldown_info = { end_time = cooldown_end, resource = invoking_resource }

        if is_global then
            global_cooldowns[cooldown_type] = cooldown_info
        else
            player_cooldowns[source] = player_cooldowns[source] or {}
            player_cooldowns[source][cooldown_type] = cooldown_info
        end

        resource_cooldowns[invoking_resource] = resource_cooldowns[invoking_resource] or {}
        resource_cooldowns[invoking_resource][resource_cooldowns[invoking_resource] + 1] = { source = source, cooldown_type = cooldown_type, is_global = is_global }
    end

    --- Checks if a cooldown is active for a player or globally.
    --- This function determines whether a specific cooldown_type of action is currently under cooldown for either a specific player or globally.
    --- @param source The players server ID or any unique identifier for non-global cooldowns.
    --- @param cooldown_type A string representing the cooldown_type of cooldown to check (e.g., "begging").
    --- @param is_global A boolean indicating whether to check for a global cooldown (true) or a player-specific cooldown (false).
    --- @return boolean Returns true if the cooldown is active, false otherwise.
    local function check_cooldown(source, cooldown_type, is_global)
        if is_global then
            return global_cooldowns[cooldown_type] and os.time() < global_cooldowns[cooldown_type].end_time
        elseif player_cooldowns[source] and player_cooldowns[source][cooldown_type] then
            return os.time() < player_cooldowns[source][cooldown_type].end_time
        end

        return false
    end

    --- Clears a cooldown for a player or globally.
    --- This function removes a cooldown for a specific cooldown_type of action either for a specific player or globally.
    --- @param source The players server ID or any unique identifier for non-global cooldowns.
    --- @param cooldown_type A string representing the cooldown_type of cooldown to clear (e.g., "begging").
    --- @param is_global A boolean indicating whether to clear a global cooldown (true) or a player-specific cooldown (false).
    local function clear_cooldown(source, cooldown_type, is_global)
        if is_global then
            global_cooldowns[cooldown_type] = nil
            GlobalState["cooldown_" .. cooldown_type] = nil
        elseif player_cooldowns[source] then
            player_cooldowns[source][cooldown_type] = nil
        end
    end

    --- Periodically checks and clears expired cooldowns.
    local function clear_expired_cooldowns()
        local current_time = os.time()

        for player_id, cooldowns in pairs(player_cooldowns) do
            for action_type, cooldown_info in pairs(cooldowns) do
                if current_time >= cooldown_info.end_time then
                    cooldowns[action_type] = nil
                end
            end
            if next(cooldowns) == nil then
                player_cooldowns[player_id] = nil
            end
        end

        for action_type, cooldown_info in pairs(global_cooldowns) do
            if current_time >= cooldown_info.end_time then
                global_cooldowns[action_type] = nil
                GlobalState["cooldown_" .. action_type] = nil
            end
        end
    end

    --- Clears cooldowns set by a specific resource.
    --- @param resource_name string: The name of the resource.
    local function clear_resource_cooldowns(resource_name)
        local cooldown_entries = resource_cooldowns[resource_name]
        
        if cooldown_entries then
            for _, entry in ipairs(cooldown_entries) do
                if entry.is_global then
                    global_cooldowns[entry.cooldown_type] = nil
                else
                    if player_cooldowns[entry.source] then
                        player_cooldowns[entry.source][entry.cooldown_type] = nil
                    end
                end
            end
            resource_cooldowns[resource_name] = nil
        end
    end

    --- @section Function Assignments
    
    cooldowns.add = add_cooldown
    cooldowns.check = check_cooldown
    cooldowns.clear = clear_cooldown
    cooldowns.clear_expired_cooldowns = clear_expired_cooldowns
    cooldowns.clear_resource_cooldowns = clear_resource_cooldowns

    --- @section Exports

    exports("add_cooldown", add_cooldown)
    exports("check_cooldown", check_cooldown)
    exports("clear_cooldown", clear_cooldown)
    exports("clear_expired_cooldowns", clear_expired_cooldowns)
    exports("clear_resource_cooldowns", clear_resource_cooldowns)

end

return cooldowns