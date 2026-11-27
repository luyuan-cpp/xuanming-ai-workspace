# 必装 AI Agent Skills 清单（8 仓精选 80 项，零冲突防截断版）

> 对应根索引 [AGENTS.md §1 / §4](../../AGENTS.md)。**每次换新电脑或接入新 AI Agent（Claude Code / Gemini / Antigravity / Cursor / Copilot）前，按本文件白名单装齐全部 80 个精选 Skills。**
> **为什么由 618 精简为 80**：全量安装 618 个会触发上下文预算截断（把 `graphify`、`ponytail`、`verification-before-completion` 等 S+ 核心挤出列表），同时引发全局拦截与同域流程打架（`using-superpowers` / `using-agent-skills` / `brainstorming` / `orch-*` 与多套 TDD/Debug/Review 互搏）。精简后零截断、零撞车，覆盖本工作区 C++/Go/Java 21/Python/Unity 全部技术栈。

选型标准与本仓技术选型一致：**负责人指定核心 Skill + GitHub ≥ 2 万 Star 的高口碑代码工程 Skill**。任何外部 Skill 与本仓 `AGENTS.md` 冲突时，一律以本仓 `AGENTS.md` 为准（完整冲突裁决顺序见 [ai-skills-ranking.md](ai-skills-ranking.md)）。

> **权限与 Codex 边界提醒**：
> - 遵循 [naming-and-boundaries.md](naming-and-boundaries.md)，新机器初始化或缺失必装 Skill 时，由开发者确认/授权后按第 2 节脚本安装。
> - 按 [ai-workflow.md](ai-workflow.md) 约定，**Codex 仅负责作图/美术素材**，`~/.codex/skills/` 独立维护作图与美术资产技能，**严禁把下方编码 Skills 装进 `codex`**。

## 1. 必装仓库总表（8 个仓库，白名单精选 80 个 Skills + CLI）

> 精简校准日期：2026-11-26（梯队排序与同域唯一默认主选见 [ai-skills-ranking.md](ai-skills-ranking.md)）。

| 序号 | 仓库 / 工具 | GitHub 地址 | Stars（2026-11） | 精选数量 | 核心用途 |
|---:|---|---|---:|---:|---|
| 1 | **mattpocock/skills**（指定必装） | https://github.com/mattpocock/skills | ~32.9 万 | 9 | 设计拷问、垂直切片 TDD、架构重构、领域建模、一手调研、PR |
| 2 | **DietrichGebert/ponytail**（指定必装） | https://github.com/DietrichGebert/ponytail | ~19.6 万 | 6 | 懒惰资深工程师模式：最小完整改动、反过度工程、全链路审计评审 |
| 3 | **obra/superpowers** | https://github.com/obra/superpowers | ~32.3 万 | 9 | 交付前实跑验真、四阶段根因排障、分步计划、子 Agent 双门禁并行 |
| 4 | **affaan-m/ECC** | https://github.com/affaan-m/ECC | ~30.8 万 | 31 | 对抗验证（Santa/GAN/Council）、安全/上线体检、C++/Go/Java/Python/C#/DB/K8s/逆向 |
| 5 | **anthropics/skills** | https://github.com/anthropics/skills | ~19.8 万 | 8 | 官方 Skill 创建评测、高质量前端 UI、Playwright、MCP、Excel/PDF/Word/PPT |
| 6 | **addyosmani/agent-skills** | https://github.com/addyosmani/agent-skills | ~11.9 万 | 6 | 证伪挑刺、五维代码评审、能力地图 Spec、性能/可观测/上下文工程 |
| 7 | **wshobson/agents** | https://github.com/wshobson/agents | ~4.3 万 | 10 | AI 暗病扫描、竞争假设并行排障、Unity ECS、内存安全、Go/Python/SQL/协议逆向 |
| 8 | **Graphify-Labs/graphify**（`graphifyy`） | https://github.com/Graphify-Labs/graphify | ~15.1 万 | 1（CLI + Skill） | 本地确定性 AST 解析，将代码库/文档/Schema 转为可查询知识图谱 |

### 附：其他按需可选（≥ 2 万 Star，默认不装）
- **Egonex-AI/Understand-Anything**（https://github.com/Egonex-AI/Understand-Anything ，~9.3 万 star）：代码库交互式知识图谱。
- **JuliusBrussee/caveman**（https://github.com/JuliusBrussee/caveman ，~12.2 万 star）：压缩 Agent 冗余输出与工具上下文消耗。
- **garrytan/gstack**（https://github.com/garrytan/gstack ，~14.2 万 star）：多角色虚拟工程团队工作流（需 Bun 环境）。
- **sickn33/agentic-awesome-skills** / **VoltAgent/awesome-agent-skills** / **github/awesome-copilot**：大型索引目录，按需单技能挑选，**严禁整仓 `-s *` 盲装**。

## 2. 新电脑 / 新 Agent 一键安装脚本（Windows PowerShell，白名单模式）

前置依赖：已安装 `git`、`node`（含 `npx`）、`python`（含 `pip` 或 `uv`）。注意目标 Agent 不含 `codex`，避免覆盖 Codex 独立作图技能目录。

```powershell
# ============================================================
# 1. 白名单安装 7 个 GitHub Skill 仓库（同步到 claude-code / gemini-cli / antigravity / cursor / github-copilot，不含 codex）
# ============================================================
$agents = "claude-code gemini-cli antigravity cursor github-copilot"

$directRepos = @{
    "mattpocock/skills"        = "codebase-design domain-modeling grill-me grilling improve-codebase-architecture pr research tdd writing-for-agents"
    "DietrichGebert/ponytail"  = "ponytail ponytail-audit ponytail-debt ponytail-gain ponytail-help ponytail-review"
    "obra/superpowers"         = "dispatching-parallel-agents executing-plans finishing-a-development-branch receiving-code-review subagent-driven-development systematic-debugging using-git-worktrees verification-before-completion writing-plans"
    "addyosmani/agent-skills"  = "code-review-and-quality context-engineering doubt-driven-development observability-and-instrumentation performance-optimization spec-driven-development"
}
foreach ($kv in $directRepos.GetEnumerator()) {
    cmd /c "npx --yes skills add $($kv.Key) -g -a $agents -s $($kv.Value) -y --copy"
}

# 大型仓库先浅克隆再本地白名单安装，避免默认 300s 克隆超时
$largeRepos = @{
    "anthropics/skills" = "docx frontend-design mcp-builder pdf pptx skill-creator webapp-testing xlsx"
    "affaan-m/ECC"      = "continuous-learning-v2 conventional-commit-review council council-multi-model cpp-coding-standards cpp-testing csharp-testing database-migrations docker-patterns dotnet-patterns gan-style-harness golang-patterns golang-testing java-coding-standards kubernetes-patterns latency-critical-systems leanrea mysql-patterns production-audit python-patterns python-testing redis-patterns santa-method search-first security-review skill-stocktake springboot-patterns springboot-tdd springboot-verification strategic-compact terminal-ops"
    "wshobson/agents"   = "ai-debt-detector async-python-patterns go-concurrency-patterns memory-safety-patterns parallel-debugging protocol-reverse-engineering python-performance-optimization sql-optimization-patterns unity-ecs-patterns uv-package-manager"
}
foreach ($kv in $largeRepos.GetEnumerator()) {
    $dir = Join-Path $env:TEMP ("skill-" + ($kv.Key -replace "/", "-"))
    if (Test-Path $dir) { Remove-Item -Recurse -Force $dir }
    git clone --depth 1 --filter=blob:none "https://github.com/$($kv.Key).git" $dir
    cmd /c "npx --yes skills add `"$dir`" -g -a $agents -s $($kv.Value) -y --copy"
    Remove-Item -Recurse -Force $dir
}

# ============================================================
# 2. 安装 Graphify CLI 及各 Agent Skill
# ============================================================
pip install --user graphifyy   # 或: uv tool install graphifyy
graphify install --platform claude
graphify install --platform antigravity-windows
graphify install --platform copilot
graphify install --platform agents
# 注：--platform gemini / cursor 会在当前目录生成 GEMINI.md / .cursor/rules/graphify.mdc，按需在具体仓库根目录内执行

# ============================================================
# 3. 原生插件去重（装了 Claude/Antigravity 原生 ponytail 插件后必跑，消除双份同名冲突）
# ============================================================
$ponytailSkills = @("ponytail","ponytail-audit","ponytail-debt","ponytail-gain","ponytail-help","ponytail-review")
if (Test-Path "$env:USERPROFILE\.gemini\config\plugins\ponytail\skills") {
    $ponytailSkills | ForEach-Object { Remove-Item -Recurse -Force "$env:USERPROFILE\.gemini\config\skills\$_" -ErrorAction SilentlyContinue }
}
if (Get-ChildItem "$env:USERPROFILE\.claude\plugins\cache\ponytail\ponytail\*\skills" -ErrorAction SilentlyContinue) {
    $ponytailSkills | ForEach-Object { Remove-Item -Recurse -Force "$env:USERPROFILE\.claude\skills\$_" -ErrorAction SilentlyContinue }
}
```

### 各 Agent 原生插件补充（推荐仅装 `ponytail` 规则插件，不叠加其他重型全局插件）
- **Claude Code**（在会话内执行）：
  ```text
  /plugin marketplace add DietrichGebert/ponytail
  /plugin install ponytail@ponytail
  ```
- **Antigravity**：`ponytail` 原生规则插件放在 `~/.gemini/config/plugins/ponytail/`（含 `plugin.json`、`rules/AGENTS.md`、`skills/`），其余 74 个技能在 `~/.gemini/config/skills/`。

## 3. 安装验收与零冲突检查

执行以下命令核对各目录数量与重名状态：
- `~/.agents/skills`：**80**（总事实源）
- `~/.copilot/skills`：**80**（无原生插件，完整 80 项）
- `~/.claude/skills`：**74**（+ 原生 `ponytail` 插件 6 项 = **80**，零重名）
- `~/.gemini/config/skills`：**74**（+ 原生 `ponytail` 插件 6 项 = **80**，零重名，且远低于上下文截断上限）
- `~/.codex/skills`：独立保留 Codex 作图/美术技能，不计入编码 80 项

```powershell
@(
  "$env:USERPROFILE\.agents\skills",
  "$env:USERPROFILE\.copilot\skills",
  "$env:USERPROFILE\.claude\skills",
  "$env:USERPROFILE\.gemini\config\skills"
) | ForEach-Object {
  $cnt = if (Test-Path $_) { (Get-ChildItem $_ -Directory).Count } else { 0 }
  Write-Output ("{0,4}  {1}" -f $cnt, $_)
}

# 校验 Antigravity skills/ 与 plugins/ 无同名冲突（预期无输出）
$gSkills = (Get-ChildItem "$env:USERPROFILE\.gemini\config\skills" -Directory -ErrorAction SilentlyContinue).Name
$gPlugins = (Get-ChildItem "$env:USERPROFILE\.gemini\config\plugins\*\skills" -Directory -ErrorAction SilentlyContinue).Name
Compare-Object $gSkills $gPlugins -IncludeEqual -ExcludeDifferent
```

## 4. 精选 80 个 Skills 完整明细（按来源仓库登记）

### 4.1 `mattpocock/skills`（9 个）
`codebase-design`、`domain-modeling`、`grill-me`、`grilling`、`improve-codebase-architecture`、`pr`、`research`、`tdd`、`writing-for-agents`

### 4.2 `DietrichGebert/ponytail`（6 个）
`ponytail`、`ponytail-audit`、`ponytail-debt`、`ponytail-gain`、`ponytail-help`、`ponytail-review`（Claude Code 与 Antigravity 走原生插件目录，其余走 `skills/`）

### 4.3 `obra/superpowers`（9 个）
`dispatching-parallel-agents`、`executing-plans`、`finishing-a-development-branch`、`receiving-code-review`、`subagent-driven-development`、`systematic-debugging`、`using-git-worktrees`、`verification-before-completion`、`writing-plans`

### 4.4 `affaan-m/ECC`（31 个）
`continuous-learning-v2`、`conventional-commit-review`、`council`、`council-multi-model`、`cpp-coding-standards`、`cpp-testing`、`csharp-testing`、`database-migrations`、`docker-patterns`、`dotnet-patterns`、`gan-style-harness`、`golang-patterns`、`golang-testing`、`java-coding-standards`、`kubernetes-patterns`、`latency-critical-systems`、`leanrea`、`mysql-patterns`、`production-audit`、`python-patterns`、`python-testing`、`redis-patterns`、`santa-method`、`search-first`、`security-review`、`skill-stocktake`、`springboot-patterns`、`springboot-tdd`、`springboot-verification`、`strategic-compact`、`terminal-ops`

### 4.5 `anthropics/skills`（8 个）
`docx`、`frontend-design`、`mcp-builder`、`pdf`、`pptx`、`skill-creator`、`webapp-testing`、`xlsx`

### 4.6 `addyosmani/agent-skills`（6 个）
`code-review-and-quality`、`context-engineering`、`doubt-driven-development`、`observability-and-instrumentation`、`performance-optimization`、`spec-driven-development`

### 4.7 `wshobson/agents`（10 个）
`ai-debt-detector`、`async-python-patterns`、`go-concurrency-patterns`、`memory-safety-patterns`、`parallel-debugging`、`protocol-reverse-engineering`、`python-performance-optimization`、`sql-optimization-patterns`、`unity-ecs-patterns`、`uv-package-manager`

### 4.8 `Graphify-Labs/graphify`（1 个）
`graphify`（通过 `graphifyy` CLI 分发到 `~/.agents/skills/graphify`、`~/.claude/skills/graphify`、`~/.gemini/config/skills/graphify`、`~/.gemini/skills/graphify`、`~/.copilot/skills/graphify`）

## 5. 精简移出说明与单技能恢复

- **为什么移出其余 538 项**：
  1. **全局强拦截与跨仓调度冲突**：`using-superpowers`、`using-agent-skills`、`brainstorming`、`orch-*` 6 件套（后者强依赖未安装的 ECC 插件命令）。
  2. **同域重复变体**：次选的 TDD / Debug / Code Review / Security / Git / API / Python-testing 变体，防止多流程叠床架屋。
  3. **与本工作区技术栈无关的长尾**：医疗 HIPAA、DeFi/NFT、Perl/PHP/Ruby/Laravel/Rails、小语种本地化、法务合同、市场营销、预测市场等。
- **按需单技能恢复**：本机已将移出的 538 项与 `.skill-lock.json.bak` 完整备份至 `~/.agents/skills-archive-20261126/skills/`；如临时需要某一项，复制单个目录回目标 Agent 的 `skills/` 即可，切勿整批恢复。
