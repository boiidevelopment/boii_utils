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

--- Drawtext bridge.
--- @script client/scripts/bridges/drawtext.lua

--- @section Constants

local DRAWTEXT

CreateThread(function()
    while not (config and config.ui and config.ui.drawtext) do
        Wait(100)
    end
    DRAWTEXT = config.ui.drawtext
    print('DRAWTEXT has been set.')
end)

--- @section Local functions

--- Show drawtext.
--- @function show_drawtext
--- @param options table: The drawtext ui options (header, message, icon).
local function show_drawtext(options)
    if not options or options.message then
        print('Invalid drawtext data provided')
        return
    end

    if DRAWTEXT == 'boii_ui' then
        exports.boii_ui:show_drawtext(options.header, options.message, options.icon)
    elseif DRAWTEXT == 'ox_lib' then
        lib.showTextUI(options.message, { icon = options.icon })
    elseif DRAWTEXT == 'qb-core' then
        exports['qb-core']:DrawText(options.message)
    elseif DRAWTEXT == 'es_extended' then
        exports.es_extended:TextUI(options.message)
    elseif DRAWTEXT == 'okokTextUI' then
        exports['okokTextUI']:Open(options.message, 'lightgrey', 'left', true)
    elseif DRAWTEXT == 'custom' then
        --- Add custom implementation here
    else
        exports.boii_ui:show_drawtext(options.header, options.message, options.icon)
    end
end

exports('ui_show_drawtext', show_drawtext)
utils.ui.show_drawtext = show_drawtext

--- Hide drawtext.
--- @function hide_drawtext
local function hide_drawtext()
    if DRAWTEXT == 'boii_ui' then
        exports.boii_ui:hide_drawtext()
    elseif DRAWTEXT == 'ox_lib' then
        lib.hideTextUI()
    elseif DRAWTEXT == 'qb-core' then
        exports['qb-core']:HideText()
    elseif DRAWTEXT == 'es_extended' then
        exports.es_extended:HideUI()
    elseif DRAWTEXT == 'okokTextUI' then
        exports['okokTextUI']:Close()
    elseif DRAWTEXT == 'custom' then
        --- Add custom implementation here
    else
        exports.boii_ui:hide_drawtext()
    end
end

exports('ui_hide_drawtext', hide_drawtext)
utils.ui.hide_drawtext = hide_drawtext
