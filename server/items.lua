--- This script manages anything related to items.
-- Currently only provides a simple system for handling on use items.

-- @script server/items.lua

--- @section Tables

--- Table to store item on use data
-- @table usable_items
local usable_items = {}

--- @section Local functions

--- Function to register an item as usable.
-- @param item_id The identifier of the item.
-- @param use_function The function to be executed when the item is used.
local function register(item_id, use_function)
    usable_items[item_id] = use_function
end

--- @section Events

--- Event to handle item use.
-- Triggered when a player uses an item.
-- @param item_id The identifier of the item being used.
RegisterServerEvent('boii_utils:sv:use_item', function(item_id)
    local _src = source
    if usable_items[item_id] then
        usable_items[item_id](_src)
    else
        print("Item with ID " .. item_id .. " is not registered as usable.")
    end
end)

--- @section Assign local functions

utils.items = utils.items or {}

utils.items.register = register