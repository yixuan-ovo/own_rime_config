--[[
	错音错字提示。
	示例：「给予」的正确读音是 ji yu，当用户输入 gei yu 时，在候选项的 comment 显示正确读音
	示例：「按耐」的正确写法是「按捺」，当用户输入「按耐」时，在候选项的 comment 显示正确写法

	关闭此 Lua 时，同时需要关闭 translator/spelling_hints，否则 comment 里都是拼音

	为了让这个 Lua 同时适配全拼与双拼，使用 `spelling_hints` 生成的 comment（全拼拼音）作为通用的判断条件。
	感谢大佬@[Shewer Lu](https://github.com/shewer)提供的思路。

	容错词使用 dicts/dicts_LMDG/cuoyin.dict.yaml。
	可通过方案中的 corrector/dictionary 覆写词库路径。
--]]

local M = {}

local default_corrections_file = "dicts/dicts_LMDG/cuoyin.dict.yaml"

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

local function load_corrections(corrections_file)
    local corrections = {}
    local file = open_resource(normalize_path(corrections_file))
    if not file then
        return corrections
    end

    for line in file:lines() do
        local text, code, comment = line:match("^([^\t#][^\t]*)\t([^\t]+)\t[^\t]*\t(.+)$")
        if text and code and comment then
            local items = corrections[code]
            local item = { text = text, comment = comment }
            if items then
                items[#items + 1] = item
            else
                corrections[code] = { item }
            end
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
    M.style = config:get_string(env.name_space .. '/style')
        or config:get_string(env.name_space)
        or '{comment}'
    local corrections_file = config:get_string(env.name_space .. '/dictionary')
        or default_corrections_file
    M.corrections = load_corrections(corrections_file)
end

function M.func(input, env)
    for cand in input:iter() do
        -- cand.comment 是目前输入的词汇的完整拼音
        local pinyin = cand.comment:match("^［(.-)］$") or cand.comment
        if pinyin and #pinyin > 0 then
            local correction_pinyin = pinyin
            if env.delimiter then
                correction_pinyin = correction_pinyin:gsub(env.delimiter,' ')
            end
            local corrections = M.corrections[correction_pinyin]
            local correction_comment
            if corrections then
                for i = #corrections, 1, -1 do
                    local c = corrections[i]
                    if cand.text == c.text then
                        correction_comment = c.comment
                        break
                    end
                end
            end
            if correction_comment then
                cand:get_genuine().comment = string.gsub(M.style, "{comment}", correction_comment)
            else
                if env.keep_comment then
                    cand:get_genuine().comment = string.gsub(M.style, "{comment}", pinyin)
                else
                    cand:get_genuine().comment = ""
                end
            end
        end
        yield(cand)
    end
end

return M
