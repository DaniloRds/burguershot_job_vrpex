Config = {}

Config.PermissaoAdmin = "admin.permissao"
Config.PermissaoBurguer = "burguershot.permissao" -- Quem tem permissão para utilizar este emprego.

Config.cdsServico = {-1188.49, -900.96, 13.98} -- Cds pra iniciar o serviço.
Config.cdsDepositoI = {-1200.76, -901.37, 13.98} -- Cds do blip do depósito de ingredientes.
Config.cdsDepositoB = {-1198.72, -903.62, 13.98} -- Cds do blip do depósito de bebidas.

Config.cdsVan = {-1165.5, -893.9, 14.05} -- Cds aonde vai estar o blip para pegar a van.
Config.cdsSpawnVan = {-1163.79,-891.17,13.71,120.0} -- Coordenadas em que o veículo vai spawnar, lembre-se de pegar o h (direção) também.

Config.sairEmp = { -- Aqui vc calcula a distãncia que o player precisa estar da coord para poder sair do emprego, eu coloquei a coord na loja, então ele precisa estar lá para sair do emprego.
    ["range"] = 15,
    ["cds"] = {-1178.58, -891.67, 13.75}
}

Config.option = 2 -- Opções 1 ou 2 (Opção 1: O player recebe o pagamento na mesma hora que coleta os ingredientes) 
-- (Opção 2: O player recebe o pagamento na hora de entregar os ingredientes com base na quantidade que ele pegou)

Config.rotas = 1 -- Opções 1 ou 2 (Opção 1: rota aleatória) (Opção 2: rota fixa)

Config.quantidadeI = {2,6} -- Quantidade de ingredientes a serem pegos por vez, valor aleátorio entre 2 e 6.

Config.probabilidade = 50 -- Número de % de chance de coletar bebidas junto com os ingredientes. (50% de chance)

Config.quantidadeB = {2,6} -- Quantidade de bebidas a serem pegos por vez de acordo com a %, valor aleátorio entre 2 e 6.

-- [Caso use a opção 1 configure o pagamentoColeta]
Config.pagamentoColeta = {600,1000} -- Valor aleatório para o pagamento após coletar os ingredientes. (Mexer só nos números, caso queira um valor fixo basta colocar os dois números iguais tipo {1000,1000})

-- [Caso use a opção 2 configure o pagamentoDeposito]
Config.pagamentoDeposito = {200,400} -- Valor aleatório para o pagamento após o depósito dos ingredientes. (Mexer só nos números, caso queira um valor fixo basta colocar os dois números iguais tipo {1000,1000})

-- (O valor é multiplicado pela quantidade de ingredientes entregados, exemplo: se forem entregues 100 ingredientes e o valor de pagamento for 500, logo o player recebe 50k)

Config.van = "burrito" -- Spawn da van que vai ser utilizada no emprego.

Config.roupas = {
	["coleta"] = { -- Aqui estão os presets das roupas caso queira alterar.
		[1885233650] = {-- Masculino                                     
            [11] = {9,0,1}, -- Jaqueta
            [8] = {15,0,1}, -- Camisa
            [5] = {0,0,1} -- Mão
        },
        [-1667301416] = {-- Feminino
            [11] = {141,0,1}, -- Jaqueta
            [8] = {15,0,1}, -- Camisa
            [5] = {0,0,1} -- Mão
        }
	}
}


return Config 