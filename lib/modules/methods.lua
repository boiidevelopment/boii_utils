--- @module Methods
--- Handles attaching methods from external resources.

--- @section Module

local methods = {}

if ENV.IS_SERVER then
    local server_methods = {}

    --- Adds a method callback to a specific server-side event.
    --- @param on_some_event string: The event to hook into.
    --- @param cb function: The callback function.
    --- @param options table|nil: Optional filtering options.
    --- @return number: ID of the method (for later removal).
    local function add_method(on_some_event, cb, options)
        if not server_methods[on_some_event] then server_methods[on_some_event] = {} end
        local id = #server_methods[on_some_event] + 1
        server_methods[on_some_event][id] = { callback = cb, options = options }
        return id
    end

    --- Removes a method by ID for a given event.
    --- @param on_some_event string: Event name to remove from.
    --- @param id number: The method ID to remove.
    local function remove_method(on_some_event, id)
        if server_methods[on_some_event] then server_methods[on_some_event][id] = nil end
    end

    --- Triggers all methods for an event, stopping if any return false.
    --- @param on_some_event string: Event name to trigger.
    --- @param response table: Table passed to all method callbacks.
    --- @return boolean: True if no method blocked, false otherwise.
    local function trigger_method(on_some_event, response)
        local list = server_methods[on_some_event]
        if not list then return true end
        for _, method in pairs(list) do
            if method.callback(response) == false then return false end
        end
        return true
    end

    --- @section Function Assignment

    methods.add = add_method
    methods.remove = remove_method
    methods.trigger = trigger_method

    --- @section Exports

    exports('add_method', add_method)
    exports('remove_method', remove_method)
    exports('trigger_method', trigger_method)

else
    local client_methods = {}

    --- Adds a method callback to a specific client-side event.
    --- @param on_some_event string: The event to hook into.
    --- @param cb function: The callback function.
    --- @param options table|nil: Optional filtering options.
    --- @return number: ID of the method (for later removal).
    local function add_method(on_some_event, cb, options)
        if not client_methods[on_some_event] then client_methods[on_some_event] = {} end
        local id = #client_methods[on_some_event] + 1
        client_methods[on_some_event][id] = { callback = cb, options = options }
        return id
    end

    --- Removes a method by ID for a given event.
    --- @param on_some_event string: Event name to remove from.
    --- @param id number: The method ID to remove.
    local function remove_method(on_some_event, id)
        if client_methods[on_some_event] then client_methods[on_some_event][id] = nil end
    end

    --- Triggers all methods for an event, stopping if any return false.
    --- @param on_some_event string: Event name to trigger.
    --- @param response table: Table passed to all method callbacks.
    --- @return boolean: True if no method blocked, false otherwise.
    local function trigger_method(on_some_event, response)
        local list = client_methods[on_some_event]
        if not list then return true end
        for _, method in pairs(list) do
            if method.callback(response) == false then return false end
        end
        return true
    end

    --- @section Function Assignment

    methods.add = add_method
    methods.remove = remove_method
    methods.trigger = trigger_method

    --- @section Exports

    exports('add_method', add_method)
    exports('remove_method', remove_method)
    exports('trigger_method', trigger_method)

end

return methods