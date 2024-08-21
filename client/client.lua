-- THIS IS FOR CREATING PROPERTIES

local properties = {
    {
        id = 1, -- Unique identifier for the property
        name = "Property 1", -- Name of the property
        coords = vector3(-778.2485, 299.2582, 85.75365), -- Coordinates for the property location
        price = 50000, -- Price of the property
        interior = {
            ipl = "apa_v_mp_h_04_a", -- IPL (Interior Proxy Library) name for the interior
            coords = vector3(-781.9878, 323.6537, 176.8037), -- Coordinates for where it will tp player
            exits = {
                vector3(-783.2204, 317.142, 176.8037), -- Main exit coordinates
                vector3(-790.0, 320.0, 217.6385) -- Additional exit coordinates
            }
        }
    },
    -- Add more properties as needed
}

local ownedProperties = {}
local props = {}
local blips = {}

Citizen.CreateThread(function()
    for _, property in pairs(properties) do
        local blip = AddBlipForCoord(property.coords)
        SetBlipSprite(blip, 375)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(property.name)
        EndTextCommandSetBlipName(blip)
        blips[property.id] = blip
    end
end)

RegisterNetEvent('property:owned')
AddEventHandler('property:owned', function(propertyId)
    ownedProperties[propertyId] = true
    if props[propertyId] then
        DeleteObject(props[propertyId])
        props[propertyId] = nil
    end
    if blips[propertyId] then
        RemoveBlip(blips[propertyId])
        blips[propertyId] = nil
    end
    local houseBlip = AddBlipForCoord(properties[propertyId].coords)
    SetBlipSprite(houseBlip, 40) -- House blip
    SetBlipDisplay(houseBlip, 4)
    SetBlipScale(houseBlip, 0.8)
    SetBlipColour(houseBlip, 3)
    SetBlipAsShortRange(houseBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("My Property")
    EndTextCommandSetBlipName(houseBlip)
    blips[propertyId] = houseBlip
end)

RegisterNetEvent('property:alreadyOwned')
AddEventHandler('property:alreadyOwned', function()
    -- Notify the player that the property is already owned
end)

RegisterNetEvent('property:sold')
AddEventHandler('property:sold', function(propertyId)
    ownedProperties[propertyId] = nil
    if blips[propertyId] then
        RemoveBlip(blips[propertyId])
        blips[propertyId] = nil
    end
end)

RegisterNetEvent('property:notOwner')
AddEventHandler('property:notOwner', function()
    -- Notify the player that they are not the owner
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, property in pairs(properties) do
            if #(playerCoords - property.coords) < 1.5 then
                if not ownedProperties[property.id] then
                    if not props[property.id] then
                        local prop = CreateObject(GetHashKey("prop_forsale_lrg_06"), property.coords.x, property.coords.y, property.coords.z, false, false, false)
                        PlaceObjectOnGroundProperly(prop)
                        props[property.id] = prop
                    end
                    DrawText3D(property.coords, "[E] Buy Property")
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('property:buy', property.id)
                    end
                else
                    DrawText3D(property.coords, "[E] Enter Property")
                    if IsControlJustReleased(0, 38) then
                        RequestIpl(property.interior.ipl)
                        SetEntityCoords(playerPed, property.interior.coords)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, property in pairs(properties) do
            if ownedProperties[property.id] then
                for _, exit in pairs(property.interior.exits) do
                    DrawMarker(1, exit.x, exit.y, exit.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, nil, nil, false)
                    if #(playerCoords - exit) < 1.5 then
                        DrawText3D(exit, "[E] Exit Property")
                        if IsControlJustReleased(0, 38) then
                            SetEntityCoords(playerPed, property.coords)
                            RemoveIpl(property.interior.ipl)
                        end
                    end
                end
            end
        end
    end
end)

function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 75)
end
