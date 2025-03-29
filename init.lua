--- @script Utils Initialization
--- Initializes framework bridge, loads and caches relevant modules.

--- @section Environment

ENV = setmetatable({
    --- @section Cache

    DATA = {},
    MODULES = {},

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

--- @section Resource Detection

--- Framework auto detection if `AUTO_DETECT_FRAMEWORK = true` or if convar is not explicity set.
if ENV.AUTO_DETECT_FRAMEWORK and ENV.FRAMEWORK == "standalone" then

    --- Detects current running framework if not started falls back to standalone.
    local function detect_framework()
        for _, res in ipairs(ENV.FRAMEWORKS) do
            if GetResourceState(res.resource) == "started" then
                print("^2Framework Bridge:^7 Server is running ".. res.resource..'. ENV.FRAMEWORK has been set accordingly.')
                return res.key
            end
        end
        return "standalone"
    end

    ENV.FRAMEWORK = detect_framework()
end

--- Auto-detects the currently running DrawText UI resource if `AUTO_DETECT_DRAWTEXT = true` or if convar is not explicitly set.
if ENV.AUTO_DETECT_DRAWTEXT and ENV.DRAWTEXT == "default" then

    --- Detects the active DrawText UI resource if not found, falls back to default.
    local function detect_drawtext()
        for _, res in ipairs(ENV.DRAWTEXTS) do
            if GetResourceState(res.resource) == "started" then
                return res.key
            end
        end
        return "default"
    end

    ENV.DRAWTEXT = detect_drawtext()
end

--- Auto-detects the currently running Notify resource if `AUTO_DETECT_NOTIFY = true` or if convar is not explicitly set.
if ENV.AUTO_DETECT_NOTIFY and ENV.NOTIFY == "default" then

    --- Detects the active Notify resource if not found, falls back to default.
    local function detect_notify()
        for _, res in ipairs(ENV.NOTIFICATIONS) do
            if GetResourceState(res.resource) == "started" then
                return res.key
            end
        end
        return "default"
    end

    ENV.NOTIFY = detect_notify()
end

--- Unified function to load modules or data based on a prefixed name.
--- @param name string: Prefixed name to load, e.g., "modules.core" or "data.licenses".
function get(name)
    local prefix, clean_name = name:match("^(%w+)%.(.+)$")
    if not prefix or not clean_name then print(("[ERROR] Invalid name format: %s"):format(name)) return nil end
    local handlers = {
        data = {env = ENV.DATA, paths = {"lib/data/%s.lua"}},
        modules = {env = ENV.MODULES, paths = {"lib/modules/%s.lua", "lib/bridges/ui/%s.lua"}}
    }
    if clean_name == "core" and ENV.FRAMEWORK ~= "standalone" then
        handlers.modules.paths[#handlers.modules.paths + 1] = ("lib/bridges/frameworks/%s.lua"):format(ENV.FRAMEWORK)
    end
    local handler = handlers[prefix]
    if not handler then print(("[ERROR] Unknown prefix: %s"):format(prefix)) return nil end
    if handler.env[name] then return handler.env[name] end
    for _, path in ipairs(handler.paths) do
        local content = LoadResourceFile(GetCurrentResourceName(), path:format(clean_name))
        if content then
            local fn, err = load(content, ("@@%s/%s"):format(GetCurrentResourceName(), path:format(clean_name)), "t", _G)
            if not fn then print(("[ERROR] Load error in %s: %s"):format(clean_name, err)) return nil end
            local success, result = pcall(fn)
            if not success then print(("[ERROR] Execution error in %s: %s"):format(clean_name, result)) return nil end
            handler.env[name] = result
            return result
        end
    end
    print(("[ERROR] File not found for %s in any specified path."):format(name))
end

exports("get", get)