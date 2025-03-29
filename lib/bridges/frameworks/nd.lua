if ENV.FRAMEWORK ~= "nd" then return end

--- @section Modules

local TABLES <const> = get("modules.tables")

--- @module Core Bridge

local core = {}

if ENV.IS_SERVER then

    --- @section Players

    --- Retrieves all players.
    --- @return players table
    local function get_players()
        local players = exports.ND_Core:getPlayers()

        return players
    end

    --- Retrieves player data from the server based on the framework.
    --- @param source number: Player source identifier.
    --- @return Player data object.
    local function get_player(source)
        local player = exports.ND_Core:getPlayer(source)

        return player
    end

    --- @section Database

    --- Prepares query parameters for database operations.
    --- @param source number: Player source identifier.
    --- @return Query part and parameters.
    local function get_id_params(source)
        local player = get_player(source)
        if not player then return false end

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

    --- Retrieves a players identity information.
    --- @param source number: Player source identifier.
    --- @return Table of players identity information.
    local function get_identity(source)
        local player = get_player(source)
        if not player then return false end

        local identity = {
            first_name = player.getData("firstname"),
            last_name = player.getData("lastname"),
            dob = player.getData("dob"),
            sex = player.getData("gender"),
            nationality = "LS, Los Santos" 
        }

        return identity
    end

    --- Retrieves a players identity information by their id (citizenid, unique_id+char_id, etc..)
    --- @param unique_id string: The id of the user to retrieve identity information for.
    --- @return Table of identity information.
    local function get_identity_by_id(unique_id)
        local players = get_players()

        for _, player in ipairs(players) do
            if type(player) == "table" then
                p_source = player.source
            else
                p_source = player
            end

            local p_id = get_player_id(p_source)
            if p_id == unique_id then
                local identity = get_identity(p_source)
                return identity
            end
        end

        return nil
    end

    --- @section Inventory

    --- Gets a players inventory data
    --- @param source Player source identifier.
    --- @return The players inventory.
    local function get_inventory(source)
        local player = get_player(source)
        if not player then return false end

        local inventory = exports.ox_inventory:GetInventory(source, false)
        return inventory
    end

    --- Retrieves an item from the players inventory.
    --- @param source number: Player source identifier.
    --- @param item_name string: Name of the item to retrieve.
    --- @return Item object if found, nil otherwise.
    local function get_item(source, item_name)
        local player = get_player(source)
        if not player then return nil end

        local items = exports.ox_inventory:Search(source, "items", item_name)
        if items and #items > 0 then
            local item = items[1]
            return item
        end
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

        local count = exports.ox_inventory:Search(source, "count", item_name)
        return count ~= nil and count >= required_amount
    end

    --- Adds an item to a players inventory.
    --- @param source number: Player source identifier.
    --- @param item_id string: The ID of the item to add.
    --- @param amount number: The amount of the item to add.
    --- @param data table|nil: Optional metadata for the item.
    local function add_item(source, item_id, amount, data)
        local player = get_player(source)
        if not player then return false end

        exports.ox_inventory:AddItem(source, item_id, amount, data)
    end

    --- Removes an item from a players inventory.
    --- @param source number: Player source identifier.
    --- @param item_id string: The ID of the item to remove.
    --- @param amount number: The amount of the item to remove.
    --- @param data table|nil: Optional metadata for the item.
    local function remove_item(source, item_id, amount, data)
        local player = get_player(source)
        if not player then return false end

        exports.ox_inventory:RemoveItem(source, item_id, amount, data)
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

        local items = exports.ox_inventory:Search(source, 1, item_id)
        for _, v in pairs(items) do
            for key, value in pairs(updates) do
                v.metadata[key] = value
            end
            exports.ox_inventory:SetMetadata(source, v.slot, v.metadata)
            break
        end
    end

    --- @section Balances

    --- Retrieves the balances of a player.
    --- @param source number: Player source identifier.
    --- @return A table of balances by type.
    local function get_balances(source)
        local player = get_player(source)
        if not player then return false end

        local balances = { 
            cash = player.cash, 
            bank = player.bank 
        } 

        return balances
    end

    --- Retrieves a specific balance of a player by type.
    --- @param source number: Player source identifier.
    --- @param balance_type string: The type of balance to retrieve.
    --- @return The balance amount for the specified type.
    local function get_balance_by_type(source, balance_type)
        local balances = get_balances(source)
        if not balances then print("no balances") return false end

        local balance
        if balance_type == "cash" then
            local cash_item = get_item(source, "money")
            local cash_balance = cash_item and cash_item.count or 0
            balance = cash_balance
        else
            balance = balances[balance_type]
        end

        return balance
    end

    --- Adds money to a players balance.
    --- @param source number: Player source identifier.
    --- @param balance_type string: The type of balance to adjust.
    --- @param amount number: The amount to add.
    local function add_balance(source, balance_type, amount)
        local player = get_player(source)
        if not player then print("player not found") return end

        if balance_type == "cash" or balance_type == "money" then
            exports.ox_inventory:AddItem(source, "money", amount)
        else
            player.addMoney(balance_type, amount)
        end
    end

    --- Removes money from a players balance.
    --- @param source number: Player source identifier.
    --- @param balance_type string: The type of balance to adjust.
    --- @param amount number: The amount to remove.
    local function remove_balance(source, balance_type, amount)
        local player = get_player(source)
        if not player then print("player not found") return end

        if balance_type == "cash" or balance_type == "money" then
            exports.ox_inventory:RemoveItem(source, "money", amount)
        else
            player.deductMoney(balance_type, amount)
        end
    end

    --- @section Jobs

    --- Retrieves the job(s) of a player by their source identifier.
    --- @param source number: The players source identifier.
    --- @return A table containing the players jobs and their on-duty status.
    local function get_player_jobs(source)
        local player = get_player(source)

        local player_jobs = player.getJob()
        return player_jobs
    end

    --- Checks if a player has one of the specified jobs and optionally checks their on-duty status.
    --- @param source number: The players source identifier.
    --- @param job_names table: An array of job names to check against the players jobs.
    --- @param check_on_duty boolean: Optional boolean to also check if the player is on-duty for the job.
    --- @return Boolean indicating if the player has any of the specified jobs and meets the on-duty condition.
    local function player_has_job(source, job_names)
        local player_jobs = get_player_jobs(source)
        if not player_jobs then return false end

        local job_found = false
        local on_duty_status = false

        if TABLES.contains(job_names, player_jobs.name) then
            job_found = true
            on_duty_status = true
        end

        return job_found and (not check_on_duty or on_duty_status)
    end

    --- Retrieves a players job grade for a specified job.
    --- @param source number: The players source identifier.
    --- @param job_id string: The job ID to retrieve the grade for.
    --- @return The grade of the player for the specified job, or nil if not found.
    local function get_player_job_grade(source, job_id)
        local player_jobs = get_player_jobs(source)
        if not player_jobs then return nil end

        if player_jobs.id == job_id then
            return player_jobs.rank
        end

        return nil
    end

    --- Counts players with a specific job and optionally filters by on-duty status.
    --- @param job_names table: Table of job names to check against the players jobs.
    --- @param check_on_duty boolean: Optional boolean to also check if the player is on-duty for the job.
    --- @return Two numbers: total players with the job, and total players with the job who are on-duty.
    local function count_players_by_job(job_names, check_on_duty)
        local players = get_players()

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

    --- Returns a players job name.
    --- @param source number: The players source identifier.
    local function get_player_job_name(source)
        local player_jobs = get_player_jobs(source)
        if not player_jobs then return false end

        local job_name
        if player_jobs then
            job_name = player_jobs.name
        end

        return job_name
    end

    --- @section Statuses

    --- Modifies a players server-side statuses.
    --- @param source The players source identifier.
    --- @param statuses The statuses to modify.
    local function adjust_statuses(source, statuses)
        local player = get_player(source)
        if not player then print("Player not found") return end

        --- @todo nd status logic
    end

    --- @section Usable Items

    --- Register an item as usable for different frameworks.
    --- @param item string: The item identifier.
    --- @param cb function: The callback function to execute when the item is used.
    local function register_item(item, cb)
        if not item then return false end
        
        --- @todo nd register item method
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

    --- Retrieves a players client-side data based on the active framework.
    --- @param key string (optional): The key of the data to retrieve.
    --- @return table: The requested player data.
    local function get_data()
        local player_data = exports.ND_Core:getPlayer()

        return player_data
    end

    --- Retrieves a players identity information.
    --- @return table: The players identity information (first name, last name, date of birth, sex, nationality).
    local function get_identity()
        local player = get_data()
        if not player then return false end

        local identity = {
            first_name = player.firstname or "firstname missing",
            last_name = player.lastname or "lastname missing",
            dob = player.dob or "dob missing",
            sex = player.gender or "gender missing",
            nationality = "LS, Los Santos"
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

    --- @section Exports

    exports("get_data", get_data)
    exports("get_identity", get_identity)
    exports("get_player_id", get_player_id)
    
    --- @section Function Assignments
    
    core.get_data = get_data
    core.get_identity = get_identity
    core.get_player_id = get_player_id

end

return core