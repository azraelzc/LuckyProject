UIPanelState =
{
    NeedDestory = 1,
    Loading = 2,
    Loaded = 3,
}

UIPanelAnchor = {
	leftUp = 1,
	leftMiddle = 2,
	leftDown = 3,
	middleUp = 4,
	center = 5,
	middleDown = 6,
	rightUp = 7,
	rightMiddle = 8,
	rightDown = 9,
}

UILoadingType = {
	LuaLoad = 0,
	battle = 1,
}

-- base是最底层 固定在屏幕中的 目前只有battle
-- window表示经常会开关 每次打开都是在最上层
-- tip层表示最高层 类似loading tip提示
UIType = {
	base = 1,
	window = 2,
	tip = 3,
}

-- name 			lua文件的UIXXX以及fgui里面的组件名字
-- pkgName          fgui的包名 
-- depPkg = {} 		依赖包
-- fullScreen		设置全屏
--clickOtherHide    --点击当前界面之外的任意地方关闭
UIPanelType = {
	Main = { name = "Main/Main", uType = UIType.base, fullScreen = true, pkgName = "UILogin"},
}