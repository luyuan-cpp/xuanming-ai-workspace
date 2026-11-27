# AI Agent Skills 梯队与冲突裁决表（80 个精选技能，零截断版）

> **更新日期**：2026-11-26（由 618 个全量精简为 **80 个游戏多仓零冲突精选集**，原 538 个非核心/重复技能已归档备份，不丢失）  
> **关联安装清单**：8 仓精选 80 个技能明细、白名单一键安装与去重验收脚本见 [required-skills.md](required-skills.md)  
> **安装位置说明**：80 个技能主目录在 `~/.agents/skills/`（`~/.copilot/skills/` 同步 80 项；Claude Code 与 Antigravity 因已装原生 `ponytail` 插件，其 `skills/` 仅放去重后的 74 项 + 插件 6 项 = 80 项；`~/.codex/skills/` 独立保留 Codex 作图/美术技能，不混入编码技能）。  
> **排序依据**：对 AI 工程产出的杠杆效应、机制独特性、贴合当前 C++/Go/Java/Python/Unity 游戏多仓技术栈。任何外部 Skill 与本仓 `AGENTS.md` 冲突时，一律以 `AGENTS.md` 为准。

---

## 一、多 Skill 冲突裁决规则（强制）

### 1. 优先级（高优先级覆盖低优先级）
`本轮用户显式指令 > 目标子仓 AGENTS.md > 总仓 AGENTS.md（含 docs/rules/） > ponytail 原生插件规则 > 用户显式点名 Skill > 自动触发 Skill`

### 2. 高频工程域唯一默认主选（不叠加同功能流程）

| 场景 / 域 | 默认主选（1 个） | 互补 / 按需显式调用 | 已移出归档的冲突旧项 |
|---|---|---|---|
| **需求拷问与规格** | `grilling`（别名 `/grill-me`） | `spec-driven-development`、`writing-plans` | `brainstorming`（全局抢跑）、`interview-me`、`idea-refine`、`before-you-build`、`planning-and-task-breakdown` |
| **日常编码与改动** | `ponytail`（原生插件常驻） | `executing-plans`、`subagent-driven-development` | `using-superpowers`、`using-agent-skills`、`orch-*` 6 件套（依赖未装 ECC 斜杠命令） |
| **排障 / 调试** | `systematic-debugging` | `parallel-debugging`（疑难多假设 ACH） | `diagnosing-bugs`、`debugging-and-error-recovery`、`debugging-strategies`、`orch-fix-defect` |
| **TDD / 单元测试** | `tdd`（mattpocock 版） | 语言专版：`cpp-testing` / `golang-testing` / `springboot-tdd` / `python-testing` / `csharp-testing` | `tdd-workflow`、`test-driven-development`、`python-testing-patterns` |
| **代码评审** | `ponytail-review`（追调用方最小评审） | `code-review-and-quality`（五维深审）、`receiving-code-review`（回应评审） | `code-review`、`code-review-excellence`、`requesting-code-review`、`multi-reviewer-patterns` |
| **安全与上线体检** | `security-review` | `production-audit`、`ai-debt-detector` | `security-and-hardening`、`security-scan`、`web-perimeter-owasp-2025-audit` |
| **交付前验证** | `verification-before-completion` | `springboot-verification`（Java 专项） | `verification-loop` |
| **Git / 提交 / PR** | `conventional-commit-review` + `pr` | `using-git-worktrees`、`finishing-a-development-branch` | `git-workflow`、`git-workflow-and-versioning`、`git-advanced-workflows` |
| **编写/审计 Skill** | `skill-creator` | `writing-for-agents`、`skill-stocktake`、`continuous-learning-v2` | `writing-skills`、`template-skill` |

---

## 二、S+ 级：镇仓核心（6 组 / 12 个）

1. **`graphify`**（`Graphify-Labs/graphify`）— **唯一带本地 AST 解析 CLI 的知识图谱引擎**  
   把代码/文档/多仓库转成可查询知识图谱（社区聚类、God Nodes、`query/path/explain`、交互式 HTML、MCP）。对多仓跨语言服务端/客户端架构对账是降维打击。
2. **`ponytail`** + **`ponytail-audit`** / **`ponytail-review`** / **`ponytail-debt`** / **`ponytail-gain`** / **`ponytail-help`**（`DietrichGebert/ponytail`）— **专治 AI 过度设计与整仓体检**  
   日常强压最小完整改动、拒写废抽象；`audit/review` 按「正确性 → 安全 → 并发 → 测试 → 性能 → 精简」全链路追调用方，不做表面 diff 评审。
3. **`verification-before-completion`**（`obra/superpowers`）— **反 AI 嘴炮/幻觉铁律**  
   强制“未在本轮亲手跑完验证命令并看完完整输出，严禁宣称通过/修好”，把各种“应该没问题”的借口直接拉黑。
4. **`systematic-debugging`**（`obra/superpowers`）— **四阶段根因排障（排障默认主选）**  
   铁律是“没查到根因前禁止提修复”，强迫先复现、查近期变更、跨组件边界埋诊断日志。
5. **`subagent-driven-development`**（`obra/superpowers`）— **子 Agent 流水线 + 双门禁验收**  
   每个任务派全新上下文子 Agent 做，做完立刻过「规范合规 + 代码质量」两道审查，减少长上下文污染。
6. **`grilling`** + **`grill-me`**（`mattpocock/skills`）— **设计树式无情拷问（需求澄清默认主选）**  
   把需求拆成决策前沿树分轮追问，并附默认推荐答案；凡能自己从代码库查到的事实派子 Agent 去查，不拿能查的事烦人。

---

## 三、S 级：高杠杆架构 / 对抗验证 / 高难排障（9 个）

| 排名 | 技能 | 来源 | 厉害在哪 |
|---:|---|---|---|
| 7 | **`doubt-driven-development`** | `addyosmani` | 写关键代码或定架构**前**，拉一个“以证伪为目标”的新鲜上下文审查者挑刺，打破长会话自我催眠 |
| 8 | **`improve-codebase-architecture`** + **`codebase-design`** | `mattpocock` | 按 `git log` 热点扫“浅模块/烂接缝”，产出前后对比方案再逐项讨论重构 |
| 9 | **`santa-method`** | `ECC` | 双独立审查 Agent（无共享上下文、同量表）各自打分，全过才放行，否则自动返工收敛 |
| 10 | **`gan-style-harness`** | `ECC` | 复现 Generator-Evaluator 对抗闭环，彻底拆分“干活的”和“挑刺的” |
| 11 | **`council`** + **`council-multi-model`** | `ECC` | 重大权衡时拉怀疑派/务实派/批评派圆桌辩论，必要时引入外部视角刻意找漏洞 |
| 12 | **`ai-debt-detector`** | `wshobson` | 专查 AI 写代码特有暗病：只写 happy path、吞异常、孤儿资源未释放、虚构依赖/API |
| 13 | **`parallel-debugging`** | `wshobson` | 疑难 Bug 用竞争假设分析（ACH），按逻辑/数据/状态等维度并发排查仲裁 |

---

## 四、A 级：日常高频主力与元技能（20 个）

- **需求、计划与调研（4 个）**：`spec-driven-development`、`writing-plans`、`executing-plans`、`search-first`
- **测试、评审与安全（5 个）**：`tdd`（mattpocock 版）、`code-review-and-quality`、`receiving-code-review`、`production-audit`、`security-review`
- **Git 与并行防降智（7 个）**：`using-git-worktrees`、`dispatching-parallel-agents`、`finishing-a-development-branch`、`conventional-commit-review`、`pr`、`context-engineering`、`strategic-compact`
- **元技能（4 个）**：`skill-creator`、`writing-for-agents`、`skill-stocktake`、`continuous-learning-v2`

---

## 五、游戏多仓技术栈与高杠杆通用工具（39 个）

- **C++ / 低延迟服务端（4 个）**：`cpp-coding-standards`、`cpp-testing`、`memory-safety-patterns`、`latency-critical-systems`
- **Go 微服务（3 个）**：`golang-patterns`、`go-concurrency-patterns`、`golang-testing`
- **Java 21 / Spring Boot（4 个）**：`java-coding-standards`、`springboot-patterns`、`springboot-tdd`、`springboot-verification`
- **Python 3.11+ asyncio（5 个）**：`python-patterns`、`async-python-patterns`、`python-testing`、`python-performance-optimization`、`uv-package-manager`
- **Unity / C# 客户端（3 个）**：`unity-ecs-patterns`、`dotnet-patterns`、`csharp-testing`
- **数据层与领域建模（5 个）**：`mysql-patterns`、`redis-patterns`、`sql-optimization-patterns`、`database-migrations`、`domain-modeling`
- **容器 / 集群 / 性能 / 可观测（4 个）**：`docker-patterns`、`kubernetes-patterns`、`performance-optimization`、`observability-and-instrumentation`
- **轻量逆向与协议分析（2 个）**：`leanrea`、`protocol-reverse-engineering`
- **通用工具与导表办公（9 个）**：`frontend-design`、`webapp-testing`、`mcp-builder`、`xlsx`（策划导表刚需）、`pdf`、`docx`、`pptx`、`research`、`terminal-ops`

---

## 六、上下文预算与变更说明

- **截断已消除**：精简后 Antigravity 实际加载 `74（skills/） + 6（plugins/ponytail） + 15（builtin） = 95` 项（总描述约 26 KB），远低于上下文预算上限，`graphify`、`ponytail`、`verification-before-completion`、`doubt-driven-development`、`santa-method` 等全部 S+/S 级技能在新会话中均可稳定完整可见，不再被截断。
- **归档恢复说明**：其余 538 个低频长尾（医疗/DeFi/小语种/Perl/PHP/Ruby/营销等）与同域冲突变体未永久删除，均保留在本机 `~/.agents/skills-archive-20261126/skills/`；若日后确需某个单技能，从该目录拷回对应 Agent 的 `skills/` 即可。
