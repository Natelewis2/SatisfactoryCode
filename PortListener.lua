--find NIC in computer
local NIC = computer.getPCIDevices(findClass("NetworkCard"))[1]
local internetNIC=computer.getPCIDevices(findClass("FINInternetCard"))[1]

for x=900,2000,1 do
  NIC:open(x)
end
  print("Ports opened")

event.ignoreAll()
event.clear()
event.listen(NIC)
local ports = {}

while true do

    e, s, senderaddr, port, stationName,item,count,loading,maxSize,flow = event.pull(1)


    if (e=="NetworkMessage") then
        --ports[x]=port,stationName
        --print(port,stationName,item,loading,maxSize,flow)

        if(stationName) then
          stationNameTrimmed = string.gsub(stationName," ","")
        else
          stationNameTrimmed = "ERROR"
        end

        if(item) then
          itemTrimmed = string.gsub(item," ","")
        else
          itemTrimmed = "ERROR"
        end


        itemTrimmed=string.gsub(item," ","")
        local req = internetNIC:request(("http://192.168.1.200:8000/home/UpdatePorts/"..port.."/"..stationNameTrimmed.."/"..itemTrimmed), "POST", "", "Content-Type", "text")
        local responseCode, libdata = req:await()
        --print(libdata)
        if(responseCode==200) then
          --print(responseCode)
        else
          print("Error on port: "..port)
          print(libdata)
        end

    end

end