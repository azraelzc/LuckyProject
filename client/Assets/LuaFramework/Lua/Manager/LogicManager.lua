require "Common/define"
require "View/UIDefine"

LogicManager = {}
local this = LogicManager
local LogicTable = {}

LogicType = {
	DungeonTXG = "DungeonPlayTianXingGe",
}

function LogicManager.PreLoad()
	local temp = {}
	table.insert(temp, UIPanelType.Main.name)
	for k,v in pairs(temp) do
		local logic = require("Logic/"..v.."Logic").new()
		logic:Init()
		this.Add(v, logic)
	end
end

function LogicManager.Init()
	this.PreLoad()
end

function LogicManager.Get(logicName)
	local logic = LogicTable[logicName]
	if logic == nil then
		logError(logicName.." is nil")
	end
	return logic
end

function LogicManager.Add(logicName, logic)
	LogicTable[logicName] = logic
end
