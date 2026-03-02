# 🤖 AI Assistant - AI 助手示例

基于大语言模型的智能助手。

## 功能

- 智能对话
- 上下文记忆
- 系统人格设定
- 多模态理解

## 快速开始

```bash
# 复制到技能目录
cp -r examples/ai-assistant ~/.openclaw/workspace/skills/

# 配置 API Key
openclaw config set providers.anthropic.apiKey "sk-..."

# 启用
openclaw skills enable ai-assistant
```

## 代码

```javascript
// index.js
export default {
  name: "ai-assistant",
  version: "1.0.0",
  description: "AI 智能助手",
  
  // 系统设定
  systemPrompt: `你叫小二，是一个友好、专业、有帮助的 AI 助手。

特点：
- 回答简洁明了
- 善于用中文交流
- 喜欢用 emoji
- 适当时候使用代码块

知识截止：2024年12月`,
  
  rules: [
    {
      pattern: /.*/,
      ai: true,
      system: "你叫小二，是用户的 AI 助手。用中文回复，保持简洁。"
    }
  ],
  
  // 生命周期
  async onLoad() {
    console.log("AI 助手已加载");
    // 初始化向量数据库（可选）
    // await this.initKnowledgeBase();
  },
  
  // 消息预处理
  async onBeforeMessage(message) {
    // 添加用户信息到上下文
    if (message.from) {
      const userPref = await this.getUserPref(message.from);
      if (userPref) {
        message.context = `用户偏好：${JSON.stringify(userPref)}`;
      }
    }
    return message;
  },
  
  // 消息后处理
  async onAfterMessage(message, response) {
    // 记录对话历史
    await this.saveToHistory(message, response);
    
    // 更新用户偏好
    await this.updateUserPref(message.from, message.content);
    
    return response;
  },
  
  // 获取用户偏好
  async getUserPref(userId) {
    // 从记忆系统获取
    return await memory.get(`user:${userId}:pref`);
  },
  
  // 保存对话历史
  async saveToHistory(message, response) {
    await memory.set(`history:${message.from}:last`, {
      question: message.content,
      answer: response,
      timestamp: Date.now()
    });
  },
  
  // 更新偏好
  async updateUserPref(userId, content) {
    // 根据对话内容更新偏好
    if (content.includes('我喜欢') || content.includes('我偏好')) {
      // 提取偏好并保存
    }
  }
}
```

## 高级功能

### 自定义人格

```javascript
// 不同人格配置
const PERSONAS = {
  default: {
    name: "小二",
    description: "友好热情的助手",
    system: "你叫小二..."
  },
  professional: {
    name: "博士",
    description: "专业严谨的顾问",
    system: "你是专业的技术顾问..."
  },
  creative: {
    name: "创意师",
    description: "富有创意的头脑风暴伙伴",
    system: "你是一个创意无限的思想伙伴..."
  }
};

// 切换人格
export default {
  // ...
  
  rules: [
    {
      pattern: /^切换人格\s*(\w+)/,
      handler: async (match) => {
        const persona = match[1];
        if (PERSONAS[persona]) {
          this.currentPersona = PERSONAS[persona];
          return `已切换到 ${this.currentPersona.description}`;
        }
        return "未知人格";
      }
    }
  ]
}
```

### 知识库集成

```javascript
// 知识库检索
export default {
  async searchKnowledge(query) {
    // 向量搜索
    const results = await this.vectorDB.search(query, { topK: 3 });
    
    // 构建上下文
    const context = results
      .map(r => r.content)
      .join('\n\n');
    
    return context;
  },
  
  async onBeforeMessage(message) {
    // 先搜索知识库
    const knowledge = await this.searchKnowledge(message.content);
    
    // 添加到系统提示
    if (knowledge) {
      message.knowledge = knowledge;
    }
    
    return message;
  }
}
```

### 函数调用

```javascript
// 定义可用函数
const tools = [
  {
    name: "get_weather",
    description: "获取天气信息",
    parameters: {
      type: "object",
      properties: {
        city: { type: "string", description: "城市名称" }
      },
      required: ["city"]
    }
  },
  {
    name: "search_web",
    description: "搜索网页",
    parameters: {
      type: "object",
      properties: {
        query: { type: "string", description: "搜索关键词" }
      },
      required: ["query"]
    }
  }
];

// 使用函数
export default {
  tools: tools,
  
  async onToolCall(toolName, args) {
    switch (toolName) {
      case "get_weather":
        return await this.getWeather(args.city);
      case "search_web":
        return await this.searchWeb(args.query);
    }
  }
}
```

## 配置

```json
{
  "enabled": true,
  "settings": {
    "model": "claude-3.5-sonnet",
    "temperature": 0.7,
    "maxTokens": 4096,
    "systemPrompt": "你叫小二...",
    "historyLength": 10,
    "tools": {
      "weather": true,
      "search": true
    }
  }
}
```

## 性能优化

### 请求缓存

```javascript
// 缓存常见问题
const cache = new Map();

export default {
  async onMessage(message) {
    const cacheKey = message.content;
    
    if (cache.has(cacheKey)) {
      return cache.get(cacheKey);
    }
    
    const response = await this.getAIResponse(message);
    
    // 缓存 1 小时
    cache.set(cacheKey, response);
    setTimeout(() => cache.delete(cacheKey), 3600000);
    
    return response;
  }
}
```

### 流式响应

```javascript
// 对于长回复使用流式
async streamResponse(message) {
  const stream = await this.ai.stream(message);
  
  let response = '';
  for await (const chunk of stream) {
    response += chunk;
    // 实时发送（需要渠道支持）
    await this.sendChunk(response);
  }
}
```

## 监控

```javascript
// 记录使用统计
export default {
  async onAfterMessage(message, response) {
    await this.track({
      user: message.from,
      channel: message.channel,
      tokens: response.usage,
      latency: response.latency
    });
  }
}
```