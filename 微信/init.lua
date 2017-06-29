--init.lua
print("set up wifi")
wifi.setmode(wifi.STATION)
--wifi.sta.config("TP-LINK_504","18626183405")
wifi.sta.config("Motor","18626183405")
--wifi.sta.config("T440","88888888") --这里设置你的 WIFI 名字和密码
wifi.sta.autoconnect(1)
tmr.alarm(1, 500, tmr.ALARM_AUTO, function()
	if wifi.sta.getip()== nil then
		print("IP unavaiable, Waiting...")
	else 
		tmr.stop(1)
		print("Config done, IP is "..wifi.sta.getip())
		tmr.start(0)
		tmr.start(2)
	end
end)

--dht11
--url = "http://103.13.221.30/weixin"
url = "http://1.hygxm1.applinzi.com/weixin"
pin = 1
function dht11()
    status, temp, humi, temp_dec, humi_dec = dht.read(pin)
    if status == dht.OK then
        -- Integer firmware using this example
        -- print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
              -- math.floor(temp),
              -- temp_dec,
              -- math.floor(humi),
              -- humi_dec
        -- ))
    
        --Float firmware using this example
        --print("DHT Temperature:"..temp..";".."Humidity:"..humi)
		http.get(url.."/GET.php?temp="..temp.."&humi="..humi, nil, function(code, data)
			if (code > 0) then
				print("DHT update")
			end
		end)
    end
end
tmr.register(0, 3000, tmr.ALARM_AUTO, dht11)



--led 
led = 4  
gpio.mode(led, gpio.OUTPUT)  
function http_led()
	http.get(url.."/GET.php?control=1", nil, function(code, data)
			if (code > 0) then
				if (string.find(data,"OPEN") ~= nil) then
					print("OPEN")
					gpio.write(led, gpio.LOW)
				else 
					print("CLOSE")
					gpio.write(led, gpio.HIGH)
				end
			end
		end)
end
tmr.register(2, 1000, tmr.ALARM_AUTO, http_led)



