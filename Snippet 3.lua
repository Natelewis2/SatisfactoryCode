local greenThreshold = .7
local yellowThreshold = .3

local inputColumnX=10
local outputColumnX=85

local incomingItems={{"CopperIngot",9600,"Copper Ingot",70,76},{"AluminumIngot",9600,"Aluminum Ingot",72,77},{"CopperSheet",19200,"Copper Sheet",74,78}}
local outgoingItems={{"Alclad",19200,"Alclad Aluminum Sheet",60,66},{"AluminumCase",19200,"Aluminum Casing",62,67},{"Heatsink",9600,"Heat sink",64,68}}

-- get first T1 GPU avialable from PCI-Interface
local gpu = computer.getPCIDevices(findClass("GPUT1"))[1]
if not gpu then
 error("No GPU T1 found!")
end

local comp = component.findComponent(findClass("Screen"))[1]
if not comp then
 error("No Screen found!")
end
screen = component.proxy(comp)

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

-- setup gpu
event.listen(gpu)
gpu:bindScreen(screen)
w, h = gpu:getSize()

print(w,h)

-- clear background
gpu:setBackground(0,0,0,0)
gpu:fill(0, 0, w, h, " ", " ")
gpu:flush()


while true do
  gpu:fill(0, 0, w, h, " ", " ")
  
  gpu:setForeground(1,1,1,1)

  local cursor=2
  for _, item in ipairs(incomingItems) do
    gpu:setForeground(1,1,1,1)
    if(inStations[item[1]]:getDockedLocomotive()) then
      gpu:setText(inputColumnX,cursor,item[3].." (LOADING)")
      net:send(CentralComp,item[5],itemName,"Loading",1)
    else
      gpu:setText(inputColumnX,cursor,item[3])
      net:send(CentralComp,item[5],itemName,"Loading",0)
    end

    local itemName=item[1]
    local itemCount=0
    for _, container in ipairs(inBuffers[itemName]) do
      
      itemCount = itemCount + container:getInventories()[1].itemCount

    end
    gpu:setText(inputColumnX+2,cursor+1,itemCount)
--print (itemCount)

    if((itemCount/item[2])>greenThreshold) then
      gpu:setForeground(0,255,0,1)
    elseif((itemCount/item[2])<=greenThreshold and (itemCount/item[2])>yellowThreshold) then
      gpu:setForeground(255,255,0,1)
    else
      gpu:setForeground(255,0,0,1)
    end
    gpu:setText(inputColumnX+2,cursor+1,"Input Buffer: "..itemCount)

    net:send(CentralComp,item[4],itemName,"InputBuffer",itemCount)
    --print(item[4],itemName,itemCount)

    cursor=cursor+1
    local tempStation=inStations[item[1]]
    platform1=  inStations[item[1]]:getConnectedPlatform(0)
    platform2=platform1:getConnectedPlatform(platform1,0)
    stationInventory= platform1:getInventories()[1].itemCount + platform2:getInventories()[1].itemCount

    if((stationInventory/item[2])>greenThreshold) then
      gpu:setForeground(0,255,0,1)
    elseif((stationInventory/item[2])<=greenThreshold and (stationInventory/item[2])>yellowThreshold) then
      gpu:setForeground(255,255,0,1)
    else
      gpu:setForeground(255,0,0,1)
    end
    gpu:setText(inputColumnX+2,cursor+1,"Station: "..stationInventory)

    net:send(CentralComp,(item[4]+1),itemName,"Station",stationInventory)
    --print(item[4]+1,itemName,itemCount)
    cursor = cursor+3
  end

  gpu:setForeground(1,1,1,1)
  --gpu:setText(outputColumnX+10,0,"Outgoing")



  local cursor=2
  for _, item in ipairs(outgoingItems) do
    gpu:setForeground(1,1,1,1)
    if(outStations[item[1]]:getDockedLocomotive()) then
      gpu:setText(outputColumnX,cursor,item[3].." (LOADING)")
      net:send(CentralComp,item[5],itemName,"Loading",1)
    else
      gpu:setText(outputColumnX,cursor,item[3])
      net:send(CentralComp,item[5],itemName,"Loading",0)
    end

    local itemName=item[1]
    local itemCount=0
    for _, container in ipairs(outBuffers[itemName]) do
      
      itemCount = itemCount + container:getInventories()[1].itemCount

    end
    gpu:setText(outputColumnX+2,cursor+1,itemCount)

    if((itemCount/item[2])>greenThreshold) then
      gpu:setForeground(0,255,0,1)
    elseif((itemCount/item[2])<=greenThreshold and (itemCount/item[2])>yellowThreshold) then
      gpu:setForeground(255,255,0,1)
    else
      gpu:setForeground(255,0,0,1)
    end
    gpu:setText(outputColumnX+2,cursor+1,"Output Buffer: "..itemCount)
    net:send(CentralComp,item[4],itemName,"OutputBuffer",itemCount)


    cursor=cursor+1
    local tempStation=outStations[item[1]]
    platform1=  outStations[item[1]]:getConnectedPlatform(0)
    platform2=platform1:getConnectedPlatform(platform1,0)
    stationInventory= platform1:getInventories()[1].itemCount + platform2:getInventories()[1].itemCount

    if((stationInventory/item[2])>greenThreshold) then
      gpu:setForeground(0,255,0,1)
    elseif((stationInventory/item[2])<=greenThreshold and (stationInventory/item[2])>yellowThreshold) then
      gpu:setForeground(255,255,0,1)
    else
      gpu:setForeground(255,0,0,1)
    end
    gpu:setText(outputColumnX+2,cursor+1,"Station: "..stationInventory)
    net:send(CentralComp,(item[4]+1),itemName,"Station",stationInventory)

    cursor = cursor+3
  end



  gpu:flush()
  event.pull(.1)
end
