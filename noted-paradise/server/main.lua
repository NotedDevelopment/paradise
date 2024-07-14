local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand(Config.ParadiseCommand, function(source)
    print("paradise entered\n")
    TriggerClientEvent('noted-paradise:client:ActiveCamera', source, 1)
end, false)

-- QBCore.Functions.CreateCallback('qb-scrapyard:checkOwnerVehicle', function(_, cb, plate)
--     local result = MySQL.scalar.await("SELECT `plate` FROM `player_vehicles` WHERE `plate` = ?",{plate})
--     if result then
--         cb(false)
--     else
--         cb(true)
--     end
-- end)


-- RegisterCommand("cs", function(source, CurrentVehicles)
--     TriggerClientEvent("qb-scrapyard:client:StartListEmail", source)
-- end, false)



-- RegisterCommand(Config.CheckListCommand, function(source)
--     TriggerClientEvent("qb-scrapyard:client:checkList", source)
-- end, false)
