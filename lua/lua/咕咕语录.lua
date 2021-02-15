command = {}
local Null = require("cirno")
function hitokoto(Msg)
    rv = ""
    local dir_path = dice.DiceDir() .. "\\user\\Cirno_plugin\\cache\\" --搜歌路径
    local file_path = dir_path .. "pigeons.txt"
    dice.mkDir(dir_path)
    local url = "http://www.koboldgame.com/gezi/api.php"
    dice.fDownWebPage(url, file_path)
    local rv = Null.ReadFile(file_path) -- 读取
    rv = string.sub( rv, 17 , -4)
    return rv
end
command["咕咕语录"] = "hitokoto"
