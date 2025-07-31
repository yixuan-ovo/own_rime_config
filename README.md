# own_rime_config

# 列表

|**🌟 文件名**|**🧠 释义**|**🔧 备注**|
|:-:|-|-|
|default.yaml|主要配置|覆盖写在.custom内|
|default.custom.yaml|目前仅记录激活了什么输入法|...|
|double_pinyin_flypy.schema.yaml|小鹤双拼定制版主文件|...|
|double_pinyin_flypy.custom.yaml|小鹤覆盖配置|激活语言模型wanxiang|
|melt_eng.schema.yaml|方便中英文混输方案调用|name:Easy English Nano|
|melt_eng.dict.yaml|name:melt_eng|melt_eng.schema的词库文件|
|radical_pinyin_flypy.schema.yaml|偏旁部件拆字(小鹤)|提供偶尔Uu进行拆字,不需要激活此输入法|
|radical_pinyin.dict.yaml|radical_pinyin|小鹤、全拼等输入法依赖的拆字字库|
|rime_mint。dict.yaml|rime_mint|各输入法依赖的主词重字库|
|squirrel.yaml|皮肤设置的默认兜底文件|🈶️其余样式不生效|
|symbols.yaml|快捷键|定义/bq等快捷输入表情|
|terra_pinyin.dict.yaml|name:terra_pinyin|地球拼音专用词库|
|terra_pinyin.schema.yaml|地球拼音输入法配置|...|
|terra_symbols.yaml|地球拼音专用快捷键|...|
|wanxiang-lts-zh-hans.gram|万象语法模型|RIME-LMDG|
|weasel.custom.yaml|覆盖的样式配置|目前内容为选定的输入法皮肤|
|weasel.yaml|主要样式配置|添加自定义皮肤及预览图片(/preview)|
|-|-|-|
|opencc/fly_Chaifen.json|乙	〔フフ｜yivv〕|显示拆字结果|

# 1. 待解决:

1. 拆字同时显示中文和双拼拼音

2. is_in_user_lua文件无法和拆字共存

3. 有点卡顿,考虑禁用腾讯字库

~~4. 候选项的emoji有点太多了,需要降低权重~~

5. 地球拼音重复问题,需删除Rime\weasel-0.17.4\data下的terra同名文件,或者改名

# 2. 已修改:
1. rime_mint.dict修改字库,雾凇+白霜

2. 删除不需要的偏旁拆字、小鹤混输、薄荷拼音-全拼输入

3. 增加自定义配色皮肤+预览图

4. 修改rime_mint的依赖词库

5. 合并terra_pinyin和rime_mint为一个输入法(terra为主)

6. 

# 3. 已知问题
![](ihjmerr.png)

---

# 自用整合配置 

## ```安装到C盘内需将[WeaselServer]兼容性设置为管理员```

本输入方案内主要使用：

- 小鹤双拼-薄荷定制: 基于小鹤双拼，添加定制内容。支持输入音形(形码)、自然码辅助码或墨奇辅助码作为辅助输入；

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


如果你喜欢使用 Rime 打一些长句，那么强烈建议配合语言模型来使用。参考教程:
- [Rime 内如何配置语言模型 -- 薄荷输入配置教程](https://www.mintimate.cc/zh/guide/languageModel.html)

## 配置文件说明

- `default.yaml` 设置输入法、如何切换输入法、翻页等；建议自行创建`default.custom.yaml`来覆写薄荷配置的`default.yaml`.

- `weasel.yaml` 小狼毫( Win 版本 )设置哪些软件默认英文输入，输入法皮肤等；如需自定义，建议自行创建`weasel.custom.yaml`来覆写。

配置文件中大部分都有注释，配合教程：[配置覆写](https://www.mintimate.cc/zh/guide/configurationOverride.html)

## 词库定制以及更新

详细说明：

```txt
dicts
├── custom_simple.dict.yaml    # 自定义词库（建议自己添加的词库可以放这里）
├── other_emoji.dict.yaml      # emoji 词库
├── other_kaomoji.dict.yaml    # 颜文字词库（按vv进行激活）
├── rime_ice.ext.dict.yaml     # 白霜词库（GitHub action自动更新）
├── rime_ice.cn_en.txt         # 白霜词库（GitHub action自动更新）
├── rime_ice.en.dict.yaml      # 白霜词库（GitHub action自动更新）
├── rime_ice.en_ext.dict.yaml  # 白霜词库（GitHub action自动更新）
├── rime_ice.others.dict.yaml  # 白霜词库（GitHub action自动更新）
├── rime_mint.base.dict.yaml            # 万象词库（GitHub action自动更新）
├── rime_mint.chars.dict.yaml           # 万象词库（GitHub action自动更新）
├── rime_mint.correlation.dict.yaml     # 万象词库（GitHub action自动更新）
└── rime_mint.ext.dict.yaml             # 万象词库（GitHub action自动更新）
```

后续更新词库；可以下载本仓库`dicts`内的文件，除了`custom_simple.dict.yaml`的文件，其他都进行覆盖替换即可。

如果想自己扩展词库，可以在输入法的字典配置文件内进行导入，比如字典配置文件[rime_mint.dict.yaml](rime_mint.dict.yaml)内：

```yaml
name: rime_mint                  # 注意name和文件名一致
version: "2025.07.06"
sort: by_weight
use_preset_vocabulary: false
# 此处为 输入法所用到的词库，既补充拓展词库的地方
# 雾凇拼音词库，由Github Robot自动更新
import_tables:
  - dicts/custom_simple          # 自定义
  - dicts/rime_ice.8105           # 字表
  - dicts/rime_ice.41448         # 大字表（按需启用）
  - dicts/rime_ice.base         # 基础词库
  - dicts/rime_ice.ext          # 扩展词库
  - dicts/tencent  # 腾讯词向量（大词库，部署时间较长）
  - dicts/other_kaomoji          # 颜文字表情（按`VV`呼出)
  # 20240608 Emoji完全交由OpenCC，不再使用字典作为补充
  # - dicts/other_emoji            # Emoji(仅仅作为补充，实际使用一般是OpenCC生效)

  # 细胞词库
  - cn_dicts_cell/medication
  - cn_dicts_cell/industry_product
  - cn_dicts_cell/exthot
  - cn_dicts_cell/chess
  - cn_dicts_cell/chess2
  - cn_dicts_cell/animal
  - cn_dicts_cell/game
  - cn_dicts_cell/idiom
  - cn_dicts_cell/sport
  - cn_dicts_cell/media
  - cn_dicts_cell/shulihua
  - cn_dicts_cell/food
  - cn_dicts_cell/inputmethod
  - cn_dicts_cell/history
  - cn_dicts_cell/place
  - cn_dicts_cell/geography
  - cn_dicts_cell/name2
  - cn_dicts_cell/literature
  - cn_dicts_cell/music
  - cn_dicts_cell/computer
  - cn_dicts_cell/composite
  - cn_dicts_cell/name
```