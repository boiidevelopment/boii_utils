--- This script provides server-side functionalities related to chat commands and user permissions.
-- It includes functions to register commands, check permissions, and handle chat suggestions for autocomplete.
-- @script server/commands.lua

--- @section Tables

--- Local table to store chat suggestions for autocomplete.
-- @table chat_suggestions: Stores chat suggestions.
local chat_suggestions = {}

--- @section Local functions

--- Retrieves user data from the database based on the source.
-- @function get_user_data
-- @param _src number: The source ID of the player.
-- @return table: The user data containing unique_id and rank, or nil if not found.
local function get_user_data(_src)
    local user = connected_users[_src]
    if user then
        return { unique_id = user.unique_id, rank = user.rank }
    else
        return nil
    end
end

--- Checks if a user has the required permission rank.
-- @function has_permission
-- @param unique_id string: The unique ID of the user.
-- @param required_rank string/table: The required rank or ranks.
-- @return boolean: True if the user has the required permission, false otherwise.
local function has_permission(_src, unique_id, required_rank)
    local user_data = get_user_data(_src)
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

--- Registers chat suggestions for autocomplete in the client chat input.
-- @function register_chat_suggestion
-- @param command string: The command for which the suggestion is being registered.
-- @param help string: The help text for the command.
-- @param params table: The parameters for the command.
local function register_chat_suggestion(command, help, params)
    chat_suggestions[#chat_suggestions + 1] = {
        command = command,
        help = help,
        params = params
    }
end

--- Registers a new command with the system.
-- @function register_command
-- @param command string: The command to register.
-- @param required_rank string/table: The required rank or ranks to execute the command.
-- @param help string: The help text for the command.
-- @param params table: The parameters for the command.
-- @param handler function: The handler function to execute when the command is called.
local function register_command(command, required_rank, help, params, handler)
    if help and params then
        register_chat_suggestion(command, help, params)
    end
    RegisterCommand(command, function(source, args, raw)
        local user = utils.connections.get_user(source)
        if user then
            local unique_id = user.unique_id
            if not required_rank or required_rank == nil or has_permission(source, unique_id, required_rank) then
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
