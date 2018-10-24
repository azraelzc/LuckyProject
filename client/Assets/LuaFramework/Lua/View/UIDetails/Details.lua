local Details = class(require("View.BaseUI"))

function Details:onInit(obj)
    self.super.onInit(self,obj)
    self.view:GetChild("close").onClick:Set(function()
    	Event.Brocast("mainShowIcon")
    	self:onExit()
    end)
    self.btnTabs = {}
    for i=1,3 do
    	self.btnTabs[i] = self.view:GetChild("btnTab"..i)
    end
end

function Details:onEnter()
    self.super.onEnter(self)
end

function Details:onExit()
    self.super.onExit(self)
end

return Details