command = {}
fire = {}
function fire.a0(type, msgs, save)
    local stroy = "一切的起始\f\f\f\f\f\f\f\f\f在很久很久以前~\n西方来了一群强盗\n将村里的月台毁了,结界也因此衰败破落\n现在,村里诞生了一名勇者\n是时候开始反击了!"
    local go_to = {["a1"] = "前往勇者小屋", ["a2"] = "前往演武场", ["a3"] = "前往村长家"}
    if type == "stroy" then
        return stroy
    elseif type == "skill" then
        return "待开发"
    elseif type == "jump" then
        return "待开发"
    end
end
function fire.a1(type, msgs, save)
    local stroy = "小屋里什么都没有"
    local go_to = {["a2"] = "前往演武场", ["a3"] = "前往村长家"}
    if type == "stroy" then
        return stroy
    elseif type == "skill" then
        return "待开发"
    elseif type == "jump" then
        return "待开发"
    end
end
function fire.a2(type, msgs, save)
    local stroy = "你来到了演武场\n演武场早已破败不堪\n你所知道的就是在演武场的深处有一把被封印的魔剑"
    local go_to = {["a4"] = "深入"}
    if type == "stroy" then
        return stroy
    elseif type == "skill" then
        return "待开发"
    elseif type == "jump" then
        return "待开发"
    end
end
function fire.a3(type, msgs, save)
    local stroy = "村长家离这里太远了,你还不足以支撑这么长途的跋涉"
    local go_to = {["a2"] = "前往演武场"}
    if type == "stroy" then
        return stroy
    elseif type == "skill" then
        return "待开发"
    elseif type == "jump" then
        return "待开发"
    end
end
function fire.a4(type, msgs, save)
    local stroy = "这只是一个实验品,所以到此为止了"
    if type == "stroy" then
        return stroy
    elseif type == "skill" then
        return "待开发"
    elseif type == "jump" then
        return "待开发"
    end
end
function main_fire(msg)
    local save = "a1"    -- 模拟读取存档
    local input = msg   -- 模拟消息输入
    input = "a" .. input
    if save == nil or save == "" then
        save = "a0" -- 初始化存档
    end
    if save == input then
        print (fire[input]("stroy",msg,save))
    else
        print ("jump")
    end
end
main_fire(0)

command[".test\\s?(\\d)"] = "main_fire"

--[[
极端环境:
    1.骰点
        成功跳转a
        失败后跳转b
    2.星状路径,最多能进入四次
        与
    3.进入不存在的编号&进入当前页码去不了的编号
    4.人物死亡
]]
--[[
预处理需要的是:
    存档文件
    输入消息
书页需要输入的是:
    1:输入类型
    2.存档
    3.输入内容
书页
    内置的是:
        各种逻辑指令
    外置的是:
        故事本体
]]
--[[
输入模式
    .fire
        跳转
        故事
    .fire ra
        骰点
预处理
    读取存档数字
    .fire类
        如果存档数字不等于输入编号
            跳转标记
        如果存档数字等于输入编号
            故事标记
    .firera类
        骰点标记
    然后输入到页面里并获取返回值输出
页面
    跳转标记
        计算输入编号的可行性
            跳转模块
                页面次数+1
                type转为故事标记

    故事标记
        直接输出故事
        然后给出选项
        选项自动减少
        次数到了以后强制跳转
            选项模块
            跳转模块
    骰点标记
        骰点模块
]]
