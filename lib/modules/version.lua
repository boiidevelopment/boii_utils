local version = {}

if ENV.SERVER then

    --- Compares two semantic version strings.
    --- @param current_version The current version of the resource.
    --- @param latest_version The latest version available for comparison.
    local function compare_versions(current_version, latest_version)
        local pattern = "(%d+)%.(%d+)%.(%d+)"

        local cur_major, cur_minor, cur_patch = current_version:match(pattern)
        local lat_major, lat_minor, lat_patch = latest_version:match(pattern)
        cur_major, cur_minor, cur_patch = tonumber(cur_major), tonumber(cur_minor), tonumber(cur_patch)
        lat_major, lat_minor, lat_patch = tonumber(lat_major), tonumber(lat_minor), tonumber(lat_patch)

        if not (cur_major and cur_minor and cur_patch and lat_major and lat_minor and lat_patch) then
            return false, "Invalid version format"
        end

        if cur_major < lat_major then return true
        elseif cur_major > lat_major then return false
        elseif cur_minor < lat_minor then return true
        elseif cur_minor > lat_minor then return false
        elseif cur_patch < lat_patch then return true
        else return false end
    end

    --- Checks the version of a resource against a version listed in a JSON file hosted on GitHub.
    --- @param opts Table containing configuration options:
    local function check_version(opts)
        local resource_name = opts.resource_name or GetCurrentResourceName()
        local current_version = GetResourceMetadata(resource_name, "version", 0)
        local versions_url = "https://raw.githubusercontent.com/" .. opts.url_path

        if not current_version or current_version == "" then
            print("^1[VERSION CHECK] ERROR: Resource metadata 'version' is missing for '" .. resource_name .. "' in fxmanifest.lua^7")
            return
        end

        PerformHttpRequest(versions_url, function(status, response_text)
            if status == 200 then
                local versions_data = json.decode(response_text)
                if not versions_data or not versions_data.resources then
                    print("^1[VERSION CHECK] - Error decoding JSON or invalid structure for resource: " .. resource_name)
                    if opts.callback then opts.callback(false, "Error decoding JSON or invalid structure.") end
                    return
                end
                local resource_info = versions_data.resources[resource_name]
                if resource_info and resource_info.version then
                    local latest_version = resource_info.version
                    local update_notes = resource_info.notes
                    local is_outdated, err = compare_versions(current_version, latest_version)
                    if err then
                        print("^1[VERSION CHECK] - Error comparing versions for '" .. resource_name .. "': " .. err .. "^7")
                        if opts.callback then opts.callback(false, "Error comparing versions: " .. err) end
                        return
                    end
                    if is_outdated then
                        print("^3[VERSION CHECK] - ^7Update available for resource: '^5" .. resource_name .. "^7'. Current version: ^2" .. current_version .. " ^7Latest version: ^2" .. latest_version .. "^7.")
                        if update_notes and #update_notes > 0 then
                            print("Notes:")
                            for _, note in ipairs(update_notes) do
                                print("^6-> " .. note .. "^7")
                            end
                        end
                        if opts.callback then opts.callback(false, current_version, latest_version, table.concat(update_notes or {}, "\n")) end
                    elseif current_version == latest_version then
                        if opts.callback then opts.callback(true, current_version, latest_version, "Resource is up to date.") end
                    else
                        if opts.callback then opts.callback(true, current_version, latest_version, "Resource version is ahead of the repository.") end
                    end
                else
                    print("^1[VERSION CHECK] - Version info for '" .. resource_name .. "' not found.^7")
                    if opts.callback then opts.callback(false, "Version info not found for resource.") end
                end
            else
                print("^1[VERSION CHECK] - HTTP Error: " .. tostring(status) .. " while fetching version data for " .. resource_name)
                if opts.callback then opts.callback(false, "HTTP Error: " .. tostring(status)) end
            end
        end, "GET")
    end

    local opts = {
        resource_name = 'boii_utils',
        url_path = 'boiidevelopment/fivem_resource_versions/main/versions.json',
    }
    
    check_version(opts)

    --- @section Function Assignments

    version.check = check_version

    --- @section Exports

    exports('check_version', check_version)

end

return version