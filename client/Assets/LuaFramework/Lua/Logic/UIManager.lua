local UIManager = {}

function UIManager:Init()
    self.UIList = {}
    self.uiClasses = {}
    self.packageCache = {}
    self.curUIInfo = nil
    self:preAddPackage()
end

function UIManager:GetClass(name)
    return self.uiClasses[name]
end

function UIManager:AddClass(name,uiClass)
    self.uiClasses[name] = uiClass
end

function UIManager:RemoveClass(name)
    self.uiClasses[name] = nil
end

function UIManager:Destory(name)
    for i = 1, #self.UIList do
        if self.UIList[i].uiPanel.name == name then
            table.remove(self.UIList,i)
            break
        end
    end
    self:RemoveClass(name)
end

function UIManager:preAddPackage()
    UIManager:AddPackage("Common",nil)
end

-- 这里是从window类的hide方法里面调过来的 别的地方禁止调用
function UIManager:HideWindow(win)
    win.visible = false
end

-- 这里是从window类的show方法调用过来 别的地方禁止调用
function UIManager:ShowWindow(win)
    win.visible = true
    if win.parent ~= GRoot.inst then
        GRoot.inst:AddChild(win)
    end
end

function UIManager:AddUI(addUiInfo)
    for i = 1, #self.UIList do
        local uiInfo = self.UIList[i]
        if uiInfo.uiPanel == addUiInfo.uiPanel then
            table.remove(self.UIList,i)
            break
        end
    end
    table.insert(self.UIList,addUiInfo)
end

function UIManager:GetUIByUIID(UIID)
    local retUIInfo = nil
    for i = 1, #self.UIList do
        if self.UIList[i].uiPane.id == UIID then
            retUIInfo = self.UIList[i]
            break
        end
    end
    return retUIInfo
end

function UIManager:CloseUIByUIID(UIID)
    if self.curUIInfo ~= nil and self.curUIInfo.uiPanel.id == UIID then
        self:CloseUI(self.curUIInfo)
    else
        local uiInfo = self:GetUIByUIID(UIID)
        if uiInfo ~= nil then
            self:CloseUI(uiInfo)
        end
    end
end

function UIManager:CloseUI(uiInfo)
    uiInfo.uiClass:onExit()
end

function UIManager:ClearCurUI()
    if self.curUIInfo ~= nil and self.curUIInfo.uiPanel.uType == UIDefine.UIType.Window then
        local preUIInfo = self.curUIInfo.preUIInfo
        self.curUIInfo.preUIInfo = nil
        self:AddUI(self.curUIInfo)
        self.curUIInfo = nil
        if preUIInfo ~= nil then
            self:OpenUI(preUIInfo.uiPanel)
        end
    end
end

function UIManager:OpenUI(uiPanel,cb,needBack)
    if uiPanel == nil then
        return
    end
    local uiClass = self:GetClass(uiPanel.name)
    local createCB = function (uiClass)
        if uiPanel.uType == UIDefine.UIType.Window then
            local preUIInfo = nil
            if self.curUIInfo ~= nil then
                if needBack then
                    preUIInfo = self.curUIInfo
                end
                self.curUIInfo.uiClass:onExit()
            end
            self.curUIInfo = {}
            self.curUIInfo.uiPanel = uiPanel
            self.curUIInfo.uiClass = uiClass
            self.curUIInfo.preUIInfo = preUIInfo
        end
        uiClass:onEnter()
        if cb ~= nil then
            cb(uiClass)
        end
    end
    if uiClass == nil then
        self:CreatUI(uiPanel,createCB)
    else
        createCB(uiClass)
    end
end

function UIManager:CreatUI(uiPanel,cb)
    self:CheckPackage(uiPanel,function ()
        local panelCtrl = require(uiPanel.classPath).new(uiPanel)
        self:AddClass(uiPanel.name,panelCtrl)
        local ui = UIPackage.CreateObject(uiPanel.pkgName, uiPanel.name)
        GRoot.inst:AddChild(ui)
        ui.position = Vector3.zero
        panelCtrl:onInit(ui)
        if cb ~= nil then
            cb(panelCtrl)
        end
    end)
end

function UIManager:CheckPackage(uiPanel,cb)
    local addCount = 0
    local addPkgs = {}
    if self.packageCache[uiPanel.pkgName] == nil then
        table.insert(addPkgs,uiPanel.pkgName)
    end
    if uiPanel.depdPkg ~= nil then
        for i = 1, #uiPanel.depdPkg do
            local pkgName = uiPanel.depdPkg[i]
            if self.packageCache[pkgName] == nil then
                table.insert(addPkgs,pkgName)
            end
        end
    end
    local success = function ()
        if addCount == #addPkgs then
            if cb ~= nil then
                cb()
            end
        end
    end
    if #addPkgs > 0 then
        for i = 1, #addPkgs do
            self:AddPackage(addPkgs[i],function ()
                addCount = addCount + 1
                success()
            end)
        end
    else
        success()
    end

end

function UIManager:AddPackage(pkgName,cb)
    resMgr:LoadPackage(pkgName,function (pkgPath)
        self.packageCache[pkgName] = pkgPath
        if cb ~= nil then
            cb()
        end
    end)
end

return UIManager

