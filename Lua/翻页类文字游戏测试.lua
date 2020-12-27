command = {}
fire = {}
function jump_return(msgs, save, go_to)
    if go_to[msgs] ~= nil then
        --这里可以搞一个+1计数
        return (fire[msgs]("stroy", msgs, save))
    else
        return "你目前还不能这么做"
    end
end
function choose_return(save, go_to)
    local rv = {}
    if save["hasbeen"] == nil then
        save["hasbeen"] = {}
    end
    for key, value in pairs(go_to) do
        if go_to[key][2] == nil then
            go_to[key][2] = 1
        end
        if go_to[key][2] ~= nil then
            go_to[key][2] = 1
            save.hasbeen[key] = 0
        end
        if save.hasbeen[key] == nil then
            save.hasbeen[key] = 0
        end
        if save.hasbeen[key] < go_to[key][2] then
            table.insert(rv, "\n")
            table.insert(rv, string.sub(key, 2))
            table.insert(rv, " ：")
            table.insert(rv, go_to[key][1])
        end
    end
    return table.concat(rv)
end
--[[
列出可选项目需要:
1. 选项可用
2. 选项在次数范围内
]]
function fire.a0(type, msgs, save)
    local stroy = "你站在城镇的门口"
    local go_to = {["a1"] = {"前往地牢，让我们出发吧！"}}
    local choose = choose_return(save, go_to)
    if type == "stroy" then
        return stroy .. choose
    elseif type == "skill" then
        return "待开发"
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
    local choose = choose_return(save, go_to)
    if type == "stroy" then
        return stroy .. choose
    elseif type == "skill" then
        return "待开发"
    elseif type == "jump" then
        return jump_return(msgs, save, go_to)
    else
        return "未知问题1"
    end
end
function fire.a2(type, msgs, save)
    local stroy = "确定返回城镇么？"
    local go_to = {
        ["a0"] = {"是的", ""},
        ["a1"] = {"不", ""},
        ["a3"] = {"想得美，你无论如何也得给我下去！"}
    }
    local choose = choose_return(save, go_to)
    if type == "stroy" then
        print(save.hasbeen["a2"])
        if save.hasbeen["a2"] < 3 then
            return stroy .. choose
        else
            return go_to.a3[1].."\n\n"..jump_return("a3", save, go_to)
        end
    elseif type == "skill" then
        return "待开发"
    elseif type == "jump" then
        return jump_return(msgs, save, go_to)
    else
        return "未知问题2"
    end
end
function fire.a3(type, msgs, save)
    --这里可以删除存档了
    local stroy = "进入地牢\n开始探险\n导入结束了"
    return stroy
end
function main_fire(msg)
    local save = {
        ["save"] = "a2",
        ["hasbeen"] = {["a2"] = 3}
    }
    -- 模拟读取存档
    local input = msg.msg[1] -- 模拟消息输入
    input = "a" .. input
    if save == nil or save.save == nil or save.save == "" then
        save = {["save"] = "a0"} -- 初始化存档
    end
    if save.save == input then
        print(fire[save.save]("stroy", input, save))
    else
        print(save.hasbeen["a2"]..save.save)
        print(fire[save.save]("jump", input, save))
    end
end
local t_msg = {["msg"] = {2}}
main_fire(t_msg) -- 模拟消息输入

command[".test\\s?(\\d)"] = "main_fire"
