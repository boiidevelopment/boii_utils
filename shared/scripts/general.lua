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

--- General use functions.
-- @script shared/scripts/general.lua

--- @section Local functions

--- Converts a boolean value to its corresponding string representation.
-- @function general_bool_to_string
-- @param value boolean: The boolean value to convert.
-- @return string: "true" if value is true, otherwise "false".
local function bool_to_string(value)
    return value and "true" or "false"
end

exports('general_bool_to_string', bool_to_string)
utils.general.bool_to_string = bool_to_string

--- Converts RGB color values to a HEX string.
-- @function general_rgb_to_hex
-- @param r number: Red component (0-255).
-- @param g number: Green component (0-255).
-- @param b number: Blue component (0-255).
-- @return string: The HEX color string (e.g., "#FF0000").
local function rgb_to_hex(r, g, b)
    return string.format("#%02X%02X%02X", r, g, b)
end

exports('general_rgb_to_hex', rgb_to_hex)
utils.general.rgb_to_hex = rgb_to_hex

--- Converts a HEX color string to RGB values.
-- @function general_hex_to_rgb
-- @param hex string: The HEX color string (e.g., "#FF0000").
-- @return table: A table containing the RGB values.
local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return {
        r = tonumber("0x" .. hex:sub(1, 2)),
        g = tonumber("0x" .. hex:sub(3, 4)),
        b = tonumber("0x" .. hex:sub(5, 6))
    }
end

exports('general_hex_to_rgb', hex_to_rgb)
utils.general.hex_to_rgb = hex_to_rgb

--- Generates a UUID.
-- @function general_generate_uuid
-- @return string: A new UUID.
local function generate_uuid()
    local random = math.random
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

exports('general_generate_uuid', generate_uuid)
utils.general.generate_uuid = generate_uuid