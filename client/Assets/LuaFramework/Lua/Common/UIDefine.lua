local UIDefine = {}

UIDefine.UIType =
{
    Hud = 1,
    Window = 2,
    Tip = 3,
    Loading = 4,
}

UIDefine.UIPanel =
{
    Main = {name="Main", uType = UIDefine.UIType.Hud, pkgName="UIMain",classPath = "View/UIMain/Main",id=10000,cache = 1 },
    Bag = {name="Bag", uType = UIDefine.UIType.Window, pkgName="UIBag",classPath = "View/UIBag/Bag",id=10100,cache = 1 },
    Attribute = {name="Attribute", uType = UIDefine.UIType.Window, pkgName="UIAttribute",classPath = "View/UIAttribute/Attribute",id=10200,cache = 0 },
}

return UIDefine