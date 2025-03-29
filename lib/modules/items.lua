--- @module Usable Items

local items = {}

if ENV.IS_SERVER then

    usable_items = {}

    --- @section Local functions

    --- Function to register an item as usable.
    --- @param item_id The identifier of the item.
    --- @param use_function The function to be executed when the item is used.
    local function register(item_id, use_function)
        usable_items[item_id] = use_function
    end

    --- Function to use a registered item
    --- @param item_id The identifier of the item.
    local function use_item(source, item_id)
        if usable_items[item_id] then
            usable_items[item_id](source, item_id)
        else
            print("Item with ID " .. item_id .. " is not registered as usable.")
        end
    end

    --- @section Function Assignments

    items.register = register
    items.use = use_item

    --- @section Exports

    exports("register_item", register)
    exports("use_item", use_item)

end

return items