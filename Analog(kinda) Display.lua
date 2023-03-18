local greenThreshold = .7
local yellowThreshold = .2

local panel = component.proxy("FDBEFCAB499D240D416EC7B17D230FCD")

local EIBStorageIDs=component.findComponent("OutBuffer EIB")
local EIBStorages = component.proxy(EIBStorageIDs)
local EIBBufferLabel=panel:getModule(0,9,0)

local EIBStationLabel=panel:getModule(0,7,0)
local EIBStation=component.proxy("03FB783345F71B016B65EAB88A50E630")
local EIBStationPlatform1=EIBStation:getConnectedPlatform(0)
local EIBStationPlatform2 = EIBStationPlatform1.getConnectedPlatform(EIBStationPlatform1)

local EIBGauge=panel:getModule(0,4,0)
EIBGauge.limit=19200

local EIBLamp=panel:getModule(0,3,0)
local EIBLoadingLamp=panel:getModule(0,2,0)



local SteelBeamStorageIDs=component.findComponent("OutBuffer SteelBeam")
local SteelBeamStorages = component.proxy(SteelBeamStorageIDs)
local SteelBeamBufferLabel=panel:getModule(2,9,0)

local SteelBeamStationLabel=panel:getModule(2,7,0)
local SteelBeamStation=component.proxy("9BBB026B44818703D839A0B60EC3C6D3")
local SteelBeamStationPlatform1=SteelBeamStation:getConnectedPlatform(0)
local SteelBeamStationPlatform2 = SteelBeamStationPlatform1.getConnectedPlatform(SteelBeamStationPlatform1)

local SteelBeamGauge=panel:getModule(2,4,0)
SteelBeamGauge.limit=38400

local SteelBeamLamp=panel:getModule(2,3,0)
local SteelBeamLoadingLamp=panel:getModule(2,2,0)


local SteelPipeStorageIDs=component.findComponent("OutBuffer SteelPipe")
local SteelPipeStorages = component.proxy(SteelPipeStorageIDs)
local SteelPipeBufferLabel=panel:getModule(4,9,0)

local SteelPipeStationLabel=panel:getModule(4,7,0)
local SteelPipeStation=component.proxy("380B699D4AA1EBA750DFD4ABDB7E54F5")
local SteelPipeStationPlatform1=SteelPipeStation:getConnectedPlatform(0)
local SteelPipeStationPlatform2 = SteelPipeStationPlatform1.getConnectedPlatform(SteelPipeStationPlatform1)

local SteelPipeGauge=panel:getModule(4,4,0)
SteelPipeGauge.limit=38400

local SteelPipeLamp=panel:getModule(4,3,0)
local SteelPipeLoadingLamp=panel:getModule(4,2,0)


local IronIngotStorageIDs=component.findComponent("InBuffer IronIngot")
local IronIngotStorages = component.proxy(IronIngotStorageIDs)
local IronIngotBufferLabel=panel:getModule(7,9,0)

local IronIngotStationLabel=panel:getModule(7,7,0)
local IronIngotStation=component.proxy("FA1518BF40FC436B92F3B8973A8FB9C0")
local IronIngotStationPlatform1=IronIngotStation:getConnectedPlatform(0)
local IronIngotStationPlatform2 = IronIngotStationPlatform1.getConnectedPlatform(IronIngotStationPlatform1)

local IronIngotGauge=panel:getModule(7,4,0)
IronIngotGauge.limit=19200

local IronIngotLamp=panel:getModule(7,3,0)
local IronIngotLoadingLamp=panel:getModule(7,2,0)


local CoalStorageIDs=component.findComponent("InBuffer Coal")
local CoalStorages = component.proxy(CoalStorageIDs)
local CoalBufferLabel=panel:getModule(9,9,0)

local CoalStationLabel=panel:getModule(9,7,0)
local CoalStation=component.proxy("41660DF54271AFAA495749A9341AC076")
local CoalStationPlatform1=CoalStation:getConnectedPlatform(0)
local CoalStationPlatform2 = CoalStationPlatform1.getConnectedPlatform(CoalStationPlatform1)

local CoalGauge=panel:getModule(9,4,0)
CoalGauge.limit=19200

local CoalLamp=panel:getModule(9,3,0)
local CoalLoadingLamp=panel:getModule(9,2,0)

while true do

--EIB
  bufferEIB=0
  for _, container in ipairs(EIBStorages) do
    bufferEIB = bufferEIB + container:getInventories()[1].itemCount
  end
  EIBBufferLabel:setText(bufferEIB)

  stationEIB=0
  stationEIB= stationEIB+EIBStationPlatform1:getInventories()[1].itemCount
  stationEIB= stationEIB+EIBStationPlatform2:getInventories()[1].itemCount
  EIBStationLabel:setText(stationEIB)

  EIBGauge.percent=(stationEIB+bufferEIB)/EIBGauge.limit

  if(EIBGauge.percent>=greenThreshold) then
    EIBLamp:setColor(0,255,0,.001)
  elseif(EIBGauge.percent<greenThreshold and EIBGauge.percent>=yellowThreshold) then
    EIBLamp:setColor(255,255,0,.001)
  else
    EIBLamp:setColor(255,0,0,.001)
  end

  if(EIBStation:getDockedLocomotive()) then
   EIBLoadingLamp:setColor(215,72,38,.001)
  else
   EIBLoadingLamp:setColor(0,0,0,0)
  end

--Steel Beam
  bufferSteelBeam=0
  for _, container in ipairs(SteelBeamStorages) do
    bufferSteelBeam = bufferSteelBeam + container:getInventories()[1].itemCount
  end
  SteelBeamBufferLabel:setText(bufferSteelBeam)

  stationSteelBeam=0
  stationSteelBeam= stationSteelBeam+SteelBeamStationPlatform1:getInventories()[1].itemCount
  stationSteelBeam= stationSteelBeam+SteelBeamStationPlatform2:getInventories()[1].itemCount
  SteelBeamStationLabel:setText(stationSteelBeam)

  SteelBeamGauge.percent=(stationSteelBeam+bufferSteelBeam)/SteelBeamGauge.limit

  if(SteelBeamGauge.percent>=greenThreshold) then
    SteelBeamLamp:setColor(0,255,0,.001)
  elseif(SteelBeamGauge.percent<greenThreshold and SteelBeamGauge.percent>=YellowThreshold) then
    SteelBeamLamp:setColor(255,255,0,.001)
  else
    SteelBeamLamp:setColor(255,0,0,.001)
  end

  if(SteelBeamStation:getDockedLocomotive()) then
   SteelBeamLoadingLamp:setColor(215,72,38,.001)
  else
   SteelBeamLoadingLamp:setColor(0,0,0,0)
  end

--Steel Pipe
  bufferSteelPipe=0
  for _, container in ipairs(SteelPipeStorages) do
    bufferSteelPipe = bufferSteelPipe + container:getInventories()[1].itemCount
  end
  SteelPipeBufferLabel:setText(bufferSteelPipe)

  stationSteelPipe=0
  stationSteelPipe= stationSteelPipe+SteelPipeStationPlatform1:getInventories()[1].itemCount
  stationSteelPipe= stationSteelPipe+SteelPipeStationPlatform2:getInventories()[1].itemCount
  SteelPipeStationLabel:setText(stationSteelPipe)

  SteelPipeGauge.percent=(stationSteelPipe+bufferSteelPipe)/SteelPipeGauge.limit

  if(SteelPipeGauge.percent>=greenThreshold) then
    SteelPipeLamp:setColor(0,255,0,.001)
  elseif(SteelPipeGauge.percent<greenThreshold and SteelPipeGauge.percent>=yellowThreshold) then
    SteelPipeLamp:setColor(255,255,0,.001)
  else
    SteelPipeLamp:setColor(255,0,0,.001)
  end

  if(SteelPipeStation:getDockedLocomotive()) then
   SteelPipeLoadingLamp:setColor(215,72,38,.001)
  else
   SteelPipeLoadingLamp:setColor(0,0,0,0)
  end


--Iron Ingot
  bufferIronIngot=0
  for _, container in ipairs(IronIngotStorages) do
    bufferIronIngot = bufferIronIngot + container:getInventories()[1].itemCount
  end
  IronIngotBufferLabel:setText(bufferIronIngot)

  stationIronIngot=0
  stationIronIngot= stationIronIngot+IronIngotStationPlatform1:getInventories()[1].itemCount
  stationIronIngot= stationIronIngot+IronIngotStationPlatform2:getInventories()[1].itemCount
  IronIngotStationLabel:setText(stationIronIngot)

  IronIngotGauge.percent=(stationIronIngot+bufferIronIngot)/IronIngotGauge.limit

  if(IronIngotGauge.percent>=greenThreshold) then
    IronIngotLamp:setColor(0,255,0,.001)
  elseif(IronIngotGauge.percent<greenThreshold and IronIngotGauge.percent>=yellowThreshold) then
    IronIngotLamp:setColor(255,255,0,.001)
  else
    IronIngotLamp:setColor(255,0,0,.001)
  end

  if(IronIngotStation:getDockedLocomotive()) then
   IronIngotLoadingLamp:setColor(215,72,38,.001)
  else
   IronIngotLoadingLamp:setColor(0,0,0,0)
  end

--Coal
  bufferCoal=0
  for _, container in ipairs(CoalStorages) do
    bufferCoal = bufferCoal + container:getInventories()[1].itemCount
  end
  CoalBufferLabel:setText(bufferCoal)

  stationCoal=0
  stationCoal= stationCoal+CoalStationPlatform1:getInventories()[1].itemCount
  stationCoal= stationCoal+CoalStationPlatform2:getInventories()[1].itemCount
  CoalStationLabel:setText(stationCoal)

  CoalGauge.percent=(stationCoal+bufferCoal)/CoalGauge.limit

  if(CoalGauge.percent>=greenThreshold) then
    CoalLamp:setColor(0,255,0,.001)
  elseif(CoalGauge.percent<greenThreshold and CoalGauge.percent>=yellowThreshold) then
    CoalLamp:setColor(255,255,0,.001)
  else
    CoalLamp:setColor(255,0,0,.001)
  end

  if(CoalStation:getDockedLocomotive()) then
   CoalLoadingLamp:setColor(215,72,38,.001)
  else
   CoalLoadingLamp:setColor(0,0,0,0)
  end

event.pull(.1)
end
