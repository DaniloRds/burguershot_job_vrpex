fx_version 'adamant'
game 'gta5'

author 'danilords' 
description 'By Unity FiveM | discord.gg/pbT5wVp8e9' 

ui_page "nui/index.html"

client_scripts { 
	"@vrp/lib/utils.lua",
	"cfg/config.lua",
	"client.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"cfg/config.lua",
	"server.lua"
}

files {
	"nui/*"
}