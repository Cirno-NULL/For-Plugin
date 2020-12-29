command = {}
function isnum(text)
    return tonumber(text) ~= nil
end
--[[↑检查是不是数字]]
function jump_return(msgs, save, go_to)
    if go_to[msgs] ~= nil then
        --这里可以搞一个+1计数
        --这里必须要搞一个存档
        return fire[msgs]("stroy", msgs, save)
    else
        return "你目前还不能这么做\n现在你在这里:" .. string.sub(save.save, 2)
    end
end
--[[翻页返回
只是单纯的验证是否可以返回并且返回消息
]]
function choose_return(save, go_to)
    local rv = {}
    --[[防止出现各种奇奇怪怪的table的问题,新开一个变量好了]]
    rv = save
    for key, value in pairs(go_to) do
        if go_to[key][2] == nil then
            go_to[key][2] = 1
        end --[[如果key的第二个值是nil就变成1,对应的就是只能用一次的选项]]
        if rv.hasbeen[key] == nil then
            rv.hasbeen[key] = 0
        end --[[如果已到为nil就初始化为0]]
        if go_to[key][2] ~= nil then
            go_to[key][2] = 1
            rv.hasbeen[key] = 0
        end --[[如果key的第二个值不是nil就变成1,并且把已到变成0,对应的就是无限次数的选项]]
        if rv.hasbeen[key] < go_to[key][2] then
            table.insert(rv, "\n")
            table.insert(rv, string.sub(key, 2))
            table.insert(rv, " ：")
            table.insert(rv, go_to[key][1])
        end --[[很简单的key-选项]]
    end
    return table.concat(rv)
end
--[[返回可选项
    这里功能纯化,只返回类似ink里的+和*的类别
    具体就是如果第二个值是nil就类似ink里的*
    如果第二个值不是nil就类似ink里的+
    需要额外的特殊规则去自定义去,具体看a2
    传入值为存档和选项列表
]]
fire = {}
function fire.a0(type, msgs, save)
    local stroy = "你站在城镇的门口"
    local go_to = {["a1"] = {"前往地牢，让我们出发吧！"}}
    if type == "stroy" then
        return stroy .. choose_return(save, go_to)
    elseif type == "jump" then
        return jump_return(msgs, save, go_to)
    else
        return "未知问题0"
    end
end
function fire.a1(type, msgs, save)
    local stroy = "到了地牢门口"
    local go_to = {
        ["a3"] = {"进入地牢"},
        ["a2"] = {"返回城镇", ""}
    }
    if type == "stroy" then
        return stroy .. choose_return(save, go_to)
    elseif type == "jump" then
        return jump_return(msgs, save, go_to)
    else
        return "未知问题1"
    end
end
function fire.a2(type, msgs, save)
    local stroy = "确定返回城镇么？" -- 这里就是每一页的故事内容
    local go_to = {
        -- 这里是这一页的选项
        ["a0"] = {"是的", ""},
        ["a1"] = {"不", ""}
    }
    if type == "stroy" then
        --[[如果是故事模式,
        这里就是故事模式的时候可以做的各种动作了
        比如你可以穷举每一个选项之类的
        随你]]
        if isnum(save.hasbeen["a2"]) == false or save.hasbeen["a2"] < 3 then
            return stroy .. choose_return(save, go_to)
        else
            go_to.a3 = {"想得美，你无论如何也得给我下去！"}
            return go_to.a3[1] .. "\n" .. jump_return("a3", save, go_to)
        end
    elseif type == "jump" then -- 如果是跳转模式
        return jump_return(msgs, save, go_to)
    else -- 捕获其他可能性用的,也可以拿来当扩展
        return "未知问题2"
    end
end
function fire.a3(type, msgs, save)
    --这里可以删除存档了
    local stroy = "进入地牢中...\n开始探险ing...\n导入结束了"
    return stroy
end
function main_fire(msg)
    local rv = ""
    local save = nil
    -- local save = {
        -- ["save"] = "a1",
        -- ["hasbeen"] = {["a2"] = 3}
    -- }
    -- 模拟读取存档并转成json后的table
    local input = msg.str[1]
    input = "a" .. input
    if save == nil then
        save = {} -- 初始化存档
    end
    if save.hasbeen == nil then
        save.hasbeen = {} -- 初始化存档
    end
    if save.save == nil or save.save == "" then
        save.save = "a0"
        rv = rv .. "当前无存档,默认进入初始位置\n"
        rv = rv .. (fire[save.save]("stroy", "a0", save))
    elseif save.save == input then
        rv = rv .. (fire[save.save]("stroy", input, save))
    else
        rv = rv .. (fire[save.save]("jump", input, save))
    end
    return rv
end
-- local t_msg = {["str"] = {0}}
-- print(main_fire(t_msg)) -- 模拟消息输入并返回的过程
command[".test\\s?(\\d+)"] = "main_fire"
