local net = computer.getPCIDevices(findClass("NetworkCard"))[1]
local radarTower = component.proxy(component.findComponent(findClass("Build_RadarTower_C"))[1])

local locationX = math.floor(radarTower.location.x/100)
local locationY = math.floor(radarTower.location.y/100)
local locationZ = math.floor(radarTower.location.z/100)

local startPort = 300
local portCursor = startPort
local factoryName="Rotor"

--local stations = component.findComponent("Station")

local stations = component.findComponent(findClass("Build_TrainStation_C"))

local dronePorts = component.findComponent(findClass("Build_DroneStation_C"))

while true do
  portCursor=startPort
    net:broadcast(portCursor,factoryName,locationX,locationY,locationZ)
    --print(portCursor,"Rotor",locationX,locationY,locationZ)

  --Process train stations
  for _, station in ipairs(stations) do

    --Station Instance
    local stationp=component.proxy(station)

    --Station Platforms
    local cargoPlatform1 = stationp:getConnectedPlatform()
    local cargoPlatform2 = cargoPlatform1:getConnectedPlatform()  

    --Flow Direction
    local flow=""
    if(cargoPlatform1.isUnloading) then
       flow="Unload"
    else
       flow="Load"
    end

    --Station Name
    local stationName=stationp.name

    --Station Loading
    if(stationp:getDockedLocomotive()) then
      stationLoading=true
    else
      stationLoading=false
    end

    --Station Cargo Count / Max Count
    local stationCargoName=cargoPlatform1:getInventories()[1]:getStack(1).item.type.name
    local stationCargo=cargoPlatform1:getInventories()[1].itemCount+cargoPlatform2:getInventories()[1].itemCount
    local maxCargo=cargoPlatform1:getInventories()[1]:getStack(1).item.type.max*48*2

    --Broadcast Status
    net:broadcast(portCursor+1,stationName,stationCargoName,stationCargo,stationLoading,maxCargo,flow)
    --print(portCursor+1,stationName,stationCargoName,stationCargo,maxCargo,stationLoading,flow)

    --Increment port for next station
    portCursor = portCursor+1
  end

  portCursor = startPort+50
  --Process Drone Ports
  for _, dronePort in ipairs(dronePorts) do
    local dronePortp = component.proxy(dronePort)
    local dronePortCargoName=dronePortp:getInventories()[1]:getStack(1).item.type.name
    local dronePortCargo=dronePortp:getInventories()[1].itemCount
    local maxDronePortCargo=dronePortp:getInventories()[1]:getStack(1).item.type.max*18
    net:broadcast(portCursor+1,"",dronePortCargoName,dronePortCargo,"",maxDronePortCargo,"")
    --print(portCursor+1,"DronePort",dronePortCargoName,dronePortCargo,nil,maxDronePortCargo,nil)
  end

event.pull(1)
end