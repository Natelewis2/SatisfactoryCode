local net = computer.getPCIDevices(findClass("NetworkCard"))[1]
local monitorComputer="16F13B23453005B9F006FABE7F3F1B1A"

local startPort = 100
local portCursor = startPort

local stations = component.findComponent("Station")
while true do
  portCursor=startPort
    net:send(monitorComputer,portCursor,"Rotor")
--print(portCursor,"Rotor")
  for _, station in ipairs(stations) do
    --Station Name
    local stationp=component.proxy(station)

    local cargoPlatform1 = stationp:getConnectedPlatform()
    local cargoPlatform2 = cargoPlatform1:getConnectedPlatform()  
    local flow="Unload"
    if(cargoPlatform1.isUnloading) then
       flow="Unload"
    else
       flow="Load"
    end

    local stationName=stationp.name

    local stationLoading = false

    if(stationp:getDockedLocomotive()) then
      stationLoading=true
    else
      stationLoading=false
    end

    local stationCargoName=cargoPlatform1:getInventories()[1]:getStack(1).item.type.name
    local stationCargo=cargoPlatform1:getInventories()[1].itemCount+cargoPlatform2:getInventories()[1].itemCount
    local maxCargo=cargoPlatform1:getInventories()[1]:getStack(1).item.type.max*48*2

    net:send(monitorComputer,portCursor+1,stationName,stationCargoName,stationCargo,stationLoading,maxCargo,flow)
    --print(portCursor+1,stationName,stationCargoName,stationCargo,maxCargo,stationLoading,flow)

    portCursor = portCursor+1
  end
event.pull(1)
end