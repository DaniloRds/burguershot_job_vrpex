fx_version 'adamant'
game 'gta5'
-- ESTE É UM CONTEÚDO TOTALMENTE GRATUITO!
author 'danilords' 
description 'By Unity FiveM | discord.gg/pbT5wVp8e9' 
version '1.0.0'

ui_page 'nui/index.html'

client_scripts {
	'@vrp/lib/utils.lua',
	'client.lua',
	'config.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'server.lua',
	'config.lua'
}

files {
	'nui/*.html',
	'nui/*.js',
	'nui/*.css',
	'nui/**/*'
}