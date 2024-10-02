### Olá, sou o Danilo desenvolvedor da Unity Dev Fivem e quero agradecer pela confiança.

<hr>

> Esse script tem várias funções que são sensacionais para seu roleplay e deixam seu servidor mais imersivo.

### Comandos: <br>
/burguershot -> Mostra quantos trabalhadores do burguershot estão em serviço (só pode ser usado pelo dono ou adm) <br>
/shot -> Entra e saí de serviço (o funcionário precisa estar no local certo)

<hr>

### Como instalo o script na minha base? (VRPEX)<br>

Primeiramente você deve colocar os itens necessários na sua base, vou deixar as imagens deles caso queira usar.<br>

**LISTA DE ITENS:**<br>
- bebidas<br>
- ingredientes<br>
- lanche<br>
- agua<br>
- cola<br>
- hotdog<br>
- hamburguer<br>
- pizza <br>
- coxadefrango<br>


> [!WARNING]
Lembrando que o nome de spawn do item tem que ser igual o que está a cima.

Você vai __criar__ uma pasta chamada ```[burguer-job]``` dentro de sua resources em local de sua escolha, depois vai colocar todos os arquivos dentro dela e startar a pasta em seu .cfg

Dentro do .cfg você coloca
```ensure [burguer-job]```
ou
```start [burguer-job]```

Nisso todos os scripts vão estar startados e funcionando, basta conferir os arquivos de config e ver se está do jeito que quer.

> [!WARNING]
Você deve retirar o veículo burrito da sua concessionária caso você venda ele pois faz parte do emprego e tem uma skin customizada.

Depois coloque isso no groups da sua base:

	["burguer1"] = {
		_config = {
			title = "Dono do Burguershot",
			gtype = "job"
		},
		"dono.burguershot",
		"burguershot.permissao"
	},
	["burguer"] = {
		_config = {
			title = "Funcionário Burguershot",
			gtype = "job"
		},
		"burguershot.permissao",
		"servico.burguershot"
	},
	["burguer1-off"] = {
		_config = {
			title = "Burguershot: Fora de Serviço",
			gtype = "job"
		},
		"burguershotdono.foradeservico"
	},
	["burguer-off"] = {
		_config = {
			title = "Burguershot: Fora de Serviço",
			gtype = "job"
		},
		"burguershot.foradeservico"
	},

E por fim não se esqueça de configurar os itens dentro do seu inventário para serem consumidos pelos players! <br>
- agua <br>
- cola <br>
- hotdog <br>
- hamburguer <br>
- pizza <br>
- coxadefrango <br>
