--local computer=component.proxy("4F4F7A234FA4CD24F6EEE39491031023")
local net = computer.getPCIDevices(findClass("NetworkCard"))[1]
local mainMonitor = component.proxy(component.findComponent("CentralNet"))
print(mainMonitor)
local CentralComp="C42EA3B34C64AEF568730AB66017D154"

local panel = component.proxy("33FD2B8843DF387234BE35B5DB3B9104")
local outputStation = component.proxy("FB04A45A4B059274336FCBA0EC2108E8")
local inputStation = component.proxy("593178864932511C4423B78B9F2F4A8C")

local sulfurInputStorageIDs=component.findComponent("Sulfur WH InputBuffer")
local sulfurInputStorages = component.proxy(sulfurInputStorageIDs)

local sulfurWHStorageIDs=component.findComponent("Sulfur WH WHBuffer")
local sulfurWHStorages = component.proxy(sulfurWHStorageIDs)

local sulfurOutputStorageIDs=component.findComponent("Sulfur WH OutputBuffer")
local sulfurOutputStorages = component.proxy(sulfurOutputStorageIDs)
  
local labelSign = component.proxy("9389F8F945BBDC93141818A57B7743C0")
local indicatorPole = component.proxy("7C847F7F4939676547C517BDBEAE6470")

local labelTextSize=75
local IOMax=9600
local WHMax=28800

local inputStationLamp=panel:getModule(8,2,0)
local outputStationLamp=panel:getModule(8,8,0)

InputBufferLabel=panel:getModule(0,0,0)
InputBufferLabel.size=labelTextSize
InputBufferLamp=panel:getModule(4,2,0)
InputBufferLamp:setColor(0,0,0,0)
InputBufferGuage=panel:getModule(4,1,0)
InputBufferGuage.limit=IOMax

WHBufferLabel=panel:getModule(0,4,0)
WHBufferLabel.size=labelTextSize
WHBufferLamp=panel:getModule(4,5,0)
WHBufferLamp:setColor(0,0,0,0)
WHBufferGuage=panel:getModule(4,3,0)
WHBufferGuage.limit=WHMax

OutputBufferLabel=panel:getModule(0,7,0)
OutputBufferLabel.size=labelTextSize
OutputBufferLamp=panel:getModule(4,8,0)
OutputBufferLamp:setColor(0,0,0,0)
OutputBufferGuage=panel:getModule(4,6,0)
OutputBufferGuage.limit=IOMax



while true do

  if(inputStation:getDockedLocomotive()) then
   inputStationLamp:setColor(215,72,38,.001)
  else
   inputStationLamp:setColor(0,0,0,0)
  end

  if(outputStation:getDockedLocomotive()) then
   outputStationLamp:setColor(215,72,38,.001)
  else
   outputStationLamp:setColor(0,0,0,0)
  end

--Input Buffer
  totalSulfur=0
  for _, container in ipairs(sulfurInputStorages) do
    totalSulfur = totalSulfur + container:getInventories()[1].itemCount
  end

  InputBufferLabel.text=totalSulfur
  if((totalSulfur / IOMax)>.75) then
   InputBufferLamp:setColor(0,255,0,.001)
  
  elseif ((totalSulfur / IOMax)<=.75 and (totalSulfur / IOMax)>.25) then
   InputBufferLamp:setColor(255,255,0,.001)
  
  else
   InputBufferLamp:setColor(255,0,0,.01)
  end 

  InputBufferGuage.percent=(totalSulfur / IOMax)

  net:send(CentralComp,10,"Sulfur","InputBuffer",totalSulfur)

  --event.pull(.1)
--WH Buffer------------------
  totalSulfur=0
  for _, container in ipairs(sulfurWHStorages) do
    totalSulfur = totalSulfur + container:getInventories()[1].itemCount
  end
  WHBufferLabel.text=totalSulfur
  if((totalSulfur / WHMax)>.75) then
   WHBufferLamp:setColor(0,255,0,.001)
  
  elseif ((totalSulfur / WHMax)<=.75 and (totalSulfur / WHMax)>.25) then
   WHBufferLamp:setColor(255,255,0,.001)
  
  else
   WHBufferLamp:setColor(255,0,0,.01)
  end 

  WHBufferGuage.percent=(totalSulfur / WHMax)
  net:send(CentralComp,11,"Sulfur","WHBuffer",totalSulfur)

  --event.pull(.1)
--Output Buffer---------------
  totalSulfur=0
  for _, container in ipairs(sulfurOutputStorages) do
    totalSulfur = totalSulfur + container:getInventories()[1].itemCount
  end


  OutputBufferLabel.text=totalSulfur
  if((totalSulfur / IOMax)>.75) then
   OutputBufferLamp:setColor(0,255,0,.001)
  
  elseif ((totalSulfur / IOMax)<=.75 and (totalSulfur / IOMax)>.25) then
   OutputBufferLamp:setColor(255,255,0,.001)
  
  else
   OutputBufferLamp:setColor(255,0,0,.01)
  end 

  OutputBufferGuage.percent=(totalSulfur / IOMax)

  net:send(CentralComp,12,"Sulfur","OutputBuffer",totalSulfur)
  event.pull(1)
end

