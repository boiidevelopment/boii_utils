local TABLES = get("modules.tables")

--- @section Variables

local registered_functions = {}

--- @section Local Functions

--- Registers a function under a unique key for callbacks.
-- @param label string: The unique key to associate with the function.
-- @param func function: The function to register.
local function register_function(label, func)
    registered_functions[label] = func
end

--- Calls a registered function by its label.
-- @param label string: The key associated with the function.
-- @return The result of the function, or false if not found.
local function call_registered_function(label)
    if registered_functions[label] then
        return registered_functions[label]()
    else
        print('Function with label ' .. label .. ' not found.')
        return false
    end
end

--- Processes and filters menu content, replacing functions with boolean results.
-- @param content table: The menu content.
-- @return Filtered menu content with functions replaced.
local function filter_menu(content)
    local processed_options = {}
    for _, option in ipairs(content) do
        local processed_option = TABLES.deep_copy(option)
        if type(processed_option.can_interact) == 'function' then
            local label = 'can_interact_' .. tostring(option.label):gsub(' ', '_'):gsub('%W', '')
            register_function(label, processed_option.can_interact)
            local success, result = pcall(call_registered_function, label)
            processed_option.interactable = success and result or false
            processed_option.can_interact = nil
        else
            processed_option.interactable = processed_option.disabled ~= true
        end
        if processed_option.type == 'checkbox' and processed_option.state == nil then
            processed_option.state = false
        end
        if processed_option.submenu then
            processed_option.submenu = filter_menu(processed_option.submenu)
        end
        processed_options[#processed_options + 1] = processed_option
    end
    return processed_options
end

--- Opens the context menu with given data.
-- @param menu_data table: The menu data to open.
local function create_context_menu(menu_data)
    local filtered_menu = {
        header = menu_data.header,
        content = filter_menu(menu_data.content or {})
    }
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'create_context_menu',
        menu = filtered_menu
    })
end

--- Exports and Utility Bindings
exports('context_menu', create_context_menu)

--- @section NUI Callbacks

--- Event to close the context menu.
RegisterNUICallback('close_context_menu', function()
    SetNuiFocus(false, false)
    active_context_menu = false
end)

-- Callback to trigger events from the menu
RegisterNUICallback('context_menu_trigger_event', function(data)
    local action_handlers = {
        ['function'] = function(action) action(data.action) end,
        ['client'] = function(action) TriggerEvent(action.name, action.params) end,
        ['server'] = function(action) TriggerServerEvent(action.name, action.params) end
    }
    local handler = action_handlers[data.type]
    if not handler then
        print('Error: Incorrect action type for key')
        return
    end
    handler(data.action)
end)
