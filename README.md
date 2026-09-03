# own_rime_config

这是一套面向个人使用的 Rime 配置：以 [oh-my-rime / 薄荷输入法](https://github.com/Mintimate/oh-my-rime) 为配置骨架，以 [RIME-LMDG / 万象](https://github.com/amzxyz/RIME-LMDG) 为中文词库和语法模型底座，并整合 [rime-frost / 白霜拼音](https://github.com/gaboolic/rime-frost) 与 [rime-ice / 雾凇拼音](https://github.com/iDvel/rime-ice) 的词库和功能。

|上游项目|本项目中的主要用途|
|-|-|
|oh-my-rime / 薄荷输入法|小鹤双拼、地球拼音、英文子方案、基础配置与 Weasel 界面骨架|
|RIME-LMDG / 万象|带声调中文词库、词频、语法模型和带调预编辑|
|rime-frost / 白霜拼音|细胞词库、白霜单字辅码和句中任意位置辅助码|
|rime-ice / 雾凇拼音|英文词库、补充纠错数据、Emoji、符号以及多项 Lua 工具|

## 上游维护记录

- [2026-09-03：上游对比、更新与部署验证](docs/upstream-updates/2026-09-03.md)：更新现有 LMDG、白霜细胞词库、雾凇英文/纠错/Emoji；适配薄荷的注释修复。保留小鹤双拼习惯、语法模型、词库引用顺序和个人配置。
- 更新按文件来源选择性同步，不把任意一个上游整套覆盖到本项目。模型及实际用户目录中的 `*.userdb`、`sync/` 不属于词库更新内容。

## 整合的功能

### 从 rime-ice 整合的功能

1. **Lua 脚本增强**
   - `unicode.lua` - Unicode 字符输入（如 `U62fc` 得到「拼」）
   - `uuid.lua` - UUID 生成（输入 `uuid`）
   - `pin_cand_filter.lua` - 置顶候选项
   - `long_word_filter.lua` - 长词优先（提升「西安」「提案」等词汇的优先级）
   - `v_filter.lua` - v 模式符号优先
   - `date_translator.lua` - 日期时间输入（触发关键字：`rq`, `sj`, `xq`, `dt`, `ts`, `yf`, `rqzh`, `rqen`）
   - `lunar.lua` + `lunar.db` - 农历输入（触发关键字：`lunar`，公历转农历：`N20240115`，支持自定义输出格式）

2. **符号输入系统升级**
   - 整合了 rime-ice 的 v 模式符号系统
   - 支持 `/` 和 `v` 两种模式的符号输入
   - 包含丰富的符号分类（电脑符号、象棋、麻将、色子、扑克、Emoji、天气、音乐等）

3. **配置文件优化**
   - 优化了 `default.yaml`（添加了 `digit_separators`、更完善的 `recognizer`、更详细的 `key_binder` 等）
   - 优化了 `weasel.yaml`（添加了 Firefox 的 `inline_preedit` 配置等）

4. **方案文件增强**
   - 为 `double_pinyin_flypy` 和 `terra_pinyin_all` 两个方案添加了 rime-ice 的功能
   - 保留了 own_rime_config 的特色功能（小鹤双拼辅码、super_preedit、万象语法模型等）

### 保留的特色功能

- 小鹤双拼辅码（仅 flypy）
- super_preedit 全拼音调显示
- 万象语法模型相关配置
- 白霜/墨奇辅助码：单字精确查找和词组、整句候选过滤
- 自定义配色方案（yixuan1-6）
- 拆字反查功能
- 用户词典标记（is_in_user_dict.lua）

# 列表-配置文件说明

## 核心配置文件

|**🌟 文件名**|**🧠 释义**|**🔧 备注**|
|:-:|-|-|
|default.yaml|全局默认配置|包含方案列表、菜单、快捷键、标点符号等全局设置|
|default.custom.yaml|全局配置覆写|当前为空补丁 `patch: {}`|
|weasel.yaml|Weasel 前端配置|Windows 小狼毫样式、配色、布局等设置|
|weasel.custom.yaml|Weasel 配置覆写|自定义前端设置|

## 输入方案文件

|**🌟 文件名**|**🧠 释义**|**🔧 备注**|
|:-:|-|-|
|double_pinyin_flypy.schema.yaml|小鹤双拼-ytq改|主输入方案，支持辅码、拆字、音调显示等|
|double_pinyin_flypy.custom.yaml|小鹤双拼配置覆写|激活万象语法模型等自定义设置|
|terra_pinyin_all.schema.yaml|地球拼音-ytq改|全拼备用方案，支持声调输入|
|terra_pinyin_all.dict.yaml|地球拼音词库|地球拼音专用词库文件|
|melt_eng.schema.yaml|英文输入方案|Easy English Nano，方便中英文混输|
|melt_eng.dict.yaml|英文词库|melt_eng 方案的词库文件|
|radical_pinyin_flypy.schema.yaml|小鹤拆字方案|偏旁部件拆字（小鹤），通过 Uu 触发，无需激活|
|radical_pinyin.schema.yaml|全拼拆字方案|偏旁部件拆字（全拼），通过 `u` 触发|
|radical_pinyin.dict.yaml|拆字字库|拆字反查依赖的字库文件|
|rime_frost_aux.schema.yaml|白霜单字辅码依赖方案|负责编译 `rime_frost_aux` 辅码词典|

## 词库文件

|**🌟 文件名**|**🧠 释义**|**🔧 备注**|
|:-:|-|-|
|rime_mint.dict.yaml|主词库配置|小鹤双拼依赖的主词库，整合万象词库|
|terra_pinyin_all.dict.yaml|地球拼音主词库配置|与小鹤方案共享同一套分层词库|
|rime_frost_aux.dict.yaml|白霜单字辅码词典|编码格式为 ``拼音`辅码``，配合 `frost_aux` 翻译器使用|
|wanxiang-lts-zh-hans.gram|万象语法模型|需要自行下载并放入实际使用的 Rime 用户目录，不随本仓库分发|

## Lua 脚本文件

|**🌟 文件名**|**🧠 释义**|**🔧 备注**|
|:-:|-|-|
|lua/unicode.lua|Unicode 字符输入|输入 `U62fc` 得到「拼」|
|lua/uuid.lua|UUID 生成器|输入 `uuid` 生成 UUID v4|
|lua/pin_cand_filter.lua|置顶候选项|自定义候选项置顶规则，提升常用词优先级|
|lua/long_word_filter.lua|长词优先|提升「西安」「提案」等长词优先级|
|lua/v_filter.lua|v 模式符号优先|优化 v 模式符号输入体验|
|lua/date_translator.lua|日期时间翻译器|触发：`rq`(日期)、`sj`(时间)、`xq`(星期)、`dt`(ISO 8601)、`ts`(时间戳)、`yf`(月份)、`rqzh`(中文日期)、`rqen`(英文日期)|
|lua/lunar.lua|农历翻译器|输入 `lunar` 获取当前日期农历，输入 `N20240115` 公历转农历，支持星期和节气显示|
|lua/number_translator.lua|数字金额翻译器|输入 `R1234.56` 转换为中文大写金额|
|lua/mint_calculator_translator.lua|计算器|输入 `=1+2*3` 进行计算|
|lua/corrector.lua|错音错字提示|同时读取 LMDG 与 rime-ice 两份纠错 YAML，显示正确读音或写法|
|lua/super_preedit.lua|全拼音调显示|实时显示带声调的全拼拼音|
|lua/autocap_filter.lua|英文自动大写|自动识别需要大写的英文单词|
|lua/reduce_english_filter.lua|降低英文优先级|降低部分英文单词在候选项的位置|
|lua/auxCode_filter.lua|辅码过滤器|小鹤双拼辅码（音形）支持|
|lua/aux_lookup_filter.lua|白霜辅助码过滤器|使用墨奇辅码筛选词组和整句候选|
|lua/is_in_user_dict.lua|用户词典标记|用户词追加 `🍃`，自动造句追加 `🍡`|
|lua/codeLengthLimit_processor.lua|输入长度限制|限制最大输入长度，防止卡顿|
|lua/select_character.lua|以词定字|通过快捷键选择词的首字或尾字|
|lua/force_gc.lua|强制垃圾回收|定期清理内存，解决长期使用卡顿|
|lua/tag_user_dict.lua|用户词典标签|用户词典相关功能|

## 符号和快捷键配置

|**🌟 文件名**|**🧠 释义**|**🔧 备注**|
|:-:|-|-|
|symbols.yaml|符号输入配置|定义 `/` 和 `v` 两种模式的符号输入，如 `/bq`、`vfh` 等|
|terra_symbols_all.yaml|地球拼音符号|地球拼音专用的符号快捷键配置|

## OpenCC 转换配置

|**🌟 文件名**|**🧠 释义**|**🔧 备注**|
|:-:|-|-|
|opencc/emoji.json|Emoji 转换配置|中文转 Emoji 表情|
|opencc/fly_Chaifen.json|小鹤拆字显示|显示拆字结果，如：乙 〔フフ｜yivv〕|
|s2t.json|简体转繁体|默认由 Weasel/Rime 共享数据目录提供，本仓库不重复保存|

配置文件中大部分都有注释，配合教程：[配置覆写](https://www.mintimate.cc/zh/guide/configurationOverride.html)

---

# 1. 待解决:

~~1. 拆字同时显示中文和双拼拼音~~

2. is_in_user_lua文件无法和拆字共存

~~3. 有点卡顿,考虑禁用腾讯字库~~

~~4. 候选项的emoji有点太多了,需要降低权重~~

~~5. 地球拼音重复问题,需删除Rime\weasel-0.17.4\data下的terra同名文件,或者改名~~

~~6. 字库重复太多,删除data下bin文件重新部署报错~~

# 2. 已修改:

## 词库相关
1. `rime_mint.dict.yaml` 修改词库，采用雾凇 `en_dicts`、白霜 `cn_dicts_cell`、万象模型和 `dicts_LMDG`
2. 按来源与用途整理词库引用；候选主要按词条权重排序，引用顺序用于组织和同权重兜底
3. 删除与 LMDG、细胞词库高度重合的腾讯词库，减少部署体积和重复候选

## 输入方案相关
4. 删除不需要的输入法，只保留小鹤双拼-月七改和地球拼音-月七改
5. 合并 terra_pinyin 和 rime_mint 为一个输入法（terra 为主）
6. 修改 terra_pinyin_all，防止名称重复不显示
7. 方案名称统一改为“ytq改”

## 功能增强（整合 rime-ice）
8. 补充 Lua 脚本：unicode、uuid、pin_cand_filter、long_word_filter、v_filter、date_translator、lunar
9. 升级符号输入系统：整合 v 模式符号，支持 `/` 和 `v` 两种模式
10. 优化配置文件：default.yaml 和 weasel.yaml，添加更多实用配置
11. 增强方案文件：为两个方案添加 rime-ice 的功能（Unicode、UUID、置顶候选项、长词优先等）
12. 接通白霜辅码：单字使用 `table_translator@frost_aux`，词组和整句使用 `aux_lookup_filter.lua`

## 界面和体验
13. preview 增加自定义配色皮肤 + 预览图（yixuan1-6），当前 `weasel.custom.yaml` 使用 yixuan5
14. 增加 `is_in_user_dict.lua`：用户词用 `🍃` 标记，自动造句用 `🍡` 标记
15. 增加小键盘的数字、符号可被计算器调用
16. 优化快捷键配置，支持更多便捷操作

# 3. 可忽略的部署提示

![](ihjmerr.png)

```
optional resource not loaded: symbols.custom
```
这是 Rime 查找未定义的可选 patch 文件时产生的提示。

不影响输入法功能，可以忽略，或者添加空的 `symbols.custom.yaml` 来去除提示。

例如：`patch: {}`。`terra_pinyin_all.custom.yaml` 已经存在，不再属于这一问题。

雾凇 `en_ext` 与 `en` 保留了一些有意重叠的英文词条和权重，完整重编译英文词库时可能出现 `duplicate word definition`。上游明确允许这种重叠，不必为消除提示删词；英文引用仍保持 `en_ext` 在前、`en` 在后。

`Encode failure` 则不能一概忽略。英文主词库的 `use_preset_vocabulary` 应为 `false`，避免把中文预设词汇送进英文编码器。2026-09-03 已修复该旧配置，并消除了拆字方案自引用引起的循环依赖提示。

---

# 自用整合配置 

## ```安装到C盘内需将程序目录内的[WeaselServer.exe]兼容性设置为管理员```

本输入方案内主要使用：

- **小鹤双拼-ytq改**：基于小鹤双拼，整合 rime-ice 功能。支持：
  - 音形（形码）输入，通过 `;` 激活辅码显示
  - 拆字反查（通过 `Uu` 触发）
  - 全拼音调显示（super_preedit）
  - 万象语法模型（LMDG）
  - rime-ice 增强功能（Unicode、UUID、置顶候选项、长词优先等）
  - 白霜/墨奇辅助码（使用反引号 `` ` `` 触发）

- **地球拼音-ytq改**：全拼备用方案，支持：
  - 声调输入（通过 `-`、`/`、`<`、`\` 输入四声）
  - 万象语法模型
  - rime-ice 增强功能
  - 白霜/墨奇辅助码（使用反引号 `` ` `` 触发）

### 万象语法模型

方案覆写文件已经配置 `wanxiang-lts-zh-hans`。模型文件 `wanxiang-lts-zh-hans.gram` 由使用者自行下载并放入实际部署的 Rime 用户目录；仓库只保存模型配置，不保存模型文件。放入后重新部署即可加载。

### 白霜/墨奇辅助码

本项目保留两套互不冲突的辅助输入：

- `;`：小鹤双拼原有的鹤形辅码，只在小鹤方案中使用。
- 反引号 `` ` ``：白霜的墨奇辅助码，小鹤双拼和地球拼音都可以使用。

反引号辅码分成两条互补链路：

1. **单字精确查找**：`table_translator@frost_aux` 查询 `rime_frost_aux.dict.yaml`。例如输入 ``ni`rx`` 可精确查找「你、伱」。
2. **词组和整句过滤**：`aux_lookup_filter.lua` 读取 `lua/aux_code/moqi_aux_code.txt`，只保留辅助码匹配的候选。全拼可输入 ``shishi`b``，小鹤双拼对应输入 ``uiui`b``。

它的主要好处是：不改变日常拼音/双拼习惯，只在同音候选难以区分时追加 1～2 位形码；既能减少翻页，也能在长词或整句中针对有歧义的位置筛选。正常输入时码表延迟加载，额外开销较小。

## Tips

本地rime配置文件默认地址，如下

- Windows
  - Weasel: `%APPDATA%\Rime`
- Linux
  - iBus:`~/.config/ibus/rime`
  - Fcitx5: `~/.local/share/fcitx5/rime`

- Fctix5 Android(小企鹅入法): `/storage/emulated/0/Android/data/org.fcitx.fcitx5.android/files/data/rime/`

本地rime日志文件默认地址如下：

- Windows
  - Weasel: `%TEMP%`

- Linux
  - iBus:`/tmp`

---

## 词库定制以及更新

### 词库目录结构

```txt
dicts/
├── custom_simple.dict.yaml          # 自定义词库（用户自行维护，不会被覆盖）
│
├── dicts_LMDG/                      # 万象词库目录（RIME-LMDG）
│   ├── cuoyin.dict.yaml            # LMDG 错音错字对照表
│   ├── zi.dict.yaml                # 单字基础保障
│   ├── jichu.dict.yaml             # 常用词，主干词库
│   ├── duoyin.dict.yaml            # 多音字兼容优化
│   ├── mixed.dict.yaml              # 中英、数字等混合词条
│   ├── lianxiang.dict.yaml         # 五字及以上长词联想
│   ├── shici.dict.yaml             # 诗词/成语/典故类
│   ├── renming.dict.yaml           # 人名词库（专有名词）
│   ├── diming.dict.yaml            # 地名/行政区划（专有名词）
│   ├── huaxue.dict.yaml            # 化学词库
│   ├── yaopin.dict.yaml            # 药品词库
│   ├── yixue.dict.yaml             # 医学词库
│   ├── wuzhong.dict.yaml           # 物种词库（专业领域）
│   └── dikuang.dict.yaml           # 地质矿物词库（本项目保留）
│
├── cn_dicts_cell/                   # 细胞词库（细分类词库）
│   ├── food.dict.yaml              # 食品（日常高频）
│   ├── sport.dict.yaml             # 运动（日常高频）
│   ├── media.dict.yaml              # 媒体（日常高频）
│   ├── game.dict.yaml              # 游戏（日常高频）
│   ├── exthot.dict.yaml            # 网络热词（日常高频）
│   ├── animal.dict.yaml            # 动物（日常使用）
│   ├── idiom.dict.yaml             # 成语（日常使用）
│   ├── shulihua.dict.yaml          # 网络用语（日常使用）
│   ├── computer.dict.yaml          # 计算机（专业领域）
│   ├── medication.dict.yaml        # 医疗（专业领域）
│   ├── industry_product.dict.yaml  # 工业产品（专业领域）
│   ├── inputmethod.dict.yaml       # 输入法（专业领域）
│   ├── chess.dict.yaml             # 象棋（专业领域）
│   ├── chess2.dict.yaml            # 象棋2（专业领域）
│   ├── music.dict.yaml             # 音乐（文化类）
│   ├── literature.dict.yaml        # 文学（文化类）
│   ├── luna.dict.yaml              # 明月拼音扩展词库（当前未导入）
│   ├── history.dict.yaml           # 历史（文化类）
│   ├── place.dict.yaml             # 地名（专有名词）
│   ├── geography.dict.yaml         # 地理（专有名词）
│   ├── name.dict.yaml              # 人名（专有名词）
│   ├── name2.dict.yaml             # 人名2（专有名词）
│   └── composite.dict.yaml         # 复合词（扩展词库）
│
├── en_dicts/                        # 英文词库目录
│   ├── en.dict.yaml                 # 雾凇英文基础词库
│   ├── en_ext.dict.yaml             # 雾凇英文扩展词库
│   ├── cn_en_flypy.txt             # 中英混输（小鹤双拼风格）映射表
│   └── cn_en.txt                   # 中英混输（全拼风格）映射表
│
├── corrections_rime_ice.dict.yaml   # 从 rime-ice 纠错规则生成的补充词库
└── other_kaomoji.dict.yaml         # 颜文字表情词库（Kaomoji，按 `VV` 呼出）
```

### 词库更新说明

1. **万象词库更新**：同步 RIME-LMDG 中本项目已经引用的同名文件；`custom_simple.dict.yaml` 和本项目保留的 `dikuang.dict.yaml` 不应被覆盖或删除。

2. **自定义词库**：`dicts/custom_simple.dict.yaml` 是用户自定义词库，不会被自动更新覆盖，可以在此文件中添加个人常用词汇。

3. **词库优先级**：`sort: by_weight` 时候选主要按词条权重排序；引用顺序主要影响同权重候选和重复定义的兜底顺序，并不等同于全局优先级。

4. **词库分类说明**：
   - **纠错类**：`cuoyin`、`corrections_rime_ice` - 生成错音候选并显示纠错提示
   - **基础保障类**：`zi`、`jichu` - 单字和常用词，保证基本输入需求
   - **优化类**：`duoyin` - 多音字兼容，提升输入准确率
   - **联想类**：`lianxiang` - 长词联想，提升输入效率
   - **文化类**：`shici` - 诗词成语，丰富表达
   - **专有名词类**：`renming`、`diming` - 人名地名，靠后加载
   - **专业领域类**：`huaxue`、`yaopin`、`yixue`、`wuzhong`、`dikuang` 等

### 补充纠错的维护

`dicts/corrections_rime_ice.dict.yaml` 是生成文件，不手工维护。先更新 LMDG 的 `cuoyin.dict.yaml`，再从固定版本的雾凇 `lua/corrector.lua` 重新生成：

```powershell
python scripts/update_rime_ice_corrections.py `
  --source C:/path/to/rime-ice/lua/corrector.lua `
  --output dicts/corrections_rime_ice.dict.yaml `
  --exclude dicts/dicts_LMDG/cuoyin.dict.yaml `
  --version 2026.09.03
```

`--version` 填本次同步日期，并在维护记录中保存上游 commit。生成器排除与 LMDG **文字和编码完全相同**的规则；带调和无调编码仍可能并存，这是候选入口兼容，不是提示引擎重复执行。

两份纠错 YAML 仍同时导入主词库、同时被 `corrector.lua` 读取。提示匹配兼容声调和分隔符，且只处理主拼音候选。两个主方案都先运行 `super_preedit`，再运行 `corrector`，不要调换顺序：前者使用原始拼音生成预编辑，后者显示纠错、隐藏普通拼音注释，并保留 Unicode 等功能的说明。

如果想自己扩展词库，可以在输入法的字典配置文件内进行导入，比如字典配置文件[rime_mint.dict.yaml](rime_mint.dict.yaml)内：

```yaml
import_tables:
  - dicts/custom_simple          # 自定义

  # 核心词库
  - dicts/dicts_LMDG/zi                                    # 单字基础保障
  - dicts/dicts_LMDG/jichu                                 # 常用词，主干词库
  - dicts/dicts_LMDG/duoyin                                # 多音字兼容优化
  - dicts/dicts_LMDG/mixed                                 # 中英、数字等混合词条
  - dicts/dicts_LMDG/cuoyin                                # LMDG 纠错
  - dicts/corrections_rime_ice                             # rime-ice 补充纠错
  - dicts/dicts_LMDG/lianxiang                             # 五字及以上长词联想（靠后）

  - dicts/other_kaomoji          # 颜文字表情（按`VV`呼出)
  
  # 文化类
  - dicts/dicts_LMDG/shici                                 # 诗词/成语/典故类（靠后）
  # 专有名词类（靠后）
  - dicts/dicts_LMDG/renming                               # 人名词库（专有名词，靠后）
  - dicts/dicts_LMDG/diming                                # 地名/行政区划（专有名词，靠后）
  # 专业领域词库（靠后）
  - dicts/dicts_LMDG/huaxue                                # 化学词库
  - dicts/dicts_LMDG/yaopin                                # 药品词库
  - dicts/dicts_LMDG/yixue                                 # 医学词库
  - dicts/dicts_LMDG/wuzhong                               # 物种词库（专业领域，靠后）
  - dicts/dicts_LMDG/dikuang                               # 地质矿物词库（专业领域，靠后）

  # 细胞词库（按使用频率和重要性排列）
  # 日常常用词库（优先）
  - dicts/cn_dicts_cell/food              # 食品（日常高频）
  - dicts/cn_dicts_cell/sport             # 运动（日常高频）
  - dicts/cn_dicts_cell/media             # 媒体（日常高频）
  - dicts/cn_dicts_cell/game               # 游戏（日常高频）
  - dicts/cn_dicts_cell/exthot             # 网络热词（日常高频）
  - dicts/cn_dicts_cell/animal             # 动物（日常使用）
  - dicts/cn_dicts_cell/idiom              # 成语（日常使用）
  - dicts/cn_dicts_cell/shulihua           # 网络用语（日常使用）
  
  # 专业领域词库
  - dicts/cn_dicts_cell/computer           # 计算机（专业领域）
  - dicts/cn_dicts_cell/medication         # 医疗（专业领域）
  - dicts/cn_dicts_cell/industry_product   # 工业产品（专业领域）
  - dicts/cn_dicts_cell/inputmethod        # 输入法（专业领域）
  - dicts/cn_dicts_cell/chess              # 象棋（专业领域）
  - dicts/cn_dicts_cell/chess2             # 象棋2（专业领域）
  
  # 文化类词库
  - dicts/cn_dicts_cell/music              # 音乐（文化类）
  - dicts/cn_dicts_cell/history            # 历史（文化类）
  
  # 地理和专有名词（靠后）
  - dicts/cn_dicts_cell/place              # 地名（专有名词）
  - dicts/cn_dicts_cell/geography          # 地理（专有名词）
  - dicts/cn_dicts_cell/name               # 人名（专有名词）
  - dicts/cn_dicts_cell/name2              # 人名2（专有名词）
  - dicts/cn_dicts_cell/composite          # 复合词（扩展词库，最后）
```

---

## 许可证与上游声明

本仓库中未单独标明许可的原创修改，以及来自 oh-my-rime、rime-ice、rime-frost 的衍生配置，按 [GPL-3.0-only](LICENSE) 分发。RIME-LMDG 词库、部件拆字资料及其他第三方内容仍分别遵循各自的许可证和署名要求，详见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。
---
