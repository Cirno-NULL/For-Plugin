command = {}
local json = require("dkjson")
function ReadFile(path)
    local text = ""
    local file = io.open(dice.UTF8toGBK(path), "r") -- 打开了文件读写路径
    if (file ~= nil) then -- 如果文件不是空的
        text = file.read(file, "*a") -- 读取内容
        io.close(file) -- 关闭文件
    end
    return text
end
--[[↑读取对应的文件]]
function WriteFile(path, text)
    local file = io.open(dice.UTF8toGBK(path), "w") -- 以只写的方式
    file.write(file, text) -- 写入内容
    io.close(file) -- 关闭文件
end
--[[↑写入对应的文件]]
function DeliteFile(path)
    os.remove(dice.UTF8toGBK(path))
end
--[[↑删除文件,请谨慎使用]]

function SetPath()
    local DirPath = dice.DiceDir() .. "\\publicdeck\\"
    dice.mkDir(DirPath)
    return DirPath
end

function CreateDeck(Msg)
    local deckname = Msg.str[1]
    local FilePath = SetPath() .. deckname..".json"
    
    return FilePath
end
command["新建牌堆(.+)"] = "CreateDeck"