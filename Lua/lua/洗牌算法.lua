command = {}
function shuffle(numArr)
    local length = #numArr
    while (length > 1) do
        local idx = math.random(length)
        numArr[length], numArr[idx] = numArr[idx], numArr[length]
        length = length - 1
    end
    return numArr
end
--[[洗牌算法]]
function split(str, reps)
    local resultStrList = {}
    string.gsub(
        str,
        "[^" .. reps .. "]+",
        function(w)
            table.insert(resultStrList, w)
        end
    )
    return resultStrList
end
--[[输入内容分割成数组]]
function StringToTable(s)
    local tb = {} -- 定义空组,分割任意字符
    for utfChar in string.gmatch(s, "[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(tb, utfChar)
    end
    return tb
end
--[[计算输入内容字符数]]
function shuffle_main(msg)
    local total = ""
    local cache = msg.str[2]
    --total = total .. "text_length:" .. #StringToTable(cache)
    if #StringToTable(cache) >= 54 then
        total = total .. "你输入的字符太多啦!"
    else
        cache = split(cache, "、")
        --total = total .. "\ntable_length:" .. #cache .. "\n"
        if #cache < 3 then
            total = total .. "你输入的序列太少啦!\n根本不需要{self}的帮助ovo"
        elseif #cache > 12 then
            total = total .. "你输入的序列太多啦!\n{self}帮不了你ovo"
        else
            cache = shuffle(cache)
            total = total .. table.concat(cache, "、")
        end
    end
    cache = nil
    return "{self}给你洗牌的结果是:\n" .. total
end
function shuffle_help(msg)
    local total = "输入形如\n洗牌算法:琪露诺、雾之湖、baka、青蛙\n即可,不可携带回车"
    return total
end
command["洗牌算法\\s?(∶|：|:)\\s?(.*)"] = "shuffle_main"
command["洗牌算法帮助"] = "shuffle_help"
