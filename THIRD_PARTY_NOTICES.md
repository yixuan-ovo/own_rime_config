# 第三方来源与许可证声明

本项目整合了多个 Rime 社区项目。各上游作者仍保留其作品的著作权；本文件用于集中记录来源和许可证，不替代各文件中已经保留的版权或许可声明。

## GPL-3.0 系列来源

以下上游项目使用 GNU GPL v3，其衍生配置和脚本按相应 GPL 条款分发：

- [Mintimate/oh-my-rime](https://github.com/Mintimate/oh-my-rime)：本项目的初始配置骨架、薄荷方案、英文子方案和部分 Lua 功能。
- [iDvel/rime-ice](https://github.com/iDvel/rime-ice)：英文词库、腾讯扩展词库、Emoji/OpenCC 数据、符号和多项 Lua 功能。上游标注为 `GPL-3.0-only`。
- [gaboolic/rime-frost](https://github.com/gaboolic/rime-frost)：`dicts/cn_dicts_cell/`、`rime_frost_aux.*`、`lua/aux_lookup_filter.lua` 和墨奇辅助码相关资料。
- [mirtlecn/rime-radical-pinyin](https://github.com/mirtlecn/rime-radical-pinyin)：部件拆字方案和字典。当前上游仓库标注为 GPL-3.0；本仓库中带有更具体历史许可声明的文件继续遵循其文件头声明。

GPL v3 官方全文：<https://www.gnu.org/licenses/gpl-3.0.html>

## CC BY 4.0：万象词库与相关资料

`dicts/dicts_LMDG/` 来自 [amzxyz/RIME-LMDG](https://github.com/amzxyz/RIME-LMDG)，万象方案和部分 Lua 逻辑参考 [amzxyz/rime-wanxiang](https://github.com/amzxyz/rime-wanxiang)。这些上游仓库标注为 [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/)（CC BY 4.0）。

使用或再分发这些内容时，应保留：

- 作者/项目署名：`amzxyz`、`RIME-LMDG` 或 `rime-wanxiang`；
- 原项目链接；
- CC BY 4.0 许可证链接；
- 本项目已经修改、筛选或重新编排内容的说明。

## 文件内的其他许可声明

- `radical_pinyin_flypy.schema.yaml` 等历史副本的文件头标注为 CC BY-SA 4.0；这些更具体的文件级声明优先适用于对应副本。
- `lua/log.lua`、`lua/select_character.lua`、`lua/unicode.lua`、`lua/auxCode_filter.lua` 等文件包含各自作者、来源或许可说明，使用时应继续保留。
- `dicts/tencent.dict.yaml` 的原始数据来源和整理者记录在文件头中；除本仓库许可外，还应遵守原始数据提供方适用的使用条款。

## 未随仓库分发的模型

`wanxiang-lts-zh-hans.gram` 由使用者自行下载并放入实际 Rime 用户目录，本仓库不分发该模型文件。模型文件的使用和再分发应遵循其下载来源所附的许可证或使用条件。

## 本项目修改

本仓库对上游内容进行了方案裁剪、词库组合、加载顺序调整、个人配色、快捷键和 Lua 接线修改。除上述第三方例外外，这些原创修改按根目录 [LICENSE](LICENSE) 中的 `GPL-3.0-only` 条款分发。
