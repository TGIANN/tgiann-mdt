local PlayerData = {}
local tab, PoliceCadIsShowed = nil, false

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    PlayerData = ESX.GetPlayerData()
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if PoliceCadIsShowed then
			CloseCadSystem()
		end
	end
end)
    
RegisterNUICallback('search-plate', function(data)
	ESX.TriggerServerCallback('esx_police_cad:search-plate', function(data, data2)
		if data then
			SendNUIMessage({
				plate = data2.plate,
				model = data2.model,
				firstname = data.firstname,
				lastname = data.lastname
			})
		else
			SendNUIMessage({
				plate = 'The searched plate was not found',
				model = '',
				firstname = '',
				lastname = ''
			}) 
		end
	end, data.plate)
end)

RegisterNUICallback('add-cr', function(data)
  	TriggerServerEvent('esx_police_cad:add-cr', data)
end)

RegisterNUICallback('add-note', function(data)
  	TriggerServerEvent('esx_police_cad:add-note', data)
end)

RegisterNUICallback('add-bolo', function(data)
	ESX.TriggerServerCallback('esx_police_cad:add-bolo', function(data)
		SendNUIMessage({showBolos = data})
	end, data)
end)

RegisterNUICallback('get-cr', function(data)
	TriggerServerEvent("esx_police_cad:get-cr", data.identifier)
end)

RegisterNetEvent("tgiann-mdt:get-cr")
AddEventHandler("tgiann-mdt:get-cr", function(data)
	SendNUIMessage({crresults = data})
end)

RegisterNUICallback('get-bolos', function()
	ESX.TriggerServerCallback('esx_police_cad:get-bolos', function(bolo)
		SendNUIMessage({showBolos = bolo})
	end)
end)

RegisterNUICallback('get-note', function(data)
	ESX.TriggerServerCallback('esx_police_cad:get-note', function(data)
		SendNUIMessage({noteResults = data})
	end, data.identifier)
end)

RegisterNUICallback('get-player-car', function(data)
	ESX.TriggerServerCallback('esx_police_cad:get-player-car', function(data)
		local playerCar = {}
		if data then
			for i=1, #data do 
				playerCar[i] = {}
				playerCar[i].plate = data[i].plate
				playerCar[i].model = GetDisplayNameFromVehicleModel(json.decode(data[i].vehicle).model)
			end
		end
		SendNUIMessage({playerCars = playerCar})
	end, data.identifier)
end)

RegisterNetEvent("tgiann-mdt:get-note")
AddEventHandler("tgiann-mdt:get-note", function(data)
	SendNUIMessage({noteResults = data})
end)

RegisterNUICallback('save-photo', function(data)
	TriggerServerEvent("esx_police_cad:save-user-phote", data)
end)

RegisterNUICallback('takePhoto', function()
	CloseCadSystem()

	CreateMobilePhone(1)
	CellCamActivate(true, true)
	takePhoto = true
	if hasFocus == true then
		SetNuiFocus(false, false)
		hasFocus = false
	end

	while takePhoto do
		Citizen.Wait(1)
		if IsControlJustPressed(1, 27) then -- Toogle Mode
			frontCam = not frontCam
			CellFrontCamActivate(frontCam)
		elseif IsControlJustPressed(1, 177) then -- CANCEL
			DestroyMobilePhone()
			CellCamActivate(false, false)
			takePhoto = false
			break
		elseif IsControlJustPressed(1, 176) then -- TAKE.. PIC
			exports['screenshot-basic']:requestScreenshotUpload("Edit here", "files[]", function(data)
				local image = json.decode(data)
				DestroyMobilePhone()
				CellCamActivate(false, false)
				SendNUIMessage({foto = image.attachments[1].proxy_url})
				takePhoto = false
			end)
		end
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(19)
		HideHudAndRadarThisFrame()
	end
	OpenCadSystem()
end)

RegisterNUICallback('delete_note', function(noteId)
	ESX.TriggerServerCallback('esx_police_cad:delete_note', function(data)
		if data then
			SendNUIMessage({note_deleted = true})
		else
			SendNUIMessage({note_not_deleted = true})
		end
	end, noteId.id)
end)

RegisterNUICallback('delete_cr', function(crId)
	ESX.TriggerServerCallback('esx_police_cad:delete_cr', function(data)
		if data then
			SendNUIMessage({cr_deleted = true})
		else
			SendNUIMessage({cr_not_deleted = true})
		end
	end, crId.id)
end)

RegisterNUICallback('delete-bolo', function(boloId)
	ESX.TriggerServerCallback('esx_police_cad:delete-bolo', function(data)
		if data then
			SendNUIMessage({bolo_deleted = true})
		end
	end, boloId.id)
end)

RegisterNUICallback('get-license', function(data)
	ESX.TriggerServerCallback('esx_police_cad:get-license', function(data)
		SendNUIMessage({licenseResults = data})
	end, data.identifier)
end)

RegisterNUICallback('get-house', function(data)
	ESX.TriggerServerCallback('esx_police_cad:get-house', function(data)
		if data then
			SendNUIMessage({houseNo = data})
		end
	end, data.identifier)
end)

RegisterNUICallback('search-players', function(player)
	ESX.TriggerServerCallback('esx_police_cad:search-players', function(data)
		if data then
			SendNUIMessage({civilianresults = data})
		end
	end, player.search)
end)

Citizen.CreateThread(function()
	while true do
		time = 1000
		if PoliceCadIsShowed then
			time = 1
			DisableControlAction(0, 1,    true) -- LookLeftRight
			DisableControlAction(0, 2,    true) -- LookUpDown
			DisableControlAction(0, 25,   true) -- Input Aim
			DisableControlAction(0, 106,  true) -- Vehicle Mouse Control Override

			DisableControlAction(0, 24,   true) -- Input Attack
			DisableControlAction(0, 140,  true) -- Melee Attack Alternate
			DisableControlAction(0, 141,  true) -- Melee Attack Alternate
			DisableControlAction(0, 142,  true) -- Melee Attack Alternate
			DisableControlAction(0, 257,  true) -- Input Attack 2
			DisableControlAction(0, 263,  true) -- Input Melee Attack
			DisableControlAction(0, 264,  true) -- Input Melee Attack 2

			DisableControlAction(0, 12,   true) -- Weapon Wheel Up Down
			DisableControlAction(0, 14,   true) -- Weapon Wheel Next
			DisableControlAction(0, 15,   true) -- Weapon Wheel Prev
			DisableControlAction(0, 16,   true) -- Select Next Weapon
			DisableControlAction(0, 17,   true) -- Select Prev Weapon
			if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
				SendNUIMessage({type = "click"})
			end
		end
		Citizen.Wait(time)
	end
end)

RegisterNUICallback('escape', function()
	CloseCadSystem()
end)

RegisterNetEvent("tgiann-mdt:open")
AddEventHandler("tgiann-mdt:open", function()
	if PlayerData.job and PlayerData.job.name == "police"  then
		if not PoliceCadIsShowed then
			OpenCadSystem()
		else
			CloseCadSystem()
		end
	end
end)

function OpenCadSystem()
	PoliceCadIsShowed = true

	SendNUIMessage({showCadSystem = true})
	SetNuiFocus(true, true)

	ESX.Streaming.RequestAnimDict("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", function()
		local playerPed = PlayerPedId()
		tab = CreateObject(`prop_cs_tablet`, 0, 0, 0, true, true, true)
		AttachEntityToEntity(tab, playerPed, GetPedBoneIndex(playerPed, 28422), -0.05, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
		TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a" ,8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end

function CloseCadSystem()
	PoliceCadIsShowed = false

	SendNUIMessage({showCadSystem = false})
	SetNuiFocus(false, false)

	DeleteObject(tab)
	ClearPedTasks(PlayerPedId())
end