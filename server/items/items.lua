--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|             DEVELOPER UTILS
]]

--- Usable items.
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

utils.items.register = register