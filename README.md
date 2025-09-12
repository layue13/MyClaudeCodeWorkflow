# Claude Code Workflow

一套完整的 Claude Code 工作流程配置，包含质疑需求、版本管理、深度调研和 TDD 编码等最佳实践。

## 🚀 快速安装

### 方法1: 一键安装（推荐）

```bash
# 在目标项目根目录下运行
curl -fsSL https://raw.githubusercontent.com/layue13/MyClaudeCodeWorkflow/main/ccw | bash -s install
```

### 方法2: 下载脚本后使用

```bash
# 下载 CCW 管理器
curl -O https://raw.githubusercontent.com/layue13/MyClaudeCodeWorkflow/main/ccw
chmod +x ccw

# 安装
./ccw install
```

## 📋 管理命令

```bash
# 查看帮助
./ccw help

# 安装到当前项目
./ccw install

# 更新已安装的配置
./ccw update

# 查看安装状态
./ccw status

# 卸载配置
./ccw uninstall
```

## 🔧 功能特性

- **自动备份**: 更新和卸载前自动备份现有配置
- **智能检测**: 检测安装状态，防止重复安装
- **安全卸载**: 卸载时清理所有相关文件和配置
- **版本控制**: 自动配置 .gitignore，排除本地设置文件
- **多项目支持**: 可以安装到任意 Git 项目中

## 📁 安装内容

安装后会在您的项目中添加以下文件：

```
项目根目录/
├── CLAUDE.md                           # 主配置文件
├── .claude/
│   └── agents/
│       ├── research-agent.md           # 调研代理配置
│       ├── solution-agent.md           # 方案代理配置
│       └── github-agent.md             # GitHub代理配置
└── .gitignore                          # 更新排除规则
```

## 🔄 工作流程

1. **质疑需求** - 分析用户需求是否合理，质疑不当的技术选择和设计决策
2. **版本管理** - 使用 Git 确保随时可回退
3. **深度调研** - 自动启动 research-agent → solution-agent → github-agent 三阶段流程
4. **TDD编码** - Red(写失败测试) → 提交测试 → Green(最简实现) → Refactor(重构优化) → 提交代码

## 🎯 代理说明

### Research Agent (调研代理)
- 深度分析文件/图片/URL
- 输出问题本质和约束条件
- 提供调研结论

### Solution Agent (方案代理)  
- 基于调研结果设计解决方案
- 确定技术选型
- 制定实施计划

### GitHub Agent (问题管理代理)
- 创建结构化 GitHub Issue
- 记录完整决策过程
- 跟踪问题状态

## 🛡️ 安全性

- 本地配置文件 `.claude/settings.local.json` 不会被提交到版本控制
- 所有敏感信息保存在本地
- 支持多环境配置

## 🔧 自定义配置

安装后可以根据项目需要调整：

1. 编辑 `CLAUDE.md` 中的工作流程配置
2. 修改 `.claude/agents/` 中的代理配置
3. 创建 `.claude/settings.local.json` 添加本地配置

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个工作流程配置！

## 📄 许可证

MIT License