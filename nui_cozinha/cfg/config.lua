cfg = {}

localidades = {
	{ -1200.47,-897.34,13.98 }, -- Locais para aparecer o blip para cozinhar comida.
	{ -1197.82,-895.65,13.98 },
}

geremias = { -- Locais para digitar /shot e entrar e sair de serviço.
	{ -1182.21,-899.7,13.98 }, 
	{ -1183.37,-901.14,13.98 }, 
}

-- WebHook para saber quem foi contratado/demitido.
cfg.webhookburguer = ""

cfg.permissao = "burguershot.permissao" -- Permissão para abrir a bancada de cozinhar

cfg.permissaoadm = "admin.permissao" -- Permissões de adm (vai poder setar ou demitir alguém caso precise)

return cfg

