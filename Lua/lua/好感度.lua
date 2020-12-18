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
function delete_file(path)
    os.remove(path)
end
--[[↑删除文件,请谨慎使用]]
function split_favor(s)
    local t = {}
    for k, v in string.gmatch(s, "(%w+)=(%d+)") do
        t[k] = v
    end
    return t
end
--[[↑分割保存的好感度成为数组]]
function isnum(text)
    return tonumber(text) ~= nil
end
--[[↑检查是不是数字]]
function quickshort(tb, left, right)
    local low = left
    local high = right
    if (left < right) then
        local pivot = tb[left]
        while (low < high) do
            while (tb[high]["favor"] >= pivot["favor"] and low < high) do
                high = high - 1
            end
            tb[low] = tb[high]
            while (tb[low]["favor"] <= pivot["favor"] and low < high) do
                low = low + 1
            end
            tb[high] = tb[low]
        end
        tb[low] = pivot
        quickshort(tb, left, low - 1)
        quickshort(tb, low + 1, right)
    end
end
--[[自己定制过的快速排序]]
function devidepage(txt)
    quickshort(txt, 1, #txt)
    local cache, total = {}, {}
    local count, base = 1, #txt
    local devide = 5
    for i = #txt, 1, -1 do
        if count > devide then
            table.insert(total, table.concat(cache))
            cache = {}
            count = 1
        end
        table.insert(cache, "第")
        table.insert(cache, base - #txt + 1)
        table.insert(cache, "名:\nID:\t")
        table.insert(cache, txt[i]["qq"])
        table.insert(cache, "\n当前好感度:")
        local cache_favo = math.floor(math.sqrt(txt[i]["favor"] * 2 / 0.1) * 100) / 100 .. "%"
        table.insert(cache, cache_favo)
        count = count + 1
        if count <= devide and #txt > 1 then
            table.insert(cache, "\n\n")
        end
        txt[i] = txt[nil]
    end
    table.insert(total, table.concat(cache))
    return total
end
--[[排行榜分页]]
function table_table(tb)
    local fixed_table = {}
    for key, value in pairs(tb) do
        table.insert(fixed_table, value)
        tb[key] = tb[nil] -- 回收内存
    end
    tb = nil -- 回收内存
    return fixed_table
end
--[[转成能被快排的table]]
function get_old_save(path)
    local user_file = read_file(path) -- 读取用户文件内容
    local user_favor = split_favor(user_file) -- 分割成数组
    if isnum(user_favor["favo"]) ~= true then --如果好感度不是数字
        user_favor["favo"] = 0 --好感度等于0
        if isnum(user_file) then --如果历史存档是数字
            user_favor["favo"] = user_file
        else
            user_favor["favo"] = 0
        end
    end
    --用户好感度处理,返回的是原始好感度,后面需要二次处理
    return user_favor
end
--[[↑获取旧存档数据]]
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
    --[[处理好感度的时间和今日次数]]
    if isnum(table["favor"]["time"]) ~= true then
        table["favor"]["time"] = 0
    else
        table["favor"]["time"] = table["favor"]["time"] + 0
    end
    --[[用户本日存档次数处理,返回的是原始今日次数]]
    if isnum(table["favor"]["favo"]) ~= true then --如果存档不是数字
        table["favor"]["favo"] = 0 --好感度等于0
    end
    --[[用户好感度处理,返回的是原始好感度,后面需要二次处理]]
    return table
end
--[[↑获取处理过的新存档]]
function set_path()
    local old_path = dice.DiceDir() .. "\\user\\Cirno_plugin\\favor\\" -- 这里设置一下旧存档的初始地址
    local dir_path = dice.DiceDir() .. "\\user\\Cirno_plugin\\qq\\" -- 这里设置一下新存档的初始地址
    local rank_path = dice.DiceDir() .. "\\user\\Cirno_plugin\\public\\" -- 这里是排行榜的初始地址
    dice.mkDir(dir_path) -- 初始化存档路径
    dice.mkDir(rank_path) -- 初始化排行榜路径--才起了个头
    return old_path, dir_path,rank_path
end
--[[↑初始化地址]]
function rcv_gift(msg)
    --[[json和table互转
        json.encode(table_json, {indent = true}) --转成json
        json.decode(group_string, 1, nil) -- 解成table
        ]]
    local total = ""
    local old_path, dir_path ,rank_path= set_path(msg)
    local rank_list ,rank_text= "",""
    local user_path, user_old_path, user_table , user_save = "", "", {} ,""
    local tznl_path, tznl_old_path, tznl_table , tznl_save = "", "", {} ,""
    -- 新存档路径,旧存档路径,存档table,存档文字
    user_path = dir_path .. "Q" .. msg.fromQQ .. ".json" -- 新用户存档位置
    user_old_path = old_path .. msg.fromQQ .. ".txt" -- 旧用户存档位置
    user_table = get_new_save(user_path, user_old_path) -- 获得存档
    --[[计算出用户的存档路径并获取存档]]
    if user_table["favor"]["time"] < today_favor_max then
        if user_table["favor"]["hour"] ~= os.date("%H") then
            --[[后续想办法优化一下,重复代码太难看了]]
            user_table["favor"]["favo"] = user_table["favor"]["favo"] + favor_once -- 好感度+1
            user_table["favor"]["time"] = user_table["favor"]["time"] + favor_once -- 次数+1
            user_table["favor"]["hour"] = os.date("%H") -- 时间更新
            user_save = json.encode(user_table, {indent = true}) --转成json
            delete_file(user_old_path)
            write_file(user_path, user_save)
            --[[写入用户存档]]
            rank_path = rank_path .. "favor_rank.json"
            rank_list = read_file(rank_path)
            if rank_list == "" then
                rank_list = {}
            else
                rank_list = json.decode(rank_list, 1, nil)
            end
            rank_list[dice.int2string(msg.fromQQ)]={["qq"]=dice.getPcName(msg.fromQQ),["favor"]=user_table["favor"]["favo"]}
            rank_text = rank_text .. json.encode(rank_list, {indent = true}) .."\n"
            write_file(rank_path, rank_text)
            --[[排行榜的路径计算和写入]]
            tznl_path = dir_path .. "Q" .. msg.selfId .. ".json" -- 新骰娘存档位置
            tznl_old_path = old_path .. msg.selfId .. ".txt" -- 旧骰娘存档位置
            tznl_table = get_new_save(tznl_path, tznl_old_path) -- 获得存档
            --[[计算出骰娘的存档路径并获取存档]]
            tznl_table["favor"]["favo"] = tznl_table["favor"]["favo"] + favor_once -- 好感度+1
            tznl_table["favor"]["time"] = tznl_table["favor"]["time"] + favor_once -- 次数+1
            tznl_save = json.encode(tznl_table, {indent = true}) --转成json
            delete_file(tznl_old_path)
            write_file(tznl_path, tznl_save)--[[写入骰娘存档]]
            --[[后续想办法优化一下,重复代码太难看了]]
            total = total .. "感谢{nick}送的青蛙ovo\n{self}会悄悄给你来一个大成功的(\n累计收到了"..tznl_table["favor"]["favo"].."只青蛙\n今天收到了"..tznl_table["favor"]["time"].."只青蛙啦ovo\n{self}的冰雕馆藏增加啦!"
        else
            total = total .. "你投喂的太快了啦ovo\n{self}还在把之前的青蛙冻成冰雕ovo\n一个小时以后再来吧~"
        end
    else
        total = total .. "今天你送给{self}的青蛙已经够多啦...\n明天再来吧ovo"
    end
    return total
end
--[[↑喂青蛙用]]
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
--[[↑琪露诺好感度用]]
function check_rank(msg)
    local rank_list, rank_text ,rank_path= set_path(msg)
    local rank_patha = rank_path .. "favor_rank_cache.json"
    rank_path = rank_path .. "favor_rank.json"
    rank_text = read_file(rank_patha)
    if rank_text == nil or rank_text == "" then
        rank_list = {["time"]=""}
    else
        rank_list = json.decode(rank_text, 1, nil) -- 解成table
    end
    if rank_list["time"] ~= os.date("%Y%m%d%H") then
        rank_text = read_file(rank_path)
        if rank_text == "" then
            rank_list ={[1]="哎?现在的排行榜居然还是空的?\n快喂给{self}青蛙awa\n喂了你就上榜了ovo",["time"]= os.date("%Y%m%d%H")}
            rank_text = json.encode(rank_list, {indent = true}) --转成json
            write_file(rank_patha, rank_text)--[[写入排行榜缓存存档]]
            rank_text = rank_list[1]
        else
            rank_list = json.decode(rank_text, 1, nil) -- 解成table
            rank_list = table_table(rank_list) -- 格式化成能被快排的样子
            rank_list = devidepage(rank_list) -- 快排
            rank_list["time"] = os.date("%Y%m%d%H") -- 缓存用的时间
            rank_text = json.encode(rank_list, {indent = true}) --转成json
            write_file(rank_patha, rank_text)--[[写入排行榜缓存存档]]
            rank_text = rank_list[1]
            rank_text = rank_text .."\n【第1页\t共"..#rank_list.."页】"
        end
    else
        for key, value in pairs(rank_list) do
            if isnum(key) then
                rank_list[tonumber(key)] = rank_list[key]
                rank_list[key] = rank_list[nil]
            end
        end
        if msg.str[1] == nil or msg.str[1] == "" then
            rank_text = rank_list[1]
            rank_text = rank_text .."\n【第1页\t共"..#rank_list.."页】"
        elseif tonumber(msg.str[1]) <= #rank_list then
            rank_text = rank_list[tonumber(msg.str[1])]
            rank_text = rank_text .."\n【第"..tonumber(msg.str[1]).."页\t共"..#rank_list.."页】"
        else
            rank_text = "页码错误\n请重新输入"
            rank_text = rank_text .."\n共"..#rank_list.."页"
        end
    end
    return rank_text .. "\n【每小时更新一次】"
end
command["喂青蛙"] = "rcv_gift"
command["琪露诺好感度"] = "check_favor"
command["好感度排行榜(\\d?)"] = "check_rank"