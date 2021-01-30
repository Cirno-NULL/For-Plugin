-- 定义一个名为 null 的模块
null = {}
function null.ReadFile(path)
    local text = ""
    local file = io.open(dice.UTF8toGBK(path), "r") -- 打开了文件读写路径
    if (file ~= nil) then -- 如果文件不是空的
        text = file.read(file, "*a") -- 读取内容
        io.close(file) -- 关闭文件
    end
    return text
end --[[↑读取对应的文件]]
function null.WriteFile(path, text)
    local file = io.open(dice.UTF8toGBK(path), "w") -- 以只写的方式
    file.write(file, text) -- 写入内容
    io.close(file) -- 关闭文件
end --[[↑写入对应的文件]]
function null.DeliteFile(path)
    os.remove(dice.UTF8toGBK(path))
end --[[↑删除文件,请谨慎使用]]
return null
