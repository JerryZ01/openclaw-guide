# 🔗 Multi-Channel - 多渠道消息管理

展示如何同时管理多个渠道的消息。

## 项目结构

```
multi-channel/
├── index.js          # 主入口
├── channels/         # 渠道配置
│   ├── telegram.js
│   ├── feishu.js
│   └── whatsapp.js
├── router.js         # 消息路由
└── README.md
```

## 代码

### 主入口

```javascript
// index.js
export default {
  name: "multi-channel",
  version: "1.0.0",
  description: "多渠道消息管理",
  
  async onMessage(message) {
    // 统一处理逻辑
    const response = await this.processMessage(message);
    
    // 根据来源渠道返回
    return this.formatResponse(response, message.channel);
  },
  
  async processMessage(message) {
    const { content, from, channel } = message;
    
    // 记录来源
    console.log(`收到来自 ${channel} 的消息 from ${from}`);
    
    // 统一处理
    if (content.startsWith('/')) {
      return await this.handleCommand(content, message);
    }
    
    // AI 对话
    return await this.ai.chat(message);
  },
  
  async handleCommand(cmd, message) {
    const command = cmd.slice(1).split(' ')[0];
    const args = cmd.split(' ').slice(1);
    
    switch (command) {
      case 'status':
        return this.getStatus();
      case 'broadcast':
        return await this.broadcast(args.join(' '), message);
      case 'channel':
        return this.getChannelInfo(message.channel);
      default:
        return `未知命令: ${command}`;
    }
  },
  
  // 跨渠道广播
  async broadcast(text, message) {
    const channels = ['telegram', 'feishu', 'whatsapp'];
    const results = [];
    
    for (const channel of channels) {
      try {
        await this.sendToChannel(channel, {
          target: this.getChannelTarget(channel, message.from),
          message: `📢 广播\n\n${text}`
        });
        results.push(`✅ ${channel}`);
      } catch (e) {
        results.push(`❌ ${channel}: ${e.message}`);
      }
    }
    
    return results.join('\n');
  },
  
  getChannelTarget(channel, userId) {
    // 根据渠道返回正确的目标
    const targets = {
      telegram: `@${userId}`,
      feishu: `ou_${userId}`,
      whatsapp: userId
    };
    return targets[channel] || userId;
  },
  
  formatResponse(text, channel) {
    // 根据渠道格式化
    if (channel === 'discord') {
      return { content: text, embed: null };
    }
    return text;
  },
  
  getStatus() {
    return `📊 系统状态

运行时间：${this.getUptime()}
活跃会话：${this.getSessionCount()}
消息总数：${this.getMessageCount()}`;
  },
  
  getChannelInfo(channel) {
    return `📱 当前渠道: ${channel}
用户ID: ${message.from}
消息类型: ${message.type}`;
  }
}
```

### 消息路由

```javascript
// router.js
export function routeMessage(message) {
  const { content, from, channel } = message;
  
  // 路由规则
  const rules = [
    { pattern: /^admin/, handler: handleAdmin, admins: ['123456'] },
    { pattern: /^support/, handler: handleSupport },
    { pattern: /.*/, handler: handleDefault }
  ];
  
  // 执行匹配
  for (const rule of rules) {
    if (rule.pattern.test(content)) {
      // 检查权限
      if (rule.admins && !rule.admins.includes(from)) {
        return "权限不足";
      }
      return rule.handler(message);
    }
  }
}

function handleAdmin(msg) {
  return "管理员命令处理";
}

function handleSupport(msg) {
  return "技术支持处理";
}

function handleDefault(msg) {
  return "默认处理";
}
```

## 配置

```json
{
  "enabled": true,
  "settings": {
    "channels": {
      "telegram": { "enabled": true },
      "feishu": { "enabled": true },
      "whatsapp": { "enabled": true }
    },
    "router": {
      "defaultHandler": "ai",
      "fallbackHandler": "help"
    },
    "broadcast": {
      "enabled": true,
      "admins": ["123456789"]
    }
  }
}
```

## 部署

```bash
# 复制到技能目录
cp -r multi-channel ~/.openclaw/workspace/skills/

# 启用
openclaw skills enable multi-channel
```

## 功能说明

| 功能 | 说明 |
|------|------|
| 统一处理 | 一个技能处理所有渠道 |
| 跨渠道广播 | 一条消息发到所有渠道 |
| 渠道识别 | 自动识别消息来源 |
| 权限控制 | 管理员命令 |