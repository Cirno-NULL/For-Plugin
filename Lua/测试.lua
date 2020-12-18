command = {}
function test(Msg)
    Name = dice.getPcName(Msg.fromQQ)
    return Name
end
command["测试"] = "test"
