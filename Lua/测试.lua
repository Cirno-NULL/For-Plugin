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
--[[↑读取对应路径的文件]]
function test(Msg)
    local file_path = dice.DiceDir() .. "\\conf\\CustomReply.json"
    local text_json = read_file(file_path)
    local tbl, pos, err = json.decode(text_json, 1, nil)
    local fixed_table = {}
    for key, value in pairs(tbl) do
        table.insert(fixed_table, key)
    end
    tbl = nil -- 回收内存
    return table.concat( fixed_table,",")
end
command["当前tia的回复词"] = "test"
