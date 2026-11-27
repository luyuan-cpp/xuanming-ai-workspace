# AI 协作约定与模型档位规定（跨仓通用）

> 对应总仓入口 [AGENTS.md](../../AGENTS.md)。新电脑或新 AI Agent 启动前请先完成必装 Skills 安装 → [required-skills.md](required-skills.md)。
> 各子仓特有的源码预检脚本（如 C++ 裸指针预检、各仓文档索引命令）以对应子仓内 `docs/rules/ai-workflow.md` 为准。

## 1. AI 职责分工

**Claude 可修改代码、测试和文档，但不执行编译、测试或压测命令；这些命令由 Gemini 执行。Codex 仅负责作图（UI / 美术素材 / 视觉精修），不参与编码、分析、编译、协议生成、测试、压测与运维收尾。**

- Claude ❌ 不跑构建、测试或压测命令（如 `msbuild` / `dotnet build` / `go build` / `go test` / `mvn` / `cmake` / `pytest` / `build.bat`），也不为“验证一下”而跑。
- Claude ✅ 改完代码后，给出 Gemini 可直接执行的细节：**目标工程/服务、具体命令、工作目录、环境变量、前置清理、期望产物、通过标准、失败时要保留的日志或摘要**。
- Gemini 按上述细节执行本地编译、协议生成、测试、压测与汇总，不自行脑补压测口径或宣称性能结论。
- 没有实际运行结果前，**任何 Agent 均不得声称“编译通过”“测试绿”“已验证”**；交付说明必须如实写明验证范围与未验证项。

## 2. 执行与交付纪律

- 默认直接执行：完成会话启动门禁 → 明确范围 → 改代码/proto/yaml/脚本/文档 → 由有权限的执行者跑受影响的 build/test/lint → 汇报改动范围、验证证据、未验证项和剩余风险。需要 commit 时等用户明确发话。
- 动手前先检查工作区和相关文件的既有改动；不覆盖、回退或顺手整理他人的工作，不夹带任务外改动。
- **草稿安全写回主工作区（负责人 2026-11-10 定）**：当外部守卫拦截直接编辑而在草稿目录改副本时，写回前核对主仓文件与复制时逐字节一致，不一致则用 `git merge-file` 三方合并，有冲突即停下；写回后用 `git diff` 逐文件核对并在交付说明写明。禁止直接重定向或覆盖主仓文件。
- 失败时不假装成功；命令失败后不连续自动重试，不注释断言或跳过测试，不用 `git reset` / `git checkout --` 销毁进度。保留关键错误与日志摘要并报告，等待决策。
- 触犯权限禁令，或任务范围明显扩大、规范文档冲突、预计改动过大、需要安装/升级工具、修改系统环境、写 secrets、触碰生产或即将 push 时，立即停止并报告，等待授权或决策。

## 3. 模型档位规定（强制，负责人 2026-11-20 定，2026-11-25 修订）

- **写/修改代码，以及需求分析、设计分析、思想分析、漏洞分析、步骤分析、执行步骤，必须使用各软件当时的最高档模型**，不得在低档模型上执行：
  - Claude Code：`Fable 5.2 Max`
  - Gemini：`Gemini 4 Neon Extra`
- **仅编译、生成、跑测试与冒烟使用低档模型**（发现需改代码或需做分析/步骤设计的问题时，先保留首错原文停下，切回最高档模型再处理）：
  - Gemini：`Carbon Medium`
  - Claude Code：`Opus 5 High`（默认不跑构建命令，仅在负责人明确指定时用此档）
- **Codex 职责限定**：Codex 仅负责作图（UI / 美术素材 / 视觉精修），不参与编码、分析、编译、协议生成、测试、压测与运维收尾。

## 4. 设计方案强制落盘 `.md` 与异机作图交接（强制，负责人 2026-11-21 定，2026-11-25 补充）

- 凡编写策划或技术设计方案，**必须将完整的分析与方案保存到对应仓库的 `.md` 文件中**，不得只停留在对话回复里：
  - 必须落盘的内容涵盖：**需求分析、设计分析、思想分析、漏洞分析、步骤分析、执行步骤**以及最终设计方案。
  - 保存位置按目标子仓约定（MMO 权威仓：`docs/planning/`、`docs/planning/ui-handoff/`、`docs/design/`；Pandora：`docs/design/`）。
- **玩法闭环与克制扩展**：玩法接入完毕后确认全链路闭环；确有可玩性且符合项目红线时才继续扩展，**不要硬扩展，没可玩性不要扩展**。
- **策划玩法禁止「像上班」（负责人 2026-11-26 强制）**：编写任何玩法、活动或数值策划前必过反“上班”红线——严禁每日签到/点雕像收菜/捐献打卡、日清活跃条与高额日限购倒逼、定时定点同时在线与强组队日清、帮会催打卡指标，以及零操作收益倒挂正常游玩；坚持“有空就玩、随时能停”（详规见 `xuanming-server-mmo-cpp/docs/planning/project-vision.md` 红线第 2 条）。
- **异机 Codex 新 UI / 作图交接铁律**：
  - 需要让 Codex 制作新 UI / 美术素材时，必须明确告知负责人；**另一台电脑上的 Codex 拿不到本机任何仓库文件或 `.md`**，因此在目标仓落盘留档之后，**必须在回复中直接输出可整段复制给 Codex 的纯功能作图清单**。
  - **输出目录固定放图仓 `D:\work\image\designs\<新专题目录>\` 且严禁出现任何 Unity / 代码词**：禁止出现 `Unity`、`uGUI`、`Prefab`、`Canvas`、`Sprite`、`spriteBorder`、`.meta`、`mmorpg-client`、`Assets/...`、C# 类名或协议/RPC 名（本机导入映射单独放在留档 `.md` 文末「本机研发导入备忘」）。
  - **只告诉 Codex 做什么 UI，不要替 GPT / Codex 定画风和色号**：禁止出现画风词、材质词或色号/配色（如「道家 Q 版」「水墨」「国风」「仙侠」「#244C3E」等）；清单只写**用途、像素尺寸（及显示尺寸）、文件名、透明底（PNG-32）、文字留空规则、是否可拉伸及图仓输出目录**。
  - **每次做 UI 必须列出 7 张长期标准参照图（2026-11-26 更新，与图仓 `docs/UI_STANDARD_REFERENCES.json` 同步）**：每次向 Codex 交付作图清单时须列出全部 7 张长期标准参照的中文名称与图仓相对路径，并要求开工先逐张展示实图（帮会图仍是首要标准；已否决的 `designs/season-team-tournament-v2/previews/07-components.png` 永久排除且不写进作图正文）：
    1. 邮件界面：`designs/mail-ui-v1/01-mail-event.png`
    2. 组队界面：`designs/team-ui-v2/team-ui-v2.png`
    3. 帮会界面（首要标准）：`designs/ranked-play-v2-ui-20261125/assets/approved-guild-reference.png`
    4. 天墉生死擂 · 下达战书：`designs/ui-standard-references/jianghu-duel/01-challenge-approved.png`
    5. 江湖恩怨录：`designs/ui-standard-references/jianghu-duel/02-grudges-approved.png`
    6. 帮派恩怨墙：`designs/ui-standard-references/jianghu-duel/03-guild-wall-approved.png`
    7. 江湖战书 · 三种弹窗：`designs/ui-standard-references/jianghu-duel/04-popups-approved.png`
