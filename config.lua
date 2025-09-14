Config = {}

Config.Debug = false
Config.DispatchTriggerOn = 'success' -- success,  fail
Config.UISystem = 'ox_lib' -- ox_lib & ps-ui
Config.Updater = true -- Version checker
Config.VehicleClasses = {
    [0] = {duration = 4000, difficulty = {'easy', 'easy'}, alarmChance = 0.3, labelKey = 'compact'},
    [1] = {duration = 5000, difficulty = {'easy', 'medium'}, alarmChance = 0.4, labelKey = 'sedan'},
    [2] = {duration = 6000, difficulty = {'medium', 'medium'}, alarmChance = 0.5, labelKey = 'suv'},
    [3] = {duration = 5500, difficulty = {'easy', 'medium'}, alarmChance = 0.4, labelKey = 'coupe'},
    [4] = {duration = 7000, difficulty = {'medium', 'hard'}, alarmChance = 0.6, labelKey = 'muscle'},
    [5] = {duration = 8000, difficulty = {'medium', 'hard', 'hard'}, alarmChance = 0.7, labelKey = 'sports_classic'},
    [6] = {duration = 9000, difficulty = {'hard', 'hard', 'hard'}, alarmChance = 0.8, labelKey = 'sports'},
    [7] = {duration = 12000, difficulty = {'hard', 'hard', 'hard', 'hard'}, alarmChance = 0.9, labelKey = 'super'},
    [8] = {duration = 3000, difficulty = {'easy'}, alarmChance = 0.2, labelKey = 'motorcycle'},
    [9] = {duration = 5500, difficulty = {'medium', 'medium'}, alarmChance = 0.4, labelKey = 'off_road'},
    [10] = {duration = 8000, difficulty = {'medium', 'hard', 'medium'}, alarmChance = 0.3, labelKey = 'industrial'},
    [11] = {duration = 6000, difficulty = {'medium', 'medium'}, alarmChance = 0.3, labelKey = 'utility'},
    [12] = {duration = 7000, difficulty = {'medium', 'hard'}, alarmChance = 0.4, labelKey = 'van'},
    [13] = {duration = 1000, difficulty = {'easy'}, alarmChance = 0.0, labelKey = 'bicycle'},
    [14] = {duration = 6000, difficulty = {'medium', 'medium'}, alarmChance = 0.3, labelKey = 'boat'},
    [15] = {duration = 15000, difficulty = {'hard', 'hard', 'hard', 'hard', 'hard'}, alarmChance = 0.95, labelKey = 'helicopter'},
    [16] = {duration = 20000, difficulty = {'hard', 'hard', 'hard', 'hard', 'hard', 'hard'}, alarmChance = 0.98, labelKey = 'plane'},
    [17] = {duration = 8000, difficulty = {'medium', 'hard', 'medium'}, alarmChance = 0.5, labelKey = 'service'},
    [18] = {duration = 25000, difficulty = {'hard', 'hard', 'hard', 'hard', 'hard', 'hard', 'hard'}, alarmChance = 1.0, labelKey = 'emergency'},
    [19] = {duration = 30000, difficulty = {'hard', 'hard', 'hard', 'hard', 'hard', 'hard', 'hard', 'hard'}, alarmChance = 1.0, labelKey = 'military'},
    [20] = {duration = 10000, difficulty = {'medium', 'hard', 'hard', 'medium'}, alarmChance = 0.6, labelKey = 'commercial'},
    [21] = {duration = 0, difficulty = {}, alarmChance = 0.0, labelKey = 'train'}
}

Config.Hotwire = {
    Animation = {
        Dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
        Clip = 'machinic_loop_mechandplayer',
    },
    SkillCheckKeys = {'w','a','s','d'},
}



Config.Notifications = {
    NoKey = {
        Type = 'error',
        Duration = 3000,
    },
    HotwireStart = {
        Type = 'inform',
        Duration = 2000,
    },
    HotwireSuccess = {
        Type = 'success',
        Duration = 3000,
    },
    HotwireFail = {
        Type = 'error',
        Duration = 2000,
    },
    HotwireCancel = {
        Type = 'error',
        Duration = 2000,
    },
    AlertWarning = {
        Type = 'warning',
        Duration = 3000,
    },
}

Config.TextUI = {
    Hotwire = {
        Position = 'top-center',
        Icon = 'fas fa-key',
    }
}

Config.Dispatch = "bub-mdt"
Config.PoliceAlertChance = 0.7
Config.PoliceAlertEnabled = true

Config.DispatchTypes = {
    ["ps-dispatch"] = {
        export = function(coords, vehicle)
            exports['ps-dispatch']:VehicleTheft(vehicle)
        end
    },
    

    ["bub-mdt"] = {
        export = function(coords, vehicle)
            local vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            local plate = GetVehicleNumberPlateText(vehicle):gsub('%s+', '')
            
            exports['bub-mdt']:CustomAlert({
                coords = coords,
                info = {
                    {
                        label = 'Araç Hırsızlığı Girişimi',
                        icon = 'car',
                    },
                    {
                        label = 'Model: ' .. vehicleModel,
                        icon = 'info',
                    },
                    {
                        label = 'Plaka: ' .. plate,
                        icon = 'id-card',
                    }
                },
                code = '10-90',
                offense = 'Araç Hırsızlığı',
                blip = 225,
                sprite = 225,
                color = 1,
                scale = 1.2,
                length = 3, 
            })
        end
    },
    
    ["cd_dispatch"] = {
        export = function(coords, vehicle)
            local vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            local plate = GetVehicleNumberPlateText(vehicle):gsub('%s+', '')
            
            TriggerServerEvent('cd_dispatch:AddNotification', {
                job_table = {'police'},
                coords = coords,
                title = '10-90 - Araç Hırsızlığı',
                message = 'Birisi araç çalmaya çalışıyor! Model: ' .. vehicleModel .. ' Plaka: ' .. plate,
                flash = 0, 
                unique_id = tostring(math.random(1000000, 9999999)),
                blip = {
                    sprite = 225,
                    scale = 1.2,
                    colour = 1,
                    flashes = false,
                    text = '10-90 - Araç Hırsızlığı',
                    time = (3 * 60 * 1000), 
                    sound = 1,
                }
            })
        end
    },
    
    ["core_dispatch"] = {
        export = function(coords, vehicle)
            local vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            local plate = GetVehicleNumberPlateText(vehicle):gsub('%s+', '')
            
            exports['core_dispatch']:addCall(
                "10-90", 
                "Araç Hırsızlığı Girişimi", 
                {
                    {icon = "fas fa-car", info = "Model: " .. vehicleModel},
                    {icon = "fas fa-id-card", info = "Plaka: " .. plate},
                }, 
                {coords.x, coords.y}, 
                "police", 
                5000, 
                11, 
                5 
            )
        end
    },
    
    ["qs-dispatch"] = {
        export = function(coords, vehicle)
            local vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            local plate = GetVehicleNumberPlateText(vehicle):gsub('%s+', '')
            
            exports['qs-dispatch']:VehicleTheft(coords, {
                model = vehicleModel,
                plate = plate,
                heading = GetEntityHeading(vehicle)
            })
        end
    },
    
    ["origen_police"] = {
        export = function(coords, vehicle)
            exports['origen_police']:SendAlert({
                coords = coords,
                title = 'Araç Hırsızlığı',
                message = 'Birisi araç çalmaya çalışıyor!',
                type = 'vehicle_theft',
                time = 180000, 
                blip = 225
            })
        end
    },
    
    ["tk_dispatch"] = {
        export = function(coords, vehicle)
            local vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            local plate = GetVehicleNumberPlateText(vehicle):gsub('%s+', '')
            
            exports['tk_dispatch']:CustomAlert({
                message = 'Araç Hırsızlığı Girişimi',
                code = '10-90',
                coords = coords,
                priority = 2,
                blip = {
                    sprite = 225,
                    color = 1,
                    scale = 1.2
                },
                info = {
                    ['Model'] = vehicleModel,
                    ['Plaka'] = plate
                }
            })
        end
    },
    
    ["rcore_dispatch"] = {
        export = function(coords, vehicle)
            TriggerServerEvent('rcore_dispatch:server:sendAlert', {
                code = '10-90',
                default_priority = 'medium',
                coords = coords,
                job = {'police'},
                text = 'Araç Hırsızlığı Girişimi',
                type = 'alerts',
                blip_time = 300, 
                image = nil,
                custom_sound = nil
            })
        end
    },
    
    ["lj_dispatch"] = {
        export = function(coords, vehicle)
            exports['lj_dispatch']:AlertPolice({
                coords = coords,
                title = 'Araç Hırsızlığı',
                message = 'Birisi araç çalmaya çalışıyor!',
                sprite = 225,
                color = 1,
                scale = 1.2,
                length = 3
            })
        end
    },
    
    ["custom"] = {
        export = function(coords, vehicle)
            print("^3[HOTWIRE] Custom dispatch tanımlanmamış!^0")
        end
    }
}


