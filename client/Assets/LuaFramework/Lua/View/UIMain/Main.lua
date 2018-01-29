local Main = class(require("View/BaseUI"))

function Main:onInit(obj)
    self.super:onInit(obj)
    print("=======Main:onInit======")
    self.btn = self.view:GetChild("n0")
    self.btn.onClick:Set(function ()
        print("=====btn click=======")
    end)
end

function Main:onEnter()

end

function Main:onExit()

end

return Main