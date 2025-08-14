--- @script init.lua
--- Handles utils initilization.

--- @section Helpers

--- Print logs
local function log_err(fmt, ...) print(("^1[UTILS]^7 " .. fmt):format(...)) end -- Error
local function log_ok (fmt, ...) print(("^2[UTILS]^7 " .. fmt):format(...)) end -- Ok

--- Builds relative paths 
local function build_path(tpl, name)
    return tpl:find("%%s") and tpl:format(name) or ("%s/%s.lua"):format(tpl, name)
end

--- @section Resource Auto Detection

--- Auto detects ui/framework resources.
--- @param flag_key string: ENV flag key e.g. "AUTO_DETECT_FRAMEWORK"
--- @param option_key string: ENV option key e.g. "FRAMEWORK"
--- @param list table: ENV resource table e.g. "ENV.FRAMEWORKS"
--- @param default_value string: Convar default value "standalone"
--- @param label string: Optional log string for detected resource e.g. "Framework" would log "Framework detected: boii_core".
local function auto_detect(flag_key, option_key, list, default_value, log)
    if not ENV[flag_key] or ENV[option_key] ~= default_value then return end
    for _, res in ipairs(list) do
        if GetResourceState(res.resource) == "started" then
            ENV[option_key] = res.key
            if log then log_ok("%s detected: %s", log, res.resource) end
            return
        end
    end
end

auto_detect("AUTO_DETECT_FRAMEWORK", "FRAMEWORK", ENV.FRAMEWORKS, "standalone", "Framework")
auto_detect("AUTO_DETECT_DRAWTEXT", "DRAWTEXT", ENV.DRAWTEXTS, "default")
auto_detect("AUTO_DETECT_NOTIFY", "NOTIFY", ENV.NOTIFICATIONS, "default")

--- @section Safe Require Function

--- Quick ref to env path table
local p = ENV.INTERNAL_PATHS

--- Universal cached loader
--- @param key string: String name for module to load e.g. Internal: "modules.core" | "data.jobs", External: "your_resource:path.to.file"
--- @return table|nil
function get(key)
    local resource, rel_path
    if key:find(":") then
        resource, rel_path = key:match("^([^:]+):(.+)$")
        if not resource or not rel_path then log_err("bad key %s", key) return end
        rel_path = rel_path:gsub("%.", "/")
        if not rel_path:match("%.lua$") then rel_path = rel_path .. ".lua" end
    else
        local prefix, name = key:match("^(%w+)%.(.+)$")
        if not (prefix and p[prefix]) then log_err("bad key %s", key) return end
        resource = ENV.RESOURCE_NAME
        rel_path = build_path(p[prefix], name)
        if prefix == "modules" then
            local tries = { rel_path, build_path(p.ui_bridge, name) }
            if name == "core" and ENV.FRAMEWORK ~= "standalone" then
                tries[#tries + 1] = build_path(p.fw_bridge, ENV.FRAMEWORK)
            end
            for _, path_try in ipairs(tries) do
                if LoadResourceFile(resource, path_try) then
                    rel_path = path_try
                    break
                end
            end
        end
    end

    local cache_key = ("%s:%s"):format(resource, rel_path)
    if ENV.CACHE[cache_key] then return ENV.CACHE[cache_key] end

    local max_tries, wait_ms = 20, 100
    local tries = 0
    local state = GetResourceState(resource)
    while state == "starting" and tries < max_tries do
        Citizen.Wait(wait_ms)
        tries = tries + 1
        state = GetResourceState(resource)
    end
    if state ~= "started" then log_err("resource not started: %s (key %s)", resource, key) return end

    local text = LoadResourceFile(resource, rel_path)
    if not text then log_err("file not found: %s/%s", resource, rel_path) return end
    local chunk, err = load(text, ("@@%s/%s"):format(resource, rel_path), "t", _G)
    if not chunk then log_err("compile error in %s: %s", rel_path, err) return end
    local ok, result = pcall(chunk)
    if not ok then log_err("runtime error in %s: %s",  rel_path, result) return end
    if type(result) ~= "table" then log_err("module did not return table: %s", rel_path) return end

    ENV.CACHE[cache_key] = result
    return result
end

--- Replace global require with cfx safe "get".
_G.require = get

--- Exports
exports("require", get)
exports("get", get)

--- @section Dot Access Helpers

ENV.DATA = setmetatable({}, { __index = function(_, k) return get("data." .. k) end })
ENV.MODULES = setmetatable({}, { __index = function(_, k) return get("modules." .. k) end })

--- @section Compat

exports("get_utils", function()
    log_err(("Legacy Call: 'get_utils' was removed in v2.0"))
    log_err("Download v1.8.7 (last version with get_utils): https://github.com/boiidevelopment/boii_utils/releases/tag/v1.8.7")
    return {}
end)
