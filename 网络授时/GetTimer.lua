--GetTimer.lua
host = 'baidu.com'
port = 80
url = '/'
httpPKG = "HEAD " .. url .. " HTTP/1.1\r\nHost: " .. host .. "\r\nConnection: close\r\n\r\n"
curGMT = ""
bConnected = false
calibratedAfterPowerOn = false
tzone = 8 -- 东 8 区时区
sentCnt = 0
t2cnt = 1
t2target = 0
tmrBtn = 2
tmrCycled = 4
ioPWR = 1
ioCali = 2
-----------------------------
function adjustClock(hour, minute)
local cc
hour = hour % 12
minute = minute % 60
cc = hour * 60 + minute
print("========== Calibrated by Internet ================")
print(" Adjust clock to " .. hour .. ":" .. minute)
end
function constructConnection()
if bConnected == false then
socket = nil
socket = net.createConnection(net.TCP, 0)
socket:on("connection", function(sck, response)
bConnected = true
sentCnt = sentCnt + 1
--print("\r\n#### Conneted!\t\t&socket:", socket)
socket:send(httpPKG)
end)
socket:on("disconnection", function(sck, response)
bConnected = false
socket:close()
socket = nil
--print("#### Socket disconneted, @Count=" .. sentCnt ..", Heap=" .. node.heap())
end)
socket:on("receive", function(sck, response)
hh = nil
curGMT = string.sub(response,string.find(response,"Date: "),string.find(response,"Date: ")+35)
hh,mm,ss = string.match(curGMT, "(%d+)%d*:(%d+)%d*:(%d+)%d* GMT")
if hh ~= nil then
print("#### Get Internet time from " .. host, ((hh+tzone)%24)..":"..mm..":"..ss)
if (calibratedAfterPowerOn == false) or (hh + tzone == 24) then
calibratedAfterPowerOn = true
adjustClock(hh+tzone, mm)
end
end
end)
socket:connect(port, host)
end
end
constructConnection()
tmr.alarm(tmrCycled,3660000,1,function() constructConnection() end) --可以将 3660000 改为 5000 试试
tmr.start(tmrCycled)