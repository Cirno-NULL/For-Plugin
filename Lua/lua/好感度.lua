command = {}
today_favor_max = 8 ---单日次数上限
favor_once = 1 -- 单次好感上升
local json = require("dkjson")
function mkDirs(path)
    os.execute('mkdir "' .. path .. '"')
end
--[[初始化文件路径]]
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
function split_favor(s)
    local t = {}
    for k, v in string.gmatch(s, "(%w+)=(%d+)") do
        t[k] = v
    end
    return t
end
--[[分割保存的好感度成为数组]]
function isnum(text)
    return tonumber(text) ~= nil
end
--[[检查是不是数字]]
function get_old_save(path)
    local total = ""
    local user_file = read_file(path) -- 读取用户文件内容
    local user_favor = split_favor(user_file) -- 分割成数组
    if user_favor["date"] ~= os.date("%Y-%m-%d") then
        user_favor["date"] = os.date("%Y-%m-%d")
        user_favor["time"] = 0
        user_favor["hour"] = ""
    end
    -- 存档时间处理,后续不需要处理时间了
    if isnum(user_favor["time"]) ~= true then
        user_favor["time"] = 0
    else
        user_favor["time"] = user_favor["time"] + 0
    end
    -- 用户本日存档次数处理,返回的是原始今日次数
    if isnum(user_favor["favo"]) ~= true then --如果存档不是数字
        user_favor["favo"] = "0" --好感度等于0
        if isnum(user_file) then --如果历史存档是数字
            user_favor["favo"] = user_file
        else
            user_favor["favo"] = 0
        end
    end
    --用户好感度处理,返回的是原始好感度,后面需要二次处理
    return user_favor
end
--[[获取旧存档数据]]
function get_new_save(path, patha)
    local text = read_file(path)
    local table = json.decode(text, 1, nil) -- 解成table
    if table == nil or table["favor"] == nil then
        table = {}
        table["favor"] = get_old_save(patha)
    elseif table["favor"]["favo"] == nil or table["favor"]["date"] == nil or table["favor"]["time"] == nil  or
    table["favor"]["favo"] == "" or table["favor"]["date"] == "" or table["favor"]["time"] == "" then
        table["favor"] = get_old_save(patha)
    end
    if table["favor"]["date"] ~= os.date("%Y-%m-%d") then
        table["favor"]["date"] = os.date("%Y-%m-%d")
        table["favor"]["time"] = 0
        table["favor"]["hour"] = ""
    end
    -- 处理好感度的时间和今日次数
    if isnum(table["favor"]["time"]) ~= true then
        table["favor"]["time"] = 0
    else
        table["favor"]["time"] = table["favor"]["time"] + 0
    end
    -- 用户本日存档次数处理,返回的是原始今日次数
    if isnum(table["favor"]["favo"]) ~= true then --如果存档不是数字
        table["favor"]["favo"] = "0" --好感度等于0
        if isnum(text) then --如果历史存档是数字
            table["favor"]["favo"] = text
        else
            table["favor"]["favo"] = 0
        end
    end
    --用户好感度处理,返回的是原始好感度,后面需要二次处理
    return table
end
--[[获取处理过的新存档]]
function set_path(msg)
    local old_path = dice.DiceDir() .. "\\user\\Cirno_plugin\\favor\\" -- 这里设置一下旧存档的初始地址
    local dir_path = dice.DiceDir() .. "\\user\\Cirno_plugin\\qq\\" -- 这里设置一下新存档的初始地址
    local dir_path_p = dice.DiceDir() .. "\\user\\Cirno_plugin\\public\\" -- 这里是排行榜的初始地址
    dice.mkDir(dir_path) -- 初始化存档路径
    dice.mkDir(dir_path_p) -- 初始化排行榜路径
    return old_path, dir_path,dir_path_p
end
--[[初始化地址]]
function rcv_gift(msg)
    --[[json和table互转
        json.encode(table_json, {indent = true}) --转成json
        json.decode(group_string, 1, nil) -- 解成table
        ]]
    local total = ""
    local old_path, dir_path = set_path(msg)
    local user_path, user_old_path, user_table , user_save = "", "", {} ,""
    local tznl_path, tznl_old_path, tznl_table , tznl_save = "", "", {} ,""
    -- 新存档路径,旧存档路径,存档table,存档文字
    user_path = dir_path .. "Q" .. msg.fromQQ .. ".json" -- 新用户存档位置
    user_old_path = old_path .. msg.fromQQ .. ".txt" -- 旧用户存档位置
    user_table = get_new_save(user_path, user_old_path) -- 获得存档
    
    if user_table["favor"]["time"] < today_favor_max then
        if user_table["favor"]["hour"] ~= os.date("%H") then
            user_table["favor"]["favo"] = user_table["favor"]["favo"] + favor_once -- 好感度+1
            user_table["favor"]["time"] = user_table["favor"]["time"] + favor_once -- 次数+1
            user_table["favor"]["hour"] = os.date("%H") -- 时间更新
            user_save = json.encode(user_table, {indent = true}) --转成json
            write_file(user_old_path, "")
            write_file(user_path, user_save) -- 写入用户数据
            tznl_path = dir_path .. "Q" .. msg.selfId .. ".json" -- 新骰娘存档位置
            tznl_old_path = old_path .. msg.selfId .. ".txt" -- 旧骰娘存档位置
            tznl_table = get_new_save(tznl_path, tznl_old_path) -- 获得存档
            tznl_table["favor"]["favo"] = tznl_table["favor"]["favo"] + favor_once -- 好感度+1
            tznl_table["favor"]["time"] = tznl_table["favor"]["time"] + favor_once -- 次数+1
            tznl_save = json.encode(tznl_table, {indent = true}) --转成json
            write_file(tznl_old_path, "")
            write_file(tznl_path, tznl_save) -- 写入用户数据
            total = total .. "感谢{nick}送的青蛙ovo\n累计收到了"..tznl_table["favor"]["favo"].."只啦咕嘿嘿\n{self}今天收到了"..tznl_table["favor"]["time"].."只青蛙啦\n{self}对你的某个属性上升了!"
        else
            total = total .. "你投喂的太快了啦ovo\n上一次投喂是在" .. os.date("%H") .. "点ovo\n请在一个小时以后再来吧~"
        end
    else
        total = total .. "今天你送给{self}的青蛙已经够多啦...\n明天再来吧ovo"
    end
    return total
end
-- 喂青蛙用
function check_favor(msg)
    local total = ""
    local old_path, dir_path = set_path(msg)
    local user_path, user_old_path, user_table , user_save = "", "", {} ,""
    -- 新存档路径,旧存档路径,存档table,存档文字
    user_path = dir_path .. "Q" .. msg.fromQQ .. ".json" -- 新用户存档位置
    user_old_path = old_path .. msg.fromQQ .. ".txt" -- 旧用户存档位置
    user_table = get_new_save(user_path, user_old_path) -- 获得存档
    user_table["favor"]["favo"] = user_table["favor"]["favo"] + 0
    favo = math.floor(math.sqrt(user_table["favor"]["favo"] * 2 / 0.1) * 100) / 100
    total = total .. "你一共送给{self}" .. user_table["favor"]["favo"] .. "只青蛙啦" .. "\n{self}对你的好感度\n大概有" .. favo .. "%这么多吧"
    if favo < 10 then
        total = total .. "Σ( ° △ °|||)︴"
    elseif favo < 30 then
        total = total .. "(>▽<)"
    elseif favo < 50 then
        total = total .. "～(￣▽￣～)~"
    elseif favo < 70 then
        total = total .. "╰(*°▽°*)╯"
    else
        total = total .. "(σ′▽‵)′▽‵)σ"
    end
    return total .. "???"
end
--[[琪露诺好感度用
    过会再修
]] 
command["喂青蛙"] = "rcv_gift"
command["琪露诺好感度"] = "check_favor"