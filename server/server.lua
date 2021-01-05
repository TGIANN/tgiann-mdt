ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_police_cad:search-plate', function(source, cb, plate)
    if string.len(plate) == 8 then
        MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate", {
            ['@plate'] = plate
        }, function (result)
            if result[1] then
                MySQL.Async.fetchAll("SELECT identifier, firstname, lastname FROM users WHERE identifier = @identifier", {
                    ['@identifier'] = result[1].owner
                }, function(result2)
                    if result2 then
                        cb(result2[1], result[1])
                    end
                end)
            else
                cb(nil)
            end
        end)
    else
        cb(nil)
    end
end)

RegisterCommand("mdt", function(source, args, raw)
	TriggerClientEvent('tgiann-mdt:open', source)
end)

ESX.RegisterServerCallback('esx_police_cad:search-players', function(source, cb, search)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE CONCAT(firstname, ' ', lastname) LIKE @search LIMIT 30", {
        ['@search'] = '%'..search..'%'
    }, function (result)
        if result then
            cb(result)
        end
    end)
end)

RegisterServerEvent('esx_police_cad:add-cr')
AddEventHandler('esx_police_cad:add-cr', function(data)
    local src = source
    if string.match(data.resmi, 'htt') then
        MySQL.Async.fetchAll('UPDATE users SET userimage=@url WHERE identifier = @identifier', {
            ['@url'] = data.resmi,
            ['@identifier'] = data.playerid
        })
    end

    MySQL.Async.fetchAll("INSERT INTO tgiann_mdt_records SET reason = @reason, fine = @fine, user_id = @user_id", {
        ['@user_id'] = data.playerid,
        ['@reason'] = data.reason,
        ['@fine'] = data.fine,
    }, function()
        get_cr(src, data.playerid)
    end)
end)

RegisterServerEvent('esx_police_cad:save-user-phote')
AddEventHandler('esx_police_cad:save-user-phote', function(data)
    local src = source
    MySQL.Async.fetchAll('UPDATE users SET userimage=@url WHERE identifier = @identifier', {
        ['@url'] = data.resmi,
        ['@identifier'] = data.playerid
    },function()
        get_cr(src, data.playerid)
    end)
end)

RegisterServerEvent('esx_police_cad:add-note')
AddEventHandler('esx_police_cad:add-note', function(data)
    local src = source
    MySQL.Async.fetchAll("INSERT INTO tgiann_mdt_notes SET title = @title, user_id = @user_id", {
        ['@title'] = data.title,
        ['@user_id'] = data.playerid,
    }, function()
        MySQL.Async.fetchAll("SELECT * FROM tgiann_mdt_notes WHERE user_id = @user_id ORDER BY id DESC LIMIT 10", {
            ['@user_id'] = data.playerid
        }, function(result)
            if result[1] then
                TriggerClientEvent("tgiann-mdt:get-note", src, result)
            else
                local result = {{id = "-1", title = "No note!", user_id = data.playerid }}
                TriggerClientEvent("tgiann-mdt:get-note", src, result)
            end
        end)

    end)
end)

ESX.RegisterServerCallback('esx_police_cad:delete_note', function(source, cb, note)
    MySQL.Async.fetchAll("DELETE FROM tgiann_mdt_notes WHERE id = @id", {
        ['@id'] = note
    }, function(result)
        if result.affectedRows == 1 then
            cb(true)
        else
            cb(false)
        end
    end)
end)

ESX.RegisterServerCallback('esx_police_cad:delete_cr', function(source, cb, cr)
    MySQL.Async.fetchAll("DELETE FROM tgiann_mdt_records WHERE id = @id", {
        ['@id'] = cr,
    }, function (result)
        MySQL.Async.fetchAll("SELECT id FROM tgiann_mdt_records WHERE id = @id", {
            ['@id'] = cr,
        }, function(result2)
            if result2[1] then
                cb(false)
            else
                cb(true)
            end
        end)
    end)
end)

ESX.RegisterServerCallback('esx_police_cad:get-note', function(source, cb, playerid)
    MySQL.Async.fetchAll("SELECT * FROM tgiann_mdt_notes WHERE user_id = @user_id ORDER BY id DESC LIMIT 10", {
        ['@user_id'] = playerid
    }, function(result)
        if result[1] then
            cb(result)
        else
            local result = {{id = "-1", title = "No Note!", user_id = playerid }}
            cb(result)
        end
    end)
end)

RegisterServerEvent('esx_police_cad:get-cr')
AddEventHandler('esx_police_cad:get-cr', function(identifier)
    get_cr(source, identifier)
end)

function get_cr(source, id)
    local src = source
    local identifier = id
    MySQL.Async.fetchAll("SELECT * FROM tgiann_mdt_records WHERE user_id = @user_id ORDER BY id DESC LIMIT 10", {
        ['@user_id'] = identifier
    }, function (result)
        if result[1] then
            TriggerClientEvent("tgiann-mdt:get-cr", src, result)
        else
            local result = {{id = "-1", fine = "", reason = "No Criminal Record!", user_id = playerid }}
            TriggerClientEvent("tgiann-mdt:get-cr", src, result)
        end
    end)
end

ESX.RegisterServerCallback('esx_police_cad:get-license', function(source, cb, owner)
    MySQL.Async.fetchAll("SELECT * FROM user_licenses WHERE owner = @owner", {
        ['@owner'] = owner
    }, function(result)
        if result[1] then
            cb(result)
        end
    end)
end)

ESX.RegisterServerCallback('esx_police_cad:get-bolos', function(source, cb)
    MySQL.Async.fetchAll("SELECT * FROM tgiann_mdt_bolos order by id", {
    }, function (result)
        if (result[1] ~= nil) then
            cb(result)
        else
            cb({{id = -1, name = "No wanted criminal!"}})
        end
    end)
end)

ESX.RegisterServerCallback('esx_police_cad:add-bolo', function(source, cb, data)
    MySQL.Async.fetchAll("INSERT into tgiann_mdt_bolos SET name = @name, lastname = @lastname, gender = @gender, reason = @reason, created_at = @created_at", {
        ['@name'] = data.name,
        ['@lastname'] = data.lastname,
        ['@gender'] = data.gender,
        ['@reason'] = data.reason,
        ['@created_at'] = os.date("%d-%m-%Y %H:%M:%S"),
    },function (result)
        MySQL.Async.fetchAll("SELECT * FROM tgiann_mdt_bolos order by id desc", {
        }, function (result2)
            cb(result2)
        end)
    end)
end)

ESX.RegisterServerCallback('esx_police_cad:delete-bolo', function(source, cb, data)
    MySQL.Async.fetchAll("DELETE FROM tgiann_mdt_bolos WHERE id = @id", {
        ['@id'] = data,
    },function (result)
        MySQL.Async.fetchAll("SELECT id FROM tgiann_mdt_bolos WHERE id = @id", {
            ['@id'] = data,
        }, function()
            cb(true)
        end)
    end)
end)

ESX.RegisterServerCallback('esx_police_cad:get-player-car', function(source, cb, owner)
    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner", {
        ['@owner'] = owner
    }, function (result)
        if result[1] then
           cb(result)
        else
            cb(nil)
        end
    end)
end)