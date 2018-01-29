local BaseUI = {}

function BaseUI:ctor(pType)
    print("====BaseUI:ctor=====")
    self.panelType = pType
    self.view = nil
    self.transform = nil
end

function BaseUI:onInit(obj)
    print("====BaseUI:ctor=====",obj)
    self.view = obj
end

function BaseUI:onEnter()

end

function BaseUI:onExit()

end

function BaseUI:onDestory()

end

return BaseUI