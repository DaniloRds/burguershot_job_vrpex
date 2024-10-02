local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

vSERVER = Tunnel.getInterface(GetCurrentResourceName())

local cfg = module(GetCurrentResourceName(),"config")

-- NÃO MEXA
local servico = false
local locais = 0
local processo = false
local tempo = 0
local animacao = false
local controle = false

------------------------------------
------- LOCALIZAÇÕES DAS ENTREGAS --
------------------------------------
local unity = {
	[1] = { ['x'] = -14.09, ['y'] = -1442.08, ['z'] = 31.11 },
    [2] = { ['x'] = 152.58, ['y'] = -1823.7, ['z'] = 27.87 }, 
    [3] = { ['x'] = 282.63, ['y'] = -1899.0, ['z'] = 27.27 },
    [4] = { ['x'] = 399.46, ['y'] = -1864.94, ['z'] = 26.72 }, 
    [5] = { ['x'] = 443.45, ['y'] = -1707.33, ['z'] = 29.71 },
    [6] = { ['x'] = 269.6, ['y'] = -1712.98, ['z'] = 29.67 }, 
    [7] = { ['x'] = 216.41, ['y'] = -1717.29, ['z'] = 29.68 }, 
    [8] = { ['x'] = 1295.05, ['y'] = -1739.69, ['z'] = 54.28 }, 
    [9] = { ['x'] = 1220.23, ['y'] = -1658.77, ['z'] = 48.65 }, 

    [10] = { ['x'] = 970.78, ['y'] = -701.16, ['z'] = 58.49 }, 
    [11] = { ['x'] = 1388.93, ['y'] = -569.47, ['z'] = 74.5 }, 
    [12] = { ['x'] = 1328.36, ['y'] = -536.0, ['z'] = 72.45 }, 
    [13] = { ['x'] = 1264.84, ['y'] = -702.83, ['z'] = 64.91 }, 
    [14] = { ['x'] = 965.3, ['y'] = -542.01, ['z'] = 59.73 }, 
    [15] = { ['x'] = 1028.86, ['y'] = -408.42, ['z'] = 66.35 }, 
    [16] = { ['x'] = 880.28, ['y'] = -205.45, ['z'] = 71.98 }, 
    [17] = { ['x'] = -106.84, ['y'] = -8.49, ['z'] = 70.53 }, 
    [18] = { ['x'] = -667.14, ['y'] = 471.54, ['z'] = 114.14 }, 
    [19] = { ['x'] = -1107.62, ['y'] = 594.52, ['z'] = 104.46 }, 

    [20] = { ['x'] = -1174.8, ['y'] = 440.15, ['z'] = 86.85 }, 
    [21] = { ['x'] = -1753.23, ['y'] = -724.21, ['z'] = 10.41 }, 
    [22] = { ['x'] = -1967.67, ['y'] = -531.77, ['z'] = 12.18 }, 
    [23] = { ['x'] = -1093.6, ['y'] = -1608.24, ['z'] = 8.46 }, 
    [24] = { ['x'] = -1995.67, ['y'] = 591.13, ['z'] = 117.91 }, 
    [25] = { ['x'] = -597.12, ['y'] = 851.67, ['z'] = 211.45 }, 
    [26] = { ['x'] = -1100.54, ['y'] = 2722.43, ['z'] = 18.81 }, 
    [27] = { ['x'] = 634.94, ['y'] = 2774.95, ['z'] = 42.02 }, 
    [28] = { ['x'] = 1142.33, ['y'] = 2654.7, ['z'] = 38.16 }, 
    [29] = { ['x'] = 106.23, ['y'] = -1280.82, ['z'] = 29.26 }, 

    [30] = { ['x'] = -833.35, ['y'] = -1071.59, ['z'] = 11.66 },
	[31] = { ['x'] = -1032.0, ['y'] = -1620.13, ['z'] = 5.11 },
	[32] = { ['x'] = -935.5, ['y'] = -1523.43, ['z'] = 5.25 },
	[33] = { ['x'] = -1320.66, ['y'] = -1045.14, ['z'] = 7.46 },
	[34] = { ['x'] = -1312.53, ['y'] = -765.14, ['z'] = 20.19 },
	[35] = { ['x'] = -1495.33, ['y'] = -661.67, ['z'] = 29.03 },
	[36] = { ['x'] = -1463.13, ['y'] = -662.02, ['z'] = 29.59 },
	[37] = { ['x'] = -1569.47, ['y'] = -294.88, ['z'] = 48.28 },
	[38] = { ['x'] = -1542.75, ['y'] = -278.6, ['z'] = 48.29 },
	[39] = { ['x'] = -1405.64, ['y'] = 526.82, ['z'] = 123.84 },
	
	[40] = { ['x'] = -1165.72, ['y'] = 726.84, ['z'] = 155.61 },
	[41] = { ['x'] = -908.86, ['y'] = 693.95, ['z'] = 151.44 },
	[42] = { ['x'] = -536.83, ['y'] = 477.43, ['z'] = 103.2 },
	[43] = { ['x'] = 321.09, ['y'] = 180.54, ['z'] = 103.59 },
	[44] = { ['x'] = 1323.31, ['y'] = -1650.96, ['z'] = 52.28 },
	[45] = { ['x'] = 1327.63, ['y'] = -1553.05, ['z'] = 54.06 },
	[46] = { ['x'] = 1276.5, ['y'] = -1629.06, ['z'] = 54.54 },
	[47] = { ['x'] = 899.23, ['y'] = -1722.17, ['z'] = 32.16 },
	[48] = { ['x'] = 467.08, ['y'] = -1590.37, ['z'] = 32.83 },
	[49] = { ['x'] = 464.28, ['y'] = -794.53, ['z'] = 27.36 },
	[50] = { ['x'] = -421.84, ['y'] = -2171.45, ['z'] = 11.34 }

}

----------
-- MAIN --
----------

-- PEGAR TRABALHO
Citizen.CreateThread(function()
	while true do
		local danilo = 1000
		local x,y,z = table.unpack(cfg.cdsServico)
		local x2,y2,z2 = table.unpack(cfg.cdsServico)
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
		if servico == false then
			if distance < 2.1 then
				danilo = 3
				DrawText3Ds(x2,y2,z2 + 1.0,"~w~PRESSIONE ~g~E ~w~PARA PEGAR O SERVIÇO")
				DrawMarker(27,x,y,z-1.0,0,0,0,0,0,0,0.5,0.5,0.5,50,205,50,100,0,300,0,1)
				if not servico then
					if distance < 1.2 then
						if IsControlJustPressed(0, 38) then
							TriggerEvent("Notify","sucesso","Você entrou em serviço")
							colocarUniforme("entregador",1000)
							Wait(1000)
							TriggerEvent("Notify","importante","Agora colete os lanches para fazer as entregas, após coletar pegue sua moto de trabalho!",8000)
							servico = true
							controle = false
							locais = math.random(1,50)
							CriandoBlip(unity,locais)
						end
					end
				end
			end
		end
	Citizen.Wait(danilo)
	end
end)

-- COLETAR LANCHE
Citizen.CreateThread(function()
	while true do
		local danilo = 1000
		if servico then 
			local x,y,z = table.unpack(cfg.cdsLanche)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if distance <= 5 then 
				danilo = 5
                DrawText3Ds(x,y,z + 1.0,"~w~PRESSIONE ~g~E ~w~PARA COLETAR OS LANCHES")
			    DrawMarker(27,x,y,z-1.0,0,0,0,0,0,0,0.5,0.5,0.5,50,205,50,100,0,300,0,1)
		        if IsControlJustPressed(0, 38) then
		            TriggerEvent("progress",8000,"Coletando Lanches")
					vRP._playAnim(false,{{"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator"}},true)
					servico = false
					animacao = true
					Desabilitar()
					SetTimeout(8000,function()
						vRP._stopAnim(source,false)
						vSERVER.giveLanche()	
						servico = true
						animacao = false
				    end) 
                end
		    end                   
		end
	Citizen.Wait(danilo)
	end
end)

-- PEGAR MOTO
Citizen.CreateThread(function()
	while true do
		local danilo = 1000
	    if servico then 
		    local x,y,z = table.unpack(cfg.cdsPegarMoto)
			local ped = PlayerPedId()
		    local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
		    if distance <= 2.0 then
		        danilo = 5
              DrawText3Ds(x,y,z + 0.7,"~w~PRESSIONE ~g~E ~w~PARA SOLICITAR A MOTO")
			  DrawMarker(37,x,y,z-0.2,0,0,0,0,0,0,1.0,1.0,1.0,50,205,50,100,0,300,0,1)
                if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then	
					TriggerEvent("Notify","importante","Agora você já pode fazer as entregas, caso queira sair de serviço basta pressionar <b>F7.</b> (sua moto irá sumir)",15000)
                	Fade(1200)
					spawnMoto(-1169.57, -896.21, 13.36, 27.96, cfg.Moto, false)
		            parte = 1
				end
		    end
		end
	Citizen.Wait(danilo)
	end
end)		

-- INICIAR ENTREGAS
Citizen.CreateThread(function()
	while true do
		local danilo = 1000
		if servico then
			local car = GetHashKey(cfg.Moto)
			local ped = PlayerPedId()
			local vehicle = GetPlayersLastVehicle(ped, car)
			local veh = IsVehicleModel(vehicle, car)
			local usando = GetVehiclePedIsUsing(ped)
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(unity[locais].x,unity[locais].y,unity[locais].z)
			local distance = GetDistanceBetweenCoords(unity[locais].x,unity[locais].y,cdz,x,y,z,true)
			if distance <= 50 then
				danilo = 5
				DrawMarker(1,unity[locais].x,unity[locais].y,unity[locais].z-1.0,0,0,0,0,0,0,1.0,1.0,1.0,50,205,50,100,0,300,0,1)
			end
			if distance < 10 then
				danilo = 1
				if distance < 1.5 then

					danilo = 5
					DrawText3Ds(unity[locais].x,unity[locais].y,unity[locais].z + 0.4,"~w~PRESSIONE ~g~E ~w~PARA ENTREGAR O LANCHE")
					if IsControlJustPressed(0, 38) and not IsPedInAnyVehicle(ped) then
						if IsVehicleModel(vehicle,GetHashKey(cfg.Moto)) then
							TriggerEvent("progress",2000,"Entregando...")
							RemoveBlip(blips)
							animacao = true
							if animacao then
								vRP._playAnim(false,{{"mp_common","givetake1_a"}},true)
								Desabilitar()
								Citizen.Wait(2000)
								vRP.stopAnim(false)
								vSERVER.checkPayment()
								animacao = false
								if locais == #unity then
									locais = 1
								else
									locais = math.random(1,50)
								end
								CriandoBlip(unity,locais)
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
							TriggerServerEvent("entregador_retirar-uniforme")
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

-------------
-- EVENTOS --
-------------
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

-------------
-- FUNÇÕES --
-------------

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

-- SPAWN DA MOTO 
function spawnMoto(x,y,z,h,veiculo,extra)
	local checkPos = vRP.getNearestVehicles(10.0)
	local ped = PlayerPedId()
	if CountTable(checkPos) > 0 then
		TriggerEvent("Notify","importante","Todas as vagas estão ocupadas no momento.", 5)
		return false
	else
		if controle == false then -- Verifica se o player já puxou um veículo.
			if veiculo then
				local mhash = GetHashKey(veiculo)
				while not HasModelLoaded(mhash) do
					RequestModel(mhash)
					Citizen.Wait(10)
				end

				if HasModelLoaded(mhash) then
					Fade(1300)

					local nveh = CreateVehicle(mhash,x,y,z,h,true,false)
					DecorSetInt(nveh,'rCollisionTime',GetNetworkTime()+6*1000)
					SetVehicleOnGroundProperly(nveh)
					SetVehicleNumberPlateText(nveh,vRP.getRegistrationNumber())
					SetEntityAsMissionEntity(nveh,true,true)
					SetModelAsNoLongerNeeded(mhash)

					Citizen.Wait(1300)

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
										--print("teste4")
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
		else
			TriggerEvent("Notify","negado","Você já pegou um veículo da empresa.")
		end
	end
end

-- FAZ A ANIMAÇÃO DE FADE
function Fade(time)
	DoScreenFadeOut(800)
	Wait(time)
	DoScreenFadeIn(800)
end

-- Colocar uniforme
function colocarUniforme(modelo,time)
	DoScreenFadeOut(600)
	Wait(time)
	TriggerServerEvent("entregador_uniforme", modelo)
	DoScreenFadeIn(600)
end


-- DESABILITA ALGUMAS FUNÇÕES
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

-- TEXTO E BLIPS
function drawTxt(text, font, x, y, scale, r, g, b, a)
	SetTextFont(font)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry('STRING')
	AddTextComponentString(text)
	DrawText(x, y)
end

function CriandoBlip(unity,locais)
	blips = AddBlipForCoord(unity[locais].x,unity[locais].y,unity[locais].z)
	SetBlipSprite(blips,38)
	SetBlipColour(blips,2)
	SetBlipScale(blips,0.8)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	SetBlipRouteColour(blips,2)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entregar Lanche")
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



