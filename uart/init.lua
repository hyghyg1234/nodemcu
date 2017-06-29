gpio.mode(1, gpio.INPUT, gpio.PULLUP)

cnt = 0
tmr.alarm(0, 10000, tmr.ALARM_SINGLE, function()
    if(gpio.read(1) == 0) then 
        uart.setup(0, 256000, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)
        print("256000 8-n-1")
        uart.on("data", function(data)
            cnt = cnt + 1
            tmr.stop(1)
            tmr.interval(1, 1)
            tmr.start(1)
            uart.write(0, data)
        end, 0)
    else
        uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
        print("115200 8-n-1")
        uart.on("data")
    end
end)

tmr.register(1, 1, tmr.ALARM_SEMI, function()
    print("\n")
    print(cnt)
    print("\n")
end)
