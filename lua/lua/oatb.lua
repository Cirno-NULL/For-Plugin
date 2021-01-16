command = {};
function StringToTable(s)
    local tb = {} -- 定义空组,分割任意字符
    for utfChar in string.gmatch(s, "[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(tb, utfChar)
    end
    return tb
end
--[[↑字符转数组
    UTF8的编码规则：
    1. 字符的第一个字节范围： 0x00—0x7F(0-127),或者 0xC2—0xF4(194-244); UTF8 是兼容 ascii 的，所以 0~127 就和 ascii 完全一致
    2. 0xC0, 0xC1,0xF5—0xFF(192, 193 和 245-255)不会出现在UTF8编码中 
    3. 0x80—0xBF(128-191)只会出现在第二个及随后的编码中(针对多字节编码，如汉字) 
    ---------------------
    原理是utf-8字节的编码
]]
function shuffle()
    local numArr = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
    local length = 10
    while (length > 1) do
        local idx = math.random(length)
        numArr[length], numArr[idx] = numArr[idx], numArr[length]
        length = length - 1
    end
    -- 这里是神奇的分割线
    local cardlist = ""
    for i = 1, 4, 1 do
        cardlist = cardlist .. numArr[i]
        -- 循环输出前四个数字
    end
    return cardlist
end
--[[↑洗牌算法获取不重复的随机数列并且转成1a2b答案]]
function IsValNum(str)
    local total = ""
    if #str == 4 and tonumber(str) and str:match("[^0123456789]") == nil then
        local t = {}
        for i = 1, 4 do
            local s = str:sub(i, i)
            if t[s] then
                return "你输入的数字中有相同数字!"
            end
            t[s] = true
        end
        t = nil
        return true
    end
    return "答案格式错误,请重新输入"
end
--[[↑检查输入数字并返回是不是符合格式的数字
    如果没出现过t[s] = nil
    然后循环完了t[s] = true
    再次循环就是t[s] = true直接跳出
    其他的就是正常的样子了
    这个操作好骚气
]]
function read_file(path)
    local answer = ""
    local file = io.open(path, "r") -- 打开了文件读写路径
    if (file ~= nil) then -- 如果文件不是空的
        answer = file.read(file, "*a") -- 读取答案
        io.close(file) -- 关闭文件
    end
    return answer
end
--[[↑读取对应的1a2b答案]]
function write_file(path, text)
    file = io.open(path, "w") -- 以只写的方式
    file.write(file, text) -- 写入好感度
    io.close(file) -- 关闭文件
end
--[[↑写入对应的1a2b答案]]
function set_path(msg)
    files_path = ".\\Dice"..msg.selfId.."\\user\\Cirno_plugin\\1a2b\\" -- 这里设置一下存档的初始地址
    os.execute("mkdir \"" .. files_path .. "\"") -- 初始化存档目录
    local save_file_name = ""
    if (msg.msgType == 1) then
        save_file_name = "G" .. msg.tergetId .. ".txt"
    else
        save_file_name = "Q" .. msg.tergetId .. ".txt"
    end
    path = files_path .. save_file_name
end
--[[↑初始化1a2b地址]]
function returnab(group_string, answer)
    local answer_local,answer_user={},{}
    local total,a,b="","0","0"
    answer_local=StringToTable(group_string)
    answer_user=StringToTable(answer)
    total = total .. "你输入的答案是:\n" .. table.concat(answer_user, '-')
    for i = 1, 4, 1 do
        for z = 1, 4, 1 do
            if (answer_local[i] == answer_user[z] and i == z) then
                a = a + 1
            elseif (answer_local[i] == answer_user[z]) then
                b = b + 1
            else
            end
        end
    end
    total = total .. "\n" .. a .. "A" .. b .. "B"
    return total
end
function help(msg)
    local recive_msg = msg.msg
    local total = ""
    if recive_msg == "1a2b帮助" then
        total = total ..
                    "\n1a2b帮助:\n开始1a2b\n--如果当前群1a2b答案不存在则开始\n--否则提示已经开始\n结束1a2b\n--如果当前群1a2b答案存在则开始\n--反之给出答案并结束游戏\n1a2b菜单\n--显示本页面\n1a2b 1234\n--输入答案用的\n--1a2b后面必须加一个空格\n游戏规则:\n随机给出四个不同数字\n举例:1234\n玩家给出回复\n如果数字相同记1b\n如果数字位置都相同记1a\n猜中正确答案者获胜"
    end
    return total
end
function oatbse(msg)
    set_path(msg)
    local total, group_string, check = "", "", "" -- 回执 群组 是不是1a2b答案
    group_string = read_file(path) -- 读取对应群的答案
    if (group_string == nil) then
        group_string = ""
    end
    if msg.msg == "开始1a2b" then
        check = IsValNum(group_string)--检查正确性
        if check ~= true then
            local cardlist = shuffle() -- 洗牌获取0-9的数列
            total = total .. "\n1a2b开始啦"
            write_file(path, cardlist) -- 写入对应答案
        else
            total = total .. "\n1a2b已经开始啦\n无法重复开始"
        end
    elseif (msg.msg == "结束1a2b") then
        check = IsValNum(group_string)--检查正确性
        if (check ~= true) then
            total = total .. "\n1a2b还没开始哦"
        else
            total = total .. "\n好吧好吧,答案是:" .. group_string
            write_file(path, "") -- 写入空答案
        end
    else
        total=total.."可能是你输错了?"
    end
    return total
end
function oatb(msg)
    set_path(msg)
    local total, group_string, check = "", "", "" -- 回执 群组 是不是1a2b答案
    group_string = read_file(path) -- 读取对应群的答案
    if (group_string == nil) then
        group_string = ""
    end
    if group_string==""then
        total = total .. "\n1a2b还没开始哦\n请输入\"开始1a2b\"开始游戏"
    elseif IsValNum(msg.str[1])==true then
        if(group_string==msg.str[1])then
            total=total.."恭喜!你猜对了!游戏结束!"
            write_file(path, "") -- 写入空答案
        else
            total = total ..returnab(group_string,msg.str[1])
        end
    else
        total=total..IsValNum(msg.str[1])
    end
    return total
end
command["1[aA]2[bB]\\s*(\\d{4})"] = "oatb"
command["开始1a2b"] = "oatbse"
command["结束1a2b"] = "oatbse"
command["1a2b帮助"] = "help"