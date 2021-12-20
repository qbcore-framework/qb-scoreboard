Config = Config or {}

-- Open scoreboard key
Config.OpenKey = 'HOME' -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/

-- Max Server Players
Config.MaxPlayers = GetConvarInt('sv_maxclients', 48) -- It returns 48 if it cant find the Convar Int

-- Minimum Police for Actions
Config.IllegalActions = {
    ["storerobbery"] = {
        minimum = 2,
        busy = false,
    },
    ["bankrobbery"] = {
        minimum = 3,
        busy = false,
    },
    ["jewellery"] = {
        minimum = 3,
        busy = false,
    },
    ["pacific"] = {
        minimum = 5,
        busy = false,
    },
}

-- Current Cops Online
Config.CurrentCops = 0

-- Current Ambulance / Doctors Online
Config.CurrentAmbulance = 0

-- Show ID's for all players or Opted in Staff
Config.ShowIDforALL = false
