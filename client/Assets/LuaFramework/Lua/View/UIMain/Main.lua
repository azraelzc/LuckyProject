local Main = class(require("View.BaseUI"))

function Main:onInit(obj)
    self.super.onInit(self,obj)
    self.btnBag = self.view:GetChild("btnBag")
    self.btnBag.onClick:Set(function ()
        UIManager:OpenUI(UIDefine.UIPanel.Bag)
    end)
    self.btnDestroyHouse = self.view:GetChild("btnDestroyHouse")
    self.btnDestroyHouse.onClick:Set(function ()
        UIManager:OpenUI(UIDefine.UIPanel.DestroyHouse)
    end)
end

function Main:onEnter()
    self.super.onEnter(self)
end

function Main:onExit()
    self.super.onExit(self)
end

return Main