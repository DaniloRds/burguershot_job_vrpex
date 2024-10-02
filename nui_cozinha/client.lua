-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("nui_cozinha",src)
vSERVER = Tunnel.getInterface("nui_cozinha")

cfg = module("nui_cozinha", "cfg/config")

local invOpen = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOJA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local kswait = 1000
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local x,y,z = table.unpack(GetEntityCoords(ped))
			for k,v in pairs(localidades) do
				local distance = Vdist(x,y,z,v[1],v[2],v[3])
					if distance <= 2 then
					kswait = 1
					DrawText3Ds(v[1],v[2],v[3] + 1.0,"~w~PRESSIONE ~b~E ~w~PARA PREPARAR OS LANCHES")
					DrawMarker(27,v[1],v[2],v[3]-1.0,0,0,0,0,0,0,0.5,0.5,0.5,0,0,255,100,0,300,0,1)
					if distance <= 1.2 then
						
						if IsControlJustPressed(0,38) then
							SetNuiFocus(true,true)
							SendNUIMessage({ action = "showMenu", ingredientes = vSERVER.checkIngredientes()})
						end
						
			    	end
				end
			end
		end
		Citizen.Wait(kswait)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("shopClose",function(data)
	StopScreenEffect("MenuMGSelectionIn")
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hideMenu" })
	invOpen = false
end)

RegisterNUICallback("clearweapons",function(data)
	RemoveAllPedWeapons(GetPlayerPed(-1), true)
	vSERVER.limparcolete()
	invOpen = false
end)

RegisterNUICallback("coletes",function(data)
	vSERVER.colete()
	invOpen = false
end)

RegisterNUICallback("humburger",function(data)
	vSERVER.fazerhumburger()
end)

RegisterNUICallback("pizza",function(data)
	vSERVER.fazerpizza()
end)

RegisterNUICallback("hotdog",function(data)
	vSERVER.fazerhotdog()
end)

RegisterNUICallback("frango",function(data)
	vSERVER.fazerfrango()
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REMEDIOSLIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("carrosList",function(data,cb)
	local shopitens = vSERVER.carrosList()
	if shopitens then
		cb({ shopitens = shopitens })
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CURATIVOSLIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("itensList",function(data,cb)
	local shopitens = vSERVER.itensList()
	if shopitens then
		cb({ shopitens = shopitens })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOP RENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("shopBuy",function(data)
	if data.index ~= nil then
		if data.type == "cars" then
			vSERVER.buyCar(data.index, data.buy)
		else
			vSERVER.buyItem(data.index)
		end
	end
end)

RegisterNUICallback("shopItem",function(data)
	if data.index ~= nil then
		vSERVER.comprarItem(data.index)
	end
end)

function DrawText3D(x,y,z, text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,50)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DENTRO E FORA DE SERVIÇO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("shot",function(source,args)
	local ped =  PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	for k,v in pairs(geremias) do
		local distance = GetDistanceBetweenCoords(x,y,z,v[1],v[2],v[3],true)
		if distance <= 1.5 then
			TriggerServerEvent("FuncionarioBurguerShot") -- toggleService
		end
	end
end)


function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.50,0.35)
	SetTextColour(255,255,255,500)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/ 370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

