---
--- Created by Administrator.
--- DateTime: 2017/8/16 15:33
---
TimeMgr = {}

local _date = os.date

--转换为显示时间
function TimeMgr.ConvertToDateTime(t)
    return _date("%Y-%m-%d %H:%M:%S",t/1000)
end

function TimeMgr:ConvertToMinTime(t)
    return _date("%M:%S",t)
end

--转换成时间戳
function TimeMgr.ConvertToTimeStamp(year,month,day,hour,min,sec)
    local time = {day=1, month=1, year=1970, hour=0, minute=0, second=0}
    if year ~= nil then
        time.year = year
    end
    if month ~= nil then
        time.month = month
    end
    if day ~= nil then
        time.day = day
    end
    if hour ~= nil then
        time.hour = hour
    end
    if min ~= nil then
        time.minute = min
    end
    if sec ~= nil then
        time.second = sec
    end
    return os.time(time)
end

TimeMgr.SERVER_TIME_DIFF = 0
TimeMgr.SERVER_TIME_FLOAT = 0

--时间戳转换table
function TimeMgr.ConvertTimeStampToTable(timeInt)
    local dt = {}
    dt.year = _date("%Y", timeInt)
    dt.month = _date("%m", timeInt)
    dt.day = _date("%d", timeInt)
    dt.hour = _date("%H", timeInt)
    dt.minute = _date("%M", timeInt)
    dt.second = _date("%S", timeInt)
    dt.weekday = _date("%w", timeInt)
    return dt
end

function TimeMgr.GetServerTime()
    return TimeMgr.ConvertToDateTime(TimeMgr.GetServerTimeInt())
end

function TimeMgr.GetServerTimeInt()
    local timeStamp = os.time() + TimeMgr.SERVER_TIME_DIFF
    return timeStamp
end

--获取当前周开始时间戳
function TimeMgr.GetCurWeekStartStamp()
    local now = TimeMgr.GetServerTimeInt()
    local dt = TimeMgr.ConvertTimeStampToTable(now)
    dt.hour = 0
    dt.minute = 0
    dt.second = 0
    local timeStamp = os.time(dt)

    local wday = dt.weekday - 1
    if wday < 0 then
        wday = 6
    end

    timeStamp = timeStamp - wday * 86400
    return timeStamp
end

--将周时间0－604800转换成中文周几
function TimeMgr.ConvertWeekTimeToWeekDayStr(timeInt)
    local weekday = math.mod(timeInt + 86399,86400)
    return TimeMgr.GetWeekDayStr(weekday)
end

--获取今日0点时间戳
function TimeMgr.GetTodayStartStamp()
    local now = TimeMgr.GetServerTimeInt()
    local dt = TimeMgr.ConvertTimeStampToTable(now)
    dt.hour = 0
    dt.minute = 0
    dt.second = 0
    local timeStamp = os.time(dt)
    return timeStamp
end

--获取当天周几索引
function TimeMgr.GetTodayWeekDayIdx()
    return _date("%w", TimeMgr.GetServerTimeInt())
end

--获取当前时间戳，从当日0点开始算
function TimeMgr.GetTodayTimeInt()
    return TimeMgr.GetServerTimeInt() - TimeMgr.GetTodayStartStamp()
end

--秒数转换成周时间戳
function TimeMgr.ConvertWeekTimeStamp(timeInt)
    local wStart = TimeMgr.GetCurWeekStart()
    return wStart + timeInt
end

--转换为时间格式
function TimeMgr.ConverToTimeFromSecond(second)
    second = tonumber(second)
    local sec = math.fmod(second,60)
    local min = math.fmod(second - sec,3600) / 60
    local H = (second - min * 60 - sec) / 3600
    return string.format("%02d:%02d:%02d",H,min,sec)
end

--获取周几中文
function TimeMgr.GetWeekDayStr(wd)
    local weekday = tonumber(wd)
    if weekday == 1 then
        return Language.Get("timemgr_text1")
    elseif weekday == 2 then
        return Language.Get("timemgr_text2")
    elseif weekday == 3 then
        return Language.Get("timemgr_text3")
    elseif weekday == 4 then
        return Language.Get("timemgr_text4")
    elseif weekday == 5 then
        return Language.Get("timemgr_text5")
    elseif weekday == 6 then
        return Language.Get("timemgr_text6")
    else
        return Language.Get("timemgr_text7")
    end
end

--以;分割如0;1;3，代表周日，周一，周二,7天都有则显示每天
function TimeMgr.ConvertWeekDaysString(weekdays,splitChar)

    if splitChar == nil then
        splitChar = ","
    end

    local days = string.split(weekdays, ';')
    if #days == 7 then
        return Language.Get("timemgr_text8")
    end
    local wds = {}
    for k,v in ipairs(days) do
        table.insert(wds, TimeMgr.GetWeekDayStr(v))
    end

    return string.join(wds,',')
end

--将秒数时间段转换成时间，如0:86400 转换成00:00:00-24:00:00,可以多个用;分割
--支持0:604800 周几显示,如周一00:00:00 - 周五20:00:00
function TimeMgr.ConvertTimeString(openTimeStrs,splitChar)
    if splitChar == nil then
        splitChar = " "
    end

    local times = DBLogic.ConverSplitTable(openTimeStrs)
    local strs = {}
    for k,v in ipairs(times) do
        local startTime = tonumber(v[1])
        local endTime = startTime + tonumber(v[2])

        local startWeekday = ""
        local endWeekDay = ""
        if startTime > 86400 or endTime > 86400 then
            startWeekday = TimeMgr.ConvertWeekTimeToWeekDayStr(startTime)
            endWeekDay = TimeMgr.ConvertWeekTimeToWeekDayStr(endTime)

            --周天一样时，只显示一个周X
            if startWeekday == endWeekDay then
                endWeekDay = ""
            end
            startTime = math.mod(startTime,86400)
            endTime = math.mod(endTime,86400)
        end

        local openTimeS = TimeMgr.ConverToTimeFromSecond(startTime)
        local endTimeS = TimeMgr.ConverToTimeFromSecond(endTime)
        if inverted then
            table.insert(strs, endWeekDay ..endTimeS .. "-" .. startWeekday .. openTimeS)
        else
            table.insert(strs, startWeekday .. openTimeS .. "-" .. endWeekDay ..endTimeS)
        end
    end

    if openTimeStrs == "0:86400" then
        return Language.Get("timemgr_text9")
    end

    return string.join(strs, splitChar)
end

--判断当前是否在周时间范围内，0:12800;43200:12800 ,冒号前为开始时间，后为持续时间
function TimeMgr.IsInWeekTimeStr(weekTimeStr)
    if weekTimeStr == nil or weekTimeStr == "" then
        return false
    end
    local weekTimes = string.split(weekTimeStr,';')
    for i,v in ipairs(weekTimes) do
        local timeSeg = string.split(v,':')
        if timeSeg ~= nil and #timeSeg == 2 then
            local startTime = tonumber(timeSeg[1]) + TimeMgr.GetCurWeekStartStamp()
            local endTime = startTime + tonumber(timeSeg[2])
            local curTime = TimeMgr.GetServerTimeInt()
            if curTime >= startTime and curTime <= endTime then
                return true
            end
        end
    end
    return false
end

local DelayTimers = {}
local TimerStartId = 0

function TimeMgr.DelayDo(func,delay)
    if func ~= nil and delay ~= nil then
        TimerStartId = TimerStartId + 1
        local timerId = TimerStartId
        local timer = Timer.New(function()
            DelayTimers[timerId].func()
            DelayTimers[timerId] = nil
        end, delay, false, false)
        DelayTimers[timerId] = {}
        DelayTimers[timerId].func = func
        DelayTimers[timerId].timer = timer
        timer:Start()
    end
end
