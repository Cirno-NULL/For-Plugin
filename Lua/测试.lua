command = {}
function CreateDeck()
  local nul = require("cirno")

  return dice.DiceDir() .. ""
end
command["测试"] = "CreateDeck"
