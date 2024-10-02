local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

-- TUNNEL
vCLIENT = {}
Tunnel.bindInterface(GetCurrentResourceName(),vCLIENT)
----------------------------------------------------------------------------------
-- VARIÁVEIS
----------------------------------------------------------------------------------
local cfg = module(GetCurrentResourceName(),"config")
----------------------------------------------------------------------------------
-- BANCO DE DADOS
----------------------------------------------------------------------------------
vRP.prepare("vRP/ingredientes","SELECT bebidas FROM vrp_burguershot")
vRP.prepare("vRP/ingredientes","SELECT ingredientes FROM vrp_burguershot")
vRP.prepare("vRP/add_ingredientes","UPDATE vrp_burguershot SET ingredientes = @ingredientes")
vRP.prepare("vRP/add_bebidas","UPDATE vrp_burguershot SET bebidas = @bebidas")

-- [Colocar uniforme] --
RegisterServerEvent("coleta_uniforme")
AddEventHandler("coleta_uniforme",function(modelo)
	local source = source
    local user_id = vRP.getUserId(source)
	local roupas = cfg.roupas
    local custom = roupas[modelo]
    if custom then
        local old_custom = vRPclient.getCustomization(source)
        local idle_copy = {}

        idle_copy = vRP.save_idle_custom(source,old_custom)
        idle_copy.modelhash = nil

        for k,v in pairs(custom[old_custom.modelhash]) do
            idle_copy[k] = v
        end
        vRPclient._setCustomization(source,idle_copy)
    end
end)

RegisterServerEvent("coleta_retirar-uniforme")
AddEventHandler("coleta_retirar-uniforme",function()
    local user_id = vRP.getUserId(source)
    vRP.removeCloak(source)
end)
-----------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÃO
-----------------------------------------------------------------------------------------------------------------------------------
function vCLIENT.checkPerm()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,cfg.PermissaoBurguer) or vRP.hasPermission(user_id,cfg.PermissaoAdmin)  then
        return true
	else
		TriggerClientEvent("Notify",source,"negado","Para iniciar este serviço você precisa ter carteira assinada no <b>BurguerShot<b>.")
    end
end
--------------------------------------------------------------------------------------------------------------------------------------
-- PAGAMENTO
--------------------------------------------------------------------------------------------------------------------------------------
function vCLIENT.pagamentoColeta()
	local source = source
	local user_id = vRP.getUserId(source)
	local quantidadeI = math.random(table.unpack(cfg.quantidadeI))
	local quantidadeB = math.random(table.unpack(cfg.quantidadeB))
	local probabilidade = math.random(1,100)
	if user_id then
		if vRP.getInventoryWeight(user_id) + vRP.getItemWeight("ingredientes") *1 <= vRP.getInventoryMaxWeight(user_id) then
			vRP.giveInventoryItem(user_id,"ingredientes",quantidadeI)
			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidadeI.."</b> ingredientes.")
			if probabilidade >= cfg.probabilidade then
				vRP.giveInventoryItem(user_id,"bebidas",quantidadeB)
				TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidadeB.."</b> bebidas.")
			end
			Wait(1000)
			if cfg.option == 1 then
				money = math.random(table.unpack(cfg.pagamentoColeta))
				vRP.giveMoney(user_id,parseInt(money))
				TriggerClientEvent("Notify",source,"sucesso","BurguerShot agradece, foi depositado <b>$"..money.." na sua conta</b>.")
				TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
			end
		else
			TriggerClientEvent("Notify",source,"negado","Você não tem espaço na mochila.")
			vRP.playSound(source,"Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSITO
--------------------------------------------------------------------------------------------------------------------------------------
function vCLIENT.depositoIngredientes()
	local source = source
	local user_id = vRP.getUserId(source)
	local ingredientes = vRP.query("vRP/ingredientes",{ ingredientes = ingredientes })
	local descricao = vRP.prompt(source,"Quantia de ingredientes para depositar:","")
	if user_id then
		if tonumber(descricao) ~= nil and tonumber(descricao) > 0 then
			if vRP.getInventoryItemAmount(user_id,"ingredientes") >= tonumber(descricao) then
				vRP.tryGetInventoryItem(user_id,"ingredientes",tonumber(descricao))
				TriggerClientEvent("Notify",source,"sucesso","Você depositou <b>"..tonumber(descricao).."</b> ingredientes no depósito.")
				vRP.execute("vRP/add_ingredientes",{ ingredientes = (ingredientes[1].ingredientes + tonumber(descricao)) })
				vRPclient._playAnim(source,false,{{"mp_common","givetake1_a"}},true)
				SetTimeout(1500,function()
					vRPclient._stopAnim(source,false)
				end)
				-- [Pagamento no Depósito dos Ingredientes] --
				if cfg.option == 2 then
					randmoney = math.random(table.unpack(cfg.pagamentoDeposito))
					vRP.giveMoney(user_id,parseInt(randmoney)*tonumber(descricao))
					TriggerClientEvent("Notify",source,"sucesso","BurguerShot agradece, foi depositado <b>$"..parseInt(randmoney)*tonumber(descricao).." na sua conta</b>.")
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
				end
			else
				TriggerClientEvent("Notify",source,"negado","Você não tem essa quantia de ingredientes na mochila.")
			end
		else
			TriggerClientEvent("Notify",source,"negado","Você não colocou um valor válido.")
		end
	end
end
--
function vCLIENT.depositoBebidas()
	local source = source
	local user_id = vRP.getUserId(source)
	local bebidas = vRP.query("vRP/bebidas",{ bebidas = bebidas })
	local descricao = vRP.prompt(source,"Quantia de bebidas para guardar:","")
	if user_id then
		if tonumber(descricao) ~= nil and tonumber(descricao) > 0 then
			if vRP.getInventoryItemAmount(user_id,"bebidas") >= tonumber(descricao) then
				vRP.tryGetInventoryItem(user_id,"bebidas",tonumber(descricao))
				TriggerClientEvent("Notify",source,"sucesso","Você guardou <b>"..tonumber(descricao).."</b> bebidas no freezer.")
				vRP.execute("vRP/add_bebidas",{ bebidas = (bebidas[1].bebidas + tonumber(descricao)) })
				vRPclient._playAnim(source,false,{{"mp_common","givetake1_a"}},true)
				SetTimeout(1500,function()
					vRPclient._stopAnim(source,false)
				end)
				-- [Pagamento no Depósito das Bebidas] --
				if cfg.option == 2 then
					randmoney = math.random(table.unpack(cfg.pagamentoDeposito))
					vRP.giveMoney(user_id,parseInt(randmoney)*tonumber(descricao)/2)
					TriggerClientEvent("Notify",source,"sucesso","BurguerShot agradece, foi depositado $<b>"..parseInt(parseInt(randmoney)*tonumber(descricao)/2).." na sua conta</b>.")
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
				end
			else
				TriggerClientEvent("Notify",source,"negado","Você não tem essa quantia de bebidas na mochila.")
			end
		else
			TriggerClientEvent("Notify",source,"negado","Você não colocou um valor válido.")
		end
	end
end

