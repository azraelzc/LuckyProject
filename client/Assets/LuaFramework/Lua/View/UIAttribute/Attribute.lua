local Attribute = class(require("View.BaseUI"))

function Attribute:onInit(obj)
    self.super.onInit(self,obj)
    self.btn = self.view:GetChild("btnBag")
    self.view:GetChild("close").onClick:Set(self.onExit,self)
end

function Attribute:onEnter()
    self.super.onEnter(self)
end

function Attribute:onExit()
    self.super.onExit(self)
end

return Attribute