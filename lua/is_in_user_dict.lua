-- 根据是否在用户词典，在结尾加上一个星号 *
-- is_in_user_dict: true           输入过的内容
-- is_in_user_dict: false 或不写    未输入过的内容



-- 根据是否在用户词典，追加标记符号
-- 📰 表示用户词典中；👻 表示整句联想

local M = {}

function M.init(env)
  -- 获取配置（如未设置，默认启用）
  local config = env.engine.schema.config
  env.name_space = env.name_space:gsub('^*', '')
  M.is_in_user_dict = config:get_bool(env.name_space) or true
end

function M.func(input, env)
  for cand in input:iter() do
    local comment = cand.comment or ""

    -- ✅ 用户词典中，追加 ★
    if cand.type == "user_phrase" and not comment:find("★") then
      comment = comment .. "📰"
    end

    -- ✅ 整句联想，追加 ∞
    if cand.type == "sentence" and not comment:find("∞") then
      comment = comment .. "👻"
    end

    cand.comment = comment
    yield(cand)
  end
end

return M
