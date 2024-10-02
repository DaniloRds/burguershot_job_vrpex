fx_version 'bodacious'
game 'gta5'

author 'danilords' 
description 'By Unity FiveM | discord.gg/pbT5wVp8e9' 
version '1.0.0'

ui_page "nui/ui.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"config.lua",
	"client.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"config.lua",
	"server.lua"
}

files {
	"nui/ui.html",
	"nui/ui.js",
	"nui/ui.css",
	"nui/images/*.png",
}