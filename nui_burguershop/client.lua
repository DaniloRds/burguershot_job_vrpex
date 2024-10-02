local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface("nui_burguershop",src)
vSERVER = Tunnel.getInterface("nui_burguershop")

local cfg = module("nui_burguershop","config")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		TransitionFromBlurred(1000)
		SendNUIMessage({ hidemenu = true })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "comprar-hamburguer" then
		TriggerServerEvent("fastfood-comprar-hamburguer","hamburguer")

		SendNUIMessage({ action = "atualizar", 
		hamburguer = vSERVER.checkHam(),
		pizza = vSERVER.checkPizza(),
		frango = vSERVER.checkFrango(),
		hotdog = vSERVER.checkHotdog(),
		agua = vSERVER.checkBebidas(),
		cola = vSERVER.checkBebidas(),
		})

	elseif data == "comprar-pizza" then
		TriggerServerEvent("fastfood-comprar-pizza","pizza")

		SendNUIMessage({ action = "atualizar", 
		hamburguer = vSERVER.checkHam(),
		pizza = vSERVER.checkPizza(),
		frango = vSERVER.checkFrango(),
		hotdog = vSERVER.checkHotdog(),
		agua = vSERVER.checkBebidas(),
		cola = vSERVER.checkBebidas(),
		})

	elseif data == "comprar-hotdog" then
		TriggerServerEvent("fastfood-comprar-hotdog","hotdog")

		SendNUIMessage({ action = "atualizar", 
		hamburguer = vSERVER.checkHam(),
		pizza = vSERVER.checkPizza(),
		frango = vSERVER.checkFrango(),
		hotdog = vSERVER.checkHotdog(),
		agua = vSERVER.checkBebidas(),
		cola = vSERVER.checkBebidas(),
		})

	elseif data == "comprar-coxadefrango" then
		TriggerServerEvent("fastfood-comprar-frango","coxadefrango")

		SendNUIMessage({ action = "atualizar", 
		hamburguer = vSERVER.checkHam(),
		pizza = vSERVER.checkPizza(),
		frango = vSERVER.checkFrango(),
		hotdog = vSERVER.checkHotdog(),
		agua = vSERVER.checkBebidas(),
		cola = vSERVER.checkBebidas(),
		})

	elseif data == "comprar-agua" then
		TriggerServerEvent("fastfood-comprar-bebidas","agua")

		SendNUIMessage({ action = "atualizar", 
		hamburguer = vSERVER.checkHam(),
		pizza = vSERVER.checkPizza(),
		frango = vSERVER.checkFrango(),
		hotdog = vSERVER.checkHotdog(),
		agua = vSERVER.checkBebidas(),
		cola = vSERVER.checkBebidas(),
		})

	elseif data == "comprar-cola" then
		TriggerServerEvent("fastfood-comprar-bebidas","cola")

		SendNUIMessage({ action = "atualizar", 
		hamburguer = vSERVER.checkHam(),
		pizza = vSERVER.checkPizza(),
		frango = vSERVER.checkFrango(),
		hotdog = vSERVER.checkHotdog(),
		agua = vSERVER.checkBebidas(),
		cola = vSERVER.checkBebidas(),
		})

	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
local marcacoes = {
	table.unpack(cfg.cds)
}

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local nyoSleep = 500
		for _,mark in pairs(marcacoes) do
			local x,y,z = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if distance <= 1.2 then
				nyoSleep = 5
				DrawText3D(x,y,z-0.1,"~o~[BurguerShot]\n~w~Pressione ~g~[E]~w~ para acessar",0.5,3)
				if IsControlJustPressed(0,38) then
					ToggleActionMenu()
					SendNUIMessage({ action = "atualizar", 
					hamburguer = vSERVER.checkHam(),
					pizza = vSERVER.checkPizza(),
					frango = vSERVER.checkFrango(),
					hotdog = vSERVER.checkHotdog(),
					agua = vSERVER.checkBebidas(),
					cola = vSERVER.checkBebidas(),
					})
				end
			end
		end
		Citizen.Wait(nyoSleep)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
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

function DrawText3D(x,y,z, text, scl, font) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
    if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
    end
end