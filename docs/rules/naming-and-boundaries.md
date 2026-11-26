# 命名规范与跨仓权限边界（跨仓通用）

> 对应总仓入口 [AGENTS.md](../../AGENTS.md)。各子仓的语言/框架专属命名约定（如 C++ `*Handler`/`*System`、Unity `*Client`/`*Model`/`*Window`、Pandora 禁 `Xuanming` 前缀）见各自子仓规范。

## 1. 命名规范第一原则（强制）

所有命名（类名、函数、变量、字段、proto、配置表、表列、错误码、指标、Redis 键等）**必须清晰易懂且语义完全准确**，做到见名知意、零歧义：

- 准确表达业务对象、行为动作、状态语义与物理单位（如 `_ms` / `Ms`、`_sec` / `Sec`、`_count`、`_bytes` / `Bytes`），拒绝含糊缩写、误导性命名、与实际行为不符的历史遗留名及泛化命名（如无上下文的 `data` / `info` / `flag` / `temp` / `Handle` / `Process`）。
- 布尔值命名必须明确真值含义，不制造双重否定或歧义。
- 不把两层概念混在同一字段名中（例如「是什么」与「摆在哪」，或「奖励内容表 ID」与「业务领取位序」）。

## 2. 工作区关联 Git 仓库与目录约束

核心仓库按 GitHub 地址定位（本地克隆路径因机器而异，不在文档或脚本里写死个人盘符）：

| 项目组 | 目录名 | 角色 | GitHub 仓库 |
|---|---|---|---|
| 总仓 | 工作区根目录 | AI 规则 / 通用 Skills / 5 仓挂载入口 | `https://github.com/luyuan-cpp/xuanming-ai-workspace` |
| MMORPG | `mmorpg-client` | Unity 客户端 | `https://github.com/luhailong-cpp/mmorpg-client` |
| MMORPG | `xuanming-server-mmo-cpp` | C++ 节点 + Go 微服务（权威契约源） | `https://github.com/luyuan-cpp/xuanming-server-mmo` |
| MMORPG | `xuanming-server-mmo` | Java 21 服务端 | `https://github.com/luyuan-java/xuanming-server-mmo` |
| MMORPG | `xuanming-server-mmo-python` | Python 服务端 | `https://github.com/luhailong-python/xuanming-server-mmo-python` |
| Pandora | `xuanming-server` | Pandora Go 服务端（5v5 MOBA） | `https://github.com/luyuan-go/xuanming-server` |
| 工具库 | （独立依赖） | 协议转 MySQL 工具库 | `https://github.com/luyuan-cpp/proto2mysql` |

- 临时产物、验证包、构建日志放在对应子仓已忽略目录或系统临时目录，不在总仓新增未登记的受控杂项。
- **总仓 Submodule 红线**：严禁在总仓执行 `git submodule update --recursive`、`git submodule absorbgitdirs` 或强制重置子仓；各子仓日常开发保持在各自的 `main` 分支独立提交。

## 3. 跨仓硬禁令

- ❌ **严禁引入可能导致游戏不过审、被迫下架或广告/支付封号的任何设计、配置与文案（一票否决，负责人 2026-11-26 强制）**：见总仓 [AGENTS.md §2](../../AGENTS.md#2-全局一票否决红线严禁导致游戏不过审或被迫下架负责人-2026-11-26-强制)。
- ❌ 禁止手改任何自动生成代码或同步契约产物（须修改权威源后运行正式生成器）。
- ❌ 禁止私自新开独立线程 / 后台 goroutine（压测证实确需新增且先获负责人批准的除外）。
- ❌ 禁止用 `--no-verify`、注释断言、跳过测试等方式绕过质量与安全门禁。
- ❌ 未经用户明确授权，禁止执行 `git push` / `git tag` / `git push --force`；`git commit` 仅在用户明确要求时执行。
- ❌ 禁止登录远端账号、修改 CI 凭证/secrets，禁止把 secret / token / 密码写入 Git 跟踪文件或日志。
- ❌ 禁止对生产环境执行 `kubectl apply` 或 `docker push` 到镜像仓库；只可操作本地或用户明确指定的 dev 环境。
