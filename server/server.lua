RegisterNetEvent('Imagetest')
AddEventHandler('Imagetest', function(plate, img, notes)
if plate then
    local Export = exports.oxmysql:executeSync( 'UPDATE player_vehicles SET pics =  ?,notes = ? WHERE  plate = ?', {json.encode(img), notes, plate})
else
TriggerClientEvent("QBCore:Notify",source,"No Plate passed")
end
end)

QBCore.Functions.CreateCallback('fx-screen:server:UpdateData',function(source,cb,plate,img,notes,garage,price) 
    local Export = exports.oxmysql:executeSync( 'UPDATE player_vehicles SET pics =  ?,notes = ?, garage = ?,depotprice = ?,state = 2 WHERE  plate = ?', {json.encode(img),notes,garage,price,plate})
    if Export then
        cb(true)
    else
        cb(false)
    end

end)


QBCore.Functions.CreateCallback("GetData", function(source, cb, plate)
    local Response = exports.oxmysql:scalarSync( 'SELECT citizenid FROM player_vehicles WHERE plate =?', {plate})
    local Player = QBCore.Functions.GetPlayerByCitizenId(Response)
    cb({
        name = Player.PlayerData.charinfo.firstname .. " " ..Player.PlayerData.charinfo.lastname,
        phone = Player.PlayerData.charinfo.phone,
        citizenid = Response
    })
end)

-- RegisterNetEvent('SendMessage', function(data)
--     local Citizend = data.citizenid
--     local Email = tostring(data.email)
--     TriggerEvent('qb-phone:server:sendNewMailToOffline', Citizend,{sender = "Police", subject = "Impound", message = Email})
-- end)

