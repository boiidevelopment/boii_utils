--- @section Get Modules

local CALLBACKS <const> = get("modules.callbacks")

--- @module Licences

local licences = {}

if ENV.IS_SERVER then

    local utils_licences = {}

    --- @section Helper Functions
    
    local function init_licences(source)
        local identifier = CORE.get_player_id(source) or get_identifiers(source).license
        if not identifier then return {} end
    
        local query = 'SELECT licence_id, theory, practical, theory_date, practical_date, points, max_points, revoked FROM utils_licences WHERE identifier = ?'
        local results = MySQL.query.await(query, { identifier })
    
        local licence = {}
        for _, row in ipairs(results or {}) do
            licence[row.licence_id] = {
                theory = row.theory == 1,
                practical = row.practical == 1,
                theory_date = row.theory_date,
                practical_date = row.practical_date,
                points = row.points or 0,
                max_points = row.max_points or 12,
                revoked = row.revoked == 1
            }
        end
    
        utils_licences[source] = licence
        return licence
    end
    
    --- @section Module Functions
    
    --- Gets licences for the player.
    --- @param source number: Player source identifier
    local function get_licences(source)
        if not utils_licences[source] then
            return init_licences(source)
        end
        return utils_licences[source]
    end

    --- Get a specific licence for a player.
    --- @param source number: Player source identifier.
    --- @param licence_id string: Licence ID to retrieve.
    --- @return table|nil: Returns the licence data if found, otherwise nil.
    local function get_licence(source, licence_id)
        if not source or not licence_id then return nil end

        if utils_licences[source] and utils_licences[source][licence_id] then
            return utils_licences[source][licence_id]
        end

        local identifier = CORE.get_player_id(source) or get_identifiers(source).license
        if not identifier then return nil end

        local query = 'SELECT licence_id, theory, practical, theory_date, practical_date, points, max_points, revoked FROM utils_licences WHERE identifier = ? AND licence_id = ?'
        local result = MySQL.query.await(query, { identifier, licence_id })

        if result and #result > 0 then
            local row = result[1]
            local licence_data = {
                licence_id = row.licence_id,
                theory = row.theory == 1,
                practical = row.practical == 1,
                theory_date = row.theory_date,
                practical_date = row.practical_date,
                points = row.points or 0,
                max_points = row.max_points or 12,
                revoked = row.revoked == 1
            }

            if not utils_licences[source] then utils_licences[source] = {} end
            utils_licences[source][licence_id] = licence_data

            return licence_data
        end

        return nil
    end

    --- Add a licence to a player
    --- @param source number: Player source identifier
    --- @param licence_id string: Licence ID to add
    local function add_licence(source, licence_id)
        local identifier = CORE.get_player_id(source) or get_identifiers(source).license
        if not identifier or not licence_id then return false end

        local query = 'INSERT INTO utils_licences (identifier, licence_id) VALUES (?, ?) ON DUPLICATE KEY UPDATE identifier = identifier'
        MySQL.update.await(query, { identifier, licence_id })

        if not utils_licences[source] then utils_licences[source] = {} end
        utils_licences[source][licence_id] = { theory = false, practical = false, points = 0, max_points = 12, revoked = false }

        return true
    end

    --- Remove a licence from a player
    --- @param source number: Player source identifier
    --- @param licence_id string: Licence ID to remove
    local function remove_licence(source, licence_id)
        local identifier = CORE.get_player_id(source) or get_identifiers(source).license
        if not identifier or not licence_id then return false end

        local query = 'DELETE FROM utils_licences WHERE identifier = ? AND licence_id = ?'
        MySQL.update.await(query, { identifier, licence_id })

        if utils_licences[source] then
            utils_licences[source][licence_id] = nil
        end

        return true
    end

    --- Add points to a players licence
    --- @param source number: Player source identifier
    --- @param licence_id string: Licence ID to modify
    --- @param points number: Points to add
    local function add_points(source, licence_id, points)
        local identifier = CORE.get_player_id(source) or get_identifiers(source).license
        if not identifier or not licence_id or not points then return false end

        local query = 'UPDATE utils_licences SET points = points + ? WHERE identifier = ? AND licence_id = ?'
        MySQL.update.await(query, { points, identifier, licence_id })

        if utils_licences[source] and utils_licences[source][licence_id] then
            utils_licences[source][licence_id].points = utils_licences[source][licence_id].points + points

            if utils_licences[source][licence_id].points >= utils_licences[source][licence_id].max_points then
                utils_licences[source][licence_id].revoked = true
                local revoke_query = 'UPDATE utils_licences SET revoked = 1 WHERE identifier = ? AND licence_id = ?'
                MySQL.update.await(revoke_query, { identifier, licence_id })
            end
        end

        return true
    end

    --- Remove points from a players licence
    --- @param source number: Player source identifier
    --- @param licence_id string: Licence ID to modify
    --- @param points number: Points to remove
    local function remove_points(source, licence_id, points)
        local identifier = CORE.get_player_id(source) or get_identifiers(source).license
        if not identifier or not licence_id or not points then return false end

        local query = 'UPDATE utils_licences SET points = GREATEST(points - ?, 0), revoked = 0 WHERE identifier = ? AND licence_id = ?'
        MySQL.update.await(query, { points, identifier, licence_id })

        if utils_licences[source] and utils_licences[source][licence_id] then
            utils_licences[source][licence_id].points = math.max(utils_licences[source][licence_id].points - points, 0)
            utils_licences[source][licence_id].revoked = false
        end

        return true
    end

    --- Update a players licence test status.
    --- @param source number: Player source identifier
    --- @param licence_id string: Licence ID to update
    --- @param test_type string: 'theory' or 'practical'
    --- @param passed boolean: Whether the test was passed
    local function update_licence(source, licence_id, test_type, passed)
        local identifier = CORE.get_player_id(source) or get_identifiers(source).license
        if not identifier or not licence_id or (test_type ~= 'theory' and test_type ~= 'practical') then return false end

        local date_field = test_type .. "_date"
        local sql = string.format('UPDATE utils_licences SET %s = ?, %s = ? WHERE identifier = ? AND licence_id = ?', test_type, date_field)
        MySQL.update.await(sql, { passed, passed and os.date('%Y-%m-%d %H:%M:%S') or nil, identifier, licence_id })

        if utils_licences[source] and utils_licences[source][licence_id] then
            utils_licences[source][licence_id][test_type] = passed
            utils_licences[source][licence_id][date_field] = passed and os.date('%Y-%m-%d %H:%M:%S') or nil
        end

        return true
    end

    --- @section Function Assignments

    licences.get_all = get_licences
    licences.get = get_licence
    licences.add = add_licence
    licences.remove = remove_licence
    licences.add_points = add_points
    licences.remove_points = remove_points
    licences.update = update_licence

    --- @section Exports

    exports('get_licences', get_licences)
    exports('add_licence', add_licence)
    exports('remove_licence', remove_licence)
    exports('add_points', add_points)
    exports('remove_points', remove_points)
    exports('update_licence', update_licence)

    --- @section Callbacks

    CALLBACKS.register('boii_utils:sv:get_licences', function(source, data, cb)
        local utils_licences = get_licences(source)
        if utils_licences then
            cb({ success = true, licences = utils_licences })
        else
            cb({ success = false, })
        end
    end)

else

    --- Gets licences for the player.
    local function get_licences()
        CALLBACKS.trigger('boii_utils:sv:get_licences', nil, function(response)
            if response.success and response.licences then
                return response.licences
            else
                return nil
            end
        end)
    end

    --- @section Function Assignments

    licences.get_all = get_licences

    --- @section Exports

    exports('get_licences', get_licences)

end

return licences
