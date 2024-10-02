local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface("nui_gerenciamento",src)
vCLIENT = Tunnel.getInterface("nui_gerenciamento")

local cfg = module("nui_gerenciamento","config")
--[ Database ]----------------------------------------------------------------------------------------------------------------------------

vRP.prepare("vRP/ingredientes","SELECT ingredientes FROM vrp_burguershot")
vRP.prepare("vRP/ham","SELECT hamburguer FROM vrp_burguershot")
vRP.prepare("vRP/pizza","SELECT pizza FROM vrp_burguershot")
vRP.prepare("vRP/frango","SELECT frango FROM vrp_burguershot")
vRP.prepare("vRP/hotdog","SELECT hotdog FROM vrp_burguershot")
vRP.prepare("vRP/bebidas","SELECT bebidas FROM vrp_burguershot")
vRP.prepare("vRP/dinheiro","SELECT dinheiro FROM vrp_burguershot")
vRP._prepare("vRP/bank", "UPDATE vrp_burguershot SET dinheiro = @dinheiro") 

--[ Event ]----------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("fastfood-comprar")
AddEventHandler("fastfood-comprar",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
end)

--[ Functions ]----------------------------------------------------------------------------------------------------------------------------

function src.checkPerm()
    local source = source
    local user_id = vRP.getUserId(source) 
    if vRP.hasPermission(user_id,cfg.dono) or vRP.hasPermission(user_id,cfg.admin) then
        return true
	else
		TriggerClientEvent("Notify",source,"negado","<b>Você não tem acesso.<b>.")
    end
end

function src.checkIngredientes()
	local t = vRP.query("vRP/ingredientes",{ ingredientes = ingredientes })
	return t[1].ingredientes
end

function src.checkHam()
	local t = vRP.query("vRP/ham",{ hamburguer = hamburguer })
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

function src.checkDinheiro()
	local t = vRP.query("vRP/dinheiro",{ dinheiro = dinheiro })
	return t[1].dinheiro
end

--

function src.sacar()
    local src = source
    local user_id = vRP.getUserId(src)
    local curBank = vRP.query("vRP/dinheiro",{ dinheiro = dinheiro })

	local descricao = vRP.prompt(src,"Quantia para Saque:","")
	if user_id then
		if tonumber(descricao) ~= nil and tonumber(descricao) > 0 then
			if tonumber(descricao) <= curBank[1].dinheiro then
				vRP.giveMoney(user_id,tonumber(descricao))
				vRP.execute("vRP/bank",{ dinheiro = (curBank[1].dinheiro - tonumber(descricao)) })
				TriggerClientEvent("Notify",src,"sucesso","Você sacou <b>$".. descricao .."</b>.")
			else
				TriggerClientEvent("Notify",src,"negado","Você não possui <b>$".. descricao .."</b> para <b>sacar</b>.")
			end
			return
		else
			TriggerClientEvent("Notify",src,"negado","Você não colocou o valor.")
		end
	end
end

function src.depositar()
    local src = source
    local user_id = vRP.getUserId(src)
    local curBank = vRP.getBankMoney(user_id)
	local DB = vRP.query("vRP/dinheiro",{ dinheiro = dinheiro })

	local descricao = vRP.prompt(src,"Quantia para Depósito:","")
	if user_id then
		if tonumber(descricao) ~= nil and tonumber(descricao) > 0 then
			if tonumber(descricao) <= curBank then
				vRP.setBankMoney(user_id,parseInt(curBank-tonumber(descricao)))
				vRP.execute("vRP/bank",{ dinheiro = (DB[1].dinheiro + tonumber(descricao)) })
				TriggerClientEvent("Notify",src,"sucesso","Você depositou <b> $".. descricao .."</b>.")
			else
				TriggerClientEvent("Notify",src,"negado","Você não possui <b>$".. descricao .."</b> no <b> banco </b> para depositar.")
			end
			return
		else
			TriggerClientEvent("Notify",src,"negado","Você não colocou o valor.")
		end
	end
end

function src.contratar()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local descricao = vRP.prompt(source,"Digite o PASSAPORTE DO CONTRATADO:","")
	local nplayer = vRP.getUserSource(tonumber(descricao))
	local nuser_id = vRP.getUserId(nplayer)
	if tonumber(descricao) ~= nil and tonumber(descricao) >= 0 then
		local identity2 = vRP.getUserIdentity(nuser_id)
		if vRP.request(source,"Você quer contratar " ..identity2.name.." "..identity2.firstname.."  ?",30) then
			-- SendWebhookMessage(webhookburguer,"```css\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[CONTRATOU O ID]:"..tonumber(descricao).." \n[GRUPO]: BurguerShot \nData e Hora : "..os.date("%d/%m/%Y %H:%M:%S").." \r```")
			vRP.addUserGroup(nuser_id,"burguer")
			TriggerClientEvent("Notify",source,"sucesso","Você assinou a carteira do RG de Número: "..tonumber(descricao).."",8000)
			TriggerClientEvent("Notify",nplayer,"aviso","Sua carteira de trabalho foi assinada por "..identity.name.." "..identity.firstname.."",8000)
		end
	else
		TriggerClientEvent("Notify",source,"negado","Você <b>não</b> digitou o <b>ID</b> corretamente.")
	end
end

function src.demitir()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local descricao = vRP.prompt(source,"Digite o PASSAPORTE DO FUNCIONÁRIO:","")
	local nplayer = vRP.getUserSource(tonumber(descricao))
	local nuser_id = vRP.getUserId(nplayer)
	if tonumber(descricao) ~= nil and tonumber(descricao) >= 0 then
		local identity2 = vRP.getUserIdentity(nuser_id)
		if vRP.request(source,"Você quer demitir " ..identity2.name.." "..identity2.firstname.."  ?",30) then
			-- SendWebhookMessage(webhookburguer,"```css\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[CONTRATOU O ID]:"..tonumber(descricao).." \n[GRUPO]: BurguerShot \nData e Hora : "..os.date("%d/%m/%Y %H:%M:%S").." \r```")
			vRP.removeUserGroup(nuser_id,"burguer")
			TriggerClientEvent("Notify",source,"sucesso","Você demitiu o empregado do RG de Número: "..tonumber(descricao).."",8000)
			TriggerClientEvent("Notify",nplayer,"aviso","Você foi demitido do burguershot por "..identity.name.." "..identity.firstname.."",8000)
		end
	else
		TriggerClientEvent("Notify",source,"negado","Você <b>não</b> digitou o <b>ID</b> corretamente.")
	end
end

function src.funcionarios()
    local source = source
    local user_id = vRP.getUserId(source)
	local title = "LISTA DE FUNCIONÁRIOS"
    local funcionarios = vRP.getUsersByPermission("burguer.permissao")
		for i = 1, #funcionarios do
			local identity = vRP.getUserIdentity(funcionarios[i])
			users_string_table = "[" .. funcionarios[i] .. "] " .. identity.name .. " " .. identity.firstname .. "\n"
		end
    vRP.prompt(source, title, users_string_table)
end
