local QBCore = exports['qb-core']:GetCoreObject()
local TotalPlayers = 0
local PoliceCount = 0
local AmbulanceCount = 0
local players = {}

QBCore.Functions.CreateCallback('qb-scoreboard:server:GetCurrentPlayers', function(source, cb)
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        TotalPlayers = TotalPlayers + 1
    end
    cb(TotalPlayers)
end)

QBCore.Functions.CreateCallback('qb-scoreboard:server:GetActivity', function(source, cb)
    for k, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            PoliceCount = PoliceCount + 1
        end

        if v.PlayerData.job.name == "ambulance" and v.PlayerData.job.onduty then
            AmbulanceCount = AmbulanceCount + 1
        end
    end
    cb(PoliceCount, AmbulanceCount)
end)

QBCore.Functions.CreateCallback('qb-scoreboard:server:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

QBCore.Functions.CreateCallback('qb-scoreboard:server:GetPlayersArrays', function(source, cb)
    for k, v in pairs(QBCore.Functions.GetQBPlayers()) do
        players[v.PlayerData.source] = {}
        players[v.PlayerData.source].permission = QBCore.Functions.IsOptin(v.PlayerData.source)
    end
    cb(players)
end)

RegisterNetEvent('qb-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('qb-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)