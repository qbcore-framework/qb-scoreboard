local QBCore = exports['qb-core']:GetCoreObject()
local scoreboardOpen = false
local PlayerOptin = {}

-- Functions

local function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function GetPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            players[#players+1] = player
        end
    end
    return players
end

local function GetPlayersFromCoords(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

    if coords == nil then
		coords = GetEntityCoords(PlayerPedId())
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = #(targetCoords - vector3(coords.x, coords.y, coords.z))
		if targetdistance <= distance then
            closePlayers[#closePlayers+1] = player
		end
    end

    return closePlayers
end

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
    while true do
        local loop = 1000
        if scoreboardOpen then
            for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 10.0)) do
                local PlayerId = GetPlayerServerId(player)
                local PlayerPed = GetPlayerPed(player)
                local PlayerCoords = GetEntityCoords(PlayerPed)
                if Config.ShowIDforALL or PlayerOptin[PlayerId].permission then
                    loop = 0
                    DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '['..PlayerId..']')
                end
            end
        end
        Wait(loop)
    end
end)