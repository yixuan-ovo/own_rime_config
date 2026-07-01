local M = {}

local corrections_file = "/dicts/dicts_LMDG/cuoyin.dict.yaml"

local function load_corrections()
    local corrections = {}
    local file = io.open(rime_api.get_user_data_dir() .. corrections_file, "r")
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
    env.keep_comment = config:get_bool('translator/keep_comments')
    local delimiter = config:get_string('speller/delimiter')
    if delimiter and #delimiter > 0 and delimiter:sub(1,1) ~= ' ' then
        env.delimiter = delimiter:sub(1,1)
    end
    env.name_space = env.name_space:gsub('^*', '')
    M.style = config:get_string(env.name_space) or '{comment}'
    M.corrections = load_corrections()
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
