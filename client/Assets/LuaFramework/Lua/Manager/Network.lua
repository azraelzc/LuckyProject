require "Common/define"
require "Common/functions"

require "Protol/NFMsgBase_pb"
-- require "Protol/NFFleetingDefine_pb"
require "Protol/NFDefine_pb"
require "Protol/NFMsgPreGame_pb"
require "Protol/NFMsgShare_pb"
require "Protol/NFMsgURl_pb"
-- require "Protol/NFSLGDefine_pb"
require "Protol/NFMsgMysql_pb"

require "Protocol/protocol_c2s"
require "Protocol/protocol_s2c"


-- require "3rd/pbc/protobuf"

-- event用来分发持久的全局的事件
Event = require 'events'

Network = {};
local this = Network;

local transform;
local gameObject;
local isConnect = false

local SocketEvent = {}

local pingDistTime = 30
local lastPingTime = 0
local attrSyncRoleId = 0


function Network.Start()

    -- local pbFiles = {"NFDefine.pb", "NFFleetingDefine.pb", "NFMsgBase.pb", "NFMsgMysql.pb", "NFMsgPreGame.pb"
    --                 , "NFMsgShare.pb", "NFMsgURl.pb", "NFSLGDefine.pb"}
    -- this.RegisterFile(pbFiles)

    logWarn("Network.Start!!");
    networkMgr:ConnectServer("118.89.142.233", 14001)
    -- networkMgr:SendConnect()
    -- Event.AddListener(Protocol.Connect, this.OnConnect); 
    -- Event.AddListener(Protocol.Exception, this.OnException); 
    -- Event.AddListener(Protocol.Disconnect, this.OnDisconnect); 
    -- Event.AddListener(Protocol.ConnectFail, this.OnConnectFail);

    -- Event.AddListener(t2c_error_notify, this.OnErrorNotify)
    -- Event.AddListener(g2c_attr_sync_begin, this.OnAttrSyncBegin)
    -- Event.AddListener(g2c_sync_attr_list, this.OnSyncAttrList)
    -- Event.AddListener(g2c_attr_sync_end, this.OnAttrSyncEnd)
end

function Network.RegisterFile(fileNames)
    for key,value in pairs(fileNames) do
        protobuf.register_file(AppConst.GetPbFilePath()..value)
    end    
end 

--Socket消息 所有的消息都从这里回调--
function Network.OnSocket(key, data)
    -- log("OnSocket receive id:"..key)
    if Protocol_ParseFunc[key] then
        local res = {}
        res = Protocol_ParseFunc[key](data)
        if this.OnAckRespond(key, res) == false then
        -- 如果在发送消息的时候没有注册 那么从这里走
            Event.Brocast(key, res);
        end
    else
        logError("Protocol_ParseFunc nil:"..key)
        Event.Brocast(key, res);
    end
end

--当连接建立时--
function Network.OnConnect() 
    isConnect = true;
    logWarn("Game Server connected!!");
end

function Network.OnConnectFail()
    logError("OnConnectFail!");
end

--异常断线--
function Network.OnException() 
    isConnect = false; 
    NetManager:SendConnect();
   	logError("OnException------->>>>");
end

--连接中断，或者被踢掉--
function Network.OnDisconnect() 
    isConnect = false; 
    logError("OnDisconnect------->>>>");
end

function Network.OnGameHeart()
    if PlayerData.IsLogin == true then
        local _time = TimeMgr.GetServerTimeInt()
        local _preTime = lastPingTime + pingDistTime
        if _time > _preTime then
            lastPingTime = _time
            this.Ping()
        end
    end
end

function Network.Ping()
    local t = {}
    t.dwPingTick = TimeMgr.SERVER_TIME_FLOAT
    local function OnPing(data)
        local delay = TimeMgr.SERVER_TIME_FLOAT - data.dwPingTick
        log("delay:"..delay)
    end
    Packet_C2S_Ping(t, t2c_ping_ack, OnPing)
end

function Network.SendMessage(msgId, msg)
    networkMgr:SendMsg(tonumber(msgId), msg)
end

-- function Network.SendMessage(msg, needSize, rpId, respond)
--     if isConnect == false then
--         logError("SendMessage: isConnect is false")
--         return
--     end
--     if rpId ~= nil then
--         this.AddAckListener(rpId, respond)
--     end
--     if needSize == true then
--         local dataLen = msg:getLength()
--         msg:seekOffset(2)
--         msg:writeUIn16(dataLen)
--     end
--     networkMgr:SendMessage(msg)
-- end

function Network.GetMsgSize(msgId)
    return g_nS2CMessageSize[msgId+1]
end

-- 已注册的消息从这里回调
function Network.OnAckRespond(msgId, data)
    if SocketEvent[msgId] ~= nil then
        for i,v in ipairs(SocketEvent[msgId]) do
            v(data)
        end
        this.RemoveAckListener(msgId)
        return true
    end
    return false
end

function Network.AddAckListener(msgId, callback)
    if SocketEvent[msgId] == nil then
        SocketEvent[msgId] = {}
    end
    table.insert(SocketEvent[msgId], callback)
end

function Network.RemoveAckListener(msgId)
    if SocketEvent[msgId] ~= nil then
        SocketEvent[msgId] = nil
    end
end

--卸载网络监听--
function Network.Unload()
    -- Event.RemoveListener(Protocol.Connect);
    -- Event.RemoveListener(Protocol.Exception);
    -- Event.RemoveListener(Protocol.Disconnect);
    logWarn('Unload Network...');
end


function Network.OnErrorNotify(t)
    log("OnErrorNotify:"..t.nErrCode)
end