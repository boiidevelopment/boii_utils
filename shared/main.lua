utils = utils or {}

utils.shared = utils.shared or {}
utils.debug = utils.debug or {}
utils.general = utils.general or {}
utils.geometry = utils.geometry or {}
utils.keys = utils.keys or {}
utils.maths = utils.maths or {}
utils.networking = utils.networking or {}
utils.serialization = utils.serialization or {}
utils.strings = utils.strings or {}
utils.tables = utils.tables or {}
utils.validation = utils.validation or {}

--- @section Local functions

--- Retrieve data from the shared tables based on category and request_data
-- @param category string: the category to search within ('gangs', 'jobs', 'vehicles', etc.)
-- @param request_data string: the specific data to retrieve within the category
-- @return table|nil: the retrieved data if found, or nil if not found
-- @usage 
--[[
    local data = boii.shared.get_shared_data(category, request_data)
]]
-- @example
--[[
    local ballas_data = utils.shared.get_shared_data("gangs", "ballas")
    if ballas_data then
        -- Do something with ballas_data
    end
]]
local function get_shared_data(category, request_data)
    if not category or not request_data then
        debug_log('err', 'Function: get_shared_data failed | Reason: Missing one or more required parameters. - category or request_data.') 
        return nil
    end
    if not shared[category] then
        debug_log('err', 'Function: get_shared_data failed | Reason: Category ' .. category .. ' not found in shared data.') 
        return nil
    end
    for id, shared_data in pairs(shared[category]) do
        if id == request_data then
            return shared_data
        end
    end
    debug_log('err', 'Function: get_shared_data failed | Reason: Data for request ' .. request_data .. ' not found in category ' .. category .. '.') 
    return nil
end

utils.shared.get_data = get_shared_data