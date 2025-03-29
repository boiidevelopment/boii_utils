--- @section Modules

local DRAWTEXT = get("modules.drawtext")

--- @section Events

if not ENV.IS_SERVER then

    --- Show drawtext.
    --- @param options table: Options for drawtext ui.
    RegisterNetEvent("boii_utils:cl:drawtext_show", function(options)
        DRAWTEXT.show(options)
    end)

    --- Hide drawtext.
    RegisterNetEvent("boii_utils:cl:drawtext_hide", function()
        DRAWTEXT.hide()
    end)

end
