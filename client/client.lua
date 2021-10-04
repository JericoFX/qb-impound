screenshot = {}
local show = false
RegisterCommand("impound", function()
        local vehicle = QBCore.Functions.GetClosestVehicle()
        local plate = GetVehicleNumberPlateText(vehicle)
        for k,v in pairs(Depots) do
            SendNUIMessage({show = not show,
                plate = plate,
                GaragesIndex = {k},
                GarageNames = {Depots[k].label},
                price = {Depots[k].price},
                vehicle = vehicle
            })
        end
        SetNuiFocus(true, true)
end, false)

RegisterNUICallback('GetData', function(data, cb)
        local Plate = data
        QBCore.Functions.TriggerCallback('GetData', function(Data) 
            cb(Data) 
        end,Plate)
end)

RegisterNUICallback('ExitApp', function(data, cb)
        SetNuiFocus(false, false)
          show = false
        cb({})
end)
local function Log(...)
    if type(...) == 'table' then
        print(json.encode(...))
    elseif type(...) == 'string' or type(...) == 'number' then
        print(tostring(...))
    end
end

RegisterNUICallback('SendDataToLua', function(data, cb)
    local Plate = tostring(data.plate)
    local Img = data.img or ""
    local Notes = tostring(data.notes) or ""
    local Garage = data.garage
    local Price = data.price or 2000
    local Vehicle = data.vehicle
    QBCore.Functions.TriggerCallback("fx-screen:server:UpdateData",function(Data) 
        if Data then
            VehicleExist(Plate,function(cb) 
                if cb then
                    QBCore.Functions.DeleteVehicle(Vehicle)
                end
            end)
        end
    end,Plate,Img,Notes,Garage,Price)
  cb({})

end)

RegisterNUICallback('Camera', function(data, cb)
        exports['screenshot-basic']:requestScreenshotUpload(WebHook, "files[]",function(data)
                local image = json.decode(data)
                cb(json.encode(image.attachments[1].proxy_url))
            end)
end)

-- CHECK IF THE VEHICLE IS OUT
function VehicleExist(plate,cb)
    local pool = GetGamePool("CVehicle")
    for i = 0, #pool do
        local Plate = pool[i]
        if DoesEntityExist(Plate) then
            if GetVehicleNumberPlateText(Plate) == plate then
                cb(true)
            else
                cb(false)
            end
        end
    end
end