----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--[[
    NETWORKING UTILITIES
]]

local server_synced_data = {}

-- Synchronize data between a client and the server, then update all other clients with this data
-- Usage: Trigger this event when a client wants to update a key-value pair in a specific table and synchronize it with all other clients
RegisterServerEvent('boii_utils:sv:sync_data')
AddEventHandler('boii_utils:sv:sync_data', function(table_name, key, data_to_sync)
    if not server_synced_data[table_name] then
        server_synced_data[table_name] = {}
    end
    server_synced_data[table_name][key] = data_to_sync
    TriggerClientEvent('boii_utils:cl:update_synced_data', -1, table_name, key, data_to_sync)
end)
