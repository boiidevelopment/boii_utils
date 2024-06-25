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

--- Serialization functions.
-- @script shared/scripts/serialization.lua

--- @section Serialization Utilities

--- Safely serializes data using JSON encoding.
--- @function safe_serialize
--- @param data The data to serialize.
--- @return The serialized data string, or nil if an error occurs.
--- @usage local serialized_data = utils.serialization.safe_serialize(your_table_or_data)
local function safe_serialize(data)
    local status, result = pcall(json.encode, data)
    if status then
        return result
    else
        utils.debugging.err('Serialization Error: ' .. result)
        return nil
    end
end

exports('serialization_safe_serialize', safe_serialize)
utils.serialization.safe_serialize = safe_serialize

--- Safely deserializes data using JSON decoding.
--- @function safe_deserialize
--- @param data_str The serialized data string to deserialize.
--- @return The deserialized data, or nil if an error occurs.
--- @usage local deserialized_data = utils.serialization.safe_deserialize(your_serialized_data_string)
local function safe_deserialize(data_str)
    local status, result = pcall(json.decode, data_str)
    if status then
        return result
    else
        utils.debugging.err('Deserialization Error: ' .. result)
        return nil
    end
end

exports('serialization_safe_deserialize', safe_deserialize)
utils.serialization.safe_deserialize = safe_deserialize

--- Pretty prints a table as JSON.
--- @function pretty_print_json
--- @param tbl The table to pretty print.
--- @return The pretty-printed JSON string.
--- @usage utils.serialization.pretty_print_json('your_table')
local function pretty_print_json(tbl)
    return json.encode(tbl, {indent = true})
end

exports('serialization_pretty_print_json', pretty_print_json)
utils.serialization.pretty_print_json = pretty_print_json

--- Converts a table to an XML string.
--- This is a simplistic approach and might not cover all edge cases.
--- @function table_to_xml
--- @param tbl The table to convert.
--- @return The XML string.
--- @usage local xml_str = utils.serialization.table_to_xml('your_table')
local function table_to_xml(tbl)
    local xml = ''
    for k, v in pairs(tbl) do
        local element = k
        if type(v) == 'table' then
            xml = xml .. '<' .. element .. '>' .. table_to_xml(v, element) .. '</' .. element .. '>'
        else
            xml = xml .. '<' .. element .. '>' .. tostring(v) .. '</' .. element .. '>'
        end
    end
    return xml
end

exports('serialization_table_to_xml', table_to_xml)
utils.serialization.table_to_xml = table_to_xml

--- Encodes a string into Base64.
--- @function base64_encode
--- @param data The data to encode.
--- @return The Base64 encoded string.
--- @usage local encoded_data = utils.serialization.base64_encode('your_string')
local function base64_encode(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x) 
        local r, b='', x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

exports('serialization_base64_encode', base64_encode)
utils.serialization.base64_encode = base64_encode

--- Decodes a Base64 string.
--- @function base64_decode
--- @param data The Base64 encoded data to decode.
--- @return The decoded data string.
--- @usage local decoded_data = utils.serialization.base64_decode('your_encoded_data')
local function base64_decode(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r, f='', (b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

exports('serialization_base64_decode', base64_decode)
utils.serialization.base64_decode = base64_decode