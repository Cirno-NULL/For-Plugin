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
function write_file(path, text)
    local file = io.open(dice.UTF8toGBK(path), "w") -- 以只写的方式
    file.write(file, text) -- 写入内容
    io.close(file) -- 关闭文件
end
--[[↑写入对应的文件]]
function test(Msg)
    local file_path = dice.DiceDir() .. "\\publicdeck\\无尽的挂机.json"
    local text_json = read_file(file_path)
    local tbl, pos, err = json.decode(text_json, 1, nil)
    local fixed_table = {}
    for key, value in pairs(tbl) do
        table.insert(fixed_table, key)
        tbl[key] = tbl[nil] -- 回收内存
    end
    tbl = nil -- 回收内存
    file_path = dice.DiceDir() .. "\\conf\\ttttttttttttttttttt.json"
    local text = json.encode(fixed_table, {indent = true}) --转成json
    write_file(file_path, text)
    return "完毕"
end
command["测试"] = "test"
