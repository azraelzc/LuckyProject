local Main = class(require("View.BaseUI"))

function Main:onInit(obj)
    self.super.onInit(self,obj)
    self.btn = self.view:GetChild("btnBag")
    self.btn.onClick:Set(function ()
        UIManager:OpenUI(UIDefine.UIPanel.Bag)
    end)
end

function Main:onEnter()
    self.super.onEnter(self)
end

function Main:onExit()
    print("======Main:onExit=======")
    self.super.onExit(self)
end

return Main