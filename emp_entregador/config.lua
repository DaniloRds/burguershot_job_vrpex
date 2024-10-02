Config = {}

Config.ValorPagamento = math.random(400,500) -- Valor aléatório de pagamento (Mexer só nos números)
Config.QuantiaDeLanches = 2 -- Quantidade de lanches que vão ser entregados e coletados. (Valor aleatório entre 1 e 2)
Config.Moto = "Fan_James" -- Spawn da moto que vai ser utilizada no emprego.

Config.cdsServico = {-1180.31,-896.43,13.98} -- Coordenadas para entrar em serviço.
Config.cdsLanche = {-1196.0,-899.64,13.98} -- Coordenadas para pegar o lanche após iniciar serviço.
Config.cdsPegarMoto = {-1173.42,-898.52,13.78} -- Coordenadas para solicitar a moto.
Config.sairEmp = { -- Aqui vc calcula a distãncia que o player precisa estar da coord para poder sair do emprego, eu coloquei a coord na loja, então ele precisa estar lá para sair do emprego.
    ["range"] = 15,
    ["cds"] = {-1178.58, -891.67, 13.75}
}

Config.roupas = {

	["entregador"] = { -- Aqui estão os presets das roupas caso queira alterar.
		[1885233650] = { -- Masculino                                                          
			[11] = {146,1,1}, -- Jaqueta
			[5] = {0,0,1} -- Mão
		},
		[-1667301416] = { -- Feminino
			[11] = {212,1,1}, -- Jaqueta
			[5] = {0,0,1} -- Mão
		}
	}
}


return Config 