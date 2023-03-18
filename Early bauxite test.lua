local greenThreshold = .7
local yellowThreshold = .3

local inputColumnX=10
local outputColumnX=85

local incomingItems={{"BauxiteOre",9600,"Bauxite Ore",90,96},{"Coal",9600,"Coal",92,97},{"Silica",19200,"Silica",94,98}}
local outgoingItems={{"AluminumIngot",9600,"Aluminum Ingot",80,86}}


local net = computer.getPCIDevices(findClass("NetworkCard"))[1]

local CentralComp="C42EA3B34C64AEF568730AB66017D154"
-- set up incoming buffers and stations



local inBuffers = {}
local inStations = {} 
for _, item in ipairs(incomingItems) do
  local StorageIDs=component.findComponent("InBuffer "..item[1])
  inBuffers[item[1]]=component.proxy(StorageIDs)
  inStations[item[1]]=component.proxy(component.findComponent("Station "..item[1])[1])
end

-- set up outgoing buffers and stations

local outBuffers = {}
local outStations = {} 
for _, item in ipairs(outgoingItems) do
  local StorageIDs=component.findComponent("OutBuffer "..item[1])
  outBuffers[item[1]]=component.proxy(StorageIDs)
  outStations[item[1]]=component.proxy(component.findComponent("Station "..item[1])[1])
end


while true do

  local cursor=2
  for _, item in ipairs(incomingItems) do
    if(inStations[item[1]]:getDockedLocomotive()) then
      net:broadcast(item[5],itemName,"Loading",1)
    else
      net:broadcast(item[5],itemName,"Loading",0)
    end

    local itemName=item[1]
    local itemCount=0
    for _, container in ipairs(inBuffers[itemName]) do
      
      itemCount = itemCount + container:getInventories()[1].itemCount

    end

    net:broadcast(item[4],itemName,"InputBuffer",itemCount)


    cursor=cursor+1
    local tempStation=inStations[item[1]]
    platform1=  inStations[item[1]]:getConnectedPlatform(0)
    platform2=platform1:getConnectedPlatform(platform1,0)
    stationInventory= platform1:getInventories()[1].itemCount + platform2:getInventories()[1].itemCount

    net:broadcast((item[4]+1),itemName,"Station",stationInventory)

    cursor = cursor+3
  end


  local cursor=2
  for _, item in ipairs(outgoingItems) do

    if(outStations[item[1]]:getDockedLocomotive()) then
      net:broadcast(item[5],itemName,"Loading",1)
    else
      net:broadcast(item[5],itemName,"Loading",0)
    end

    local itemName=item[1]
    local itemCount=0
    for _, container in ipairs(outBuffers[itemName]) do
      
      itemCount = itemCount + container:getInventories()[1].itemCount

    end

    net:broadcast(item[4],itemName,"OutputBuffer",itemCount)


    cursor=cursor+1
    local tempStation=outStations[item[1]]
    platform1=  outStations[item[1]]:getConnectedPlatform(0)
    platform2=platform1:getConnectedPlatform(platform1,0)
    stationInventory= platform1:getInventories()[1].itemCount + platform2:getInventories()[1].itemCount

    net:broadcast((item[4]+1),itemName,"Station",stationInventory)

    cursor = cursor+3
  end

  event.pull(.1)
end
