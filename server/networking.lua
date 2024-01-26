--- This section is responsible for managing player connections, creating user accounts, and handling associated data.
-- @script server/connections.lua

--- @section Tables

--- Temporary table to store synced data
-- @table server_synced_data
local server_synced_data = {}

--- Synchronize data between a client and the server, then update all other clients with this data.
-- @param table_name The name of the table to sync data in.
-- @param key The key in the table to sync data for.
-- @param data_to_sync The data to be synchronized.
RegisterServerEvent('boii_utils:sv:sync_data')
AddEventHandler('boii_utils:sv:sync_data', function(table_name, key, data_to_sync)
    if not server_synced_data[table_name] then
        server_synced_data[table_name] = {}
    end
    server_synced_data[table_name][key] = data_to_sync
    TriggerClientEvent('boii_utils:cl:update_synced_data', -1, table_name, key, data_to_sync)
end)
