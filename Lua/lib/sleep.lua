-- 定义一个名为 Null 的模块
Sleep = {}
function Sleep.Sleep(time)
    local path = dice.DiceDir() .. "\\plugin\\lib\\" --设置调用的路径
    path = string.gsub(path, "(\\.+ .*)", '"%1"') --清洗路径使之变得可用
    path = path .. "sleep.exe " .. time + 0 -- 加上调用的sleep模块和参数
    os.execute(dice.UTF8toGBK(path))
    return path
end
--[[注意：
传入的time只能是整数数字
否则绝对会出问题
以及没测试过太大的数字能不能行
]]
return Sleep
