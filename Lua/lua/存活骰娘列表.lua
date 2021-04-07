command = {}
local Null = require("cirno")
local Json = require("dkjson")
function Devidepage(txt)
    local cache, total = {}, {}
    local count, devide = 1, 3
    for i = #txt, 1, -1 do
        if count > devide then
            table.insert(total, table.concat(cache))
            cache = {}
            count = 1
        end
        table.insert(cache, txt[i])
        count = count + 1
        if count <= devide and #txt > 1 then
            table.insert(cache, "\n\n")
        end
        txt[i] = txt[nil]
    end
    table.insert(total, table.concat(cache))
    return total
end
function Make_to_line(Oliva_heart,time)
    local Oliva_alive = {}
    for k, v in pairs(Oliva_heart) do
        local x = string.sub(v.time_ts, 1, string.len(v.time_ts) - 3) + 900 --900=15min
        if x < time then
        else
            v.time_ts = string.sub(v.time_ts, 1, string.len(v.time_ts) - 3)
            v.time_ts = os.date("%Y年%m月%d日 %H时%M分%S秒", v.time_ts)
            table.insert(
                Oliva_alive,("骰娘名称：" .. v.name .. "(" .. v.user_id .. ")\nMaster：" 
                .. v.masterid .. "\n核心版本：" .. v.version .. "\n最后上报时间：".. v.time_ts)
            )
        end
    end
    return Oliva_alive
end
function Tznlgsvc(Msg)
    local rv, old_time, time,pos, err = "", "", "", "", ""
    local Oliva_heart, Oliva_alive = {}, {}
    local Dir_path = dice.DiceDir() .. "\\user\\Cirno_plugin\\cache\\Diceheart\\"
    dice.mkDir(Dir_path)
    local File_path_time,File_path_heart,File_path_cache = "","",""
    File_path_time = Dir_path .. "lastpulltime.txt"
    File_path_heart = Dir_path .. "Oliva.json"
    File_path_cache = Dir_path .. "cache.json"
    old_time = Null.ReadFile(File_path_time)
    time = os.time()
    if old_time == "" or old_time + 120 < time  then -- 两分钟超时下载
        Null.WriteFile(File_path_time, time)
        Url = "http://api.dice.center/dicestatus/"
        dice.fDownWebPage(Url, File_path_heart)
        Oliva_heart = Null.ReadFile(File_path_heart)
        Oliva_heart, pos, err = Json.decode(Oliva_heart, 1, nil) -- 解成table
        Oliva_alive = Make_to_line(Oliva_heart,time)
        Oliva_alive = Devidepage(Oliva_alive)
        local cache = Json.encode(Oliva_alive, {indent = true}) --转成json
        Null.WriteFile(File_path_cache, cache)
        -- rv = rv .. "下载后转换\n\n"
    else
        Oliva_heart = Null.ReadFile(File_path_cache)
        Oliva_alive, pos, err = Json.decode(Oliva_heart, 1, nil) -- 解成table
        -- rv = rv .. "从缓存中读取,不需要下载\n\n"
    end
    


    if Msg.str[1] == nil or Msg.str[1] == "" or Msg.str[1] == "0" then
        rv = rv .. Oliva_alive[1] .. "\n\n第1页\t共" .. #Oliva_alive .. "页"
    elseif tonumber(Msg.str[1]) <= #Oliva_alive then
        rv = rv .. Oliva_alive[Msg.str[1]+0] .. "\n\n第" .. Msg.str[1] .. "页\t" .. "共" .. #Oliva_alive .. "页"
    else
        rv = rv .. "也许...是你页码输入错误了?"
    end

    return rv 
end
command["存活骰娘列表(\\d+)?"] = "Tznlgsvc"
