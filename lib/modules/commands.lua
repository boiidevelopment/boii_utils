--- @module Commands

local commands = {}

if ENV.IS_SERVER then

    --- Stores chat suggestions.
    local chat_suggestions = {}

    --- Checks if a user has the required permission rank.
    --- @param source number: The source ID of the player.
    --- @param required_rank string|table: The required rank or ranks.
    --- @return boolean: True if the user has the required permission, false otherwise.
    local function has_permission(source, required_rank)
        local user = get_user(source)
        if not user then print("user not found when using command") return false end

        local user_rank = user.rank
        local ranks = type(required_rank) == "table" and required_rank or { required_rank }

        for _, rank in ipairs(ranks) do
            if rank == user_rank or rank == "all" then return true end
        end
        return false
    end

    --- Registers chat suggestions for autocomplete in the client chat input.
    --- @param command string: The command for which the suggestion is being registered.
    --- @param help string: The help text for the command.
    --- @param params table: The parameters for the command.
    local function register_chat_suggestion(command, help, params)
        chat_suggestions[#chat_suggestions + 1] = { command = command, help = help, params = params }
    end

    --- Registers a new command with the system.
    --- @param command string: The command to register.
    --- @param required_rank string|table: The required rank(s) to execute the command.
    --- @param help string: The help text for the command.
    --- @param params table: The parameters for the command.
    --- @param handler function: The handler function to execute when the command is called.
    local function register_command(command, required_rank, help, params, handler)
        if help and params then
            register_chat_suggestion(command, help, params)
        end

        RegisterCommand(command, function(source, args, raw)
            if has_permission(source, required_rank) then
                handler(source, args, raw)
            else
                TriggerClientEvent("chat:addMessage", source, {
                    args = { "^1SYSTEM", "You do not have permission to execute this command." }
                })
            end
        end, false)
    end

    --- @section Function Assignments

    commands.register = register_command

    --- @section Exports

    exports("register_command", register_command)

else

    --- @section Local functions

    --- Sends a request to the server to get chat suggestions.
    --- This can be called to refresh or re-fetch the suggestions if needed.
    local function get_chat_suggestions()
        TriggerServerEvent("boii_utils:sv:request_chat_suggestions")
    end

    --- @section Function Assignments

    commands.get_chat_suggestions = get_chat_suggestions

    --- @section Exports

    exports("get_chat_suggestions", get_chat_suggestions)

end

return commands
