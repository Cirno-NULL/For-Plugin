-- 未完待续,用出问题了不负责
-- 定义一个名为 Null 的模块
Null = {}
function Null.ReadFile(path)
    local text = ""
    local file = io.open(dice.UTF8toGBK(path), "r") -- 打开了文件读写路径
    if (file ~= nil) then -- 如果文件不是空的
        text = file.read(file, "*a") -- 读取内容
        io.close(file) -- 关闭文件
    end
    return text
end --[[↑读取对应的文件]]

function Null.WriteFile(path, text)
    local file = io.open(dice.UTF8toGBK(path), "w") -- 以只写的方式
    file.write(file, text) -- 写入内容
    io.close(file) -- 关闭文件
end --[[↑写入对应的文件]]

function Null.DeliteFile(path)
    os.remove(dice.UTF8toGBK(path))
end --[[↑删除文件,请谨慎使用]]

function Null.Shuffle(numArr)
    local length = #numArr
    while (length > 1) do
        local idx = math.random(length)
        numArr[length], numArr[idx] = numArr[idx], numArr[length]
        length = length - 1
    end
    return numArr
end
--[[↑洗牌算法,传入数组必须是数字下标]]

return Null
