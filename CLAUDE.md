# 工作流程

1. **质疑需求** - 分析用户需求是否合理，质疑不当的技术选择和设计决策，确保需求的正确性和可行性
2. **版本管理** - `git init/commit/branch/reset --hard` + `gh repo create`，确保随时可回退
3. **深度调研** - 小步快跑的三阶段流程，每阶段都有检查点
   - **3a. 调研阶段**: research-agent深度调研 → 输出调研报告 → **检查点：用户确认调研方向**
   - **3b. 方案阶段**: solution-agent设计方案 → 输出方案草案 → **检查点：用户确认技术方案**
   - **3c. 记录阶段**: github-agent创建Issue+Branch（调研结论、技术方案、实施计划） → **检查点：Issue和分支创建完成，可开始编码**
   - 支持概括性指导("阅读处理日志的文件")或具体文件名("阅读logging.py")
4. **TDD编码** - 小步快跑的四阶段开发，每阶段在专门分支上独立完成
   - **4a. Red阶段**: Claude编写失败测试 → 提交关联Issue → github-agent评论追踪进度 → **检查点：测试框架就绪**
   - **4b. Green阶段**: Claude最简实现功能 → 提交关联Issue → github-agent评论追踪进度 → **检查点：功能基本可用**
   - **4c. Refactor阶段**: Claude重构优化代码 → 提交关联Issue → github-agent评论追踪进度 → **检查点：代码质量达标**
   - **4d. 收尾阶段**: Claude推送分支 → github-agent创建PR并关闭Issue → **检查点：任务完全结束**
   - **断点续传**: 用户提供Issue编号 → github-agent分析Issue状态 → Claude恢复开发上下文 → 从中断点继续开发