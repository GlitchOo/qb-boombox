local QBCore = exports['qb-core']:GetCoreObject()
local xSound = exports.xsound

QBCore.Functions.CreateUseableItem("boombox", function(source, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	Player.Functions.RemoveItem('boombox', 1, false)
	
	TriggerClientEvent('qb-boombox:client:placeBoombox', src)
	TriggerClientEvent('QBCore:Notify', src, 'You have just dropped the BoomBox', 'primary')
end)

RegisterNetEvent('qb-boombox:server:playMusic', function(song, entity, coords)
    local src = source
    xSound:PlayUrlPos(-1, tostring(entity), song, Config.DefaultVolume, coords)
    xSound:Distance(-1, tostring(entity), Config.radius)
    isPlaying = true
end)

RegisterNetEvent('qb-boombox:server:pickedup', function(entity)
    local src = source
    xSound:Destroy(-1, tostring(entity))
end)

RegisterNetEvent('qb-boombox:server:stopMusic', function(data)
    local src = source
    xSound:Destroy(-1, tostring(data.entity))
    TriggerClientEvent('qb-boombox:client:playMusic', src)
end)

RegisterNetEvent('qb-boombox:server:pauseMusic', function(data)
    local src = source
    xSound:Pause(-1, tostring(data.entity))
end)

RegisterNetEvent('qb-boombox:server:resumeMusic', function(data)
    local src = source
    xSound:Resume(-1, tostring(data.entity))
end)

RegisterNetEvent('qb-boombox:server:changeVolume', function(volume, entity)
    local src = source
    if not tonumber(volume) then return end
    xSound:setVolume(-1, tostring(entity), volume)
end)