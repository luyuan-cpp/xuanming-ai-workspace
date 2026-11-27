# 跨仓通用自定义 Skills 目录

本目录用于存放**团队自建、跨多个仓库复用的自定义 AI Agent Skill**（每个 Skill 一个子目录，内含 `SKILL.md`）。

## 使用约定

1. **第三方公共 Skills 不放这里**：`mattpocock/skills`、`ponytail`、`superpowers`、`ECC`、`graphify` 等 8 仓精选 80 个公共技能继续按 [../../docs/rules/required-skills.md](../../docs/rules/required-skills.md) 安装到用户全局目录（`~/.agents/skills/` 等），不重复提交进本仓库。
2. **自定义 Skill 写法**：新建 `<skill-name>/SKILL.md`（含 YAML frontmatter `name` 与 `description`），所有从工作区根目录启动的 AI Agent 即可共享，不再逐仓复制。
3. **冲突裁决**：任何 Skill 与总仓 [../../AGENTS.md](../../AGENTS.md) 或目标子仓 `AGENTS.md` 冲突时，一律以 `AGENTS.md` 为准。
