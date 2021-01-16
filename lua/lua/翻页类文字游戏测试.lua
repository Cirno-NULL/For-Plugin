command = {}
local json = require("dkjson")
deepcopy = function(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end

    return _copy(object)
end
--[[复制table而不是引用table]]
function isnum(text)
    return tonumber(text) ~= nil
end
--[[↑检查是不是数字]]
function read_file(path)
    local text = ""
    local file = io.open(path, "r") -- 打开了文件读写路径
    if (file ~= nil) then -- 如果文件不是空的
        text = file.read(file, "*a") -- 读取内容
        io.close(file) -- 关闭文件
    end
    return text
end
--[[↑读取对应的文件]]
function write_file(path, text)
    local file = io.open(path, "w") -- 以只写的方式
    file.write(file, text) -- 写入内容
    io.close(file) -- 关闭文件
end
--[[↑写入对应的文件]]
function delete_file(path)
    os.remove(path)
end
--[[↑删除文件,请谨慎使用]]
function jump_return(msgs, save, pages)
    if pages[msgs] ~= nil then
        --这里可以搞一个+1计数
        save.save = msgs
        if save.hasbeen[msgs] == nil then
            save.hasbeen[msgs] = 1
        else
            save.hasbeen[msgs] = save.hasbeen[msgs] + 1
        end
        write_file(filepath, json.encode(save, {indent = true}))  --转成json并写入文件
        return fire[msgs]("stroy", msgs, save)
    else
        return "你目前还不能这么做\n现在你在这里:" .. string.sub(save.save, 2)
    end
end
--[[翻页返回
只是单纯的验证是否可以返回并且返回消息
]]
function choose_return(save, pages)
    local rv = {}
    --[[防止出现各种奇奇怪怪的table的问题,新开一个变量好了]]
    rv.hasbeen = deepcopy(save.hasbeen)
    for key, value in pairs(pages) do
        if pages[key][2] == nil then
            pages[key][2] = 1
        end --[[如果key的第二个值是nil就变成1,对应的就是只能用一次的选项]]
        if rv.hasbeen[key] == nil then
            rv.hasbeen[key] = 0
        end --[[如果已到为nil就初始化为0]]
        if pages[key][2] ~= nil then
            pages[key][2] = 1
            rv.hasbeen[key] = 0
        end --[[如果key的第二个值不是nil就变成1,并且把已到变成0,对应的就是无限次数的选项]]
        if rv.hasbeen[key] < pages[key][2] then
            table.insert(rv, "\n")
            table.insert(rv, string.sub(key, 2))
            table.insert(rv, " ：")
            table.insert(rv, pages[key][1])
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
    local pages = {["a1"] = {"前往地牢，让我们出发吧！"}}
    if type == "stroy" then
        return stroy .. choose_return(save, pages)
    elseif type == "jump" then
        return jump_return(msgs, save, pages)
    else
        return "未知问题0"
    end
end
function fire.a1(type, msgs, save)
    local stroy = "到了地牢门口"
    local pages = {
        ["a3"] = {"进入地牢"},
        ["a2"] = {"返回城镇", ""}
    }
    if type == "stroy" then
        return stroy .. choose_return(save, pages)
    elseif type == "jump" then
        return jump_return(msgs, save, pages)
    else
        return "未知问题1"
    end
end
function fire.a2(type, msgs, save)
    local stroy = "确定返回城镇么？" -- 这里就是每一页的故事内容
    local pages = {
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
            return stroy .. choose_return(save, pages)
        else
            pages.a3 = {"想得美，你无论如何也得给我下去！"}
            return pages.a3[1] .. "\n" .. jump_return("a3", save, pages)
        end
    elseif type == "jump" then -- 如果是跳转模式
        return jump_return(msgs, save, pages)
    else -- 捕获其他可能性用的,也可以拿来当扩展
        return "未知问题2"
    end
end
function fire.a3(type, msgs, save)
    --这里可以删除存档了
    delete_file(filepath)
    local stroy = "进入地牢中...\n开始探险ing...\n导入结束了"
    return stroy
end
function setpath(msg)
    local dirpath = dice.DiceDir() .. "\\user\\Cirno_plugin\\qq\\fire_test\\"
    dice.mkDir(dirpath) -- 初始化存档路径
    local file_path = dirpath .. msg.fromQQ .. ".json"
    return file_path
end
--[[合成存档位置]]
function getsave(filepath)
    local file_text = read_file(filepath)
    return json.decode(file_text, 1, nil) -- 解成table
end
--获取存档并转成json备用
function main_fire(msg)
    filepath = setpath(msg)
    local rv = ""
    local save = getsave(filepath)
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
        write_file(filepath, json.encode(save, {indent = true}))  --转成json并写入文件
    elseif save.save == input then
        rv = rv .. (fire[save.save]("stroy", input, save))
    else
        rv = rv .. (fire[save.save]("jump", input, save))
    end
    return rv
end
command[".test\\s?(\\d+)"] = "main_fire"
