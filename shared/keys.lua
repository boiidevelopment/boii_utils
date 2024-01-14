--[[
    KEYS
]]

-- Key list
local keys = {
    ['enter'] = 191,
    ['escape'] = 322,
    ['backspace'] = 177,
    ['tab'] = 37,
    ['arrowleft'] = 174,
    ['arrowright'] = 175,
    ['arrowup'] = 172,
    ['arrowdown'] = 173,
    ['space'] = 22,
    ['delete'] = 178,
    ['insert'] = 121,
    ['home'] = 213,
    ['end'] = 214,
    ['pageup'] = 10,
    ['pagedown'] = 11,
    ['leftcontrol'] = 36,
    ['leftshift'] = 21,
    ['leftalt'] = 19,
    ['rightcontrol'] = 70,
    ['rightshift'] = 70,
    ['rightalt'] = 70,
    ['numpad0'] = 108,
    ['numpad1'] = 117,
    ['numpad2'] = 118,
    ['numpad3'] = 60,
    ['numpad4'] = 107,
    ['numpad5'] = 110,
    ['numpad6'] = 109,
    ['numpad7'] = 117,
    ['numpad8'] = 111,
    ['numpad9'] = 112,
    ['numpad+'] = 96,
    ['numpad-'] = 97,
    ['numpadenter'] = 191,
    ['numpad.'] = 108,
    ['f1'] = 288,
    ['f2'] = 289,
    ['f3'] = 170,
    ['f4'] = 168,
    ['f5'] = 166,
    ['f6'] = 167,
    ['f7'] = 168,
    ['f8'] = 169,
    ['f9'] = 56,
    ['f10'] = 57,
    ['a'] = 34,
    ['b'] = 29,
    ['c'] = 26,
    ['d'] = 30,
    ['e'] = 46,
    ['f'] = 49,
    ['g'] = 47,
    ['h'] = 74,
    ['i'] = 27,
    ['j'] = 36,
    ['k'] = 311,
    ['l'] = 182,
    ['m'] = 244,
    ['n'] = 249,
    ['o'] = 39,
    ['p'] = 199,
    ['q'] = 44,
    ['r'] = 45,
    ['s'] = 33,
    ['t'] = 245,
    ['u'] = 303,
    ['v'] = 0,
    ['w'] = 32,
    ['x'] = 73,
    ['y'] = 246,
    ['z'] = 20,
}

--[[
    FUNCTIONS
]]

-- Function to return a key code from key name
-- Usage: local key_code = utils.keys.get_key('z') -- would return '20'
local function get_key(key_name)
    return keys[key_name]
end

-- Function to return the key name for a key mostly pointless but hey..
-- Usage: local key_name = utils.keys.get_key_name(20) -- would return 'z'
local function get_key_name(key_code)
    for name, code in pairs(keys) do
        if code == key_code then
            return name
        end
    end
    return nil
end

--[[
    ASSIGN LOCALS
]]

utils.keys = utils.keys or {}

utils.keys.get_key = get_key
utils.keys.get_key_name = get_key_name