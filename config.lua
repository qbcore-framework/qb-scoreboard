Config = Config or {}

-- Open scoreboard key
Config.OpenKey = 'HOME' -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/

-- Max Server Players
Config.MaxPlayers = GetConvarInt('sv_maxclients', 64) -- It returnes 64 if it cant find the Convar Int

-- Minimum Police for Actions
Config.IllegalActions = {
    ["houserobbery"] = {
        minimum = 1,
        busy = false,
    },
    ["storerobbery"] = {
        minimum = 2,
        busy = false,
    },
    ["jewellery"] = {
        minimum = 3,
        busy = false,
    },
    ["bankrobbery"] = {
        minimum = 4,
        busy = false,
    },
    ["paleto"] = {
        minimum = 5,
        busy = false,
    },
    ["pacific"] = {
        minimum = 6,
        busy = false,
    },
}

-- Current Cops Online
Config.CurrentCops = 0

-- Current Ambulance / Doctors Online
Config.CurrentAmbulance = 0
