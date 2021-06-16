QBCore = nil
local scoreboardOpen = false
local PlayerOptin = {}

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    QBCore.Functions.TriggerCallback('qb-scoreboard:server:GetConfig', function(config)
        Config.IllegalActions = config
    end)
end)

RegisterNetEvent('qb-scoreboard:client:SetActivityBusy')
AddEventHandler('qb-scoreboard:client:SetActivityBusy', function(activity, busy)
    Config.IllegalActions[activity].busy = busy
end)

-- Main Thread

Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, Config.OpenKey) then
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
            end
        end

        if IsControlJustReleased(0, Config.OpenKey) then
            if scoreboardOpen then
                SendNUIMessage({
                    action = "close",
                })
                scoreboardOpen = false
            end
        end

        if scoreboardOpen then
            for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 10.0)) do
                local PlayerId = GetPlayerServerId(player)
                local PlayerPed = GetPlayerPed(player)
                local PlayerName = GetPlayerName(player)
                local PlayerCoords = GetEntityCoords(PlayerPed)

                if not PlayerOptin[PlayerId].permission then
                    DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '['..PlayerId..']')
                end
            end
        end

        Citizen.Wait(3)
    end
end)

-- Functions

DrawText3D = function(x, y, z, text)
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

GetPlayersFromCoords = function(coords, distance)
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
			table.insert(closePlayers, player)
		end
    end
    
    return closePlayers
end

GetPlayers = function()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
end
