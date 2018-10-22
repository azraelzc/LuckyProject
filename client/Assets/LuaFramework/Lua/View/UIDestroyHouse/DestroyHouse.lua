local DestroyHouse = class(require("View.BaseUI"))

function DestroyHouse:onInit(obj)
    self.super.onInit(self,obj)
    self.view:GetChild("close").onClick:Set(self.onExit,self)
    self.player = self.view:GetChild("player")
    self.bg = self.view:GetChild("bg")
    self.bg.onClick:Set(function (context)
        local pos = self.bg:MoseClickToGRoot(context.inputEvent.position)
        self.player.xy = pos
    end)
end

function DestroyHouse:onEnter()
    self.super.onEnter(self)
end

function DestroyHouse:onExit()
    self.super.onExit(self)
end

return DestroyHouse