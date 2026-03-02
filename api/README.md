# 📚 OpenClaw API 参考

## 概述

OpenClaw 提供完整的 REST API 和 WebSocket 接口，支持消息发送、渠道管理、会话控制等功能。

## 基础信息

- **Base URL**: `http://localhost:16784`
- **认证**: Header `Authorization: Bearer <token>`
- **格式**: JSON

## 认证

### 获取 Token

```bash
# 从配置文件获取
openclaw config get gateway.auth.token
```

### 认证示例

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
     http://localhost:16784/api/status
```

---

## 消息 API

### 发送消息

**POST** `/api/message/send`

```bash
# 请求
curl -X POST http://localhost:16784/api/message/send \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "channel": "telegram",
    "target": "@username",
    "message": "你好！"
  }'
```

**请求参数：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| channel | string | 是 | 渠道：telegram/whatsapp/feishu/wecom |
| target | string | 是 | 目标用户/频道 ID |
| message | string | 是 | 消息内容 |
| media | string | 否 | 媒体文件路径或 URL |
| replyTo | string | 否 | 回复的消息 ID |

**响应：**

```json
{
  "success": true,
  "messageId": "msg_123456",
  "channel": "telegram"
}
```

### 发送卡片消息（飞书）

```bash
curl -X POST http://localhost:16784/api/message/send \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "channel": "feishu",
    "target": "ou_xxx",
    "message": {
      "msg_type": "interactive",
      "card": {
        "header": {
          "title": { "tag": "plain_text", "content": "标题" },
          "template": "blue"
        },
        "elements": [
          {
            "tag": "div",
            "text": { "tag": "lark_md", "content": "内容" }
          }
        ]
      }
    }
  }'
```

---

## 渠道 API

### 获取渠道列表

**GET** `/api/channels`

```bash
curl http://localhost:16784/api/channels \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**响应：**

```json
{
  "channels": [
    {
      "name": "telegram",
      "enabled": true,
      "status": "connected",
      "users": 5
    },
    {
      "name": "whatsapp",
      "enabled": true,
      "status": "connected",
      "users": 12
    }
  ]
}
```

### 渠道详情

**GET** `/api/channels/:name`

```bash
curl http://localhost:16784/api/channels/telegram \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 会话 API

### 获取会话列表

**GET** `/api/sessions`

```bash
curl http://localhost:16784/api/sessions \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**响应：**

```json
{
  "sessions": [
    {
      "id": "session_123",
      "user": "user_456",
      "channel": "telegram",
      "messages": 50,
      "lastActive": "2026-03-03T01:00:00Z"
    }
  ]
}
```

### 获取会话历史

**GET** `/api/sessions/:id/history`

```bash
curl http://localhost:16784/api/sessions/session_123/history \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 发送消息到会话

**POST** `/api/sessions/:id/message`

```bash
curl -X POST http://localhost:16784/api/sessions/session_123/message \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "继续之前的对话"
  }'
```

---

## 定时任务 API

### 列出任务

**GET** `/api/cron`

```bash
curl http://localhost:16784/api/cron \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 创建任务

**POST** `/api/cron`

```bash
curl -X POST http://localhost:16784/api/cron \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "每日提醒",
    "schedule": "0 9 * * *",
    "message": "早上好！",
    "channel": "telegram",
    "target": "@username"
  }'
```

### 删除任务

**DELETE** `/api/cron/:id`

```bash
curl -X DELETE http://localhost:16784/api/cron/job_123 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 系统 API

### 健康检查

**GET** `/api/health`

```bash
curl http://localhost:16784/api/health
```

**响应：**

```json
{
  "status": "healthy",
  "uptime": 3600,
  "version": "2026.2.9",
  "channels": {
    "telegram": "connected",
    "whatsapp": "connected"
  }
}
```

### 统计信息

**GET** `/api/stats`

```bash
curl http://localhost:16784/api/stats \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**响应：**

```json
{
  "messages": {
    "total": 12345,
    "today": 234,
    "byChannel": {
      "telegram": 100,
      "whatsapp": 134
    }
  },
  "sessions": {
    "active": 5,
    "total": 100
  },
  "apiCalls": {
    "total": 50000,
    "errors": 50
  }
}
```

---

## WebSocket API

### 连接

```
ws://localhost:16784/ws?token=YOUR_TOKEN
```

### 消息事件

**接收消息：**

```json
{
  "type": "message",
  "channel": "telegram",
  "from": "user123",
  "content": "你好",
  "timestamp": "2026-03-03T01:00:00Z"
}
```

**发送消息：**

```json
{
  "type": "send",
  "channel": "telegram",
  "target": "user123",
  "message": "你好！"
}
```

### 心跳

```json
{
  "type": "ping"
}
```

---

## 错误码

| 码 | 说明 |
|----|------|
| 200 | 成功 |
| 400 | 请求错误 |
| 401 | 未授权 |
| 403 | 禁止访问 |
| 404 | 未找到 |
| 429 | 请求过多 |
| 500 | 服务器错误 |

### 错误响应

```json
{
  "error": {
    "code": 401,
    "message": "Unauthorized"
  }
}
```

---

## 完整示例

### Node.js 调用

```javascript
const axios = require('axios');

const client = axios.create({
  baseURL: 'http://localhost:16784',
  headers: {
    'Authorization': `Bearer ${process.env.OPENCLAW_TOKEN}`,
    'Content-Type': 'application/json'
  }
});

// 发送消息
async function sendMessage(channel, target, message) {
  const res = await client.post('/api/message/send', {
    channel,
    target,
    message
  });
  return res.data;
}

// 使用
sendMessage('telegram', '@username', '你好！')
  .then(console.log)
  .catch(console.error);
```

### Python 调用

```python
import requests

BASE_URL = "http://localhost:16784"
TOKEN = "your-token"

headers = {
    "Authorization": f"Bearer {TOKEN}",
    "Content-Type": "application/json"
}

def send_message(channel, target, message):
    resp = requests.post(
        f"{BASE_URL}/api/message/send",
        json={"channel": channel, "target": target, "message": message},
        headers=headers
    )
    return resp.json()

# 使用
result = send_message("telegram", "@username", "你好！")
print(result)
```

---

## 速率限制

- **默认限制**: 100 请求/分钟
- **消息限制**: 20 条/分钟/用户

如需提高限制请联系管理员。