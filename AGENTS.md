# 多仓库 AI 总控工作区总入口

> 本仓库是跨项目共享的 **AI 规则、通用 Skills 与多仓挂载总入口**（Claude Code / Codex / Gemini / Antigravity / Cursor / Copilot 与人类开发者共同遵守）。
> `CLAUDE.md`、`GEMINI.md` 与 `.github/copilot-instructions.md` 均通过 `@AGENTS.md` 单行导入本文件；**通用规则统一维护在本仓 `docs/rules/`，自定义跨仓 Skill 统一放在 `.agents/skills/`**，不再在各子仓重复维护。
> 涉及具体业务子仓的专属架构、构建命令、协议生成与提交流程，仍以对应子仓自身的 `AGENTS.md` 为唯一事实源。

## 1. 会话启动门禁（每次必做）

0. **新电脑 / 新 AI Agent 环境**：先按 [docs/rules/required-skills.md](docs/rules/required-skills.md) 装齐必装 Skills（8 仓 618 项），并按 [README.md](README.md) 跑 `scripts/bootstrap.ps1` 拉齐一级子仓。
1. 阅读本文件及任务涉及的通用分章细则（见下方索引）。
2. 确定本次任务涉及哪些子仓库，**逐一通读每个目标子仓的 `AGENTS.md` 及其专属 `docs/rules/*.md`**，严格遵守各子仓自己的构建/测试、提交格式与 `git push` 授权边界，不得把某一个子仓的习惯套用到其他子仓。
3. 动手前在目标子仓执行 `git status -sb` 与 `git log -20 --oneline`，不覆盖或回退既有未提交改动。

## 2. 全局一票否决红线：严禁导致游戏不过审或被迫下架（负责人 2026-11-26 强制）

任何新功能、商业化、广告、支付、登录、隐私、文案、配表或 SDK 接入，**凡存在触发应用商店（App Store / Google Play / 国内安卓渠道）或小游戏平台（微信 / 抖音小游戏）拒审、下架、冻结或封号风险的方案一律禁止落地**：

- **零捐赠/外链/切支付**：游戏客户端内严禁出现个人收款码、微信/支付宝转账引导、爱发电/Patreon/Ko-fi 等外链捐赠或任何绕过官方支付渠道（iOS IAP / Play Billing / 小游戏虚拟支付）的切支付入口；国内未获版号前严禁开启小游戏内购。
- **广告零拒审四重硬门禁**：首审默认服务端关闭（`RewardedAdSlot.enabled = 0`）；App 端第三方广告 SDK 必须受编译宏隔离（默认关闭）并由构建护栏拦截残留 ATT / SDK；客户端未同时满足开关+宿主+素材就绪+余量必须整块隐藏入口（杜绝 Apple 2.1 空按钮）；严禁出现「支持作者/捐赠/打赏/点广告/收款码/爱发电」等诱导点击文案，且奖励仅限物理不可交易的绑定资产（`CURRENCY_TYPE_BIND_GOLD`）。
- **合规三大件与隐私一致性**：严守实名防沉迷（无未实名游客）、7 天冷静期真注销（含 Apple `/auth/revoke`）与 UGC 内容安全；若启用任何跟踪/广告 SDK 必须同步补齐隐私声明、平台问卷与 iOS ATT 真实弹窗（拒绝跟踪仍可正常游玩）。

## 3. 总仓 Submodule 安全红线（强制）

本仓以**松耦合模式**挂载 5 个业务子仓（`.gitmodules` 统一配 `branch = main`、`ignore = all`、`update = none`），各子仓保持独立开发与推送：

- ❌ **禁止在总仓执行 `git submodule update --recursive` 或强制检出覆盖子仓**：`xuanming-server-mmo-cpp` 内含 20+ 个第三方子模块，且各子仓要求直接在 `main` 分支开发，严禁将子仓切为 detached HEAD 或回退本地进度。
- ❌ **禁止运行 `git submodule absorbgitdirs`**：保持各子仓 `.git` 目录独立，确保总仓与子仓可随时解耦。
- ❌ **总仓只提交通用文档 / Skills / 脚本变更**，不因日常子仓提交频繁刷父仓 gitlink 指针；确实需要同步里程碑快照时，只登记各子仓已推送到 `origin/main` 的提交号。
- ❌ **禁止擅自 `git push` / `git tag`**（总仓与全部子仓均须用户明确授权）。

## 4. 通用规范与 Skills 索引（单一事实源在本仓）

| 主题 | 核心内容摘要 | 完整文档 |
|---|---|---|
| 必装 Skills 清单 | 8 仓 618 个必装 Skills + Windows 一键安装与验收脚本 | [docs/rules/required-skills.md](docs/rules/required-skills.md) |
| Skills 精选梯队 | 618 个必装技能按实战杠杆排序的 S+/S/A 梯队速查 | [docs/rules/ai-skills-ranking.md](docs/rules/ai-skills-ranking.md) |
| AI 协作与模型档位 | Claude/Gemini 分工、Codex 仅作图、强制高低档模型切换、设计落盘与异机作图交接铁律 | [docs/rules/ai-workflow.md](docs/rules/ai-workflow.md) |
| 通用工程与设计原则 | SOLID、23 种设计模式、跨模块 Actor 不可变消息隔离、高 Star 开源库三步选型、实例与布局分层 | [docs/rules/engineering-principles.md](docs/rules/engineering-principles.md) |
| 位图存储与删表 ID | 纯布尔状态优先 bit 位图、归属业务表不绑 Reward 表、删表 ID 策划与程序红线 | [docs/rules/bit-storage-and-table-ids.md](docs/rules/bit-storage-and-table-ids.md) |
| 命名规范与权限边界 | 见名知意带单位、关联 Git 仓库总表、跨仓硬禁令与权限边界 | [docs/rules/naming-and-boundaries.md](docs/rules/naming-and-boundaries.md) |
| 自研通用 Skills | 团队自建跨仓通用自定义 Skill 存放目录 | [.agents/skills/README.md](.agents/skills/README.md) |

## 5. 挂载子仓库索引（按项目分组，严禁串用规则）

### A. MMORPG 项目组（4 仓，共享同一套客户端契约与配表）

| 目录（Submodule） | 角色 | 远端仓库 | 专属规范入口 |
|---|---|---|---|
| `mmorpg-client` | Unity 客户端（小游戏 + App 双形态） | `luhailong-cpp/mmorpg-client` | [AGENTS.md](mmorpg-client/AGENTS.md) |
| `xuanming-server-mmo-cpp` | C++ 节点 + Go 微服务（权威契约源） | `luyuan-cpp/xuanming-server-mmo` | [AGENTS.md](xuanming-server-mmo-cpp/AGENTS.md) |
| `xuanming-server-mmo` | Java 21 服务端（双版并行对账） | `luyuan-java/xuanming-server-mmo` | [AGENTS.md](xuanming-server-mmo/AGENTS.md)、[PARITY.md](xuanming-server-mmo/PARITY.md) |
| `xuanming-server-mmo-python` | Python 服务端（平替 C++ 增量移植） | `luhailong-python/xuanming-server-mmo-python` | [AGENTS.md](xuanming-server-mmo-python/AGENTS.md) |

### B. Pandora 项目组（1 仓，5v5 MOBA 独立项目）

| 目录（Submodule） | 角色 | 远端仓库 | 专属规范入口 |
|---|---|---|---|
| `xuanming-server` | Pandora Go 服务端（UE 5.8 DS 配套） | `luyuan-go/xuanming-server` | [AGENTS.md](xuanming-server/AGENTS.md)、[CLAUDE.md](xuanming-server/CLAUDE.md)（含 §4 commit 格式） |
