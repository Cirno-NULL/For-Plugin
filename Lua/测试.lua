command = {}
local Null = require("cirno")
function readme()
  return "下面的各项函数是\n目前的自定义模块的使用方法\n建议尝试一遍"
  --举个栗子
end
function WriteFile()
  local FilePath = dice.DiceDir() .. "\\测试.txt"
  Null.WriteFile(FilePath, "测试文本测试文本测试文本测试文本")
  return "完成,路径位于\n" .. FilePath
end
function ReadFile()
  local FilePath = dice.DiceDir() .. "\\测试.txt"
  return "完成,读取内容为:\n" .. Null.ReadFile(FilePath)
end
function DeliteFile()
  local FilePath = dice.DiceDir() .. "\\测试.txt"
  Null.DeliteFile(FilePath)
  return "完成,文件\n" .. FilePath .. "\n已删除"
end
function Shuffle()
  local a = {"1", "2", "3", "4", "5", "6", "7"}
  return "洗牌算法完成\n结果为:" .. table.concat(Null.Shuffle(a))
end
function isnum()
  local b = 3
  return "目标是不是数字:" .. tostring(Null.isnum(b))
end
function StringToTable()
  local text = ".。Oʘ⊛🅞"
  return "总计字符个数:" .. #Null.StringToTable(text)
end
command["测试"] = "StringToTable"
