command = {}
local cirno = require("cirno")
function Decks(msg)
    local decks = {
        [1] = {"单张塔罗牌", ""},
        [2] = {"圣三角牌阵", "过去的经验：\n", "问题的现状：\n", "将来的预测：\n"},
        [3] = {"四要素牌阵", "火（行动力）：\n", "水（情感）：\n", "土（现实）：\n", "风（思想）：\n"},
        [4] = {"小十字牌阵", "过去：\n", "现在(左)：\n", "现在(右)：\n", "未来：\n"},
        [5] = {"六芒星牌阵", "起因：\n", "现状：\n", "未来：\n", "对策：\n", "周遭：\n", "态度：\n", "结果：\n"},
        [6] = {"凯尔特十字牌阵","问题现状：\n","障碍助力：\n","理想状况：\n","基础条件：\n","过去状况：\n","未来发展：\n","自身现状：\n","周围环境：\n","希望恐惧：\n","最终结果：\n"
        }
    }
    local decks_cache = {
        ["圣三角"] = 2,
        ["四要素"] = 3,
        ["小十字"] = 4,
        ["六芒星"] = 5,
        ["凯尔特十字"] = 6
    }
    if decks_cache[msg[1]] ~= nil then
        local x = decks_cache[msg[1]] --获取牌堆编号
        decks_cache = {} -- 清空缓存牌堆
        decks_cache[1]=decks[x] --获取指定牌阵
        return decks_cache
    end
    return decks
end
--[[挑选合适的牌堆
一个简单的随机数和打表
]]
function Setdecks(msg)
    local decks = Decks(msg)
    if msg[2] == "阵" then
        local x = math.random(1, #decks)
        return decks[x]
    else
        return decks[1]
    end
end
--[[返回洗过的合适牌
因为有大小阿卡那的区别所以就直接全整出来
洗牌,然后加上正逆
]]
function GetCards(msg)
    local akn = ""
    if msg[3] == "全" then
        akn = {"愚者","魔术师","女祭司","女皇","皇帝","教皇","恋人","战车","力量","隐者","命运之轮","正义","倒吊人","死神","节制","恶魔","塔","星星","月亮","太阳","审判","世界","宝剑王牌","宝剑二","宝剑三","宝剑四","宝剑五","宝剑六","宝剑七","宝剑八","宝剑九","宝剑十","宝剑侍从","宝剑骑士","宝剑皇后","宝剑国王","星币王牌","星币二","星币三","星币四","星币五","星币六","星币七","星币八","星币九","星币十","星币侍从","星币骑士","星币皇后","星币国王","圣杯王牌","圣杯二","圣杯三","圣杯四","圣杯五","圣杯六","圣杯七","圣杯八","圣杯九","圣杯十","圣杯侍从","圣杯骑士","圣杯皇后","圣杯国王","权杖王牌","权杖二","权杖三","权杖四","权杖五","权杖六","权杖七","权杖八","权杖九","权杖十","权杖侍从","权杖骑士","权杖皇后","权杖国王"
        }
    else
        akn = {"愚者","魔术师","女祭司","女皇","皇帝","教皇","恋人","战车","力量","隐者","命运之轮","正义","倒吊人","死神","节制","恶魔","塔","星星","月亮","太阳","审判","世界"
        }
    end
    --[[一个很简单的添加正逆的模块]]
    local vgni = {"正位", "逆位"}
    akn = cirno.Shuffle(akn)
    for k, v in ipairs(akn) do
        local x = math.random(1, 2)
        akn[k] = akn[k] .. vgni[x]
    end
    return akn
end
--[[组合成返回的牌
这里暂时还没写完
]]
function DeckReturn(msg, decks, card_deck)
    local final_deck = {}
    table.insert(final_deck, decks[1])
    for i = 2, #decks do
        local cache = ""
        local basic_cache_name = card_deck[i - 1] --整个基础牌堆名

        local cache_name = "{_" .. basic_cache_name .. "名}"
        local card = dice.draw(cache_name)
        cache = cache .. "\n" .. decks[i] .. card
         --[[合成名称]]

        if msg[5] == "介" then 
            cache_name = "{_" .. basic_cache_name .. "介}"
            local cache_introduce = dice.draw(cache_name)
            cache = cache .. "\n" ..cache_introduce
        end
        --[[合成介绍]]

        if msg[4] == "图" then 
            local cache_pic = ""
            cache_pic = "\n[CQ:image,file=/塔罗牌/" .. basic_cache_name .. ".jpg]"
            cache = cache .. cache_pic .. "\f" --这里把""改成"\f"就可以分页了
        end
        --[[合成图片]]
        table.insert(final_deck, cache) --合并
    end
    return table.concat(final_deck, "")
end
--[[模块化拼装]]
function Main(msg)
    if msg.str[2] ~= "阵" and msg.str[1] == "塔罗" then
        if msg.str[4] ~= "图" and msg.str[4] ~= "介" then
            msg.str[4] = "图"
            msg.str[5] = "介"
        end
    end
    local decks = Setdecks(msg.str)
    local card_deck = GetCards(msg.str)
    local rv = DeckReturn(msg.str, decks, card_deck)
    return rv .. ""
end
command["(塔罗|圣三角|四要素|小十字|六芒星|凯尔特十字)牌(阵)?(全)?(图)?(介)?"] = "Main"
