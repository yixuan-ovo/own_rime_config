# own_rime_config

# 1. 待解决问题:

1. 拆字同时显示中文和双拼拼音
2. is_in_user_lua文件无法和拆字共存
3. 有点卡顿,考虑禁用腾讯字库
4. 候选项的emoji有点太多了,需要降低权重

# 2. 已实现修改:
1. rime_mint.dict修改字库,雾凇+白霜
2. 

---

# 自用整合配置 

## ```安装到C盘内需将[WeaselServer]兼容性设置为管理员```

本输入方案内主要使用：

- 小鹤双拼-薄荷定制: 基于小鹤双拼，添加定制内容。支持输入音形(形码)、自然码辅助码或墨奇辅助码作为辅助输入；

## Tips

本地rime配置文件默认地址，如下

- Windows
  - Weasel: `%APPDATA%\Rime`
- Mac OS X
  - Squirrel: `~/Library/Rime`
  - Fcitx5 macOS: `~/.local/share/fcitx5/rime`
- Linux
  - iBus:`~/.config/ibus/rime`
  - Fcitx5: `~/.local/share/fcitx5/rime`
- Fctix5 Android(小企鹅入法): `/storage/emulated/0/Android/data/org.fcitx.fcitx5.android/files/data/rime/`

本地rime日志文件默认地址如下：

- Windows
  - Weasel: `%TEMP%`
- Mac OS X
  - Squirrel: `$TMPDIR`
- Linux
  - iBus:`/tmp`


如果你喜欢使用 Rime 打一些长句，那么强烈建议配合语言模型来使用。参考教程:
- [Rime 内如何配置语言模型 -- 薄荷输入配置教程](https://www.mintimate.cc/zh/guide/languageModel.html)

## 配置文件说明

- `default.yaml` 设置输入法、如何切换输入法、翻页等；建议自行创建`default.custom.yaml`来覆写薄荷配置的`default.yaml`.
- `squirrel.yaml` 鼠须管( Mac 版本 )设置哪些软件默认英文输入，输入法皮肤等；如需自定义，建议自行创建`squirrel.custom.yaml`来覆写。
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
---
name: rime_mint                  # 注意name和文件名一致
version: "2025.07.06"
sort: by_weight
use_preset_vocabulary: false
# 此处为 输入法所用到的词库，既补充拓展词库的地方
# 雾凇拼音词库，由Github Robot自动更新
import_tables:
  - dicts/custom_simple          # 自定义
  - dicts/rime_mint.chars        # 单字词库（万象拼音词库基础版本）
  - dicts/rime_mint.base         # 基础词库（万象拼音词库基础版本）
  - dicts/rime_mint.correlation  # 关联词库（万象拼音词库基础版本）
  - dicts/rime_mint.ext          # 联想词库（万象拼音词库基础版本）
  - dicts/other_kaomoji          # 颜文字表情（按`VV`呼出)
  - dicts/rime_ice.others        # 雾凇拼音 others词库（用于自动纠错）
  # 20240608 Emoji完全交由OpenCC，不再使用字典作为补充
  # - dicts/other_emoji            # Emoji(仅仅作为补充，实际使用一般是OpenCC生效)
...
```