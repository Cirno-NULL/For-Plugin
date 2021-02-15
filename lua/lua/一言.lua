command = {}

function hitokoto(Msg)
    rv = ""
    dir_path = dice.DiceDir() .. "\\一言\\"
    file_path = dir_path .. "hitokoto_" .. dice.int2string(Msg.fromQQ) .. ".json"
    if(dice.mkDir(dir_path) == 0)
    then
        url = "https://v1.hitokoto.cn/"
        dice.fDownWebPage(url, file_path)
        rv = "『" .. dice.fGetJson(file_path, "啥也没有", "hitokoto") .. "』"
        rv = rv .. "\n" .. dice.fGetJson(file_path, "不明", "from").. " - " .. dice.fGetJson(file_path, "不明", "from_who")
    end
    return rv
end

command["一言"] = "hitokoto"