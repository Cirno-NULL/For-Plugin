command = {}
function xlhoduxk(msg)
    local file_path = dice.DiceDir() .. "\\plugin\\json\\fire.json"
    local res = dice.fGetJson(file_path, "输入页码不存在!", msg.str[1])
    return res 
end
function xlhoduxk_help()
    return "输入\".fire 1\"开始\n跳转方法：.fire+空格+数字\n例：.fire 263"
end
command[".fire\\s(\\d+)?"] = "xlhoduxk"
command[".fire\\s?(help)?"] = "xlhoduxk_help"
