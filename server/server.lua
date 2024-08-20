local properties = {
    {id = 1, name = "Eclipse Apartments"},
    -- Add more properties as needed
}

local ownedProperties = {}

RegisterServerEvent('property:buy')
AddEventHandler('property:buy', function(propertyId)
    local _source = source
    local property = getPropertyById(propertyId)

    if property then
        if not ownedProperties[propertyId] then
            ownedProperties[propertyId] = _source
            TriggerClientEvent('property:owned', _source, propertyId)
            TriggerClientEvent('chat:addMessage', _source, { args = { 'You bought ' .. property.name } })
        else
            TriggerClientEvent('property:alreadyOwned', _source)
        end
    end
end)

RegisterServerEvent('property:sell')
AddEventHandler('property:sell', function(propertyId)
    local _source = source

    if ownedProperties[propertyId] == _source then
        ownedProperties[propertyId] = nil
        TriggerClientEvent('property:sold', _source, propertyId)
        TriggerClientEvent('chat:addMessage', _source, { args = { 'You sold ' .. getPropertyById(propertyId).name } })
    else
        TriggerClientEvent('property:notOwner', _source)
    end
end)

function getPropertyById(id)
    for _, property in pairs(properties) do
        if property.id == id then
            return property
        end
    end
    return nil
end
