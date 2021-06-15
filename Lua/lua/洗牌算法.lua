command = {}
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
function shuffle_main(msg)
    local cirno = require("cirno")
    local total = ""
    local cache = msg.str[1]
    if #cirno.StringToTable(cache) >= 54 then
        total = total .. "你输入的字符太多啦!"
    else
        cache = split(cache, " ")
        if #cache < 3 then
            total = total .. "你输入的序列太少啦!\n根本不需要{self}的帮助ovo"
        elseif #cache > 12 then
            total = total .. "你输入的序列太多啦!\n{self}帮不了你ovo"
        else
            cache = cirno.Shuffle(cache)
            for k, v in pairs(cache) do
                total = total.. "\n" .. k .. ": " .. v  
            end
        end
    end
    cache = nil
    return "{self}给你洗牌的结果是:" .. total
end
function shuffle_help(msg)
    local total = "输入形如\n.sf 1 2 3 4\n即可,不可携带回车\n最多允许53个字符(含中文)\n最少需要3个"
    return total
end
command[".sf\\s?(.*)"] = "shuffle_main"
command[".sf帮助"] = "shuffle_help"
