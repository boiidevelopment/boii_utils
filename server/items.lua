----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    ITEMS
]]

-- Local table to store usable items and their corresponding functions
local usable_items = {}

-- Function to register an item as usable
local function register(item_id, use_function)
    usable_items[item_id] = use_function
end

-- Event to handle item use
RegisterServerEvent('boii_utils:sv:use_item', function(item_id)
    local _src = source
    if usable_items[item_id] then
        usable_items[item_id](_src)
    else
        print("Item with ID " .. item_id .. " is not registered as usable.")
    end
end)

--[[
    ASSIGN LOCALS
]]

utils.items = utils.items or {}

utils.items.register = register