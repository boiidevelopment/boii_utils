--- @section Modules

local COOLDOWNS <const> = get("modules.cooldowns")

if ENV.IS_SERVER then

    --- Clean up cooldowns on resource stop.
    AddEventHandler("onResourceStop", function(res)
        if res ~= GetCurrentResourceName() then return end
        COOLDOWNS.clear_resource_cooldowns(res)
    end)

end