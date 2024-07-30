
RegisterCommand("cleararea", function(source, args, rawCommand)

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)]
    local radius = 30.0

    if #args > 0 then
        radius = tonumber(args[1]) or 30.0
    end

    -- Log to console use F8 to see menu
    print(string.format("Clearing area around player with radius: %.2f", radius))

    -- Clear area using nativesm add more from CFX document page
    ClearArea(playerCoords.x, playerCoords.y, playerCoords.z, radius, true, false, false, false)
    print("ClearArea executed")
    ClearAreaOfCops(playerCoords.x, playerCoords.y, playerCoords.z, radius, false)
    print("ClearAreaOfCops executed")
    ClearAreaOfObjects(playerCoords.x, playerCoords.y, playerCoords.z, radius, 0)
    print("ClearAreaOfObjects executed")
    ClearAreaOfPeds(playerCoords.x, playerCoords.y, playerCoords.z, radius, false)
    print("ClearAreaOfPeds executed")
    ClearAreaOfVehicles(playerCoords.x, playerCoords.y, playerCoords.z, radius, false, false, false, false, false)
    print("ClearAreaOfVehicles executed")


    local entities = GetGamePool('CObject')
    for _, entity in ipairs(entities) do
        local entityCoords = GetEntityCoords(entity)
        if #(playerCoords - entityCoords) < radius then
            DeleteEntity(entity)
        end
    end

    local peds = GetGamePool('CPed')
    for _, ped in ipairs(peds) do
        local pedCoords = GetEntityCoords(ped)
        if #(playerCoords - pedCoords) < radius and not IsPedAPlayer(ped) then
            DeleteEntity(ped)
        end
    end

    local vehicles = GetGamePool('CVehicle')
    for _, vehicle in ipairs(vehicles) do
        local vehicleCoords = GetEntityCoords(vehicle)
        if #(playerCoords - vehicleCoords) < radius then
            DeleteEntity(vehicle)
        end
    end

    -- Notify player in skybox chat
    TriggerEvent('chat:addMessage', {
        args = { "Area cleared!" }
    })
end, false)

    -- Command Functionallity for chat. Radius is able to be changed if wanted.
TriggerEvent('chat:addSuggestion', '/cleararea', 'Clears all objects, peds, and vehicles in a specified radius', {
    { name="radius", help="Radius to clear (default is 1000.0)" }
})
