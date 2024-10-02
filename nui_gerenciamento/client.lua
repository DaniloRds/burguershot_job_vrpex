local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface("nui_gerenciamento",src)
vSERVER = Tunnel.getInterface("nui_gerenciamento")

local cfg = module("nui_gerenciamento","config")
--
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

--[ BUTTON ]-----------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "comprar-hamburguer" then
		TriggerServerEvent("fastfood-comprar","hamburguer")
	
	elseif data == "fechar" then
		ToggleActionMenu()
	
	end
end)

--[ LOCAIS ]-----------------------------------------------------------------------------------------------------------------------------

local pc = { 
	table.unpack(cfg.cds)
}

--[ MENU ]-------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local idle = 1000
		for k,v in pairs(pc) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			local pc = pc[k]

			
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), pc.x, pc.y, pc.z, true ) <= 1.1 and not menuactive then
				DrawText3D(pc.x, pc.y, pc.z, "Pressione [~g~E~w~] para acessar o ~g~Gerênciamento~w~.")
			end

			if distance <= 1.1 then
				DrawMarker(23, pc.x, pc.y, pc.z-0.97, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 54, 142, 73, 180, 0, 0, 0, 0)
				idle = 3
				if distance <= 1.2 then
					if IsControlJustPressed(0,38) and vSERVER.checkPerm() then
						ToggleActionMenu()
						SendNUIMessage({ action = "showMenu", 
						ingredientes = vSERVER.checkIngredientes(),
						hamburguer = vSERVER.checkHam(),
						pizza = vSERVER.checkPizza(),
						frango = vSERVER.checkFrango(),
						hotdog = vSERVER.checkHotdog(),
						bebidas = vSERVER.checkBebidas(),
						dinheiro = vSERVER.checkDinheiro()
						})
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ Call Back NUI ]-----------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("close",function(data)
	SetNuiFocus(false)
	TransitionFromBlurred(1000)
	SendNUIMessage({ hidemenu = true })
end)

RegisterNUICallback("sacar",function(data)
	vSERVER.sacar()
end)

RegisterNUICallback("depositar",function(data)
	vSERVER.depositar()
end)

RegisterNUICallback("contratar",function(data)
	vSERVER.contratar()
end)

RegisterNUICallback("demitir",function(data)
	vSERVER.demitir()
end)

RegisterNUICallback("funcionarios",function(data)
	vSERVER.funcionarios()
end)

--[ FUNÇÃO ]-----------------------------------------------------------------------------------------------------------------------------

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end