# ⏰ Reminder Bot - 提醒机器人

功能强大的提醒和定时任务机器人。

## 功能

- 一次性提醒
- 周期性任务
- 提醒降级确保送达
- 多渠道提醒

## 使用方法

```bash
# 复制到技能目录
cp -r examples/reminder-bot ~/.openclaw/workspace/skills/

# 启用
openclaw skills enable reminder-bot
```

## 代码

```javascript
// index.js
import { cron } from 'openclaw';

export default {
  name: "reminder-bot",
  version: "1.0.0",
  description: "提醒和定时任务机器人",
  
  rules: [
    // 设置提醒
    {
      pattern: /提醒我\s*(.+?)\s*(在|于)?\s*(.+)/,
      handler: async (match) => {
        const [_, task, , timeStr] = match;
        return await this.setReminder(task.trim(), timeStr.trim());
      }
    },
    // 每天提醒
    {
      pattern: /每天\s+(.+)/,
      handler: async (match) => {
        const task = match[1];
        return await this.setDailyReminder(task);
      }
    },
    // 每周提醒
    {
      pattern: /每周(.+?)\s+(.+)/,
      handler: async (match) => {
        const [_, day, task] = match;
        return await this.setWeeklyReminder(day, task);
      }
    },
    // 查看提醒
    {
      pattern: /^提醒列表|^我的提醒/,
      handler: async () => {
        return await this.listReminders();
      }
    },
    // 取消提醒
    {
      pattern: /取消提醒\s*(.+)/,
      handler: async (match) => {
        const id = match[1];
        return await this.cancelReminder(id);
      }
    }
  ],
  
  async setReminder(task, timeStr) {
    // 解析时间
    const time = this.parseTime(timeStr);
    
    if (!time) {
      return "时间格式不正确，请使用：\n• 下午3点\n• 20:30\n• 3月5日14:00";
    }
    
    if (time < new Date()) {
      return "时间必须是未来的时间";
    }
    
    // 创建定时任务
    const job = await cron.add({
      name: `提醒: ${task}`,
      schedule: { kind: "at", at: time.toISOString() },
      payload: {
        kind: "systemEvent",
        text: `⏰ 提醒：${task}`
      },
      sessionTarget: "main"
    });
    
    return `✅ 已设置提醒：${task}\n时间：${time.toLocaleString('zh-CN')}\nID: ${job.id}`;
  },
  
  async setDailyReminder(task) {
    const [hour, minute] = this.getTimeFromTask(task);
    
    await cron.add({
      name: `每日提醒: ${task}`,
      schedule: {
        kind: "cron",
        expr: `${minute} ${hour} * * *`
      },
      payload: {
        kind: "systemEvent",
        text: `⏰ 每日提醒：${task}`
      },
      sessionTarget: "main"
    });
    
    return `✅ 已设置每天 ${hour}:${minute} 提醒：${task}`;
  },
  
  async setWeeklyReminder(day, task) {
    const days = { '一': 1, '二': 2, '三': 3, '四': 4, '五': 5, '六': 6, '日': 0 };
    const dayNum = days[day] ?? 1;
    
    await cron.add({
      name: `每周提醒: ${task}`,
      schedule: {
        kind: "cron",
        expr: `0 9 * * ${dayNum}`
      },
      payload: {
        kind: "systemEvent",
        text: `⏰ 周${day}提醒：${task}`
      },
      sessionTarget: "main"
    });
    
    return `✅ 已设置每周${day}早上9点提醒：${task}`;
  },
  
  async listReminders() {
    const jobs = await cron.list();
    
    if (jobs.length === 0) {
      return "📝 暂无提醒";
    }
    
    let list = "📝 你的提醒列表：\n\n";
    jobs.forEach((job, i) => {
      list += `${i + 1}. ${job.name}\n`;
      list += `   时间：${job.nextRun || '已启用'}\n\n`;
    });
    
    return list;
  },
  
  async cancelReminder(id) {
    await cron.remove(id);
    return `✅ 已取消提醒`;
  },
  
  parseTime(str) {
    // 简单的时间解析
    const now = new Date();
    
    // 匹配 "下午3点" / "15:00" / "3月5日"
    if (str.includes('下午')) {
      const hour = parseInt(str.match(/下午(\d+)/)[1]) + 12;
      now.setHours(hour, 0, 0, 0);
    } else if (str.includes('早上') || str.includes('上午')) {
      const hour = parseInt(str.match(/早上(\d+)|上午(\d+)/)[1]);
      now.setHours(hour, 0, 0, 0);
    } else if (str.match(/^\d+:\d+$/)) {
      const [h, m] = str.split(':');
      now.setHours(parseInt(h), parseInt(m), 0, 0);
    } else {
      // 尝试解析日期
      return null;
    }
    
    return now;
  },
  
  getTimeFromTask(task) {
    // 从任务中提取时间
    const match = task.match(/(\d+):(\d+)/);
    if (match) {
      return [match[1], match[2]];
    }
    return ['9', '0']; // 默认 9:00
  }
}
```

## 使用示例

```
用户：提醒我喝水在下午3点
小二：✅ 已设置提醒：喝水
      时间：2026年3月3日15:00
      ID: abc123

用户：每天早上8点跑步
小二：✅ 已设置每天 8:0 提醒：跑步

用户：提醒列表
小二：📝 你的提醒列表：

      1. 提醒: 喝水
         时间：2026-03-03T07:00:00.000Z
```

## 高级功能

### 多渠道送达

```javascript
async sendReminder(task, message) {
  const channels = ['telegram', 'feishu', 'whatsapp'];
  
  for (const channel of channels) {
    try {
      await this.sendToChannel(channel, {
        target: this.getUserChannel(channel),
        message: message
      });
      break; // 成功就停止
    } catch (e) {
      console.log(`${channel} 发送失败，尝试下一个`);
    }
  }
}
```

### 智能降级

```javascript
async safeSend(message) {
  // 主渠道
  try {
    await this.sendToTelegram(message);
  } catch (e) {
    // 降级到飞书
    try {
      await this.sendToFeishu(message);
    } catch (e) {
      // 最后尝试短信
      await this.sendToSMS(message);
    }
  }
}
```