if ENV.FRAMEWORK ~= "boii_core" then return end

--- @section Modules

local TABLES <const> = get("modules.tables")

--- @module Core Bridge

local core = {}

if ENV.IS_SERVER then

    --- @section Players

    --- Retrieves all players.
    --- @return players table
    local function get_players()
        local players = exports.boii_core:get_players()
        if not players then return false end

        return players
    end

    --- Retrieves player data from the server based on the framework.
    --- @param source number: Player source identifier.
    --- @return Player data object.
    local function get_player(source)
        local player = exports.boii_core:get_player(source)
        if not player then return false end
        
        return player
    end

    --- @section Database

    --- Prepares query parameters for database operations.
    --- @param source number: Player source identifier.
    --- @return Query part and parameters.
    local function get_id_params(source)
        local player = get_player(source)

        local query, params = "identifier = ?", { player.identifier }

        return query, params
    end

    --- @section Identity

    --- Retrieves player character unique id.
    --- @param source number: Player source identifier.
    --- @return Players main identifier.
    local function get_player_id(source)
        local player = get_player(source)
        if not player then return false end

        local player_id = player.identifier

        return player_id
    end

    --- Retrieves a player"s identity information.
    --- @param source number: Player source identifier.
    --- @return Table of players identity information.
    local function get_identity(source)
        local player = get_player(source)
        if not player then return false end

        local player_data = {
            first_name = player._data.identity.first_name,
            middle_name = player._data.identity.middle_name or nil,
            last_name = player._data.identity.last_name,
            dob = player._data.identity.date_of_birth,
            sex = player._data.identity.sex,
            nationality = player._data.identity.nationality
        }

        return player_data
    end

    --- @section Inventory

    --- Gets a player"s inventory data
    --- @param source Player source identifier.
    --- @return The players inventory.
    local function get_inventory(source)
        local player = get_player(source)
        if not player then return false end

        return exports.boii_core:get_inventory(source)
    end

    --- Retrieves an item from the players inventory.
    --- @param source number: Player source identifier.
    --- @param item_name string: Name of the item to retrieve.
    --- @return Item object if found, nil otherwise.
    local function get_item(source, item_name)
        local player = get_player(source)
        if not player then return nil end

        return exports.boii_core:get_item(source, item_name)
    end

    --- Checks if a player has a specific item in their inventory.
    --- @param source number: Player source identifier.
    --- @param item_name string: Name of the item to check.
    --- @param item_amount number: (Optional) Amount of the item to check for.
    --- @return True if the player has the item (and amount), False otherwise.
    local function has_item(source, item_name, item_amount)
        local player = get_player(source)
        if not player then return false end

        local required_amount = item_amount or 1
        return exports.boii_core:has_item(source, item_name, required_amount)
    end

    --- Adds an item to the player"s inventory.
    --- @param source number: Player source identifier.
    --- @param item_id string: The ID of the item to add.
    --- @param amount number: The amount of the item to add.
    --- @param data table|nil: Optional metadata for the item.
    local function add_item(source, item_id, amount, data)
        local player = get_player(source)
        if not player then return false end

        exports.boii_core:add_item(source, item_id, amount, data)
    end

    --- Removes an item from the player"s inventory.
    --- @param source number: Player source identifier.
    --- @param item_id string: The ID of the item to remove.
    --- @param amount number: The amount of the item to remove.
    local function remove_item(source, item_id, amount)
        local player = get_player(source)
        if not player then return false end

        exports.boii_core:remove_item(source, item_id, amount)
    end


    --- Updates the item data for a player.
    --- @param source number: The players source identifier.
    --- @param item_id string: The ID of the item to update.
    --- @param updates table: Table containing updates like ammo count, attachments etc.
    local function update_item_data(source, item_id, updates)
        local player = get_player(source)
        if not player then return false end

        local item = get_item(source, item_id)
        if not item then return false end

        exports.boii_core:update_item_data(source, item_id, updates)
    end

    --- @section Balances

    --- Retrieves the balances of a player.
    --- @param source number: Player source identifier.
    --- @return A table of balances by type.
    local function get_balances(source)
        local player = get_player(source)
        if not player then return false end

        return exports.boii_core:get_accounts(source)
    end

    --- Retrieves a specific balance of a player by type.
    --- @param source number: Player source identifier.
    --- @param balance_type string: The type of balance to retrieve.
    --- @return The balance amount for the specified type.
    local function get_balance_by_type(source, balance_type)
        local balances = get_balances(source)
        if not balances then return false end

        local balance
        if balance_type == "cash" then
            local cash_item = get_item(source, "cash")
            local cash_balance = cash_item and cash_item.amount or 0
            balance = cash_balance
        else
            balance = balances[balance_type] and balances[balance_type].balance or 0
        end

        return balance
    end

    --- Function to add balance to a player.
    --- @param source number: Player source identifier.
    --- @param balance_type string: The type of balance to adjust.
    --- @param amount number: The amount to add.
    --- @param note string|nil: Optional note for the transaction.
    --- @param sender string|nil: Optional sender information.
    local function add_balance(source, balance_type, amount, note, sender)
        exports.boii_core:add_money(source, balance_type, amount, note or nil, sender or nil)
    end

    --- Function to remove balance from a player.
    --- @param source number: Player source identifier.
    --- @param balance_type string: The type of balance to adjust.
    --- @param amount number: The amount to remove.
    --- @param note string|nil: Optional note for the transaction.
    --- @param recipient string|nil: Optional recipient information.
    local function remove_balance(source, balance_type, amount, note, recipient)
        exports.boii_core:remove_money(source, balance_type, amount, recipient or nil, note or nil, recipient or nil)
    end

    --- @section Jobs

    --- Retrieves the jobs of a player by their source identifier.
    --- @param source number: The players source identifier.
    --- @return A table containing the players jobs and their on-duty status.
    local function get_player_jobs(source)
        local player_roles = exports.boii_core:get_roles(source)
        if not player_roles then return false end

        local player_jobs = {}

        for role, role_data in pairs(player_roles) do
            if role_data.role_type == "job" then
                player_jobs[#player_jobs + 1] = role
            end
        end

        return player_jobs
    end

    --- Checks if a player has one of the specified jobs and optionally checks their on-duty status.
    --- @param source number: The players source identifier.
    --- @param job_names table: A list of job names to check against the players roles.
    --- @param check_on_duty boolean: Optional. If true, also checks if the player is on duty for the job.
    --- @return boolean: True if the player has any of the specified jobs and meets the on-duty condition.
    local function player_has_job(source, job_names, check_on_duty)
        local player_jobs = get_player_jobs(source)
        if not player_jobs then return false end
        
        for role, role_data in pairs(player_jobs) do
            if TABLES.contains(job_names, role) then
                local on_duty = role_data.metadata and role_data.metadata.on_duty
                if not check_on_duty or on_duty then
                    return true
                end
            end
        end

        return false
    end

    --- Retrieves a player"s job grade for a specified job.
    --- @param source number: The players source identifier.
    --- @param job_id string: The job ID to retrieve the grade for.
    --- @return number|nil: The grade of the player for the specified job, or nil if not found.
    local function get_player_job_grade(source, job_id)
        local player_jobs = get_player_jobs(source)
        if not player_jobs then return false end
        
        for _, role_data in ipairs(player_jobs) do
            if role_data.role_type == "job" and role_data.job_id == job_id then
                return role_data.rank
            end
        end

        return nil
    end

    --- Counts players with a specific job and optionally filters by on-duty status.
    --- @param job_names table: Table of job names to check against the players jobs.
    --- @param check_on_duty boolean: Optional boolean to also check if the player is on-duty for the job.
    --- @return Two numbers: total players with the job, and total players with the job who are on-duty.
    local function count_players_by_job(job_names, check_on_duty)
        local players = get_players()
        if not players then return false end

        local total_with_job = 0
        local total_on_duty = 0

        for _, playersource in ipairs(players) do
            if player_has_job(playersource, job_names, false) then
                total_with_job = total_with_job + 1
                if player_has_job(playersource, job_names, true) then
                    total_on_duty = total_on_duty + 1
                end
            end
        end

        return total_with_job, total_on_duty
    end

    --- Returns the first job name for a player.
    --- @param source number: The players source identifier.
    --- @return string|nil: The job name if found, otherwise nil.
    local function get_player_job_name(source)
        local player_jobs = get_player_jobs(source)
        if not player_jobs then return false end

        for role, role_data in pairs(player_jobs) do
            if role_data.type == "job" then
                return role
            end
        end

        return nil
    end

    --- @section Statuses
    
    --- Modifies a player"s server-side statuses.
    -- @param source The player"s source identifier.
    -- @param statuses The statuses to modify.
    local function adjust_statuses(source, statuses)
        local player = get_player(source)
        if not player then return false end

        exports.boii_core:set_statuses(source, statuses)
    end

    --- @section Usable Items

    --- Register an item as usable for different frameworks.
    --- @param item string: The item identifier.
    --- @param cb function: The callback function to execute when the item is used.
    local function register_item(item, cb)
        if not item then return false end

        exports.boii_core:register_item(item, function(source)
            cb(source)
        end)
    end

    --- @section Function Assignments

    core.get_players = get_players
    core.get_player = get_player
    core.get_id_params = get_id_params
    core.get_player_id = get_player_id
    core.get_identity = get_identity
    core.get_inventory = get_inventory
    core.get_item = get_item
    core.has_item = has_item
    core.add_item = add_item
    core.remove_item = remove_item
    core.update_item_data = update_item_data
    core.get_balances = get_balances
    core.get_balance_by_type = get_balance_by_type
    core.add_balance = add_balance
    core.remove_balance = remove_balance
    core.get_player_jobs = get_player_jobs
    core.player_has_job = player_has_job
    core.get_player_job_grade = get_player_job_grade
    core.count_players_by_job = count_players_by_job
    core.get_player_job_name = get_player_job_name
    core.adjust_statuses = adjust_statuses
    core.register_item = register_item

    --- @section Exports

    exports("get_players", get_players)
    exports("get_player", get_player)
    exports("get_id_params", get_id_params)
    exports("get_player_id", get_player_id)
    exports("get_identity", get_identity)
    exports("get_inventory", get_inventory)
    exports("get_item", get_item)
    exports("has_item", has_item)
    exports("add_item", add_item)
    exports("remove_item", remove_item)
    exports("update_item_data", update_item_data)
    exports("get_balances", get_balances)
    exports("get_balance_by_type", get_balance_by_type)
    exports("add_balance", add_balance)
    exports("remove_balance", remove_balance)
    exports("get_player_jobs", get_player_jobs)
    exports("player_has_job", player_has_job)
    exports("get_player_job_grade", get_player_job_grade)
    exports("count_players_by_job", count_players_by_job)
    exports("get_player_job_name", get_player_job_name)
    exports("adjust_statuses", adjust_statuses)
    --- Registered as fw_register_item so does not conflict with internal item system.
    exports("fw_register_item", register_item)

else

    --- @section Player Data

    --- Retrieves a player"s client-side data based on the active framework.
    --- @param key string (optional): The key of the data to retrieve.
    --- @return table: The requested player data.
    local function get_data(key)
        local player_data = exports.boii_core:get_player_data(key)
        return player_data
    end

    --- Retrieves a players identity information.
    --- @return table: The players identity information (first name, last name, date of birth, sex, nationality).
    local function get_identity()
        local player = get_data()
        if not player then return false end

        local identity = {
            first_name = player.identity.first_name,
            middle_name = player.identity.middle_name or nil,
            last_name = player.identity.last_name,
            dob = player.identity.date_of_birth,
            sex = player.identity.sex,
            nationality = player.identity.nationality
        }

        return identity
    end

    --- Retrieves player unique id.
    --- @return Players main identifier.
    local function get_player_id()
        local player = get_data()
        if not player then return false end

        local player_id = player.identifier
        if not player_id then return false end

        return player_id
    end
    
    --- @section Function Assignments
    
    core.get_data = get_data
    core.get_identity = get_identity
    core.get_player_id = get_player_id

    --- @section Exports

    exports("get_data", get_data)
    exports("get_identity", get_identity)
    exports("get_player_id", get_player_id)

end

return core