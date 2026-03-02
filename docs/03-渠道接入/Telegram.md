# 📱 Telegram 接入指南

## 支持的功能

- ✅ 文字消息
- ✅ 图片/视频/音频/文件
- ✅ 表情回复
- ✅ 群组管理
- ✅ 内联键盘 (Inline Keyboard)
- ✅ 回调按钮 (Callback Buttons)

## 前置要求

- Telegram 账号
- Telegram Bot Token（从 @BotFather 获取）

## 获取 Bot Token

1. 打开 Telegram，搜索 **@BotFather**
2. 发送 `/newbot` 命令
3. 按照提示设置机器人名称和用户名
4. 获取 Bot Token（格式：`123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11`）

## 配置步骤

### 1. 配置 Bot Token

```bash
# 方式一：命令行设置
openclaw config set channels.telegram.botToken "YOUR_BOT_TOKEN"

# 方式二：直接编辑配置
openclaw config set channels.telegram.enabled true
```

### 2. 启动服务

```bash
# 重启 Gateway
openclaw gateway restart
```

### 3. 设置 Webhook（可选）

```bash
# 自动设置 webhook
openclaw channels telegram webhook
```

## 配置选项

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "YOUR_BOT_TOKEN",
      "allowFrom": [],
      "admins": [123456789, 987654321],
      "groups": {
        "enabled": true,
        "requireMention": true,
        "adminGroups": ["admins", "moderators"]
      }
    }
  }
}
```

| 选项 | 类型 | 说明 |
|------|------|------|
| `botToken` | string | 从 BotFather 获取的 Token |
| `allowFrom` | array | 允许的用户 ID 白名单 |
| `admins` | array | 管理员用户 ID（可执行管理命令） |
| `groups.requireMention` | boolean | 群组中是否需要 @ 机器人 |

## 发送消息

### 基础消息

```bash
openclaw message send \
  --channel telegram \
  --target @username \
  --message "你好！"
```

### 带键盘的消息

```json
{
  "message": "请选择操作：",
  "reply_markup": {
    "inline_keyboard": [
      [
        {"text": "查询天气", "callback_data": "weather"},
        {"text": "查询新闻", "callback_data": "news"}
      ],
      [
        {"text": "帮助", "callback_data": "help"}
      ]
    ]
  }
}
```

### 发送图片

```bash
openclaw message send \
  --channel telegram \
  --target @username \
  --media /path/to/image.jpg \
  --caption "这是一张图片"
```

### 发送文件

```bash
openclaw message send \
  --channel telegram \
  --target @username \
  --file /path/to/document.pdf
```

## 群组配置

### 基本群组

```json
{
  "channels": {
    "telegram": {
      "groups": {
        "enabled": true,
        "requireMention": true
      }
    }
  }
}
```

### 超级群组管理

```json
{
  "channels": {
    "telegram": {
      "groups": {
        "adminsOnly": false,
        "welcomeMessage": "欢迎 {{username}} 加入本群！",
        "rules": "请遵守群规：1. 文明发言 2. 禁止广告"
      }
    }
  }
}
```

## 机器人命令

| 命令 | 说明 |
|------|------|
| `/start` | 启动机器人 |
| `/help` | 获取帮助 |
| `/status` | 查看状态 |
| `/chat` | 开始对话 |
| `/quiet` | 关闭当前对话 |

## 回调处理 (Callbacks)

```javascript
// skills/telegram-callback/index.js
export default {
  name: "telegram-callback",
  onCallback: async (callback) => {
    const { data, message } = callback;
    
    switch (data) {
      case "weather":
        return "今天天气晴朗 ☀️";
      case "news":
        return "最新新闻：...";
      case "help":
        return "帮助信息：...";
      default:
        return "未知操作";
    }
  }
}
```

## 常见问题

### Q: 机器人不响应消息？

1. 检查 Bot Token 是否正确
2. 确保 `channels.telegram.enabled` 为 `true`
3. 检查群组设置（是否需要 @mention）

```bash
# 调试模式
openclaw logs --level debug | grep telegram
```

### Q: 如何获取自己的 Telegram ID？

1. 搜索 @userinfobot
2. 发送任意消息
3. 会返回你的 ID

### Q: 群组邀请链接无效？

```bash
# 重置群组邀请链接
# 在 @BotFather 中设置新的 deep link
```

### Q: 机器人被拉进群组后不工作？

需要将机器人设置为管理员，或在群组中 @机器人 并发送消息激活。

## 高级功能

### 内联模式 (Inline Mode)

```json
{
  "channels": {
    "telegram": {
      "inline": {
        "enabled": true,
        "placeholder": "搜索..."
      }
    }
  }
}
```

### 付款功能

```json
{
  "channels": {
    "telegram": {
      "payments": {
        "providerToken": "YOUR_PROVIDER_TOKEN"
      }
    }
  }
}
```

### 游戏

```json
{
  "channels": {
    "telegram": {
      "games": {
        "enabled": true
      }
    }
  }
}
```

## 安全建议

1. **保护 Bot Token**：不要泄露到公开代码库
2. **设置管理员**：限定可执行管理命令的用户
3. **启用隐私模式**：让机器人只响应指定群组
4. **定期轮换 Token**：在 @BotFather 中 revoke

## 调试命令

```bash
# 查看 Telegram 日志
openclaw logs --follow | grep telegram

# 测试发送
openclaw message send --channel telegram --target @your_username --message "test"

# 检查状态
openclaw status
```

## 相关链接

- [Telegram Bot API](https://core.telegram.org/bots/api)
- [BotFather](https://t.me/BotFather)
- [OpenClaw Telegram 文档](https://docs.openclaw.ai/channels/telegram)