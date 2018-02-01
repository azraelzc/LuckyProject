local BaseUI = class("BaseUI")

function BaseUI:ctor(uiPanel)
    self.uiPanel = uiPanel
    self.view = nil
    self.transform = nil
end

function BaseUI:onInit(obj)
    self.view = obj
end

function BaseUI:onEnter()
    self.view.visible = true
    --if self.uiPanel.uType == UIDefine.UIType.Window then
    --    UIManager:ShowWindow(self.view)
    --end
end

function BaseUI:onExit()
    self.view.visible = false
    if self.uiPanel.cache == 0 then
        self:onDestory()
    end
    UIManager:ClearCurUI()
    --if self.uiPanel.uType == UIDefine.UIType.Window then
    --    UIManager:HideWindow(self.view)
    --end

end

function BaseUI:onDestory()
    UIManager:Destory(self.uiPanel.name)
    self.view:Dispose()
end

return BaseUI