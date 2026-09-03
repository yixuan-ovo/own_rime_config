--[[
	错音错字提示。
	示例：「给予」的正确读音是 ji yu，当用户输入 gei yu 时，在候选项的 comment 显示正确读音
	示例：「按耐」的正确写法是「按捺」，当用户输入「按耐」时，在候选项的 comment 显示正确写法

	关闭此 Lua 时，同时需要关闭 translator/spelling_hints，否则 comment 里都是拼音

	为了让这个 Lua 同时适配全拼与双拼，使用 `spelling_hints` 生成的 comment（全拼拼音）作为通用的判断条件。
	感谢大佬@[Shewer Lu](https://github.com/shewer)提供的思路。

	容错词默认同时使用 LMDG 与 rime-ice 两份 YAML。
	可通过方案中的 corrector/dictionary 和 corrector/extra_dictionary 覆写路径。
--]]

local M = {}

local default_corrections_file = "dicts/dicts_LMDG/cuoyin.dict.yaml"
local default_extra_corrections_file = "dicts/corrections_rime_ice.dict.yaml"

-- 借鉴 oh-my-rime 8e7ea62：统一带调/无调拼音及分隔符，但仍按候选文字匹配。
local tone_map = {
    ["ā"] = "a", ["á"] = "a", ["ǎ"] = "a", ["à"] = "a",
    ["ō"] = "o", ["ó"] = "o", ["ǒ"] = "o", ["ò"] = "o",
    ["ē"] = "e", ["é"] = "e", ["ě"] = "e", ["è"] = "e",
    ["ī"] = "i", ["í"] = "i", ["ǐ"] = "i", ["ì"] = "i",
    ["ū"] = "u", ["ú"] = "u", ["ǔ"] = "u", ["ù"] = "u",
    ["ǖ"] = "v", ["ǘ"] = "v", ["ǚ"] = "v", ["ǜ"] = "v", ["ü"] = "v",
    ["ń"] = "n", ["ň"] = "n", ["ǹ"] = "n", ["ḿ"] = "m",
}

local function compact_code(code)
    return (code:gsub(utf8.charpattern, function(char)
        return tone_map[char] or char
    end):gsub("[ '`1-5]", ""))
end

local pinyin_types = { phrase = true, sentence = true, user_phrase = true }

local function append_correction(corrections, code, item)
    local items = corrections[code]
    if items then
        items[#items + 1] = item
    else
        corrections[code] = { item }
    end
end

local function normalize_path(path)
    path = path:gsub("\\", "/")
    if path:sub(1, 1) ~= "/" then
        path = "/" .. path
    end
    return path
end

local function open_resource(relative_path)
    local file = io.open(rime_api.get_user_data_dir() .. relative_path, "r")
    if not file and rime_api.get_shared_data_dir then
        file = io.open(rime_api.get_shared_data_dir() .. relative_path, "r")
    end
    return file
end

local function load_corrections(corrections, compact_corrections, corrections_file)
    local file = open_resource(normalize_path(corrections_file))
    if not file then
        return corrections
    end

    for line in file:lines() do
        local text, code, comment = line:match("^([^\t#][^\t]*)\t([^\t]+)\t[^\t]*\t(.+)$")
        if text and code and comment then
            local item = { text = text, comment = comment }
            append_correction(corrections, code, item)
            append_correction(compact_corrections, compact_code(code), item)
        end
    end

    file:close()
    return corrections
end

function M.init(env)
    local config = env.engine.schema.config
    env.name_space = env.name_space:gsub('^*', '')
    env.keep_comment = config:get_bool('translator/keep_comments')
    local delimiter = config:get_string('speller/delimiter')
    if delimiter and #delimiter > 0 and delimiter:sub(1,1) ~= ' ' then
        env.delimiter = delimiter:sub(1,1)
    end
    env.style = config:get_string(env.name_space .. '/style')
        or config:get_string(env.name_space)
        or '{comment}'
    local corrections_file = config:get_string(env.name_space .. '/dictionary')
        or default_corrections_file
    local extra_corrections_file = config:get_string(env.name_space .. '/extra_dictionary')
        or default_extra_corrections_file
    env.corrections = {}
    env.compact_corrections = {}
    load_corrections(env.corrections, env.compact_corrections, corrections_file)
    if extra_corrections_file ~= corrections_file then
        load_corrections(env.corrections, env.compact_corrections, extra_corrections_file)
    end
end

local function find_comment(corrections, text)
    for i = #(corrections or {}), 1, -1 do
        if corrections[i].text == text then
            return corrections[i].comment
        end
    end
end

function M.func(input, env)
    for cand in input:iter() do
        -- 日期、Unicode、反查、英文等翻译器的注释不是 spelling_hints。
        if pinyin_types[cand.type] then
            local genuine = cand:get_genuine()
            local pinyin = cand.comment or ""
            pinyin = pinyin:match("^［(.-)］$") or pinyin
            local correction_pinyin = pinyin
            if env.delimiter then
                correction_pinyin = correction_pinyin:gsub(env.delimiter, ' ')
            end
            local correction_comment = find_comment(env.corrections[correction_pinyin], cand.text)
                or find_comment(env.compact_corrections[compact_code(correction_pinyin)], cand.text)
            -- 全拼注释可能被 Rime 隐藏；预编辑已由 super_preedit 转为拼音。
            if not correction_comment then
                correction_comment = find_comment(
                    env.compact_corrections[compact_code(genuine.preedit or "")], cand.text)
            end
            if correction_comment then
                genuine.comment = env.style:gsub("{comment}", function() return correction_comment end)
            elseif env.keep_comment then
                genuine.comment = env.style:gsub("{comment}", function() return pinyin end)
            else
                genuine.comment = ""
            end
        end
        yield(cand)
    end
end

return M
