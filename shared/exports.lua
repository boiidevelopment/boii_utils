--- This section simply exports the utils table for use in other resources.
-- @script shared/exports.lua

--- Function to wrap an existing export.
-- This function allows you to modify the behavior of an existing export function from another resource.
-- It captures the original function, then creates a wrapper function that calls the original function,
-- allowing you to add custom behavior before and/or after the original function's invocation.
-- @param target_resource string: The name of the resource containing the export.
-- @param export_name string: The name of the export function to wrap.
-- @param wrapper_func function: The function containing your custom logic.
local function wrap_export(target_resource, export_name, wrapper_func)
    if not target_resource or not export_name then
        print("Error: Target resource and export name must be provided.")
        return
    end
    local original_func = exports[target_resource][export_name]
    if not original_func then
        print("Error: The original export function was not found.")
        return
    end
    local function wrapped_func(...)
        print("Function called with arguments:", ...)
        local results = { original_func(...) }
        print("Function returned:", table.unpack(results))
        return table.unpack(results)
    end
    exports[target_resource][export_name] = wrapped_func
end

--- Exports a function to get a deep copy of the utils object.
-- This exported function allows other scripts to safely access and manipulate their own copy of the utils object without affecting the original global state.
-- This is particularly useful in multi-threaded or complex applications where maintaining isolated state is crucial.
-- @function get_object
-- @usage local utils = exports['boii_utils'].get_utils()
-- @return table: A deep copy of the utils object, ensuring isolated state and no side effects on the original utils object.
exports('get_utils', function() 
    return utils.tables.deep_copy(utils) 
end)

utils.export = utils.export or {}

utils.export.wrap = wrap_export