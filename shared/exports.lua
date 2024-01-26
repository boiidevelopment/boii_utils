--- This section simply exports the utils table for use in other resources.
-- @script shared/exports.lua

--- Exports a function to get a deep copy of the utils object.
-- This exported function allows other scripts to safely access and manipulate their own copy of the utils object without affecting the original global state.
-- This is particularly useful in multi-threaded or complex applications where maintaining isolated state is crucial.
-- @function get_object
-- @usage local utils = exports['boii_utils'].get_utils()
-- @return table: A deep copy of the utils object, ensuring isolated state and no side effects on the original utils object.
exports('get_utils', function() 
    return utils.tables.deep_copy(utils) 
end)
