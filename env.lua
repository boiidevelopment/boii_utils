--- @script Environment
--- Handles script environment variables: priority loading, id prefixes, etc..

ENV = setmetatable({
    --- @section Cache

    CACHE = {},

    --- @section Utils Core

    INTERNAL_PATHS = {
        data = "lib/data/%s.lua",
        modules = "lib/modules/%s.lua",
        ui_bridge = "lib/bridges/ui/%s.lua",
        fw_bridge = "lib/bridges/frameworks/%s.lua"
    },    

    --- @section Natives

    RESOURCE_NAME = GetCurrentResourceName(),
    IS_SERVER = IsDuplicityVersion(),

    --- @section User Registry

    DEFFERAL_UPDATE_MESSAGES = GetConvar("utils:deferals_updates", "true") == "true", -- Defferal connection messages, disable with convars.
    UNIQUE_ID_PREFIX = GetConvar("utils:unique_id_prefix", "USER_"), -- Prefix is combined with digits below to create a unique id e.g, "USER_12345"
    UNIQUE_ID_CHARS = GetConvar("utils:unique_id_chars", "5"), -- Amount of random characters to use after prefix e.g, "ABC12"

    --- @section Framework Bridge

    --- Supported Frameworks: If you have changed the name of your core resource folder update it here.
    FRAMEWORKS = {
        -- If you use multiple cores you can adjust the priority loading order by changed the arrangement here.
        { key = "esx", resource = "es_extended" },
        { key = "boii", resource = "boii_core" },
        { key = "nd", resource = "ND_Core" },
        { key = "ox", resource = "ox_core" },
        { key = "qb", resource = "qb-core" },
        { key = "qbx", resource = "qbx_core" },
    },
    AUTO_DETECT_FRAMEWORK = true, -- If true FRAMEWORK convar setting will be overwritten with auto detection.
    FRAMEWORK = GetConvar("utils:framework", "standalone"), -- This should not be changed, set up convars correctly and change there if needed.

    --- @section UI Bridges

    --- Supported DrawText UIs: If you have changed the name of a resource folder update it here.
    DRAWTEXTS = {
        -- If you use multiple drawtext resource you can adjust the priority loading order by changed the arrangement here.
        { key = "boii", resource = "boii_ui" },
        { key = "esx", resource = "es_extended" },
        { key = "okok", resource = "okokTextUi" },
        { key = "ox", resource = "ox_lib" },
        { key = "qb", resource = "qb-core" }
    },
    AUTO_DETECT_DRAWTEXT = true, -- If true DRAWTEXT convar setting will be overwritten with auto detection.
    DRAWTEXT = GetConvar("utils:drawtext_ui", "default"), -- This should not be changed, set up convars correctly and change there if needed.

    --- Supported Notifys: If you have changed the name of a resource folder update it here.
    NOTIFICATIONS = {
        -- If you use multiple notify resources you can adjust the priority loading order by changed the arrangement here.
        { key = "boii", resource = "boii_ui" },
        { key = "esx", resource = "es_extended" },
        { key = "okok", resource = "okokNotify" },
        { key = "ox", resource = "ox_lib" },
        { key = "qb", resource = "qb-core" }
    },
    AUTO_DETECT_NOTIFY = true, -- If true NOTIFY convar setting will be overwritten with auto detection.
    NOTIFY = GetConvar("utils:notify", "default"), -- This should not be changed, set up convars correctly and change there if needed.

    --- @section Timers

    CLEAR_EXPIRED_COOLDOWNS = GetConvar("utils:clear_expired_cooldowns", "5"), -- Timer to clear expired cooldowns from cache in mins; default 5mins.

}, { __index = _G })