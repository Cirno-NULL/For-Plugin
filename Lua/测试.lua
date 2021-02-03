command = {}
-- local json = require("dkjson")
sqlite3 = require('lsqlite3')
function CreateDeck(Msg)
    local file_path = dice.DiceDir() .. "\\conf\\CustomReply.json"
    local text_json = null.ReadFile(file_path)
    return #text_json
end
-- test_module.lua 文件
-- module 模块为上文提到到 module.lua
command["新建牌堆(.+)"] = "CreateDeck"