----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

-- Locals
local chat_suggestions = {}

--[[
    FUNCTIONS
]]

-- Retrieves user data from the database based on unique_id.
-- Usage: local user_data = get_user_data(unique_id)
local function get_user_data(_src)
    local user = connected_users[_src]
    if user then
        return { unique_id = user.unique_id, rank = user.rank }
    else
        return nil
    end
end

-- Checks if a user has the required permission rank.
-- Usage: Internal function only
local function has_permission(unique_id, required_rank)
    local user_data = get_user_data(unique_id)
    if not user_data then 
        print('user data not found')
        return false 
    end
    local user_rank = user_data.rank
    required_rank = type(required_rank) == "table" and required_rank or {required_rank}
    for _, rank in ipairs(required_rank) do
        if rank == user_rank or rank == 'all' then 
            return true 
        end
    end 
    return false
end

-- Registers chat suggestions for autocomplete in the client chat input.
-- Usage: Internal function only
local function register_chat_suggestion(command, help, params)
    chat_suggestions[#chat_suggestions + 1] = {
        command = command,
        help = help,
        params = params
    }
end

-- Registers a new command with the system.
-- Usage: utils.commands.register(command, required_rank, help, params, handler)
local function register_command(command, required_rank, help, params, handler)
    if help and params then
        register_chat_suggestion(command, help, params)
    end
    RegisterCommand(command, function(source, args, raw)
        local user = utils.connections.get_user(source)
        if user then
            local unique_id = user.unique_id
            if not required_rank or required_rank == nil or has_permission(unique_id, required_rank) then
                handler(source, args, raw)
            else
                TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'You do not have permission to execute this command.'}})
            end
        else
            print("User data not found for source:", source)
        end
    end, false)
end

--[[
    CALLBACKS
]]

utils.callback.register('boii_utils:sv:has_command_permission', has_permission)

--[[
    EVENTS
]]

-- Event handler for requesting chat suggestions.
RegisterServerEvent('boii_utils:sv:request_chat_suggestions', function()
    local _src = source
    for _, suggestion in ipairs(chat_suggestions) do
        TriggerClientEvent('boii_utils:cl:register_chat_suggestion', _src, suggestion.command, suggestion.help, suggestion.params)
    end
end)

--[[
    ASSIGN LOCALS
]]

utils.commands = utils.commands or {}

utils.commands.register = register_command
