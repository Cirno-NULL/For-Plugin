command = {};
function duel(Msg)
    local a1 = dice.rd("1d100")
    local a2 = dice.rd("1d100")
    local a3 = dice.rd("1d100")
    local a4 = dice.rd("1d100")
    local a5 = dice.rd("1d100")
    local b1 = dice.rd("1d100")
    local b2 = dice.rd("1d100")
    local b3 = dice.rd("1d100")
    local b4 = dice.rd("1d100")
    local b5 = dice.rd("1d100")
    local rev = "看起来你想和{self}决斗ovo\n那么我出青蛙你出脸开始吧ovo\n"
    rev = rev .. "{self}:\n"
    rev = rev .. dice.int2string(a1) .. " + "
    rev = rev .. dice.int2string(a2) .. " + "
    rev = rev .. dice.int2string(a3) .. " + "
    rev = rev .. dice.int2string(a4) .. " + "
    rev = rev .. dice.int2string(a5) .. "\n总计："
    local dice_num = a1 + a2 + a3 + a4 + a5
    rev = rev  ..dice.int2string(dice_num)
    rev = rev .. "分\n{pc}:\n"
    rev = rev .. dice.int2string(b1) .. " + "
    rev = rev .. dice.int2string(b2) .. " + "
    rev = rev .. dice.int2string(b3) .. " + "
    rev = rev .. dice.int2string(b4) .. " + "
    rev = rev .. dice.int2string(b5) .. "\n总计："
    local user_num = b1 + b2 + b3 + b4 + b5
    rev = rev .. dice.int2string(user_num)
    rev = rev .. "分\n————\n"
    local total_num = (dice_num - user_num) / 10
    total_num = math.floor(total_num + 0.5)
    rev = rev .. "记：" .. dice_num - user_num .. "=" .. total_num .. "分\n"
    if (total_num < 0) then
        rev = rev .. "看起来是你赢了ovo\n给你一只青蛙ovo"
    elseif (total_num > 0) then
        rev = rev .. "如果{self}没看错的话,是你输了对吧?\n那就让我在你脸上涂两笔吧嘿嘿"
    else
        rev = rev .. "哇?是平局哦,琪露诺去捉青蛙啦咕嘿嘿"
    end
    rev=rev.."\n\n灵感来源于惠系骰娘"
    return rev
end
command["(\\.|。)duel"] = "duel"