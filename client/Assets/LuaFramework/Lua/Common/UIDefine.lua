local UIDefine = {}

UIType =
{
    Hud = 1,
    Window = 2,
    Tip = 3,
    Loading = 4,
}

UIDefine.UIPanel =
{
    Main = {name="Main", uType = UIType.Hud, pkg="UIMain",classPath = "View/UIMain/Main"},
}

return UIDefine