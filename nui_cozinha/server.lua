-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local inventory = module("vrp","cfg/inventory")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("nui_cozinha",src)
vCLIENT = Tunnel.getInterface("nui_cozinha")

cfg = module("nui_cozinha", "cfg/config")

vRP.prepare("vRP/ingredientes","SELECT ingredientes FROM vrp_burguershot")
vRP._prepare("vRP/rem_ingredientes", "UPDATE vrp_burguershot SET ingredientes = ingredientes - 10") 
--
vRP._prepare("vRP/add_h_estoque", "UPDATE vrp_burguershot SET hamburguer = hamburguer + 1") 
vRP._prepare("vRP/add_ht_estoque", "UPDATE vrp_burguershot SET hotdog = hotdog + 1") 
vRP._prepare("vRP/add_p_estoque", "UPDATE vrp_burguershot SET pizza = pizza + 1") 
vRP._prepare("vRP/add_f_estoque", "UPDATE vrp_burguershot SET frango = frango + 1") 

local webhookburguer = cfg.webhookburguer
function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

function src.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,cfg.permissao)
end

function src.checkIngredientes()
	local t = vRP.query("vRP/ingredientes",{ ingredientes = ingredientes })
	return t[1].ingredientes
end

src.fazerhumburger = function()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local t = vRP.query("vRP/ingredientes",{ ingredientes = ingredientes })
		if t[1].ingredientes >= 10 then
			TriggerClientEvent("Notify",source,"aviso","Voce precisa aguardar 20 segundos para fazer o hamburger",8000)
			TriggerClientEvent("progress",source,20000,"cozinhando")
			vRPclient._playAnim(source,false,{{"amb@prop_human_bbq@male@base","base"}},true)
			SetTimeout(20000,function()
			--vRP.giveInventoryItem(user_id,"hamburguer",1)
			TriggerClientEvent("Notify",source,"sucesso","Voce fez um Hamburguer",8000)
			vRPclient._playAnim(source,false,{{""}},true)
			end)
			vRP.execute("vRP/rem_ingredientes")
			vRP.execute("vRP/add_h_estoque")
		else
			TriggerClientEvent("Notify",source,"negado","Voce nao tem os ingredientes para fazer o humburger",8000)
		end
end

src.fazerpizza = function()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local t = vRP.query("vRP/ingredientes",{ ingredientes = ingredientes })
	if t[1].ingredientes >= 10 then
		TriggerClientEvent("Notify",source,"aviso","Voce precisa aguardar 20 segundos para fazer uma pizza",8000)
		TriggerClientEvent("progress",source,20000,"cozinhando")
		vRPclient._playAnim(source,false,{{"amb@prop_human_bbq@male@base","base"}},true)
		SetTimeout(20000,function()
		--vRP.giveInventoryItem(user_id,"pizza",1)
		TriggerClientEvent("Notify",source,"sucesso","Voce fez uma pizza",8000)
		vRPclient._playAnim(source,false,{{""}},true)
	    end)
		vRP.execute("vRP/rem_ingredientes")
		vRP.execute("vRP/add_p_estoque")
	else
		TriggerClientEvent("Notify",source,"negado","Voce nao tem os ingredientes para fazer a pizza",8000)
	end
end

src.fazerhotdog = function()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local t = vRP.query("vRP/ingredientes",{ ingredientes = ingredientes })
	if t[1].ingredientes >= 10 then
		TriggerClientEvent("Notify",source,"aviso","Voce precisa aguardar 20 segundos para fazer um hotdog",8000)
		TriggerClientEvent("progress",source,20000,"cozinhando")
		vRPclient._playAnim(source,false,{{"amb@prop_human_bbq@male@base","base"}},true)
		SetTimeout(20000,function()
		--vRP.giveInventoryItem(user_id,"hotdog",1)
		TriggerClientEvent("Notify",source,"sucesso","Voce fez um hotdog",8000)
		vRPclient._playAnim(source,false,{{""}},true)
		end)
		vRP.execute("vRP/rem_ingredientes")
		vRP.execute("vRP/add_ht_estoque")
	else
		TriggerClientEvent("Notify",source,"negado","Voce nao tem os ingredientes para fazer o hotdog",8000)
	end
end

src.fazerfrango = function()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local t = vRP.query("vRP/ingredientes",{ ingredientes = ingredientes })
	if t[1].ingredientes >= 10 then
		TriggerClientEvent("Notify",source,"aviso","Voce precisa aguardar 20 segundos para fazer um frango frito",8000)
		TriggerClientEvent("progress",source,20000,"cozinhando")
		vRPclient._playAnim(source,false,{{"amb@prop_human_bbq@male@base","base"}},true)
        SetTimeout(20000,function()
		--vRP.giveInventoryItem(user_id,"coxadefrango",1)
		TriggerClientEvent("Notify",source,"sucesso","Voce fez um frango frito",8000)
		vRPclient._playAnim(source,false,{{""}},true)
		end)
		vRP.execute("vRP/rem_ingredientes")
		vRP.execute("vRP/add_f_estoque")
	else
		TriggerClientEvent("Notify",source,"negado","Voce nao tem os ingredientes para fazer o frango frito",8000)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("FuncionarioBurguerShot")
AddEventHandler("FuncionarioBurguerShot",function()
	local source = source
	local user_id = vRP.getUserId(source)

	if vRP.hasPermission(user_id,"dono.burguershot") then
		vRP.addUserGroup(user_id,"burguer1-off")
		TriggerClientEvent("Notify",source,"sucesso","Você saiu de serviço.",8000)
	elseif vRP.hasPermission(user_id,"burguershotdono.foradeservico") then
		vRP.addUserGroup(user_id,"burguer1")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.",8000)
				
	elseif vRP.hasPermission(user_id,"servico.burguershot") then
		vRP.addUserGroup(user_id,"burguer-off")
		TriggerClientEvent("Notify",source,"sucesso","Você saiu de serviço.",8000)
	elseif vRP.hasPermission(user_id,"burguershot.foradeservico") then
		vRP.addUserGroup(user_id,"burguer")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.",8000)
	end
end)