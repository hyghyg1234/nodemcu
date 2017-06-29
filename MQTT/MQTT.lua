m = mqtt.Client("Node_MM", 30)

m:lwt("node", "lwt", 0, 0)
m:on("connect", function(client) 
    m:publish("node", "online", 0, 0)
    m:subscribe("pc", 0, function(client) 
        print("subscribe success")
    end)
end)
m:on("offline", function(client)
    print("offline")
end)

m:on("message", function(client, topic, data)
    print(topic .. ": ")
    if data ~= nil then
        print(data)
		if (string.find(data,"OPEN") ~= nil) then
			gpio.write(led, gpio.LOW)
            gpio.write(RELAY, gpio.HIGH)         
		elseif (string.find(data,"CLOSE") ~= nil) then
			gpio.write(led, gpio.HIGH)
            gpio.write(RELAY, gpio.LOW)
		end
    end
end)

--m:connect("iot.eclipse.org")
m:connect("103.13.221.30")
--m:connect("127.0.0.1")
--led 
led = 4  
gpio.mode(led, gpio.OUTPUT) 
--RELAY
RELAY = 2  
gpio.mode(RELAY, gpio.OUTPUT)
