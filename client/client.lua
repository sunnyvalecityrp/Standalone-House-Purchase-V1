-- THIS IS FOR CREATING PROPERTIES

local properties = {
    {
        id = 1, -- Unique identifier for the property
        name = "Property 1", -- Name of the property
        coords = vector3(-778.2485, 299.2582, 85.75365), -- Coordinates for the property location
        price = 500000, -- Price of the property
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
                    DrawText3D(property.coords, string.format("[E] Buy Property - $%d", property.price))
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('property:buy', property.id)
                    end
                else
                    DrawText3D(property.coords, "[E] Enter Property")
                    if IsControlJustReleased(0, 38) then
                        RequestIpl(property.interior.ipl)
                        SetEntityCoords(playerPed, property.interior.coords.x, property.interior.coords.y, property.interior.coords.z)
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
                    if #(playerCoords - exit) < 10.0 then
                        -- Draw the marker at the exit
                        DrawMarker(1, exit.x, exit.y, exit.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, nil, nil, false)

                        if #(playerCoords - exit) < 1.5 then
                            -- Show text prompt
                            ShowHelpNotification("[E] Exit Property")

                            if IsControlJustReleased(0, 38) then
                                SetEntityCoords(playerPed, property.coords.x, property.coords.y, property.coords.z)
                                RemoveIpl(property.interior.ipl)
                            end
                        end
                    end
                end
            end
        end
    end
end)


function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
    BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end


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
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0, 0, 0, 75)
end
