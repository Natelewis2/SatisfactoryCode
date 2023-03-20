
----CHANGE ON NEW BUILD----
local startPort = 1100
local factoryName="PlasticRubber2"
local updateFrequency=1 --event.pull(X) at end of loop
local syncFrequency=30 --Syncs to webserver every X seconds
local debug=false
-----------------------------------

local portCursor = startPort


local net = computer.getPCIDevices(findClass("NetworkCard"))[1]
local internetNIC=computer.getPCIDevices(findClass("FINInternetCard"))[1]

local radarTower = component.proxy(component.findComponent(findClass("Build_RadarTower_C"))[1])

local locationX = math.floor(radarTower.location.x/100)
local locationY = math.floor(radarTower.location.y/100)
local locationZ = math.floor(radarTower.location.z/100)

local syncCounter=0


--local stations = component.findComponent("Station")

local stations = component.findComponent(findClass("Build_TrainStation_C"))

local dronePorts = component.findComponent(findClass("Build_DroneStation_C"))

while true do
  syncCounter = syncCounter+1


  portCursor=startPort
    --Station Identification on startPort, train stations start at port xxx01
    net:broadcast(portCursor,factoryName,locationX,locationY,locationZ,"ID","ID")
    if(debug) then
      print(portCursor,factoryName,locationX,locationY,locationZ,"ID","ID")
    end

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
    local stationCargoName=cargoPlatform1:getInventories()[1]:getStack(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18).item.type.name
    local stationCargo=cargoPlatform1:getInventories()[1].itemCount+cargoPlatform2:getInventories()[1].itemCount
    local maxCargo=cargoPlatform1:getInventories()[1]:getStack(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18).item.type.max*48*2


    --Broadcast Status
    net:broadcast(portCursor+1,stationName,stationCargoName,stationCargo,stationLoading,maxCargo,flow)

    if(syncCounter>=syncFrequency) then
      stationCargoNameTrimmed=string.gsub(stationCargoName," ","")
      stationNameTrimmed = string.gsub(stationName," ","")

      local req = internetNIC:request(("http://192.168.1.200:8000/home/UpdatePorts/"..(portCursor+1).."/"..stationNameTrimmed.."/"..stationCargoNameTrimmed), "POST", "", "Content-Type", "text")
      local responseCode, libdata = req:await()
    end

    if(debug) then
      print(portCursor+1,stationName,stationCargoName,stationCargo,stationLoading,maxCargo,flow)
    end

    --Increment port for next station
    portCursor = portCursor+1
  end

  portCursor = startPort+51



  --Process Drone Ports, Drones start at port xxx51
  --No loading status, haven't figured this one out yet
  for _, dronePort in ipairs(dronePorts) do
    local dronePortp = component.proxy(dronePort)
    local dronePortCargo=dronePortp:getInventories()[1].itemCount

    local dronePortCargoName=dronePortp:getInventories()[1]:getStack(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18).item.type.name
--print (dronePortCargoName)
    local maxDronePortCargo=dronePortp:getInventories()[1]:getStack(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18).item.type.max*18
--print(maxDronePortCargo)
    --else
      --local dronePortCargoName="UNK"
      --local maxDronePortCargo="UNK"
    --end

    --Broadcast Drone Status
    net:broadcast(portCursor,"DRONE",dronePortCargoName,dronePortCargo,"DRONE",maxDronePortCargo,"DRONE")

    if(syncCounter>=syncFrequency) then
      stationCargoNameTrimmed=string.gsub(dronePortCargoName," ","")
      --stationNameTrimmed = string.gsub(stationName," ","")

      local req = internetNIC:request(("http://192.168.1.200:8000/home/UpdatePorts/"..(portCursor).."/DRONE/"..stationCargoNameTrimmed), "POST", "", "Content-Type", "text")
      local responseCode, libdata = req:await()
    end

    if(debug) then
      print(portCursor,"DRONE",dronePortCargoName,dronePortCargo,"DRONE",maxDronePortCargo,"DRONE")
    end
    portCursor = portCursor+1
  end
  if(syncCounter>=syncFrequency) then
    syncCounter=0
    print("Synced to database")
  end
event.pull(updateFrequency)
end