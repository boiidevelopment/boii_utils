--- @module DrawText Bridge

local drawtext = {}

if ENV.IS_SERVER then 

    --- @section Show

    --- Show drawtext for a specific client.
    --- @param source number: The ID of the target player.
    --- @param options table: The drawtext UI options (header, message, icon).
    local function show_drawtext(source, options)
        if not source or not options or not options.message then return false end

        TriggerClientEvent("boii_utils:cl:drawtext_show", source, options)
    end

    --- @section Hide

    --- Hide drawtext for a specific client.
    --- @param source number: The ID of the target player.
    local function hide_drawtext(source)
        if not source then return false end

        TriggerClientEvent("boii_utils:cl:drawtext_hide", source)
    end
    
    --- @section Function Assignments

    drawtext.show = show_drawtext
    drawtext.hide = hide_drawtext

    --- @section Exports

    exports("drawtext_show", show_drawtext)
    exports("drawtext_hide", hide_drawtext)

else

    --- @section Handlers

    local HANDLERS <const> = {
        default = {
            show = function(options)
                TriggerEvent("boii_utils:show_drawtext", options)
            end,
            hide = function()
                TriggerEvent("boii_utils:hide_drawtext")
            end
        },
        boii = {
            show = function(options)
                exports.boii_ui:show_drawtext(options.header, options.message, options.icon)
            end,
            hide = function()
                exports.boii_ui:hide_drawtext()
            end
        },
        esx = {
            show = function(options)
                exports.es_extended:TextUI(options.message)
            end,
            hide = function()
                exports.es_extended:HideUI()
            end
        },
        okok = {
            show = function(options)
                exports["okokTextUI"]:Open(options.message, "lightgrey", "left", true)
            end,
            hide = function()
                exports["okokTextUI"]:Close()
            end
        },
        ox = {
            show = function(options)
                lib.showTextUI(options.message, { icon = options.icon })
            end,
            hide = function()
                lib.hideTextUI()
            end
        },
        qb = {
            show = function(options)
                exports["qb-core"]:DrawText(options.message)
            end,
            hide = function()
                exports["qb-core"]:HideText()
            end
        }
    }

    --- @section Show

    --- Show drawtext.
    --- @param options table: The drawtext UI options (header, message, icon).
    local function show_drawtext(options)
        if not options or not options.message then return false end

        local handler = HANDLERS or HANDLERS.default

        handler.show(options)
    end

    --- Hide drawtext.
    local function hide_drawtext()
        local handler = HANDLERS or HANDLERS.default

        handler.hide()
    end

    --- @section Function Assignments

    drawtext.show = show_drawtext
    drawtext.hide = hide_drawtext

    --- @section Exports

    exports("drawtext_show", show_drawtext)
    exports("drawtext_hide", hide_drawtext)

end

return drawtext 