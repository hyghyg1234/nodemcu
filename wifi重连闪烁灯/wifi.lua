-------------
-- define
-------------
IO_BLINK = 4
TMR_BLINK = 5

gpio.mode(IO_BLINK, gpio.OUTPUT)

-------------
-- blink
-------------
blink = nil
tmr.register(TMR_BLINK, 100, tmr.ALARM_AUTO, function()
    gpio.write(IO_BLINK, blink.i % 2)
    tmr.interval(TMR_BLINK, blink[blink.i + 1])
    blink.i = (blink.i + 1) % #blink
end)

function blinking(param)
    if type(param) == 'table' then
        blink = param
        blink.i = 0
        tmr.interval(TMR_BLINK, 1)
        running, _ = tmr.state(TMR_BLINK)
        if running ~= true then
            tmr.start(TMR_BLINK)
        end
    else
        tmr.stop(TMR_BLINK)
        gpio.write(IO_BLINK, param or gpio.LOW)
    end
end

-------------
-- wifi
-------------

--参数定义SSID PASSWORD wifi账号密码，Time自动重连时间间隔、单位ms
function wifiConnect(SSID, PASSWORD, Time)
    print('Setting up WIFI...')
    wifi.setmode(wifi.STATION)
    wifi.sta.config(SSID, PASSWORD)
    wifi.sta.autoconnect(1)
    wifi.sta.eventMonStart(Time)
end

status = nil

wifi.sta.eventMonReg(wifi.STA_WRONGPWD, function()
    blinking({100, 100 , 100, 500})
    status = 'STA_WRONGPWD'
    print(status)
end)

wifi.sta.eventMonReg(wifi.STA_APNOTFOUND, function()
    blinking({500, 500})
    status = 'STA_APNOTFOUND'
    print(status)
end) 

wifi.sta.eventMonReg(wifi.STA_CONNECTING, function(previous_State)
    blinking({300, 300})
    status = 'STA_CONNECTING'
    print(status)
end)

wifi.sta.eventMonReg(wifi.STA_GOTIP, function()
    blinking()
    status = 'STA_GOTIP'
    print("Config done, IP is "..wifi.sta.getip())
end)


