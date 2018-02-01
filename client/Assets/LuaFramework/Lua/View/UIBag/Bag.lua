local Bag = class(require("View.BaseUI"))

function Bag:onInit(obj)
    self.super.onInit(self,obj)
    self.view:GetChild("close").onClick:Set(self.onExit,self)
    self.btnAtt = self.view:GetChild("btnAtt")
    self.btnAtt.onClick:Set(function ()
        UIManager:OpenUI(UIDefine.UIPanel.Attribute,nil,true)
    end)
end

function Bag:onEnter()
    self.super.onEnter(self)
end

function Bag:onExit()
    self.super.onExit(self)
end

return Bag