# xuanming-ai-workspace

多仓库 AI 协作总控工作区：集中管理跨仓库共享的 `AGENTS.md`、通用 `docs/rules/`、自定义 `.agents/skills/`，并以**安全松耦合 Git Submodule** 挂载全部 5 个业务仓库。

## 挂载仓库一览

| 分组 | 目录 | 角色 | 远端仓库 |
|---|---|---|---|
| MMORPG | `mmorpg-client` | Unity 客户端 | `luhailong-cpp/mmorpg-client` |
| MMORPG | `xuanming-server-mmo-cpp` | C++ 节点 + Go 微服务 | `luyuan-cpp/xuanming-server-mmo` |
| MMORPG | `xuanming-server-mmo` | Java 21 服务端 | `luyuan-java/xuanming-server-mmo` |
| MMORPG | `xuanming-server-mmo-python` | Python 服务端 | `luhailong-python/xuanming-server-mmo-python` |
| Pandora | `xuanming-server` | Pandora Go 服务端（MOBA） | `luyuan-go/xuanming-server` |

## 新电脑上手（3 步）

> ⚠️ **不要**使用 `git clone --recursive`（`xuanming-server-mmo-cpp` 内部含 20+ 第三方子模块，递归拉取极慢且会把子仓切为 detached HEAD）。

```powershell
# 1. 克隆总仓（不含 --recursive）
git clone git@github.com:luyuan-cpp/xuanming-ai-workspace.git xuanming-workspace
cd xuanming-workspace

# 2. 一键拉齐 5 个一级子仓到 main 分支，并自动启用 ignore=all / update=none 防误覆盖保护
pwsh -File scripts/bootstrap.ps1

# 3. 安装必装 618 个全局 AI Skills（按文档第 2 节执行）
# 详见 docs/rules/required-skills.md
```

## 日常协作方式

- **改通用规则或跨仓自定义 Skill**：只改本总仓（`AGENTS.md`、`docs/rules/`、`.agents/skills/`）并在本仓提交推送。
- **改业务代码**：进入对应子仓正常在 `main` 分支开发、提交与推送；因为 `.gitmodules` 配置了 `ignore = all` 与 `update = none`，各子仓日常变更不会把总仓标脏，也不会因误触 `git submodule update` 而回退。
- **里程碑同步子仓指针（可选）**：仅当需要刷新 GitHub 上显示的各子仓提交号时，手动用各仓已推送的 `origin/main` SHA 更新 gitlink：
  ```powershell
  $sha = (git -C mmorpg-client rev-parse origin/main).Trim()
  git update-index --cacheinfo "160000,$sha,mmorpg-client"
  ```
