# 🤝 贡献指南

感谢你对 OpenClaw 实战指南的兴趣！我们欢迎任何形式的贡献。

## 如何贡献

### 1. 报告问题

发现问题了？请先搜索是否已存在相同问题，然后创建 Issue。

**Issue 模板：**

```markdown
## 问题描述
清晰描述问题

## 复现步骤
1. 步骤 1
2. 步骤 2

## 预期行为
描述预期行为

## 实际行为
描述实际行为

## 环境信息
- OpenClaw 版本：
- 操作系统：
- 渠道：
```

### 2. 提交修复

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

### 3. 完善文档

- 修正错别字
- 补充内容
- 翻译文档
- 添加示例

## 文档规范

### Markdown 格式

- 使用中文标点
- 代码块标注语言
- 列表使用 `-` 或 `1.`
- 标题使用 `#`

### 文档结构

```markdown
# 标题

## 概述
简单介绍

## 前置要求
列出必要条件

## 步骤

### 步骤 1
...

### 步骤 2
...

## 常见问题

## 相关链接
```

### 代码规范

- JavaScript 使用 ES6+ 语法
- 变量命名使用 camelCase
- 添加必要的注释
- 保持代码简洁

## 提交信息规范

使用conventional commits：

```
feat: 添加新功能
fix: 修复问题
docs: 文档更新
style: 格式调整
refactor: 代码重构
test: 测试相关
chore: 构建/工具
```

示例：
- `feat: 添加天气查询功能`
- `fix: 修复 Docker 部署问题`
- `docs: 补充飞书接入指南`

## 贡献流程

```bash
# 1. Fork 仓库

# 2. 克隆
git clone https://github.com/YOUR_USERNAME/openclaw-guide.git
cd openclaw-guide

# 3. 创建分支
git checkout -b feature/your-feature

# 4. 开发
# ... 修改代码 ...

# 5. 提交
git add .
git commit -m 'feat: 添加新功能'

# 6. 推送
git push origin feature/your-feature

# 7. 创建 PR
```

## 审核标准

Pull Request 审核时会检查：

- [ ] 代码语法正确
- [ ] 文档格式规范
- [ ] 示例可运行
- [ ] 无敏感信息泄露

## 行为准则

- 保持友好和包容
- 尊重不同观点
- 接受建设性批评
- 关注社区利益

## 联系方式

- 问题：GitHub Issues
- 讨论：GitHub Discussions
- 紧急：邮件 maintainer@openclaw.ai

---

感谢你的贡献！ 🎉