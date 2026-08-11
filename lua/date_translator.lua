-- 日期时间，可在方案中配置触发关键字。

local convert_num = require("convert_ar_num_to_zh").convert
local convert_digits = require("convert_ar_num_to_zh").digits

-- 让日期时间候选项出现在前列
local function yield_cand(seg, text)
    local cand = Candidate('', seg.start, seg._end, text, '')
    cand.quality = 100
    yield(cand)
end

local M = {}

local month_names_short = {
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
}
local month_names_long = {
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
}

function M.init(env)
    local config = env.engine.schema.config
    env.name_space = env.name_space:gsub('^*', '')
    M.date = config:get_string(env.name_space .. '/date') or 'rq'
    M.time = config:get_string(env.name_space .. '/time') or 'sj'
    M.week = config:get_string(env.name_space .. '/week') or 'xq'
    M.datetime = config:get_string(env.name_space .. '/datetime') or 'dt'
    M.timestamp = config:get_string(env.name_space .. '/timestamp') or 'ts'
    M.month = config:get_string(env.name_space .. '/month') or 'yf'
    M.date_zh = config:get_string(env.name_space .. '/datezh') or 'rqzh'
    M.date_en = config:get_string(env.name_space .. '/dateen') or 'rqen'
end

function M.func(input, seg, env)
    -- 日期
    if (input == M.date) then
        local current_time = os.time()
        yield_cand(seg, os.date('%Y-%m-%d', current_time))
        yield_cand(seg, os.date('%Y/%m/%d', current_time))
        yield_cand(seg, os.date('%Y.%m.%d', current_time))
        yield_cand(seg, os.date('%Y%m%d', current_time))
        yield_cand(seg, os.date('%Y年%m月%d日', current_time):gsub('年0', '年'):gsub('月0','月'))
        yield_cand(seg, os.date('%m-%d-%Y', current_time))
        yield_cand(seg, string.format(
            '%s年%s月%s日',
            convert_digits(tonumber(os.date('%Y', current_time)), true),
            convert_num(tonumber(os.date('%m', current_time))),
            convert_num(tonumber(os.date('%d', current_time)))
        ))

    -- 时间
    elseif (input == M.time) then
        local current_time = os.time()
        local hour = tonumber(os.date('%H', current_time))
        local period_name
        if hour >= 5 and hour < 11 then
            period_name = '早上'
        elseif hour >= 11 and hour < 13 then
            period_name = '中午'
        elseif hour >= 13 and hour < 18 then
            period_name = '下午'
        elseif hour >= 18 and hour < 24 then
            period_name = '晚上'
        else
            period_name = '凌晨'
        end
        yield_cand(seg, os.date('%H:%M', current_time))
        yield_cand(seg, os.date('%H:%M:%S', current_time))
        yield_cand(seg, period_name .. ' ' .. os.date('%I:%M', current_time))
        yield_cand(seg, os.date('%I:%M %p', current_time))
        yield_cand(seg, os.date('%Y%m%d%H%M%S', current_time))
        yield_cand(seg, os.date('%H点%M分%S秒', current_time))

    -- 星期
    elseif (input == M.week) then
        local current_time = os.time()
        local week_tab = {'日', '一', '二', '三', '四', '五', '六'}
        local text = week_tab[tonumber(os.date('%w', current_time) + 1)]
        yield_cand(seg, '周' .. text)
        yield_cand(seg, '星期' .. text)
        yield_cand(seg, '礼拜' .. text)
        yield_cand(seg, os.date('%A', current_time))
        yield_cand(seg, os.date('%a', current_time))
        yield_cand(seg, os.date('%W', current_time))

    -- ISO 8601/RFC 3339 的时间格式
    elseif (input == M.datetime) then
        local current_time = os.time()
        local timezone = os.date('%z', current_time)
        if not timezone or not timezone:match('^[+-]%d%d%d%d$') then
            timezone = '+0800'
        end
        local iso_timezone = (timezone == '+0000' or timezone == '-0000')
            and 'Z'
            or timezone:gsub('(%d%d)$', ':%1')
        yield_cand(seg, os.date('%Y-%m-%dT%H:%M:%S', current_time) .. iso_timezone)
        yield_cand(seg, os.date('%Y-%m-%d %H:%M:%S', current_time))
        yield_cand(seg, os.date('%Y%m%d%H%M%S', current_time))

    -- 时间戳（十位数，到秒，示例 1650861664）
    elseif (input == M.timestamp) then
        local current_time = os.time()
        yield_cand(seg, string.format('%d', current_time))

    -- 月份
    elseif (input == M.month) then
        local current_time = os.time()
        yield_cand(seg, os.date('%B', current_time))
        yield_cand(seg, os.date('%b', current_time))

    -- 中文日期
    elseif (input == M.date_zh) then
        local current_time = os.time()
        local year = tonumber(os.date('%Y', current_time))
        local month = convert_num(tonumber(os.date('%m', current_time)))
        local day = convert_num(tonumber(os.date('%d', current_time)))
        yield_cand(seg, string.format('%s年%s月%s日', convert_digits(year, true), month, day))
        yield_cand(seg, string.format('%s年%s月%s日', convert_digits(year, false), month, day))
        yield_cand(seg, os.date('%Y年%m月%d日', current_time):gsub('年0', '年'):gsub('月0', '月'))

    -- 英文日期
    elseif (input == M.date_en) then
        local current_time = os.time()
        local day = tonumber(os.date('%d', current_time))
        local month = tonumber(os.date('%m', current_time))
        local year = os.date('%Y', current_time)
        yield_cand(seg, string.format('%d %s %s', day, month_names_long[month], year))
        yield_cand(seg, string.format('%s %d, %s', month_names_long[month], day, year))
        yield_cand(seg, string.format('%d %s %s', day, month_names_short[month], year))
    end

    -- -- 显示内存
    -- local cand = Candidate("date", seg.start, seg._end, ("%.f"):format(collectgarbage('count')), "")
    -- cand.quality = 100
    -- yield(cand)
    -- if input == "xxx" then
    --     collectgarbage()
    --     local cand = Candidate("date", seg.start, seg._end, "collectgarbage()", "")
    --     cand.quality = 100
    --     yield(cand)
    -- end
end

return M
