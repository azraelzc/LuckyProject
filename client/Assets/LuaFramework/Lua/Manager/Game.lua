
-- local json = require "cjson"
-- local util = require "3rd/cjson/util"

require "Table/Language"

require "Manager/UIManager"
require "Manager/TimeMgr"
require "Manager/ColorMgr"

require "Common/functions"
require "Common/FairyGUI"

--管理器--
Game = {};
local this = Game;

local game; 
local transform;
local gameObject;
-- local WWW = UnityEngine.WWW;

function Game.PreLoadFile()
    for i, v in ipairs(preLoadData) do
        package.loaded[v] = nil
        require(v)
    end
end

--初始化完成，发送链接服务器信息--
function Game.OnInitOK()
    -- AppConst.SocketPort = 2012;
    -- AppConst.SocketAddress = "127.0.0.1";
    -- networkMgr:SendConnect();

    UIManager.Init();
    ColorMgr.Init()


    -- UIManager.ShowPanel(UIPanelType.Tip)
    -- UIManager.ShowPanel(UIPanelType.Login, nil)
    logWarn('LuaFramework InitOK-11111111111111111-->>>');
end

--销毁--
function Game.OnDestroy()
    --logWarn('OnDestroy--->>>');
end
