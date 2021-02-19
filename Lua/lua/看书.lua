command = {}
local json = require("dkjson")
function read_file(path)
    local text = ""
    local file = io.open(dice.UTF8toGBK(path), "r") -- 打开了文件读写路径
    if (file ~= nil) then -- 如果文件不是空的
        text = file.read(file, "*a") -- 读取内容
        io.close(file) -- 关闭文件
    end
    return text
end
--[[↑读取对应的文件]]
function write_file(path, text)
    local file = io.open(dice.UTF8toGBK(path), "w") -- 以只写的方式
    file.write(file, text) -- 写入内容
    io.close(file) -- 关闭文件
end
--[[↑写入对应的文件]]
function isnum(text)
    return tonumber(text) ~= nil
end
--[[检查是不是数字]]
function shuffle()
    local numArr = {"a", "b", "c", "d", "e", "f"}
    local length = #numArr
    while (length > 1) do
        local idx = math.random(length)
        numArr[length], numArr[idx] = numArr[idx], numArr[length]
        length = length - 1
    end
    return numArr
end
--[[洗牌算法]]
function devide_table(s)
    local t = {}
    for k, v in string.gmatch(s, "([%d%a]+)=(%w+)") do
        if isnum(k) then
            k = k + 0
        end
        if isnum(v) then
            v = v + 0
        end
        t[k] = v
    end
    return t
end
--[[分割数组]]
function set_path(msg)
    local dirx_path = dice.DiceDir() .. "\\user\\Cirno_plugin\\read_book\\" -- 这里设置一下存档的初始地址
    local dir_path = ""
    if msg.msgType == 1 then
        dir_path = dice.DiceDir() .. "\\user\\Cirno_plugin\\Group\\"
    else
        dir_path = dice.DiceDir() .. "\\user\\Cirno_plugin\\QQ\\"
    end
    dice.mkDir(dir_path) -- 初始化存档目录
    local file_path = ""
    if (msg.msgType == 1) then
        file_path = "G" .. msg.tergetId
    else
        file_path = "Q" .. msg.tergetId
    end
    return dir_path .. file_path .. ".json", dirx_path .. file_path .. ".txt"
end
--[[↑初始化1a2b地址]]
function old_save(pahtb)
    local group_string, cache, table_json, total = "", {}, {}, ""
    group_string = read_file(pahtb) -- 读取旧存档
    cache = devide_table(group_string) -- 旧存档分割成数组
    group_string = nil -- 回收资源
    total = total .. "幸好图书馆里还有一本备用的\n"
    if cache["top"] == nil or cache[cache["top"]] == nil then
        --如果旧存档为空的处理方式
        table_json = set_save(table_json)
        total = total .. "在你兴冲冲拿起来以后\n发现备用的也坏了\n不过好在还有一本新进的\n打开书,你看见了\n"
    else -- 转换成新存档格式
        table_json["read"] = {["top"] = cache["top"]}
        cache["top"] = cache[nil] -- 删掉旧存档里的top
        table_json["read"]["data"] = cache -- data迁移
        total = total .. "再次打开,你看见了\n"
        write_file(pahtb, "")
    end
    cache = nil -- 回收一下资源
    return table_json, total
end
--[[读取并转换老旧存档]]
function get_new_save(patha, pahtb)
    local group_string, table_json, pos, err, total, cache, reason = "", {}, "", "", "", {}, ""
    group_string = read_file(patha) -- 读取新存档
    table_json, pos, err = json.decode(group_string, 1, nil) -- 解成table
    group_string = nil -- 回收资源
    if table_json == nil then -- 如果新存档为空
        total = total .. "你发现这是一本无字天书\n"
        table_json = {} -- 初始化新目录存档
        cache, reason = old_save(pahtb) -- cache是一个中继变量,用完删除,这四行是在迁移老存档到新存档
        table_json["read"] = cache["read"]
        total = total .. reason
    end
    if table_json["read"] == nil then
        --[[如果新存档read为空 读取旧存档]]
        total = total .. "发现书本已经腐朽不堪了\n"
        cache, reason = old_save(pahtb) -- cache是一个中继变量,用完删除,这四行是在迁移老存档到新存档
        table_json["read"] = cache["read"]
        total = total .. reason
    else --如果新存档不为空
        if table_json["read"]["top"] == nil or table_json["read"]["data"] == nil then
            total = total .. "书页疯狂的翻转\n在哗啦啦快一分钟后\n终于停了下来,你看见了\n"
            table_json = set_save(table_json)
        else
            total = total .. "书页无风自动,你看见了\n"
        end
    end
    cache = nil -- 回收一下资源
    reason = nil -- 回收一下资源
    return table_json, total -- 这里的total是检测用的
end
--[[读取并加载新存档]]
function set_save(table_json)
    table_json["read"] = {["top"] = 1, ["data"] = shuffle()}
    return table_json
end
--[[新建一个存档]]
function read_book(msg)
    --[[json和table互转
        json.encode(table_json, {indent = true}) --转成json
        json.decode(group_string, 1, nil) -- 解成table]]
    local patha, pahtb = "", "" -- 新存档位置,旧存档位置
    local table_json, cache = {}, ""
    local total = "{nick}翻开了书\n"
    patha, pahtb = set_path(msg) -- 新存档位置,旧存档位置
    table_json, cache = get_new_save(patha, pahtb)
    pahtb = nil -- 回收一下资源
    total = total .. cache--这里的cache是回执,拿来当检错用的
    if table_json["read"]["data"][table_json["read"]["top"]] == nil then
        table_json = set_save(table_json)
    end
    if table_json["read"]["data"][table_json["read"]["top"]] ~= "f" then
        local rand=dice.rd("1d2")
        if rand==1 then
            total = total .."道德经" ..dice.draw("{道德经}") .. "\n在{nick}看完后，书猛地合上了" .. "\n"
        else
            total = total .. dice.draw("{孙子兵法}") .. "\n在{nick}看完后，书猛地合上了" .. "\n"
        end
        
        table_json["read"]["top"] = table_json["read"]["top"] + 1
    else
        total = total .. "无穷无尽的知识向你扑面而来\n在如此庞大的知识量的冲击下\n晕了过去..."
        table_json = set_save(table_json)
    end
    cache = json.encode(table_json, {indent = true}) --转成json
    write_file(patha, cache)
    return total
end
command["看书"] = "read_book"