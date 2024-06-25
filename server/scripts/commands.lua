--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|
                              | |
                              |_|
]]

--- Command system.
--- @script server/scripts/commands.lua

--- @section Tables

--- Local table to store chat suggestions for autocomplete.
local chat_suggestions = {}

--- @section Local functions

--- Retrieves user data from the database based on the source.
--- @function get_user_data
--- @param _src number: The source ID of the player.
--- @return table: The user data containing unique_id and rank, or nil if not found.
local function get_user_data(_src)
    local user = connected_users[_src]
    if user then
        return { unique_id = user.unique_id, rank = user.rank }
    else
        return nil
    end
end

exports('commands_get_user_data', get_user_data)
utils.commands.get_user_data = get_user_data

--- Checks if a user has the required permission rank.
--- @function has_permission
--- @param unique_id string: The unique ID of the user.
--- @param required_rank string/table: The required rank or ranks.
--- @return boolean: True if the user has the required permission, false otherwise.
local function has_permission(_src, unique_id, required_rank)
    local user_data = get_user_data(_src)
    if not user_data then 
        print('user data not found')
        return false 
    end
    local user_rank = user_data.rank
    required_rank = type(required_rank) == "table" and required_rank or { required_rank }
    for _, rank in ipairs(required_rank) do
        if rank == user_rank or rank == 'all' then 
            return true 
        end
    end 
    return false
end

exports('commands_has_permission', has_permission)
utils.commands.has_permission = has_permission

--- Registers chat suggestions for autocomplete in the client chat input.
--- @function register_chat_suggestion
--- @param command string: The command for which the suggestion is being registered.
--- @param help string: The help text for the command.
--- @param params table: The parameters for the command.
local function register_chat_suggestion(command, help, params)
    chat_suggestions[#chat_suggestions + 1] = {
        command = command,
        help = help,
        params = params
    }
end

exports('commands_register_chat_suggestion', register_chat_suggestion)
utils.commands.register_chat_suggestion = register_chat_suggestion

--- Registers a new command with the system.
--- @function register_command
--- @param command string: The command to register.
--- @param required_rank string/table: The required rank or ranks to execute the command.
--- @param help string: The help text for the command.
--- @param params table: The parameters for the command.
--- @param handler function: The handler function to execute when the command is called.
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

exports('commands_register_command', register_command)
utils.commands.register = register_command

--- @section Callbacks

utils.callback.register('boii_utils:sv:has_command_permission', has_permission)

--- @section Events

--- Event handler for requesting chat suggestions.
RegisterServerEvent('boii_utils:sv:request_chat_suggestions')
AddEventHandler('boii_utils:sv:request_chat_suggestions', function()
    local _src = source
    for _, suggestion in ipairs(chat_suggestions) do
        TriggerClientEvent('boii_utils:cl:register_chat_suggestion', _src, suggestion.command, suggestion.help, suggestion.params)
    end
end)
