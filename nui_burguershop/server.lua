local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
local cfg = module("nui_burguershop","config")

src = {}
Tunnel.bindInterface("nui_burguershop",src)
vCLIENT = Tunnel.getInterface("nui_burguershop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARRAY
-----------------------------------------------------------------------------------------------------------------------------------------
local valores = {
	{ item = "hotdog", quantidade = 1, compra = 700 }, 
	{ item = "hamburguer", quantidade = 1, compra = 750 },
    { item = "pizza", quantidade = 1, compra = 850 },
	{ item = "coxadefrango", quantidade = 1, compra = 750 },
	-- Bebidas
	{ item = "agua", quantidade = 1, compra = 300 },
	{ item = "cola", quantidade = 1, compra = 400 }
}
--[BANCO DE DADOS]--
vRP._prepare("vRP/add_m", "UPDATE vrp_burguershot SET dinheiro = dinheiro + @pagamento") 
--
vRP.prepare("vRP/hamburguer","SELECT hamburguer FROM vrp_burguershot")
vRP.prepare("vRP/hotdog","SELECT hotdog FROM vrp_burguershot")
vRP.prepare("vRP/pizza","SELECT pizza FROM vrp_burguershot")
vRP.prepare("vRP/frango","SELECT frango FROM vrp_burguershot")
--
vRP._prepare("vRP/rem_h", "UPDATE vrp_burguershot SET hamburguer = hamburguer - 1") 
vRP._prepare("vRP/rem_ht", "UPDATE vrp_burguershot SET hotdog = hotdog - 1") 
vRP._prepare("vRP/rem_p", "UPDATE vrp_burguershot SET pizza = pizza - 1") 
vRP._prepare("vRP/rem_f", "UPDATE vrp_burguershot SET frango = frango - 1") 
--
vRP.prepare("vRP/bebidas","SELECT bebidas FROM vrp_burguershot")
vRP._prepare("vRP/rem_b", "UPDATE vrp_burguershot SET bebidas = bebidas - 1") 
--------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
--------------------------------------------------------------------------------------------------------------------------------------
function src.checkHam()
	local t = vRP.query("vRP/hamburguer",{ hamburguer = hamburguer })
	return t[1].hamburguer
end

function src.checkPizza()
	local t = vRP.query("vRP/pizza",{ pizza = pizza })
	return t[1].pizza
end

function src.checkHotdog()
	local t = vRP.query("vRP/hotdog",{ hotdog = hotdog })
	return t[1].hotdog
end

function src.checkFrango()
	local t = vRP.query("vRP/frango",{ frango = frango })
	return t[1].frango
end

function src.checkBebidas()
	local t = vRP.query("vRP/bebidas",{ bebidas = bebidas })
	return t[1].bebidas
end
--------------------------------------------------------------------------------------------------------------------------------------
-- COMPRAR
--------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("fastfood-comprar-hamburguer")
AddEventHandler("fastfood-comprar-hamburguer",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	local h = vRP.query("vRP/hamburguer",{ hamburguer = hamburguer })
	if user_id then
		for k,v in pairs(valores) do
			if h[1].hamburguer >= 1 then
				if item == v.item then
					if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
							local preco = parseInt(v.compra)
							if preco then
								-- CONFIGURE AQUI OS DESCONTOS PARA OS VIPS DA SUA CIDADE (MUDE APENAS AS PERMISSÕES)
								if vRP.hasPermission(user_id,cfg.burguerShot) then
									desconto = math.floor(preco*50/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.vinte) then
									desconto = math.floor(preco*20/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.quinze) then
									desconto = math.floor(preco*15/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.dez) then
									desconto = math.floor(preco*10/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.cinco) then
									desconto = math.floor(preco*5/100)
									pagamento = math.floor(preco-desconto)
								else
									pagamento = math.floor(preco)
								end
								-- AQUI QUE VOCÊ ALTERA CASO SUA BASE FOR ZIRIX 
								if vRP.tryPayment(user_id,parseInt(pagamento)) then
									TriggerClientEvent("Notify",source,"sucesso","Comprou 1x <b>" ..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(pagamento)).." dólares</b>.")
									vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
									vRP.execute("vRP/rem_h")
									vRP.execute("vRP/add_m",{ pagamento = pagamento - cfg.taxa})
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
								end
							end
					else
						TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
					end
				end
			else
				TriggerClientEvent("Notify",source,"negado","Estoque insuficiente.")
			end
		end
	end
end)
--
RegisterServerEvent("fastfood-comprar-hotdog")
AddEventHandler("fastfood-comprar-hotdog",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	local h = vRP.query("vRP/hotdog",{ hotdog = hotdog })
	if user_id then
		for k,v in pairs(valores) do
			if h[1].hotdog >= 1 then
				if item == v.item then
					if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
							local preco = parseInt(v.compra)
							if preco then
								-- CONFIGURE AQUI OS DESCONTOS PARA OS VIPS DA SUA CIDADE (MUDE APENAS AS PERMISSÕES)
								if vRP.hasPermission(user_id,cfg.burguerShot) then
									desconto = math.floor(preco*50/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.vinte) then
									desconto = math.floor(preco*20/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.quinze) then
									desconto = math.floor(preco*15/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.dez) then
									desconto = math.floor(preco*10/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.cinco) then
									desconto = math.floor(preco*5/100)
									pagamento = math.floor(preco-desconto)
								else
									pagamento = math.floor(preco)
								end
								-- AQUI QUE VOCÊ ALTERA CASO SUA BASE FOR ZIRIX (LEIA O ARQUIVO LEIA :D)
								if vRP.tryPayment(user_id,parseInt(pagamento)) then
									TriggerClientEvent("Notify",source,"sucesso","Comprou 1x <b>" ..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(pagamento)).." dólares</b>.")
									vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
									vRP.execute("vRP/rem_ht")
									vRP.execute("vRP/add_m",{ pagamento = pagamento })
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
								end
							end
					else
						TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
					end
				end
			else
				TriggerClientEvent("Notify",source,"negado","Estoque insuficiente.")
			end
		end
	end
end)
--
RegisterServerEvent("fastfood-comprar-pizza")
AddEventHandler("fastfood-comprar-pizza",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	local h = vRP.query("vRP/pizza",{ pizza = pizza })
	if user_id then
		for k,v in pairs(valores) do
			if h[1].pizza >= 1 then
				if item == v.item then
					if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
							local preco = parseInt(v.compra)
							if preco then
								-- CONFIGURE AQUI OS DESCONTOS PARA OS VIPS DA SUA CIDADE (MUDE APENAS AS PERMISSÕES)
								if vRP.hasPermission(user_id,cfg.burguerShot) then
									desconto = math.floor(preco*50/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.vinte) then
									desconto = math.floor(preco*20/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.quinze) then
									desconto = math.floor(preco*15/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.dez) then
									desconto = math.floor(preco*10/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.cinco) then
									desconto = math.floor(preco*5/100)
									pagamento = math.floor(preco-desconto)
								else
									pagamento = math.floor(preco)
								end
								-- AQUI QUE VOCÊ ALTERA CASO SUA BASE FOR ZIRIX (LEIA O ARQUIVO LEIA :D)
								if vRP.tryPayment(user_id,parseInt(pagamento)) then
									TriggerClientEvent("Notify",source,"sucesso","Comprou 1x <b>" ..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(pagamento)).." dólares</b>.")
									vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
									vRP.execute("vRP/rem_p")
									vRP.execute("vRP/add_m",{ pagamento = pagamento })
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
								end
							end
					else
						TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
					end
				end
			else
				TriggerClientEvent("Notify",source,"negado","Estoque insuficiente.")
			end
		end
	end
end)
--
RegisterServerEvent("fastfood-comprar-frango")
AddEventHandler("fastfood-comprar-frango",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	local h = vRP.query("vRP/frango",{ frango = frango })
	if user_id then
		for k,v in pairs(valores) do
			if h[1].frango >= 1 then
				if item == v.item then
					if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
							local preco = parseInt(v.compra)
							if preco then
								-- CONFIGURE AQUI OS DESCONTOS PARA OS VIPS DA SUA CIDADE (MUDE APENAS AS PERMISSÕES)
								if vRP.hasPermission(user_id,cfg.burguerShot) then
									desconto = math.floor(preco*50/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.vinte) then
									desconto = math.floor(preco*20/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.quinze) then
									desconto = math.floor(preco*15/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.dez) then
									desconto = math.floor(preco*10/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.cinco) then
									desconto = math.floor(preco*5/100)
									pagamento = math.floor(preco-desconto)
								else
									pagamento = math.floor(preco)
								end
								-- AQUI QUE VOCÊ ALTERA CASO SUA BASE FOR ZIRIX (LEIA O ARQUIVO LEIA :D)
								if vRP.tryPayment(user_id,parseInt(pagamento)) then
									TriggerClientEvent("Notify",source,"sucesso","Comprou 1x <b>" ..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(pagamento)).." dólares</b>.")
									vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
									vRP.execute("vRP/rem_f")
									vRP.execute("vRP/add_m",{ pagamento = pagamento })
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
								end
							end
					else
						TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
					end
				end
			else
				TriggerClientEvent("Notify",source,"negado","Estoque insuficiente.")
			end
		end
	end
end)
--
RegisterServerEvent("fastfood-comprar-bebidas")
AddEventHandler("fastfood-comprar-bebidas",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	local h = vRP.query("vRP/bebidas",{ bebidas = bebidas })
	if user_id then
		for k,v in pairs(valores) do
			if h[1].bebidas >= 1 then
				if item == v.item then
					if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
							local preco = parseInt(v.compra)
							if preco then
								-- CONFIGURE AQUI OS DESCONTOS PARA OS VIPS DA SUA CIDADE (MUDE APENAS AS PERMISSÕES)
								if vRP.hasPermission(user_id,cfg.burguerShot) then
									desconto = math.floor(preco*50/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.vinte) then
									desconto = math.floor(preco*20/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.quinze) then
									desconto = math.floor(preco*15/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.dez) then
									desconto = math.floor(preco*10/100)
									pagamento = math.floor(preco-desconto)
								elseif vRP.hasPermission(user_id,cfg.cinco) then
									desconto = math.floor(preco*5/100)
									pagamento = math.floor(preco-desconto)
								else
									pagamento = math.floor(preco)
								end
								-- AQUI QUE VOCÊ ALTERA CASO SUA BASE FOR ZIRIX (LEIA O ARQUIVO LEIA :D)
								if vRP.tryPayment(user_id,parseInt(pagamento)) then
									TriggerClientEvent("Notify",source,"sucesso","Comprou 1x <b>" ..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(pagamento)).." dólares</b>.")
									vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
									vRP.execute("vRP/rem_b")
									vRP.execute("vRP/add_m",{ pagamento = pagamento })
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
								end
							end
					else
						TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
					end
				end
			else
				TriggerClientEvent("Notify",source,"negado","Estoque insuficiente.")
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- BURGUER JOB
----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('burguershot', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local burguer = vRP.getUsersByPermission(cfg.burguerShot)
	local shot = 0
	local burguer_nomes = ""
	if vRP.hasPermission(user_id,cfg.donoShot) or vRP.hasPermission(user_id,cfg.admin) then
		for k,v in ipairs(burguer) do
			local identity = vRP.getUserIdentity(parseInt(v))
			burguer_nomes = burguer_nomes .. "<b>" .. v .. "</b>: " .. identity.name .. " " .. identity.firstname .. "<br>"
			shot = shot + 1
		end
		TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..shot.." funcionários</b> estão em serviço.")
	end
end)