--wifi
require "wifi"
dofile("wifi.lua")
MY_SSID = "T440"
MY_PASSWORD = "88888888"

--wifi连接，并设定自动重连时间
wifiConnect(MY_SSID, MY_PASSWORD, 1000)

