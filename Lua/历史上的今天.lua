command = {}
function read_file(path)
    local text = ""
    local file = io.open(path, "r") -- 打开了文件读写路径
    if (file ~= nil) then -- 如果文件不是空的
        text = file.read(file, "*a") -- 读取内容
        io.close(file) -- 关闭文件
    end
    return text
end
--[[↑读取对应路径的文件]]
function write_file(path, text)
    local file = io.open(path, "w") -- 以只写的方式
    file.write(file, text) -- 写入内容
    io.close(file) -- 关闭文件
end
--[[↑写入对应的文件
    需要输入的是:文件路径,文件内容
]]
function isnum(text)
    return tonumber(text) ~= nil
end
--[[↑检查是不是数字]]
function histroyoftoday()
    local json = require("dkjson")
    local table_json, cache_json = {}, {}
    local text_json, total = "", ""
    dir_path = dice.DiceDir() .. "\\user\\Cirno_plugin\\"
    file_path = dir_path .. "历史上的今天" .. ".json"
    dice.mkDir(dir_path)
    local pa = dice.UTF8toGBK(file_path) -- utf-8转gbk
    text_json = read_file(pa)
    table_json, pos, err = json.decode(text_json, 1, nil) -- 解成table
    if table_json == nil then
        table_json = {}
    end
    if table_json["year"] == os.date("%Y") 
        and table_json["month"] == os.date("%m") 
        and table_json["day"] == os.date("%d") then
        total = total .. table_json["data"]
    else
        url = "https://api.muxiaoguo.cn/api/lishijr"
        dice.fDownWebPage(url, file_path)
        total = total
        text_json = read_file(pa)
        table_json, pos, err = json.decode(text_json, 1, nil) -- 解成table
        table_json["year"] = os.date("%Y")
        for i = 1, #table_json["data"], 1 do
            if isnum(table_json["data"][i]["year"]) ~= true then
                table_json["data"][i]["year"] = "未知"
            end
            if isnum(table_json["data"][i]["month"]) ~= true then
                table_json["data"][i]["month"] = "未知"
            end
            if isnum(table_json["data"][i]["day"]) ~= true then
                table_json["data"][i]["day"] = "未知"
            end
            if table_json["data"][i]["title"] == nil then
                table_json["data"][i]["title"] = "未知"
            end
            table.insert(cache_json, "\n")
            table.insert(cache_json, table_json["data"][i]["year"])
            table.insert(cache_json, "-")
            table.insert(cache_json, table_json["data"][i]["month"])
            table.insert(cache_json, "-")
            table.insert(cache_json, table_json["data"][i]["day"])
            table.insert(cache_json, ":\n")
            table.insert(cache_json, table_json["data"][i]["title"])
        end
        table_json = {}
        total = table.concat(cache_json)
        table_json["year"] = os.date("%Y")
        table_json["month"] = os.date("%m")
        table_json["day"] = os.date("%d")
        table_json["data"] = total
        text_json = json.encode(table_json, {indent = true}) --转成json
        write_file(pa, text_json)
    end
    return total
end
command["历史上的今天"] = "histroyoftoday"
