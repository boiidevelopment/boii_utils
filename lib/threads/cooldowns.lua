--- @section Modules

local COOLDOWNS <const> = get("modules.cooldowns")

--- @section Threads

if ENV.IS_SERVER then

    --- Clean up expired cooldowns periodically.
    CreateThread(function()
        while true do
            Wait(ENV.CLEAR_EXPIRED_COOLDOWNS * 60 * 1000)
            COOLDOWNS.clear_expired_cooldowns()
        end
    end)
    
end