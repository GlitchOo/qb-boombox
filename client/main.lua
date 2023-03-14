-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local currentData = nil
local object = GetHashKey('prop_boombox_01')

-- Functions
local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

-- Events
RegisterNetEvent('qb-boombox:client:placeBoombox', function()
    loadAnimDict("anim@heists@money_grab@briefcase")
    TaskPlayAnim(PlayerPedId(), "anim@heists@money_grab@briefcase", "put_down_case", 8.0, -8.0, -1, 1, 0, false, false, false)
    Citizen.Wait(1000)
    ClearPedTasks(PlayerPedId())
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local forward = GetEntityForwardVector(PlayerPedId())
    local x, y, z = table.unpack(coords + forward * 0.5)
    local object = CreateObject(GetHashKey('prop_boombox_01'), x, y, z, true, false, false)
    PlaceObjectOnGroundProperly(object)
    SetEntityHeading(object, heading)
    FreezeEntityPosition(object, true)
    currentData = NetworkGetNetworkIdFromEntity(object)
end)

RegisterNetEvent('qb-boombox:client:pickupBoombox', function()
    local obj = NetworkGetEntityFromNetworkId(currentData)
    local objCoords = GetEntityCoords()
    NetworkRequestControlOfEntity(obj)
    loadAnimDict("anim@heists@narcotics@trash")
    TaskPlayAnim(PlayerPedId(), "anim@heists@narcotics@trash", "pickup", 8.0, -8.0, -1, 1, 0, false, false, false)
    Citizen.Wait(700)
    SetEntityAsMissionEntity(obj, false, true)
    DeleteEntity(obj)
    DeleteObject(obj)
    if not DoesEntityExist(obj) then
        TriggerServerEvent('qb-boombox:server:pickedup', currentData)
        currentData = nil
    end
    Citizen.Wait(500)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('qb-boombox:client:playMusic', function()
    local musicMenu = {
        {
            isHeader = true,
            header = '💿 | Boombox'
        },
        {
            header = '🎶 | Play a song',
            txt = 'Enter a youtube URL',
            params = {
                event = 'qb-boombox:client:musicMenu',
                args = {

                }
            }
        },
        {
            header = '⏸️ | Pause Music',
            txt = 'Pause currently playing music',
            params = {
                isServer = true,
                event = 'qb-boombox:server:pauseMusic',
                args = {
                    entity = currentData,
                }
            }
        },
        {
            header = '▶️ | Resume Music',
            txt = 'Resume playing paused music',
            params = {
                isServer = true,
                event = 'qb-boombox:server:resumeMusic',
                args = {
                    entity = currentData,
                }
            }
        },
        {
            header = '🔈 | Change Volume',
            txt = 'Resume playing paused music',
            params = {
                event = 'qb-boombox:client:changeVolume',
                args = {

                }
            }
        },
        {
            header = '❌ | Turn off music',
            txt = 'Stop the music & choose a new song',
            isServer = true,
            params = {
                isServer = true,
                event = 'qb-boombox:server:stopMusic',
                args = {
                    entity = currentData,
                }
            }
        },
        {
            header = '❌ | Pickup',
            txt = 'Stop the music & choose a new song',
            params = {
                event = 'qb-boombox:client:pickupBoombox',
                args = {
                }
            }
        }
    }
    exports['qb-menu']:openMenu(musicMenu)
end)

RegisterNetEvent('qb-boombox:client:musicMenu', function()
    local dialog = exports['qb-input']:ShowInput({
        header = 'Song Selection',
        submitText = "Submit",
        inputs = {
            {
                type = 'text',
                isRequired = true,
                name = 'song',
                text = 'YouTube URL'
            }
        }
    })
    if dialog then
        if not dialog.song then return end
        TriggerServerEvent('qb-boombox:server:playMusic', dialog.song, currentData, GetEntityCoords(NetworkGetEntityFromNetworkId(currentData)))
    end
end)

RegisterNetEvent('qb-boombox:client:changeVolume', function()
    local dialog = exports['qb-input']:ShowInput({
        header = 'Music Volume',
        submitText = "Submit",
        inputs = {
            {
                type = 'text', -- number doesn't accept decimals??
                isRequired = true,
                name = 'volume',
                text = 'Min: 0.01 - Max: 1'
            }
        }
    })
    if dialog then
        if not dialog.volume then return end
        TriggerServerEvent('qb-boombox:server:changeVolume', dialog.volume, currentData)
    end
end)
CreateThread(function()
    exports['qb-target']:AddTargetModel(object, {-- This defines the models, can be a string or a table
        options = {-- This is your options table, in this table all the options will be specified for the target to accept
            {-- This is the first table with options, you can make as many options inside the options table as you want
                num = 1, -- This is the position number of your option in the list of options in the qb-target context menu (OPTIONAL)
                type = "client", -- This specifies the type of event the target has to trigger on click, this can be "client", "server", "command" or "qbcommand", this is OPTIONAL and will only work if the event is also specified
                event = "qb-boombox:client:playMusic", -- This is the event it will trigger on click, this can be a client event, server event, command or qbcore registered command, NOTICE: Normal command can't have arguments passed through, QBCore registered ones can have arguments passed through
                icon = 'fas fa-music', -- This is the icon that will display next to this trigger option
                label = 'Play Music', -- This is the label of this option which you would be able to click on to trigger everything, this has to be a string
            }
        },
        distance = 3, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
    })
end)