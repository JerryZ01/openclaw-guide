# 🎮 Discord 接入指南

## 支持的功能

- ✅ 文字消息
- ✅ 图片/文件/音频
- ✅ _embed 消息
- ✅ 频道/线程支持
- ✅ 表情反应
- ✅ 斜杠命令 (Slash Commands)

## 前置要求

- Discord 账号
- Discord Developer Portal 访问权限

## 创建 Discord Bot

### 1. 创建应用

1. 访问 [Discord Developer Portal](https://discord.com/developers/applications)
2. 点击「New Application」
3. 填写名称，点击「Create」

### 2. 创建机器人

1. 点击左侧「Bot」
2. 点击「Add Bot」
3. 获取 Token（点击「Reset Token」）

### 3. 配置权限

在 Bot 页面，勾选以下权限：

**一般权限：**
- ✅ View Channels
- ✅ Send Messages
- ✅ Send Messages in Threads
- ✅ Create Public Threads
- ✅ Create Private Threads
- ✅ Manage Messages
- ✅ Manage Threads
- ✅ Read Message History

**高级权限：**
- ✅ Use Slash Commands
- ✅ Manage Roles（可选）
- ✅ Kick Members（可选）

### 4. 启用 Intents

点击「Message Content Intent」并保存。

### 5. 邀请机器人

1. 点击左侧「OAuth2」→「URL Generator」
2. 勾选 `bot`
3. 勾选所需权限
4. 复制生成的 URL 并在浏览器打开

## 配置 OpenClaw

### 安装依赖

```bash
# Discord 渠道通常已内置
openclaw channels list
```

### 配置 Bot Token

```bash
# 设置 Token
openclaw config set channels.discord.botToken "YOUR_BOT_TOKEN"

# 启用 Discord
openclaw config set channels.discord.enabled true
```

### 完整配置

```json
{
  "channels": {
    "discord": {
      "enabled": true,
      "botToken": "YOUR_BOT_TOKEN",
      "allowFrom": [],
      "admins": ["123456789"],
      "guilds": {
        "enabled": true,
        "requireMention": false,
        "welcomeChannel": "welcome",
        "autoReply": true
      },
      "threads": {
        "enabled": true,
        "createOnMention": true
      }
    }
  }
}
```

## 发送消息

### 基础消息

```bash
openclaw message send \
  --channel discord \
  --target "channel-id" \
  --message "你好！"
```

### 发送 Embed

```json
{
  "message": {
    "content": "信息",
    "embeds": [
      {
        "title": "标题",
        "description": "描述",
        "color": 3447003,
        "fields": [
          {
            "name": "字段名",
            "value": "字段值",
            "inline": true
          }
        ]
      }
    ]
  }
}
```

### 发送图片

```bash
openclaw message send \
  --channel discord \
  --target "channel-id" \
  --media /path/to/image.png
```

### 发送文件

```bash
openclaw message send \
  --channel discord \
  --target "channel-id" \
  --file /path/to/file.pdf
```

## 斜杠命令

### 注册命令

```javascript
// skills/discord-commands/index.js
export default {
  name: "discord-commands",
  
  // 注册斜杠命令
  commands: [
    {
      name: "help",
      description: "获取帮助",
      options: []
    },
    {
      name: "weather",
      description: "查询天气",
      options: [
        {
          name: "city",
          description: "城市",
          type: 3, // STRING
          required: true
        }
      ]
    },
    {
      name: "stats",
      description: "查看统计"
    }
  ],
  
  async onCommand(interaction) {
    const { command, options } = interaction;
    
    switch (command) {
      case "help":
        return "可用命令：/help, /weather, /stats";
      case "weather":
        const city = options.getString("city");
        return await this.getWeather(city);
      case "stats":
        return "统计信息...";
    }
  }
}
```

### 内置命令

| 命令 | 说明 |
|------|------|
| `/ping` | 测试响应 |
| `/help` | 获取帮助 |
| `/stats` | 查看状态 |

## 线程管理

### 自动创建线程

```json
{
  "channels": {
    "discord": {
      "threads": {
        "enabled": true,
        "createOnMention": true,
        "autoArchive": 1440 // 24 小时后自动归档
      }
    }
  }
}
```

### 手动创建线程

```bash
# 在频道中创建线程
openclaw message send \
  --channel discord \
  --target "channel-id" \
  --thread "thread-name" \
  --message "线程消息"
```

## 消息组件

### 按钮 (Buttons)

```javascript
export default {
  async sendWithButtons(channelId) {
    return {
      content: "选择操作：",
      components: [
        {
          type: 1, // ACTION_ROW
          components: [
            {
              type: 2, // BUTTON
              style: 1, // PRIMARY
              label: "确认",
              custom_id: "confirm"
            },
            {
              type: 2,
              style: 2, // SECONDARY
              label: "取消",
              custom_id: "cancel"
            }
          ]
        }
      ]
    };
  }
};
```

### 选择菜单 (Select Menu)

```javascript
{
  components: [
    {
      type: 1,
      components: [
        {
          type: 3, // SELECT_MENU
          custom_id: "select",
          options: [
            { label: "选项1", value: "1", description: "描述1" },
            { label: "选项2", value: "2", description: "描述2" }
          ]
        }
      ]
    }
  ]
}
```

### 按钮回调处理

```javascript
export default {
  async onComponentInteraction(interaction) {
    const { custom_id } = interaction;
    
    switch (custom_id) {
      case "confirm":
        return "已确认！";
      case "cancel":
        return "已取消";
    }
  }
}
```

## 群组管理

### 欢迎消息

```json
{
  "channels": {
    "discord": {
      "guilds": {
        "welcomeChannel": "welcome",
        "welcomeMessage": "欢迎 {user} 加入服务器！"
      }
    }
  }
}
```

### 角色管理

```javascript
// 自动分配角色
export default {
  async onMemberJoin(member) {
    await member.addRole("role-id");
  }
}
```

### 频道权限

```json
{
  "channels": {
    "discord": {
      "permissions": {
        "channel-id": {
          "role-id": ["VIEW_CHANNEL", "SEND_MESSAGES"]
        }
      }
    }
  }
}
```

## 常见问题

### Q: 机器人不响应？

1. 检查 Token 是否正确
2. 确认机器人已在服务器中
3. 检查权限设置
4. 确认已启用 Message Content Intent

```bash
# 查看 Discord 日志
openclaw logs --follow | grep discord
```

### Q: 如何获取 Channel ID？

1. 开启 Discord 开发者模式（设置 → 高级 → 开发者模式）
2. 右键频道 → 复制 ID

### Q: 消息被截断？

Discord _embed 限制：
- 标题：256 字符
- 描述：4096 字符
- 字段：1024 字符

### Q: 斜杠命令不显示？

1. 等待几分钟让 Discord 更新
2. 使用 `/register` 命令强制注册

## 高级功能

### Webhook 模式

```json
{
  "channels": {
    "discord": {
      "webhooks": {
        "enabled": true,
        "url": "https://discord.com/api/webhooks/..."
      }
    }
  }
}
```

### 跨频道转发

```javascript
export default {
  name: "discord-forwarder",
  async onMessage(message) {
    if (message.channel === "source-channel") {
      // 转发到目标频道
      await this.sendToChannel("target-channel", {
        content: message.content,
        embeds: message.embeds
      });
    }
  }
}
```

### 日志频道

```json
{
  "channels": {
    "discord": {
      "logging": {
        "enabled": true,
        "channel": "logs",
        "events": ["message_delete", "member_join", "member_leave"]
      }
    }
  }
}
```

## 调试命令

```bash
# 查看 Discord 日志
openclaw logs --level debug | grep discord

# 测试发送
openclaw message send --channel discord --target "channel-id" --message "test"

# 检查状态
openclaw status
```

## 相关链接

- [Discord Developer Portal](https://discord.com/developers/applications)
- [Discord.js 文档](https://discord.js.guide/)
- [OpenClaw Discord 文档](https://docs.openclaw.ai/channels/discord)