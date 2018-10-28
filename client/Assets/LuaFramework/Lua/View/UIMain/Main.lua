local Main = class(require("View.BaseUI"))

function Main:onInit(obj)
    self.super.onInit(self,obj)
    self.mainBtnCtrl = self.view:GetController("mainBtnCtrl")
    self.mainIconShowCtrl = self.view:GetController("mainIconShowCtrl")
    -- self.btnBag = self.view:GetChild("btnBag")
    -- self.btnBag.onClick:Set(function ()
    --     UIManager:OpenUI(UIDefine.UIPanel.Bag)
    -- end)
    self.btnBuilding = self.view:GetChild("btnBuilding")
    self.btnBuilding.onClick:Set(function ()
       if self.mainBtnCtrl.selectedIndex == 0 then
       		self.mainBtnCtrl.selectedIndex = 1
       else
			self.mainBtnCtrl.selectedIndex = 0
       end
    end)

    self.player = self.view:GetChild("player")
    self.playerClickArea = self.view:GetChild("playerClickArea")
    self.playerClickArea.onClick:Set(function (context)
    	self.mainBtnCtrl.selectedIndex = 0
        local pos = self.playerClickArea:MoseClickToGRoot(context.inputEvent.position)
        self.player:TweenMove(pos,1)
    end)

    self.btnMains = {}
    for i=1,4 do
    	self.btnMains[i] = self.view:GetChild("btnMain"..i)
    	if i == 1 then
    		self.btnMains[i].onClick:Set(function ()
    			self.mainBtnCtrl.selectedIndex = 0
    			self.mainIconShowCtrl.selectedIndex = 1
    			UIManager:OpenUI(UIDefine.UIPanel.UIDetails)
    		end)
    	end
    end

    Event.AddListener("mainShowIcon",function ()
    	self.mainIconShowCtrl.selectedIndex = 0
    end)

end

function Main:onEnter()
    self.super.onEnter(self)
end

function Main:onExit()
    self.super.onExit(self)
end

return Main