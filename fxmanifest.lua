fx_version 'cerulean'
game 'gta5'

description 'QB-Scoreboard'
version '1.0.0'

ui_page "html/ui.html"

client_scripts {
    'client.lua',
	'config.lua',
}

server_scripts {
	'config.lua',
	'server.lua',
}

files {
    "html/*"
}