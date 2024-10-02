local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

-- Tunnel
vCLIENT = {}
Tunnel.bindInterface(GetCurrentResourceName(),vCLIENT)

local cfg = module(GetCurrentResourceName(),"config")

-- COLOCAR UNIFORME
RegisterServerEvent("entregador_uniforme")
AddEventHandler("entregador_uniforme",function(modelo)
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

RegisterServerEvent("entregador_retirar-uniforme")
AddEventHandler("entregador_retirar-uniforme",function()
    local user_id = vRP.getUserId(source)
    vRP.removeCloak(source)
end)

-- PEGAR LANCHES
local quantidade = {}
function vCLIENT.QuantidadeLanches()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = math.random(cfg.QuantiaDeLanches)
	end
end

function vCLIENT.giveLanche()
	vCLIENT.QuantidadeLanches()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("lanche")*quantidade[source] <= vRP.getInventoryMaxWeight(user_id) then
			vRP.giveInventoryItem(user_id,"lanche",quantidade[source])
			quantidade[source] = nil
			return true
		else
			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.") 
			return false
		end
	end
end

-- PAGAMENTO E CHECK 
local quantidade = {}
function vCLIENT.Quantidade()
	local source = source
	if quantidade[source] == nil then
	   quantidade[source] = math.random(cfg.QuantiaDeLanches)	
	end
	   TriggerClientEvent("quantidade-lanche",source,parseInt(quantidade[source]))
end

local lanche = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(lanche) do
            if v > 0 then
                lanche[k] = v - 1
            end
        end
    end
end)

function vCLIENT.checkPayment()
	vCLIENT.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if lanche[user_id] == 0 or not lanche[user_id] then
			if vRP.tryGetInventoryItem(user_id,"lanche",quantidade[source]) then
				randmoney = (cfg.ValorPagamento*quantidade[source])
		        vRP.giveMoney(user_id,parseInt(randmoney))
		        TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
		        TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b>.")
				quantidade[source] = nil
				vCLIENT.Quantidade()
				lanche[user_id] = 15
				return true
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa de <b>"..quantidade[source].."x lanches para fazer essa entrega</b>.")
			end
		end
	end
	return false
end
