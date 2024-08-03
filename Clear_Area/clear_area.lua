-- Register the command /cleararea
RegisterCommand("cleararea", function(source, args, rawCommand)
    -- Get player ped
    local playerPed = PlayerPedId()
    -- Get player coordinates
    local playerCoords = GetEntityCoords(playerPed)

    -- Set default radius
    local radius = 30.0

    -- Check if radius is provided in command arguments
    if #args > 0 then
        radius = tonumber(args[1]) or 30.0
    end

    -- Log to console
    print(string.format("Clearing area around player with radius: %.2f", radius))

    -- Clear area using natives
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

    -- Force clear entities if natives fail
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

    -- Notify player
    TriggerEvent('chat:addMessage', {
        args = { "Area cleared!" }
    })
end, false)

-- Add a suggestion for the command in chat
TriggerEvent('chat:addSuggestion', '/cleararea', 'Clears all objects, peds, and vehicles in a specified radius', {
    { name="radius", help="Radius to clear (default is 30.0)" }
})
