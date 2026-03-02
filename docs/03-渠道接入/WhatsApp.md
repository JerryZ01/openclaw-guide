# 📱 WhatsApp 接入指南

## 支持的功能

- ✅ 文字消息
- ✅ 图片/视频/音频
- ✅ 表情反应
- ✅ 群组消息
- ✅ 语音转文字

## 前置要求

- WhatsApp 账号
- 手机安装 WhatsApp

## 连接方式

### 方式一：QR 码登录（推荐）

```bash
# 启动 WhatsApp 登录流程
openclaw channels login whatsapp
```

会显示一个 QR 码，用手机 WhatsApp 扫描：
1. 打开 WhatsApp → 设置 → 已关联的设备
2. 扫描屏幕上显示的 QR 码

### 方式二：浏览器会话复用

```bash
# 使用现有会话
openclaw channels login whatsapp --session
```

## 配置选项

```json
{
  "channels": {
    "whatsapp": {
      "enabled": true,
      "allowFrom": ["+15555550123", "+15555550124"],
      "groups": {
        "*": {
          "requireMention": false
        },
        "family-group": {
          "requireMention": true
        }
      },
      "profile": {
        "name": "OpenClaw Bot",
        "shortName": "OCBot"
      }
    }
  }
}
```

### 配置说明

| 选项 | 类型 | 说明 |
|------|------|------|
| `allowFrom` | array | 允许的白名单号码，`["*"]` 表示允许所有人 |
| `groups.*.requireMention` | boolean | 群组中是否需要 @ 机器人 |
| `profile.name` | string | 机器人显示名称 |
| `profile.shortName` | string | 简短名称（最多 25 字符） |

## 发送消息

### 发送文字

```bash
openclaw message send \
  --channel whatsapp \
  --target +15555550123 \
  --message "你好！这是测试消息"
```

### 发送图片

```bash
openclaw message send \
  --channel whatsapp \
  --target +15555550123 \
  --media /path/to/image.jpg \
  --caption "这是一张图片"
```

### 发送文件

```bash
openclaw message send \
  --channel whatsapp \
  --target +15555550123 \
  --media /path/to/document.pdf
```

## 接收消息处理

### 自动回复

```javascript
// skills/autoreply/index.js
export default {
  name: "autoreply",
  rules: [
    {
      pattern: /hello|hi|你好/,
      response: "你好！有什么可以帮你的？"
    },
    {
      pattern: /help|帮助/,
      response: "我可以帮你：\n1. 查询信息\n2. 发送提醒\n3. 等等..."
    }
  ]
}
```

### AI 对话

```javascript
// skills/ai-chat/index.js
export default {
  name: "ai-chat",
  rules: [
    {
      pattern: /.*/,
      ai: true,
      system: "你是一个友好的助手，请用中文回复。"
    }
  ]
}
```

## 常见问题

### Q: 登录失效需要重新扫码？

```bash
# 重新登录
openclaw channels logout whatsapp
openclaw channels login whatsapp
```

### Q: 消息发不出去？

1. 检查号码格式（国际号码格式：+区号号码）
2. 检查是否被对方拉黑
3. 查看日志：`openclaw logs | grep whatsapp`

### Q: 媒体消息失败？

```bash
# 检查文件大小限制（最大 16MB）
# 确保文件格式支持
```

### Q: 群组消息没有回复？

```json
{
  "channels": {
    "whatsapp": {
      "groups": {
        "your-group-name": {
          "requireMention": false
        }
      }
    }
  }
}
```

## 高级功能

### 多设备支持

OpenClaw 支持同时连接多个 WhatsApp 账号：

```bash
# 为不同渠道创建配置文件
openclaw --profile work channels login whatsapp
openclaw --profile personal channels login whatsapp
```

### 消息模板

```json
{
  "channels": {
    "whatsapp": {
      "templates": {
        "welcome": "欢迎 {{name}}！我是小二，很高兴认识你！",
        "reminder": "提醒：{{event}} 将于 {{time}} 开始"
      }
    }
  }
}
```

## 监控与调试

```bash
# 查看 WhatsApp 详细日志
openclaw logs --level debug | grep whatsapp

# 检查连接状态
openclaw status

# 诊断问题
openclaw doctor
```

## 安全注意事项

1. **不要在公共场合暴露会话文件**
2. **定期备份会话数据**
3. **使用白名单限制访问**
4. **敏感信息使用加密传输**

## 相关链接

- [OpenClaw 官方文档](https://docs.openclaw.ai)
- [WhatsApp Business API](https://developers.facebook.com/docs/whatsapp)