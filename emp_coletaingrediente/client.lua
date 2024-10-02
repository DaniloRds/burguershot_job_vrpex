local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

-- Tunnel
vSERVER = Tunnel.getInterface(GetCurrentResourceName())
local cfg = module(GetCurrentResourceName(),"config")

-- NÃO MEXER
local servico = false
local locais = 0
local processo = false
local tempo = 0
local animacao = false
local controle = false

------------------------------------
------- LOCALIZAÇÕES DAS COLETAS --
------------------------------------
local unity = {
	[1] = { ['x'] = -2073.01, ['y'] = -327.4, ['z'] = 13.32 },
    [2] = { ['x'] = -1297.11, ['y'] = -319.66, ['z'] = 36.75 }, 
    [3] = { ['x'] = -394.23, ['y'] = 208.48, ['z'] = 83.64 },
    [4] = { ['x'] = -361.5, ['y'] = 275.64, ['z'] = 86.43 }, 
    [5] = { ['x'] = 377.33, ['y'] = 327.44, ['z'] = 103.57 },
    [6] = { ['x'] = 877.1, ['y'] = -133.11, ['z'] = 78.74 }, 
    [7] = { ['x'] = 1157.69, ['y'] = -323.95, ['z'] = 69.21 }, 
    [8] = { ['x'] = 1169.93, ['y'] = -402.46, ['z'] = 71.81 }, 
    [9] = { ['x'] = 739.43, ['y'] = -970.03, ['z'] = 24.65 }, 
    [10] = { ['x'] = 462.73, ['y'] = -708.54, ['z'] = 27.53 }, 

    [11] = { ['x'] = 32.48, ['y'] = -1343.02, ['z'] = 29.5 }, 
    [12] = { ['x'] = 54.82, ['y'] = -799.25, ['z'] = 31.59 }, 
    [13] = { ['x'] = -578.2, ['y'] = -1012.78, ['z'] = 22.33 }, 
    [14] = { ['x'] = -643.24, ['y'] = -1227.75, ['z'] = 11.55 }, 
    [15] = { ['x'] = -1105.92, ['y'] = -1288.17, ['z'] = 5.43 }, 
    [16] = { ['x'] = -1206.66, ['y'] = -1134.53, ['z'] = 7.71 }, 
    [17] = { ['x'] = -1549.15, ['y'] = -435.89, ['z'] = 35.89 }, 
    [18] = { ['x'] = -1552.93, ['y'] = -439.87, ['z'] = 40.52 }, 
    [19] = { ['x'] = 82.07, ['y'] = -219.75, ['z'] = 54.64 }, 
    [20] = { ['x'] = 55.29, ['y'] = -1739.37, ['z'] = 29.6 }, 

    [21] = { ['x'] = -3042.26, ['y'] = 588.09, ['z'] = 7.91 }, 
    [22] = { ['x'] = -2963.17, ['y'] = 390.14, ['z'] = 15.05 }, 
    [23] = { ['x'] = -3245.55, ['y'] = 1009.84, ['z'] = 12.84 }, 
    [24] = { ['x'] = 546.61, ['y'] = 2669.0, ['z'] = 42.16 }, 
    [25] = { ['x'] = 1166.23, ['y'] = 2714.19, ['z'] = 38.16 }, 
    [26] = { ['x'] = 2695.53, ['y'] = 3460.59, ['z'] = 56.23 },
	[27] = { ['x'] = -1213.23, ['y'] = -406.92, ['z'] = 34.15 },
	[28] = { ['x'] = -240.97, ['y'] = -346.05, ['z'] = 30.03 },
	[29] = { ['x'] = 405.89, ['y'] = 96.28, ['z'] = 101.21 },
	[30] = { ['x'] = 100.86, ['y'] = 209.35, ['z'] = 108.0 },

	[31] = { ['x'] = -98.27, ['y'] = 367.46, ['z'] = 113.28 },
	[32] = { ['x'] = 127.77, ['y'] = -1028.58, ['z'] = 29.37 },
	[33] = { ['x'] = 370.15, ['y'] = -1027.85, ['z'] = 29.34 },
	[34] = { ['x'] = 453.69, ['y'] = -702.54, ['z'] = 27.37 },
	[35] = { ['x'] = 1139.64, ['y'] = -464.05, ['z'] = 66.86 },
	[36] = { ['x'] = 1234.53, ['y'] = -354.9, ['z'] = 69.09 }
}

-----------
-- MAIN --
-----------

-- PEGAR TRABALHO
Citizen.CreateThread(function()
	while true do
		local danilo = 1000
		local x,y,z = table.unpack(cfg.cdsServico)
		local x2,y2,z2 = table.unpack(cfg.cdsServico)
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
		if servico == false then
			if distance < 1 then
				danilo = 4
				DrawText3Ds(x2,y2,z2 + 1.0,"~w~PRESSIONE ~b~E ~w~PARA PEGAR O SERVIÇO")
				DrawMarker(27,x,y,z-1.0,0,0,0,0,0,0,0.5,0.5,0.5,0,0,255,100,0,300,0,1)
				if not servico then
					if distance < 1 then
						if IsControlJustPressed(0, 38) and vSERVER.checkPerm() then
							TriggerEvent("Notify","sucesso","Você entrou em serviço")

							colocarUniforme("coleta",1000)
				
							TriggerEvent("Notify","importante","Agora pegue o carro da empresa e vá coletar os ingredientes necessários!",8000)
							Wait(1500)
							TriggerEvent("Notify","aviso","Caso queira sair de serviço basta pressionar <b>F7</b> (seu veículo vai ser deletado)",8000)
							servico = true
							if cfg.rotas == 1 then
								locais = math.random(1,36)
							elseif cfg.rotas == 2 then
								locais = 1
							end
							CriandoBlipe(unity,locais)
							BlipNoMapa()
						end
					end
				end
			end
		end
	Citizen.Wait(danilo)
	end
end)

-- PEGAR VAN
Citizen.CreateThread(function()
	while true do
		local danilo = 1000
	    if servico then 
		    local x,y,z = table.unpack(cfg.cdsVan)
			local ped = PlayerPedId()
		    local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if not IsPedInAnyVehicle(ped) then
				if distance <= 8 then
					danilo = 4
					DrawText3Ds(x,y,z + 0.8,"~w~PRESSIONE ~b~E ~w~PARA SOLICITAR A VAN")
					DrawMarker(36,x,y,z-0.2,0,0,0,0,0,0,1.0,1.0,1.0,0,0,255,100,0,300,0,1)
					if IsControlJustPressed(0,38) then 
						if controle == false then -- Verifica se o player já pegou um veículo. primeira vez
							spawnVan(cfg.van, false)
							controle = true
							parte = 1
								TriggerEvent("Notify","importante","Agora você já pode fazer as coletas, caso queira sair de serviço basta apertar <b>F7</b>.", 8000)
						else
							TriggerEvent("Notify","negado","Você já pegou um veículo da empresa.")
						end
					end
				end
			end
		end
	Citizen.Wait(danilo)
	end
end)		

-- ENTREGAS
Citizen.CreateThread(function()
	while true do
		local danilo = 1000
		if servico then
			local car = GetHashKey(cfg.Van)
			local ped = PlayerPedId()
			local vehicle = GetPlayersLastVehicle(ped, car)
			local veh = IsVehicleModel(vehicle, car)
			local usando = GetVehiclePedIsUsing(ped)
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(unity[locais].x,unity[locais].y,unity[locais].z)
			local distance = GetDistanceBetweenCoords(unity[locais].x,unity[locais].y,cdz,x,y,z,true)
			if distance <= 50 then
				danilo = 5
				DrawMarker(1,unity[locais].x,unity[locais].y,unity[locais].z-1.0,0,0,0,0,0,0,1.0,1.0,1.0,0,0,255,100,0,300,0,1)
			end
			if distance <= 10 then
				danilo = 4
					if distance < 1.5 then
					danilo = 2
					DrawText3Ds(unity[locais].x,unity[locais].y,unity[locais].z + 0.4,"~w~PRESSIONE ~b~E ~w~PARA COLETAR OS INGREDIENTES")
					if IsControlJustPressed(0, 38) and not IsPedInAnyVehicle(ped) then
						if IsVehicleModel(vehicle,GetHashKey(cfg.van)) then
							TriggerEvent("progress",2000,"Coletando...")
							RemoveBlip(blips)
							animacao = true
							if animacao then
								vRP._playAnim(false,{{"mp_common","givetake1_a"}},true)
								Desabilitar()
								Citizen.Wait(2000)
								vRP.stopAnim(false)
								vSERVER.pagamentoColeta()
								animacao = false
								if cfg.rotas == 1 then
									if locais == #unity then
										locais = 1
									else
										locais = math.random(1,36)
									end
								elseif cfg.rotas == 2 then
									if locais == #unity then
										locais = 1
									elseif locais == 36 then
										locais = 1
									else
										locais = locais + 1
									end
								end
								CriandoBlipe(unity,locais)
							end
						else
							TriggerEvent("Notify","negado","Você precisa estar utilizar o veículo da empresa!")
						end
					end	
				end
			end
		end
	Citizen.Wait(danilo)
	end
end)

-- DEPOSITO DE INGREDIENTES
Citizen.CreateThread(function()
	while true do
		local danilo = 1000
		local x,y,z = table.unpack(cfg.cdsDepositoI)
		local x2,y2,z2 = table.unpack(cfg.cdsDepositoI)
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
		if servico then
			if distance < 3.2 then
				danilo = 4
				DrawText3Ds(x2,y2,z2 + 1.0,"~w~PRESSIONE ~g~E ~w~PARA DEPOSITAR INGREDIENTES")
				DrawMarker(30,x,y,z-0.6,0,0,0,0,0,0,0.5,0.5,0.5,0,102,0,100,0,300,0,1)
				if distance < 1.5 then
					if IsControlJustPressed(0, 38) then
						vSERVER.depositoIngredientes()
					end
				end
			end
		end
	Citizen.Wait(danilo)
	end
end)

-- DEPOSITO DE BEBIDAS
Citizen.CreateThread(function()
	while true do
		local danilo = 1000
		local x,y,z = table.unpack(cfg.cdsDepositoB)
		local x2,y2,z2 = table.unpack(cfg.cdsDepositoB)
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
		if servico then
			if distance < 3.2 then
				danilo = 4
				DrawText3Ds(x2,y2,z2 + 1.0,"~w~PRESSIONE ~b~E ~w~PARA GUARDA BEBIDAS")
				DrawMarker(30,x,y,z-0.6,0,0,0,0,0,0,0.5,0.5,0.5,65,105,225,100,0,300,0,1)
				if distance < 1.5 then
					if IsControlJustPressed(0, 38) then
						vSERVER.depositoBebidas()
					end
				end
			end
		end
	Citizen.Wait(danilo)
	end
end)

-- PARANDO DE TRABALHAR
Citizen.CreateThread(function()
	while true do
		local timeWait = 1000
		local deleteVeh = GetPlayersLastVehicle()
		local x,y,z = table.unpack(cfg.sairEmp["cds"])
		local ped = PlayerPedId()
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
		if servico then
			timeWait = 1
				if IsControlJustPressed(0,168) then
					if distance <= cfg.sairEmp["range"] then
						if not IsPedInAnyVehicle(PlayerPedId()) then
							TriggerEvent("Notify","aviso","Você saiu de serviço, seu veículo e uniforme foram devolvidos a empresa.")
							TriggerEvent('cancelando',false)
							RemoveBlip(blips)
							vRP.playSound("Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
							TriggerServerEvent("coleta_retirar-uniforme")
							TriggerEvent("deleteVehicle",VehToNet(deleteVeh))
							deleteVeh = nil
							servico = false
							controle = false
						else
							TriggerEvent("Notify","negado","Você precisa sair do veículo...")
						end
					else
						TriggerEvent("Notify","negado","Você precisa estar mais perto da loja para sair do serviço.")
					end
				end
		end
		Citizen.Wait(timeWait)
	end
end)
--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if processo and segundos > 0 then
			segundos = segundos - 1
			if segundos == 0 then
				processo = false
				vRP._stopAnim(false)
				TriggerEvent('cancelando',false)
			end
		end
	end
end)

--------------
-- EVENTOS --
--------------
RegisterNetEvent("deleteVehicle")
AddEventHandler("deleteVehicle",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				DeleteEntity(v)
				DeleteVehicle(v)
			end
		end
	end
end)

----------------
-- FUNÇÕES ---
----------------

-- REMOVE A COLISÃO DOS VEÍCULOS NO SPAWN (VISUAL SYNC)
local function requestingCollision(x,y,z)
    RequestCollisionAtCoord(x,y,z)
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        RequestCollisionAtCoord(x,y,z)
        Citizen.Wait(10)
    end
end

local function CountTable(tab)
    local i = 0
    for _,_ in pairs(tab) do i = i + 1 end
    return i
end

function getNearestVehiclesHasDecor(radius)
	local r = {}
	local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId()))

	local vehs = {}
	local it,veh = FindFirstVehicle()
	if veh then
		table.insert(vehs,veh)
	end
	local ok
	repeat
		ok,veh = FindNextVehicle(it)
		if ok and veh then
			table.insert(vehs,veh)
		end
	until not ok
	EndFindVehicle(it)
    local networkTime = GetNetworkTime()
	for _,veh in pairs(vehs) do
		local x,y,z = table.unpack(GetEntityCoords(veh))
		local distance = #(vec3(x,y,z) - vec3(px,py,pz))
		if distance <= radius and DecorExistOn(veh,'rCollisionTime') then
            if networkTime > DecorGetInt(veh,'rCollisionTime') then 
                DecorRemove(veh,'rCollisionTime') 
            else
                r[veh] = distance
            end
		end
	end
	return r
end

local vehListDecor = {}
local vehAlphaList = {}
local _thread_alpha = false

local function thread_alpha()
    if _thread_alpha then return end
    _thread_alpha = true
    Citizen.CreateThread(function()
        while CountTable(vehAlphaList) > 0 do
            local networkTime = GetNetworkTime()
            for _veh,data in pairs(vehAlphaList) do
                if DoesEntityExist(_veh) then
                    if data[2] and networkTime > data[2] or not DecorExistOn(_veh,'rCollisionTime') then
                        vehAlphaList[_veh] = nil
                        ResetEntityAlpha(_veh)
                    else
                        if GetEntityAlpha(_veh) ~= 255 then
                            ResetEntityAlpha(_veh)
                        else
                            SetEntityAlpha(_veh, 50, false)
                        end
                    end
                else
                    vehAlphaList[_veh] = nil
                end
            end
            Wait(250)
        end
        _thread_alpha = false
    end)
end

local _thread_collision = false
local function thread_collision()
    if _thread_collision then return end
    _thread_collision = true
    local _vehDecor = vehListDecor
    Citizen.CreateThread(function()
        while CountTable(_vehDecor) > 0 do
            _vehDecor = vehListDecor
            if CountTable(_vehDecor) == 0 then break end
            local idle = 10
            for _veh01,_ in pairs(_vehDecor) do
                if not vehAlphaList[_veh01] then vehAlphaList[_veh01] = {true,DecorGetInt(_veh01,'rCollisionTime')} thread_alpha() end
                local vehs = vRP.getNearestVehicles(10.0)
                for _veh02,_ in pairs(vehs) do
                    SetEntityNoCollisionEntity(_veh01, _veh02, true)
                    SetEntityNoCollisionEntity(_veh02, _veh01, true)
                end
            end
            Citizen.Wait(idle)
        end
        _thread_collision = false
    end)
end

Citizen.CreateThread(function()
    DecorRegister('rCollisionTime',3)
    while true do
        vehListDecor = getNearestVehiclesHasDecor(500.0)
        if CountTable(vehListDecor) > 0 then thread_collision() end
        Citizen.Wait(500)
    end
end)

-- SPAWNAR VAN
function spawnVan(veiculo,extra)
	local checkPos = vRP.getNearestVehicles(8.0)
	local ped = PlayerPedId()
	local x,y,z,h = table.unpack(cfg.cdsSpawnVan)
	
	if CountTable(checkPos) > 0 then
		TriggerEvent("Notify","importante","Todas as vagas estão ocupadas no momento.", 5)
		return false
	else
		if controle == false then -- Verifica se o player já puxou um veículo pela segunda vez.
			if veiculo then
				local mhash = GetHashKey(veiculo)
				while not HasModelLoaded(mhash) do
					RequestModel(mhash)
					Citizen.Wait(10)
				end

				if HasModelLoaded(mhash) then
					local nveh = CreateVehicle(mhash,x,y,z,h,true,false)
					DecorSetInt(nveh,'rCollisionTime',GetNetworkTime()+6*1000)
					SetVehicleOnGroundProperly(nveh)
					SetVehicleNumberPlateText(nveh,vRP.getRegistrationNumber())
					SetEntityAsMissionEntity(nveh,true,true)
					SetModelAsNoLongerNeeded(mhash)

					Fade(1200)
					SetPedIntoVehicle(ped,nveh,-1)

					SetTimeout(500,function()
						Citizen.CreateThread(function()
							local x,y,z = x,y,z
							while #(GetEntityCoords(ped) - vec3(x,y,z)) < 10 and IsPedInAnyVehicle(ped,false) and DecorExistOn(GetVehiclePedIsIn(ped,false),'rCollisionTime') do
								Citizen.Wait(250)
							end

							if NetworkDoesNetworkIdExist(nveh) then
								--print("teste3")
								local ent = NetworkGetEntityFromNetworkId(nveh)

								if ent and DoesEntityExist(ent) then
								
									if DecorExistOn(ent,'rCollisionTime') then
										DecorRemove(ent,'rCollisionTime')
									end
								end
							end
						end)
					end)
					controle = true
					if extra then
						veiculoS2 = nveh
					else
						veiculoS = nveh
					end
				end
			end
		end
	end
end

-- Colocar uniforme
function colocarUniforme(modelo,time)
	DoScreenFadeOut(600)
	Wait(time)
	TriggerServerEvent("coleta_uniforme", modelo)
	DoScreenFadeIn(600)
end


-- Animação de Fade
function Fade(time)
	DoScreenFadeOut(800)
	Wait(time)
	DoScreenFadeIn(800)
end

-- BLIP LOCAL DEPÓSITO
function BlipNoMapa()
	if servico then
		local blip = AddBlipForCoord(table.unpack(cfg.cdsDepositoI))
		SetBlipSprite(blip, 568)
		SetBlipColour(blip, 2)
		SetBlipScale(blip, 0.7)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Depósito de Ingredientes")
		EndTextCommandSetBlipName(blip)
	end
end

-- DESABILITAR INTERAÇÕES
function Desabilitar()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			if animacao then
				BlockWeaponWheelThisFrame()
				DisableControlAction(0,16,true)
				DisableControlAction(0,17,true)
				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true)
				DisableControlAction(0,29,true)
				DisableControlAction(0,56,true)
				DisableControlAction(0,57,true)
				DisableControlAction(0,73,true)
				DisableControlAction(0,166,true)
				DisableControlAction(0,167,true)
				DisableControlAction(0,170,true)				
				DisableControlAction(0,182,true)	
				DisableControlAction(0,187,true)
				DisableControlAction(0,188,true)
				DisableControlAction(0,189,true)
				DisableControlAction(0,190,true)
				DisableControlAction(0,243,true)
				DisableControlAction(0,245,true)
				DisableControlAction(0,257,true)
				DisableControlAction(0,288,true)
				DisableControlAction(0,289,true)
				DisableControlAction(0,344,true)		
			end	
		end
	end)
end

-- BLIPS E TXT 
function CriandoBlipe(unity,locais)
	blips = AddBlipForCoord(unity[locais].x,unity[locais].y,unity[locais].z)
	SetBlipSprite(blips,478)
	SetBlipColour(blips,3)
	SetBlipScale(blips,0.6)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	SetBlipRouteColour(blips,3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Coletar Ingredientes")
	EndTextCommandSetBlipName(blips)
end

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


