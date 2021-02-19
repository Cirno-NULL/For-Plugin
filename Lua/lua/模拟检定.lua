function return_level(count, skill, type)
    local setcoc = {
        [0] = {1, 1, 1, 1, 96, 0, 100, 0, 50},
        [1] = {1, 1, 5, 1, 96, 0, 100, 0, 50},
        [2] = {5, 1, 5, 1, 96, 0, 96, 0, 50},
        [3] = {5, 1, 5, 1, 96, 0, 96, 0, 50},
        [4] = {5, 0.1, 5, 0.1, 96, 0.1, 96, 0, 50},
        [5] = {2, 0.2, 2, 0.2, 96, 0, 99, 0, 50}
    }
    local rule = ""
    if type >= 0 and type <= 5 then
        rule = setcoc[type]
    elseif rule == 6 then
        --[[仿照的读取本地文件设置]]
        rule = {3, 1, 5, 1, 96, 0, 99, 0, 50}
    else
        --[[虽然基本不可能有这样的输入,不过万一呢,所以加了一个默认配置]]
        rule = setcoc[0]
    end
    --[[1=大成功,2=极难成功,3=困难成功,4=普通成功,5=失败,6=大失败]]
    if skill < rule[9] then
        if count <= rule[1] and count <= skill * rule[2] then return 1
        elseif count >= rule[5] + skill * rule[6] and count > skill or count == 100 then return 6
        elseif count < skill * 0.2 then return 2
        elseif count < skill * 0.5 then return 3
        elseif count <= skill then return 4
        else return 5
        end
    else
        if count <= rule[3] then return 1
        elseif count >= rule[7] and count > skill or count == 100 then return 6
        elseif count < skill * 0.2 then return 2
        elseif count < skill * 0.5 then return 3
        elseif count <= skill then return 4
        else return 5
        end
    end
end

function rv_check(count, skill, type)
    --[[这里可以拿来合成回复用,包括自定义回复,以及如果要前后回复不同其实也是可以做到的]]
    local rv_ce = return_level(count, skill, type)
    if rv_ce == 1 then return "大成功"
    elseif rv_ce == 2 then return "极难成功"
    elseif rv_ce == 3 then return "困难成功"
    elseif rv_ce == 4 then return "普通成功"
    elseif rv_ce == 5 then return "失败"
    elseif rv_ce == 6 then return "大失败"
    end
end
local s = os.clock()
local test_text = {}
for i = 1, 100000, 1 do
	local cache = rv_check(60, 55, 1) .. "\t" ..i
    table.insert( test_text, cache )
end
print(table.concat( test_text, "\n"))
local e = os.clock()
print("used time : "..e-s.." seconds")
print(os.time())
--[[需要做的:大失败的优先级]]