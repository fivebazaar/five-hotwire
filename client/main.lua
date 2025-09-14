local QBCore = exports['qb-core']:GetCoreObject()

local isHotwiring = false
local needsHotwire = false
local currentPlate = ""
local hotwiredVehicles = {}
local KeysList = {}
local playerLoaded = false
lib.locale()

local function LoadVehicleKeys()
    if playerLoaded then
        QBCore.Functions.TriggerCallback('qb-vehiclekeys:server:GetVehicleKeys', function(keys)
            KeysList = keys
        end)
    end
end

local function GetVehiclePlate(vehicle)
    return GetVehicleNumberPlateText(vehicle):gsub('%s+', '')
end

local function ShowHotwireUI()
    lib.showTextUI(locale('hotwire_textui'), {
        position = Config.TextUI.Hotwire.Position,
        icon = Config.TextUI.Hotwire.Icon
    })
end

local function HideHotwireUI()
    lib.hideTextUI()
end

local function HandleVehicleAccess(vehicle, plate)
    if not playerLoaded then return end
    
    local hasKey = KeysList[plate]
    local isHotwired = hotwiredVehicles[plate]

    if not hasKey and not isHotwired then
        SetVehicleEngineOn(vehicle, false, false, true)
        SetVehicleUndriveable(vehicle, true)
        needsHotwire = true
        lib.notify({
            title = locale('no_key_title'),
            description = locale('no_key_desc'),
            type = Config.Notifications.NoKey.Type,
            duration = Config.Notifications.NoKey.Duration
        })
        ShowHotwireUI()
    else
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, false, true)
        needsHotwire = false
        HideHotwireUI()
    end
end

local function CleanupVehicleState()
    if currentPlate ~= "" then
        hotwiredVehicles[currentPlate] = nil
        currentPlate = ""
    end
    needsHotwire = false
    HideHotwireUI()
end

local function PerformSkillCheckAsync(difficulty, callback)
    if Config.UISystem == 'ps-ui' then
        exports['ps-ui']:Circle(function(result)
            callback(result)
        end, #difficulty, 20)
    else
        local success = lib.skillCheck(difficulty, Config.Hotwire.SkillCheckKeys)
        callback(success)
    end
end

local function TriggerDispatchAlert(coords, vehicle, success)
    if not Config.PoliceAlertEnabled or not Config.Dispatch then return end
    if math.random() > (Config.PoliceAlertChance or 0.7) then return end
    
    if Config.DispatchTriggerOn == 'success' and not success then return end
    if Config.DispatchTriggerOn == 'fail' and success then return end

    local dispatchConfig = Config.DispatchTypes[Config.Dispatch]
    if dispatchConfig then
        dispatchConfig.export(coords, vehicle)
    end
end

local function HandleHotwireResult(success, vehicle, plate, ped, alarmTriggered)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, success, false, true)
    needsHotwire = not success

    if success then
        hotwiredVehicles[plate] = true
        TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
        lib.notify({
            title = locale('hotwire_success_title'),
            description = locale('hotwire_success_desc'),
            type = Config.Notifications.HotwireSuccess.Type,
            duration = Config.Notifications.HotwireSuccess.Duration
        })
    else
        lib.notify({
            title = locale('hotwire_fail_title'),
            description = locale('hotwire_fail_desc'),
            type = Config.Notifications.HotwireFail.Type,
            duration = Config.Notifications.HotwireFail.Duration
        })
    end

    if alarmTriggered then SetVehicleAlarm(vehicle, false) end
    TriggerDispatchAlert(GetEntityCoords(ped), vehicle, success)
    ClearPedTasks(ped)
    isHotwiring = false

    if needsHotwire and cache.vehicle and cache.seat == -1 then
        ShowHotwireUI()
    end
end

function StartHotwiring(vehicle, plate)
    if isHotwiring then return end
    isHotwiring = true
    HideHotwireUI()
    
    local ped = cache.ped
    local vehicleClass = GetVehicleClass(vehicle)
    local classConfig = Config.VehicleClasses[vehicleClass] or Config.VehicleClasses[0]

    TaskPlayAnim(
        ped, 
        Config.Hotwire.Animation.Dict, 
        Config.Hotwire.Animation.Clip, 
        8.0, 8.0, -1, 16, 0, false, false, false
    )
    
    lib.notify({
        title = locale('hotwire_start_title'),
        description = locale('hotwire_start_desc'),
        type = Config.Notifications.HotwireStart.Type,
        duration = Config.Notifications.HotwireStart.Duration
    })

    local alarmTriggered = false
    if math.random() <= classConfig.alarmChance then
        SetVehicleAlarm(vehicle, true)
        StartVehicleAlarm(vehicle)
        alarmTriggered = true
        lib.notify({
            title = locale('alert_warning_title'),
            description = locale('alert_warning_desc'),
            type = Config.Notifications.AlertWarning.Type,
            duration = Config.Notifications.AlertWarning.Duration
        })
    end

    local progressSuccess = lib.progressBar({
        duration = classConfig.duration,
        label = locale('hotwire_progress') .. ' (' .. locale(classConfig.labelKey) .. ')',
        useWhileDead = false,
        canCancel = true,
        disable = {car = true, move = true, combat = true},
        anim = {dict = Config.Hotwire.Animation.Dict, clip = Config.Hotwire.Animation.Clip}
    })

    if progressSuccess then
        PerformSkillCheckAsync(classConfig.difficulty, function(skillCheckSuccess)
            HandleHotwireResult(skillCheckSuccess, vehicle, plate, ped, alarmTriggered)
        end)
    else
        lib.notify({
            title = locale('hotwire_cancel_title'),
            description = locale('hotwire_cancel_desc'),
            type = Config.Notifications.HotwireCancel.Type,
            duration = Config.Notifications.HotwireCancel.Duration
        })
        if alarmTriggered then SetVehicleAlarm(vehicle, false) end
        ClearPedTasks(ped)
        isHotwiring = false
        if needsHotwire and cache.vehicle and cache.seat == -1 then
            ShowHotwireUI()
        end
    end
end

lib.onCache('vehicle', function(vehicle)
    if vehicle then
        currentPlate = GetVehiclePlate(vehicle)
        if cache.seat == -1 then
            HandleVehicleAccess(vehicle, currentPlate)
        end
    else
        CleanupVehicleState()
    end
end)

lib.onCache('seat', function(seat)
    if seat == -1 and cache.vehicle then
        currentPlate = GetVehiclePlate(cache.vehicle)
        HandleVehicleAccess(cache.vehicle, currentPlate)
    elseif seat ~= -1 then
        needsHotwire = false
        HideHotwireUI()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    playerLoaded = true
    LoadVehicleKeys()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    playerLoaded = false
    KeysList = {}
    CleanupVehicleState()
end)


lib.addKeybind({
    name = 'hotwire_vehicle',
    description = 'Hotwire Vehicle',
    defaultKey = 'E',
    onPressed = function()
        if playerLoaded and needsHotwire and cache.vehicle and cache.seat == -1 and not isHotwiring then
            StartHotwiring(cache.vehicle, currentPlate)
        end
    end
})
