Config = Config or {}

Config.Toggle = true
Config.OpenKey = 'HOME'
Config.ShowIDforALL = false
Config.MaxPlayers = GetConvarInt('sv_maxclients', 48)

Config.IllegalActions = {
    ['storerobbery'] = {
        minimumPolice = 1,
        busy = false,
        label = 'Store Robbery',
    },
    ['bankrobbery'] = {
        minimumPolice = 3,
        busy = false,
        label = 'Bank Robbery'
    },
    ['jewellery'] = {
        minimumPolice = 2,
        busy = false,
        label = 'Jewelery'
    },
    ['pacific'] = {
        minimumPolice = 5,
        busy = false,
        label = 'Pacific Bank'
    },
    ['paleto'] = {
        minimumPolice = 4,
        busy = false,
        label = 'Paleto Bay Bank'
    }
}
