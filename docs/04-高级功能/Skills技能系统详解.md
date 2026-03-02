# 🛠️ Skills 技能系统详解

## 概述

Skills（技能）是 OpenClaw 的核心扩展机制，允许用户通过自定义代码扩展 AI 助手的能力。本文详细介绍 OpenClaw 内置技能的原理、使用方法和实战技巧。

## 内置技能列表

OpenClaw 默认提供以下内置技能：

| 技能名称 | 功能 | 使用场景 |
|----------|------|----------|
| `qqbot-cron` | 定时提醒 | 会议提醒、任务提醒 |
| `qqbot-media` | 媒体发送 | 发送图片、视频 |
| `searxng` | 隐私搜索 | 网页、图片、新闻搜索 |
| `weather` | 天气查询 | 获取天气预报 |

---

## 技能架构

### 技能目录结构

```
~/.openclaw/workspace/skills/
├── SKILL.md              # 技能说明文档
├── index.js              # 技能入口文件
├── config.json           # 技能配置
├── utils/                # 工具函数
└── locales/             # 国际化文件
```

### 技能生命周期

```
加载(onLoad) → 消息处理(onMessage) → 卸载(onUnload)
         ↓
    定时任务(onScheduled)
         ↓
    HTTP 端点(onRequest)
```

---

## 内置技能详解

### 1. qqbot-cron - 定时提醒技能

**功能**：支持一次性提醒、周期性任务、自动降级确保送达

**使用命令**：
```bash
# 设置提醒
提醒我 下午3点 开会

# 查看提醒列表
我的提醒

# 取消提醒
取消提醒 1
```

**核心代码**：

```javascript
// qqbot-cron 技能核心实现

export default {
  name: "qqbot-cron",
  version: "1.0.0",
  
  // 定时任务列表
  schedule: "*/5 * * * *", // 每5分钟检查
  
  async onScheduled() {
    // 检查是否有需要发送的提醒
    await this.checkReminders();
  },
  
  rules: [
    {
      // 一次性提醒
      pattern: /提醒我(.+?)\s+(在|于)?\s*(\d{1,2}:\d{2})/,
      handler: async (match) => {
        const [_, task, , time] = match;
        return await this.setReminder(task.trim(), time);
      }
    },
    {
      // 每天提醒
      pattern: /每天\s+(.+)/,
      handler: async (match) => {
        const task = match[1];
        return await this.setDailyReminder(task);
      }
    },
    {
      // 查看提醒
      pattern: /(我的提醒|提醒列表)/,
      handler: async () => {
        return await this.listReminders();
      }
    }
  ],
  
  // 设置一次性提醒
  async setReminder(task, time) {
    const [hour, minute] = time.split(':');
    const now = new Date();
    const reminderTime = new Date();
    reminderTime.setHours(parseInt(hour), parseInt(minute), 0, 0);
    
    // 如果时间已过，推到明天
    if (reminderTime < now) {
      reminderTime.setDate(reminderTime.getDate() + 1);
    }
    
    // 创建定时任务
    const job = await cron.add({
      name: `提醒: ${task}`,
      schedule: { kind: "at", at: reminderTime.toISOString() },
      payload: { kind: "systemEvent", text: `⏰ 提醒: ${task}` },
      sessionTarget: "main"
    });
    
    return `✅ 已设置提醒：${task}\n时间：${reminderTime.toLocaleString('zh-CN')}`;
  },
  
  // 自动降级发送
  async sendWithFallback(message, userId) {
    const channels = ['telegram', 'feishu', 'whatsapp'];
    
    for (const channel of channels) {
      try {
        await this.sendToChannel(channel, {
          target: userId,
          message: message
        });
        return true;
      } catch (e) {
        console.log(`${channel} 发送失败:`, e.message);
      }
    }
    
    return false;
  }
}
```

---

### 2. qqbot-media - 媒体发送技能

**功能**：支持发送图片、视频、音频、文件到各个渠道

**使用命令**：
```
发送图片 给 @用户
发送视频 到 群名
```

**核心代码**：

```javascript
export default {
  name: "qqbot-media",
  
  rules: [
    {
      pattern: /(发送|发)(图片|照片|image)\s*(给|到)?\s*@?(\S+)?/i,
      handler: async (match) => {
        const [_, , , , target] = match;
        return await this.requestImage(target || message.from);
      }
    }
  ],
  
  // 请求用户发送图片
  async requestImage(target) {
    return {
      message: "请发送要发送的图片",
      // 进入等待图片模式
      nextState: { 
        action: "waiting_image", 
        target: target 
      }
    };
  },
  
  // 处理收到的图片
  async handleMedia(message) {
    const { media, type } = message;
    
    // 下载并处理媒体
    const file = await this.downloadMedia(media);
    
    // 发送给目标
    await this.sendToChannel(message.channel, {
      target: message.state.target,
      media: file.path,
      caption: message.text
    });
    
    return "图片已发送 ✅";
  }
}
```

---

### 3. searxng - 隐私搜索技能

**功能**：使用本地 SearXNG 实例进行隐私搜索

**使用命令**：
```
搜索 OpenClaw
图片搜索 猫咪
新闻搜索 AI
```

**核心代码**：

```javascript
export default {
  name: "searxng",
  version: "1.0.0",
  
  // 配置 SearXNG 实例
  config: {
    baseUrl: "http://searxng:8080",
    timeout: 10000
  },
  
  rules: [
    {
      pattern: /^(?:搜索?|search)\s+(.+)/i,
      handler: async (match) => {
        const query = match[1];
        return await this.search(query, "general");
      }
    },
    {
      pattern: /^(?:图片搜索|image)\s+(.+)/i,
      handler: async (match) => {
        const query = match[1];
        return await this.search(query, "images");
      }
    },
    {
      pattern: /^(?:新闻搜索|news)\s+(.+)/i,
      handler: async (match) => {
        const query = match[1];
        return await this.search(query, "news");
      }
    }
  ],
  
  // 执行搜索
  async search(query, category = "general") {
    const endpoint = category === "general" ? "" : `?categories=${category}`;
    
    try {
      const response = await fetch(`${this.config.baseUrl}/search${endpoint}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: `q=${encodeURIComponent(query)}&format=json`
      });
      
      const data = await response.json();
      
      // 格式化结果
      const results = data.results.slice(0, 5).map(r => ({
        title: r.title,
        url: r.url,
        content: r.content?.substring(0, 100) + "..."
      }));
      
      return this.formatResults(query, results);
    } catch (error) {
      return `搜索失败: ${error.message}`;
    }
  },
  
  // 格式化搜索结果
  formatResults(query, results) {
    let text = `🔍 搜索结果：${query}\n\n`;
    
    results.forEach((r, i) => {
      text += `${i + 1}. ${r.title}\n`;
      text += `   ${r.content}\n`;
      text += `   🔗 ${r.url}\n\n`;
    });
    
    text += `---`;
    text += `\n共 ${results.length} 条结果`;
    
    return text;
  }
}
```

---

### 4. weather - 天气查询技能

**功能**：获取当前天气和预报（无需 API Key）

**使用命令**：
```
天气
天气 上海
天气预报 深圳 3天
```

**核心代码**：

```javascript
export default {
  name: "weather",
  version: "1.0.0",
  
  // 缓存天气数据
  cache: new Map(),
  cacheTime: 10 * 60 * 1000, // 10分钟
  
  rules: [
    {
      pattern: /^(?:天气|天气预报)\s*(.+)?/,
      handler: async (match) => {
        const city = match[1] || "上海";
        return await this.getWeather(city);
      }
    }
  ],
  
  async getWeather(city) {
    // 检查缓存
    const cached = this.cache.get(city);
    if (cached && Date.now() - cached.time < this.cacheTime) {
      return cached.data;
    }
    
    try {
      // 使用 wttr.in（免费无需 API）
      const response = await fetch(`https://wttr.in/${encodeURIComponent(city)}?format=j1`);
      const data = await response.json();
      
      const current = data.current_condition[0];
      const forecast = data.weather.slice(0, 3);
      
      // 格式化
      const result = this.formatWeather(city, current, forecast);
      
      // 缓存
      this.cache.set(city, { time: Date.now(), data: result });
      
      return result;
    } catch (error) {
      return `查询天气失败: ${error.message}`;
    }
  },
  
  formatWeather(city, current, forecast) {
    let text = `🌤️ ${city}天气\n\n`;
    text += `**当前**\n`;
    text += `温度：${current.temp_C}°C\n`;
    text += `体感：${current.FeelsLikeC}°C\n`;
    text += `湿度：${current.humidity}%\n`;
    text += `风速：${current.windspeedKmph} km/h\n`;
    text += `天气：${current.weatherDesc[0].value}\n\n`;
    
    text += `**预报**\n`;
    forecast.forEach((day, i) => {
      const date = new Date(day.date);
      const weekday = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"][date.getDay()];
      text += `${weekday} (${day.avgtempC}°C) ${day.weatherDesc[0].value}\n`;
    });
    
    return text;
  }
}
```

---

## 技能实战案例

### 案例 1：企业客服技能

```javascript
// skills/enterprise-customer-service/index.js

export default {
  name: "enterprise-customer-service",
  version: "1.0.0",
  
  // 知识库
  knowledgeBase: {
    "请假": {
      keywords: ["请假", "休假", "年假", "调休"],
      answer: `📝 请假指南：

1. 登录 HR 系统 (hr.company.com)
2. 点击"请假申请"
3. 选择请假类型
4. 填写开始/结束时间
5. 提交审批

📌 注意事项：
- 普通请假需提前 1 天申请
- 年假需提前 3 天申请
- 紧急情况可电话请假`
    },
    "报销": {
      keywords: ["报销", "费用", "发票"],
      answer: `💰 报销指南：

1. 收集发票（电子/纸质）
2. 登录财务系统
3. 创建报销单
4. 上传发票
5. 等待审批

📌 报销周期：7个工作日内`
    },
    "IT": {
      keywords: ["IT", "电脑", "网络", "打印机"],
      answer: `💻 IT 支持：

📞 技术支持热线：800-XXX-XXXX

常见问题：
- 电脑故障：重启试试
- 网络问题：检查网线
- 打印问题：检查驱动

如无法解决，请提交工单`
    },
    "门禁": {
      keywords: ["门禁", "刷卡", "开门"],
      answer: `🚪 门禁问题：

1. 联系行政部开门
2. 申请临时门禁卡
3. 门禁卡遗失立即挂失

📞 行政部：800-XXX-XXX`
    }
  },
  
  rules: [
    {
      pattern: /.*/,
      handler: async (message) => {
        const content = message.content.toLowerCase();
        
        // 搜索知识库
        for (const [key, data] of Object.entries(this.knowledgeBase)) {
          if (data.keywords.some(k => content.includes(k))) {
            return data.answer;
          }
        }
        
        // 未匹配，转人工
        return `抱歉，我没有理解您的问题。

您可以：
1. 拨打客服热线 800-XXX-XXXX
2. 发送邮件 support@company.com
3. 继续描述您的问题

😊 我会继续学习~`;
      }
    }
  ]
}
```

### 案例 2：数据分析技能

```javascript
// skills/data-analysis/index.js

export default {
  name: "data-analysis",
  version: "1.0.0",
  
  // 数据源配置
  dataSources: {
    // 可以配置多个数据源
    sales: {
      type: "mysql",
      connection: "mysql://user:pass@localhost/sales"
    },
    users: {
      type: "postgresql",
      connection: "postgresql://user:pass@localhost/users"
    }
  },
  
  rules: [
    {
      // 销售数据查询
      pattern: /(?:销售|营收|订单)\s*(?:今天|昨日|本周|本月)?/,
      handler: async (match) => {
        return await this.querySales(match[1] || "today");
      }
    },
    {
      // 用户统计
      pattern: /(?:用户|会员)(?:统计|数据)?/,
      handler: async () => {
        return await this.queryUsers();
      }
    },
    {
      // 排行榜
      pattern: /(?:排行|top|榜单)\s*(\d+)?/,
      handler: async (match) => {
        const top = parseInt(match[1]) || 10;
        return await this.getTopProducts(top);
      }
    }
  ],
  
  async querySales(period) {
    // 模拟查询
    const data = {
      today: { orders: 156, revenue: 25680, customers: 132 },
      yesterday: { orders: 145, revenue: 23450, customers: 128 },
      week: { orders: 980, revenue: 168000, customers: 650 },
      month: { orders: 4200, revenue: 720000, customers: 2800 }
    };
    
    const d = data[period] || data.today;
    
    return `📊 销售数据 (${period})

订单数：${d.orders}
营业额：¥${d.revenue.toLocaleString()}
客户数：${d.customers}

同比：+${Math.floor(Math.random() * 20)}%`;
  },
  
  async queryUsers() {
    return `👥 用户统计

今日新增：${Math.floor(Math.random() * 50) + 10}
活跃用户：${Math.floor(Math.random() * 500) + 200}
总用户数：${Math.floor(Math.random() * 10000) + 5000}`;
  },
  
  async getTopProducts(top) {
    const products = ["商品A", "商品B", "商品C", "商品D", "商品E"];
    let text = `🏆 热销商品 Top ${top}\n\n`;
    
    for (let i = 0; i < Math.min(top, products.length); i++) {
      const sales = Math.floor(Math.random() * 1000) + 100;
      text += `${i + 1}. ${products[i]} - ${sales} 件\`;
    }
    
    return text;
  }
}
```

---

## 技能配置详解

### 技能配置文件

```json
{
  "name": "my-skill",
  "version": "1.0.0",
  "enabled": true,
  "priority": 10,
  "settings": {
    "apiKey": "${MY_API_KEY}",
    "option1": "value1"
  },
  "channels": ["telegram", "feishu"],
  "blacklist": [],
  "whitelist": []
}
```

### 环境变量使用

```json
{
  "settings": {
    "apiKey": "${API_KEY}",
    "secret": "${SECRET_KEY}"
  }
}
```

---

## 技能测试与调试

### 本地测试

```bash
# 测试技能
openclaw skills test my-skill --message "hello"

# 带参数测试
openclaw skills test weather-bot --message "天气 上海"
```

### 日志调试

```bash
# 实时查看技能日志
openclaw logs --follow | grep "my-skill"

# 调试模式
openclaw gateway --log-level debug
```

---

## 发布技能到社区

1. **创建 GitHub 仓库**
   ```bash
   mkdir openclaw-skill-xxx
   cd openclaw-skill-xxx
   git init
   ```

2. **添加必要文件**
   ```
   ├── index.js          # 主代码
   ├── SKILL.md          # 说明文档
   ├── config.json       # 默认配置
   ├── package.json      # 依赖
   └── test/             # 测试文件
   ```

3. **编写 SKILL.md**
   ```markdown
   # Skill Name
   
   ## 功能描述
   
   ## 使用方法
   
   ## 配置说明
   
   ## 示例
   ```

4. **发布**
   ```bash
   git add .
   git commit -m "v1.0.0"
   git push origin main
   ```

---

## 技能最佳实践

1. **单一职责**：一个技能只做一件事
2. **错误处理**：always try-catch
3. **日志记录**：便于问题排查
4. **配置分离**：敏感信息放环境变量
5. **版本管理**：遵循语义化版本
6. **文档完善**：让用户快速上手
7. **测试覆盖**：保证功能稳定

---

## 相关资源

- [OpenClaw Skills 官方文档](https://docs.openclaw.ai/skills)
- [技能市场 ClawHub](https://clawhub.com)
- [社区 Discord](https://discord.com/invite/clawd)