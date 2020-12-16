command = {}
function hitokoto(Msg)
    dice.setPcName(Msg.fromQQ,-1,"coroutine.running( )")
    Name = dice.getPcName(Msg.fromQQ,-1)
    dice.setPcSkill(Msg.fromQQ,-1,"wow",3456)
    dice.setPcSkill(Msg.fromQQ,-1,"wo",1234)
    dice.setPcSkill(Msg.fromQQ,-1,"w",2345)
    return "完成" .. Name
end
command["测试"] = "hitokoto"
