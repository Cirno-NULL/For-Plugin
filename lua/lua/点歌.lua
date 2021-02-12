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
--[[↑读取对应的文件]]
function write_file(path, text)
    local file = io.open(dice.UTF8toGBK(path), "w") -- 以只写的方式
    file.write(file, text) -- 写入内容
    io.close(file) -- 关闭文件
end
--[[↑写入对应的文件]]
function test(Msg)
    local base_path = dice.DiceDir() .. "\\user\\Cirno_plugin\\163music\\" --搜歌路径
    local dir_path = base_path .. "discuss\\" --热评路径
    local file_path = base_path .. "163music" .. ".json" --缓存歌曲路径
    dice.mkDir(dir_path)
    local songname = dice.UrlEncode(Msg.str[1])
    local url = "https://musicapi.leanapp.cn/search?keywords=" .. songname .. "&limit=1" --歌曲api
    dice.fDownWebPage(url, file_path) --下载
    local songinfo = read_file(file_path) -- 读取
    local songinfo = json.decode(songinfo, 1, nil) -- 解成table
    local rv = ""
    if songinfo.result.songs == nil then
        return "{self}找不到{nick}想要听的歌QvQ"
    end
    local songid = songinfo.result.songs[1].id --读取songid
    rv = rv .. "https://y.music.163.com/m/song/" .. songid --合成网址

    local songinfo = read_file(file_path) --优先读取缓存文件
    if songinfo == "" or songinfo == nil then
        url = "http://music.163.com/api/v1/resource/comments/R_SO_4_" .. songid .. "?limit=10&offset=0" --热评api
        file_path = dir_path .. songid .. ".json" -- 合成热评路径
        dice.fDownWebPage(url, file_path) -- 下载热评
        songinfo = read_file(file_path) -- 读取
    end
    local songinfo = json.decode(songinfo, 1, nil) -- 解成table
    if #songinfo.hotComments == 0 then
        rv = rv .. "\f当前歌曲无热评ovo"
    else
        local rdnum = math.random(#songinfo.hotComments)
        rv = rv .. "\f随机热评" .. rdnum .. ":\n" .. songinfo.hotComments[rdnum].content
    end
    return rv
end
command["点歌\\s?(.+)"] = "test"
