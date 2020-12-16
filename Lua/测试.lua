command = {}
function delete_file(path)
    os.remove(path)
end
--[[删除文件,请谨慎使用]]
function test()
    local old_path = dice.DiceDir() .. "\\user\\Cirno_plugin\\favor\\" -- 这里设置一下旧存档的初始地址
    local file_path = old_path .. "test.txt"
    delete_file(file_path)
    return "完成"
end
command["测试"] = "test"
