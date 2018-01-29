local UIManager = {}

function UIManager:Init()
    print("=======UIManager Init=========")
end

function UIManager:OpenUI(uiPanel,cb)
    print("=======UIManager OpenUI=========",uiPanel,table.tostring(uiPanel))
    resMgr:LoadPackage(uiPanel.name,uiPanel.pkg,function (ui)
        local panelCtrl = require(uiPanel.classPath).new(uiPanel)
        GRoot.inst:ShowPopup(ui,nil,nil)
        ui.position = Vector3.zero
        panelCtrl:onInit(ui)
        if cb ~= nil then
            cb(ui)
        end
    end)
end

return UIManager

