--init.lua
print("set up wifi")
wifi.setmode(wifi.STATION)
wifi.sta.config("T440","88888888") --这里设置你的 WIFI 名字和密码
--wifi.sta.config("TP-LINK_504","18626183405") --这里设置你的 WIFI 名字和密码
wifi.sta.connect()
tmr.alarm(1, 1000, tmr.ALARM_AUTO, function()
if wifi.sta.getip()== nil then
print("IP unavaiable, Waiting...")
else tmr.stop(1)
print("Config done, IP is "..wifi.sta.getip())
print("do MQTT.lua")
dofile("MQTT.lua")
end
end)
