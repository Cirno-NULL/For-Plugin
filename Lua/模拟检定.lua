local setcoc = {[1] = {2, 0.2, 2, 0.2, 96, 0, 99, 0, 50}}
local count, skill = 98, 50
local rule = setcoc[1]
local set_text = {"大成功", "极难成功", "困难成功", "普通成功", "失败", "大失败", "让我们来看看骰出了什么?\n"}
local return_text = set_text[7] .. count .. "/" .. skill
if skill < rule[5] then
    if count <= rule[1] and count <= skill * rule[2] then
        return_text = return_text .. set_text[1]
        print(11)
    elseif count < skill * 0.2 then
        return_text = return_text .. set_text[2]
        print(12)
    elseif count < skill * 0.5 then
        return_text = return_text .. set_text[3]
        print(13)
    elseif count < skill then
        return_text = return_text .. set_text[4]
        print(14)
    elseif count >= rule[5] + skill * rule[6] then
        return_text = return_text .. set_text[6]
        print(16)
    else
        return_text = return_text .. set_text[5]
        print(15)
    end
else
    if count <= rule[3] then
        return_text = return_text .. set_text[1]
        print(21)
    elseif count < skill * 0.2 then
        return_text = return_text .. set_text[2]
        print(22)
    elseif count < skill * 0.5 then
        return_text = return_text .. set_text[3]
        print(23)
    elseif count < skill then
        return_text = return_text .. set_text[4]
        print(24)
    elseif count >= rule[7] then
        return_text = return_text .. set_text[6]
        print(26)
    else
        return_text = return_text .. set_text[5]
        print(25)
    end
end
print(return_text)