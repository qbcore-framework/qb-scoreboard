local QBCore = exports['qb-core']:GetCoreObject()
local scoreboardOpen = false
local PlayerOptin = {}

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('qb-scoreboard:server:GetConfig', function(config)
        Config.IllegalActions = config
    end)
end)

RegisterNetEvent('qb-scoreboard:client:SetActivityBusy', function(activity, busy)
    Config.IllegalActions[activity].busy = busy
end)

-- Command

RegisterCommand('scoreboard', function()
    if not scoreboardOpen then
        QBCore.Functions.TriggerCallback('qb-scoreboard:server:GetPlayersArrays', function(playerList)
            QBCore.Functions.TriggerCallback('qb-scoreboard:server:GetActivity', function(cops, ambulance)
                QBCore.Functions.TriggerCallback("qb-scoreboard:server:GetCurrentPlayers", function(Players)
                    PlayerOptin = playerList
                    Config.CurrentCops = cops

                    SendNUIMessage({
                        action = "open",
                        players = Players,
                        maxPlayers = Config.MaxPlayers,
                        requiredCops = Config.IllegalActions,
                        currentCops = Config.CurrentCops,
                        currentAmbulance = ambulance
                    })
                    scoreboardOpen = true
                end)
            end)
        end)
    else
        SendNUIMessage({
            action = "close",
        })
        scoreboardOpen = false
    end
end)

RegisterKeyMapping('scoreboard', 'Open Scoreboard', 'keyboard', Config.OpenKey)

-- Threads

CreateThread(function()
    local loop = 1000
    while true do
        if scoreboardOpen then
            for _, player in pairs(QBCore.Functions.GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 10.0)) do
                local PlayerId = GetPlayerServerId(player)
                local PlayerPed = GetPlayerPed(player)
                local PlayerCoords = GetEntityCoords(PlayerPed)
                if Config.ShowIDforALL or PlayerOptin[PlayerId].permission then
                    QBCore.Functions.DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '['..PlayerId..']')
                end
            end
            loop = 0
        else
            loop = 1000
        end
        Wait(loop)
    end
end)