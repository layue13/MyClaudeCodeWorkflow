# 工作流程

1. **质疑需求** - 分析用户需求是否合理，质疑不当的技术选择和设计决策，确保需求的正确性和可行性
2. **版本管理** - `git init/commit/branch/reset --hard`，确保随时可回退  
3. **深度调研** - 自动启动research-agent进行调研分析 -> solution-agent设计方案 -> github-agent创建问题记录
   - **触发条件**: 当用户提出需求或问题时，自动启动三阶段流程
   - **research-agent**: 深度调研相关文件/图片/URL，输出 Why(问题本质) + Constraints(约束条件) + 调研结论
   - **solution-agent**: 基于调研结果，设计 Solution(解决方案) + 技术选型 + 实施计划  
   - **github-agent**: 创建结构化GitHub Issue记录完整的决策过程
   - 支持概括性指导("阅读处理日志的文件")或具体文件名("阅读logging.py")
4. **TDD编码** - Red(写失败测试) -> 提交测试 -> Green(最简实现) -> Refactor(重构优化) -> 提交代码