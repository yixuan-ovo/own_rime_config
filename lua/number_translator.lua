-- 数字、金额大写 (任意大写字母引导+数字)

local function splitNumPart(str)
    local part = {}
    part.int, part.dot, part.dec = string.match(str, "^(%d*)(%.?)(%d*)")
    return part
end

local function decimal_func(str, posMap, valMap)
    local dec
    posMap = posMap or {[1]="角"; [2]="分"; [3]="厘"; [4]="毫"}
    valMap = valMap or {[0]="零"; "壹"; "贰"; "叁" ;"肆"; "伍"; "陆"; "柒"; "捌"; "玖"}
    if #str > 4 then dec = string.sub(tostring(str), 1, 4) else dec = tostring(str) end
    dec = string.gsub(dec, "0+$", "")
    
    if dec == "" then return "整" end

    local result = ""
    for pos = 1, #dec do
        local val = tonumber(string.sub(dec, pos, pos))
        if val ~= 0 then 
            result = result .. valMap[val] .. posMap[pos] 
        else 
            result = result .. valMap[val] 
        end
    end
    result = result:gsub(valMap[0]..valMap[0], valMap[0])
    return result:gsub(valMap[0]..valMap[0], valMap[0])
end

local function formatNum(num, t)
    local digitUnit, wordFigure
    local result = ""
    num = tostring(num)
    if tonumber(t) < 1 then 
        digitUnit = {"", "十", "百", "千"} 
    else 
        digitUnit = {"", "拾", "佰", "仟"} 
    end
    
    if tonumber(t) < 1 then
        wordFigure = {"〇", "一", "二", "三", "四", "五", "六", "七", "八", "九"}
    else 
        wordFigure = {"零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"} 
    end
    
    if string.len(num) > 4 or tonumber(num) == 0 then return wordFigure[1] end
    local lens = string.len(num)
    for i = 1, lens do
        local n = wordFigure[tonumber(string.sub(num, -i, -i)) + 1]
        if n ~= wordFigure[1] then 
            result = n .. digitUnit[i] .. result 
        else 
            result = n .. result 
        end
    end
    result = result:gsub(wordFigure[1]..wordFigure[1], wordFigure[1])
    result = result:gsub(wordFigure[1].."$", "")
    return result
end

function number2cnChar(num, flag, digitUnit, wordFigure)
    local result = ""
    local nNum = tonumber(num) or 0
    local num1, num2 = math.modf(nNum)
    
    -- 只有当没有小数部分时才继续（因为该函数主要处理整数部分的中文读法）
    if num2 == 0 then
        if tonumber(flag) < 1 then
            digitUnit = digitUnit or {[1]="万"; [2]="亿"}
            wordFigure = wordFigure or {[1]="〇"; [2]="一"; [3]="十"; [4]="元"}
        else
            digitUnit = digitUnit or {[1]="万"; [2]="亿"}
            wordFigure = wordFigure or {[1]="零"; [2]="壹"; [3]="拾"; [4]="元"}
        end
        
        local sNum = tostring(num1)
        local lens = string.len(sNum)
        
        if lens < 5 then 
            result = formatNum(sNum, flag) 
        elseif lens < 9 then 
            result = formatNum(string.sub(sNum, 1, -5), flag) .. digitUnit[1] .. formatNum(string.sub(sNum, -4, -1), flag)
        elseif lens < 13 then 
            result = formatNum(string.sub(sNum, 1, -9), flag) .. digitUnit[2] .. formatNum(string.sub(sNum, -8, -5), flag) .. digitUnit[1] .. formatNum(string.sub(sNum, -4, -1), flag) 
        else 
            result = "" 
        end
        
        result = result:gsub("^" .. wordFigure[1], "")
        result = result:gsub(wordFigure[1] .. digitUnit[1], "")
        result = result:gsub(wordFigure[1] .. digitUnit[2], "")
        result = result:gsub(wordFigure[1] .. wordFigure[1], wordFigure[1])
        result = result:gsub(wordFigure[1] .. "$", "")
        
        if lens > 4 then result = result:gsub("^" .. wordFigure[2] .. wordFigure[3], wordFigure[3]) end
        if result ~= "" then result = result .. wordFigure[4] else result = "数值超限！" end
    else 
        return "数值超限！" 
    end

    return result
end

local function number2zh(num, t)
    local result, wordFigure
    result = ""
    if tonumber(t) < 1 then
        wordFigure = {"〇", "一", "二", "三", "四", "五", "六", "七", "八", "九"}
    else 
        wordFigure = {"零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"} 
    end
    for pos = 1, string.len(num) do
        local n = tonumber(string.sub(num, pos, pos))
        result = result .. wordFigure[n + 1]
    end
    return result
end

local function number_translatorFunc(num)
    local numberPart = splitNumPart(num)
    local result = {}
    if numberPart.dot ~= "" then
        table.insert(result, {number2cnChar(numberPart.int, 0, {"万", "亿"}, {"〇", "一", "十", "点"}) .. number2zh(numberPart.dec, 0), "〔数字小写〕"})
        table.insert(result, {number2cnChar(numberPart.int, 1, {"萬", "億"}, {"〇", "一", "十", "点"}) .. number2zh(numberPart.dec, 1), "〔数字大写〕"})
    else
        table.insert(result, {number2cnChar(numberPart.int, 0, {"万", "亿"}, {"〇", "一", "十", ""}), "〔数字小写〕"})
        table.insert(result, {number2cnChar(numberPart.int, 1, {"萬", "億"}, {"零", "壹", "拾", ""}), "〔数字大写〕"})
    end
    table.insert(result, {number2cnChar(numberPart.int, 0) .. decimal_func(numberPart.dec, {[1]="角"; [2]="分"; [3]="厘"; [4]="毫"}, {[0]="〇"; "一"; "二"; "三"; "四"; "五"; "六"; "七"; "八"; "九"}), "〔金额小写〕"})
    table.insert(result, {number2cnChar(numberPart.int, 1) .. decimal_func(numberPart.dec, {[1]="角"; [2]="分"; [3]="厘"; [4]="毫"}, {[0]="零"; "壹"; "贰"; "叁"; "肆"; "伍"; "陆"; "柒"; "捌"; "玖"}), "〔金额大写〕"})
    return result
end

local function number_translator(input, seg, env)
    -- 注意：请确保 schema 中 recognizer 定义正确
    local str = ""
    if input:sub(1, 1):match("%a") then
        str = input:sub(2)
        if str:match("^%d+%.?%d*$") then
            local numberPart = number_translatorFunc(str)
            for i = 1, #numberPart do
                yield(Candidate(input, seg.start, seg._end, numberPart[i][1], numberPart[i][2]))
            end
        end
    end
end

return number_translator