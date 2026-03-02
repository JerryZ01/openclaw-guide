# 🤖 Basic Bot - 基础机器人示例

一个最简单的关键词响应机器人。

## 功能

- 关键词自动回复
- AI 对话模式
- 帮助命令

## 使用方法

```bash
# 复制到技能目录
cp -r examples/basic-bot ~/.openclaw/workspace/skills/

# 启用技能
openclaw skills enable basic-bot
```

## 代码

```javascript
// index.js
export default {
  name: "basic-bot",
  version: "1.0.0",
  description: "基础关键词响应机器人",
  
  rules: [
    // 问候
    {
      pattern: /^(你好|hello|hi|嗨)/i,
      response: "你好！我是小二 🦊 有什么可以帮你的吗？"
    },
    // 帮助
    {
      pattern: /^(帮助|help|命令)/i,
      response: `📚 可用命令：
• 你好 - 打招呼
• 帮助 - 查看命令
• 天气 [城市] - 查询天气
• 翻译 [内容] - 翻译
• 关于 - 关于我`
    },
    // 关于
    {
      pattern: /^(关于|about|你是谁)/i,
      response: "我是 OpenClaw 助手小二 🦊\n基于 AI 的多渠道消息助手"
    },
    // 默认 AI 回复
    {
      pattern: /.*/,
      ai: true,
      system: "你是一个友好、简洁的助手，用中文回复，长度控制在100字以内"
    }
  ]
}
```

## 配置

```json
{
  "enabled": true,
  "priority": 10
}
```

## 扩展

添加更多关键词：

```javascript
{
  pattern: /^(笑话|joke)/i,
  response: "有一天，程序员去面试...\n\n面试官：你工作经验几年？\n程序员：...\n（请自行脑补结局）😂"
}
```