command = {}
local Sleep = require("sleep")
function sleeptest(msg)
    local rv = "收到消息时间："..os.date("%H:%M:%S") .. "\n"
    rv = rv .. Sleep.Sleep(msg.str[1]) -- 这里调用sleep模块,主要就是Sleep.Sleep(整数或者整数变量)
    rv = rv .. "\n延迟后返回时间：" .. os.date("%H:%M:%S")
    return rv
end
--[[这里是一个示例
触发词是sleeptest+数字
举例:sleeptest1
]]
command["sleeptest(\\d+)"] = "sleeptest"