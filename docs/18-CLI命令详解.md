# ⌨️ OpenClaw CLI 命令详解

本文档详细介绍 OpenClaw 所有命令行工具的使用方法。

## 命令列表

| 命令 | 说明 |
|------|------|
| `openclaw serve` | 启动 OpenClaw 服务 |
| `openclaw status` | 查看运行状态 |
| `openclaw config` | 配置管理 |
| `openclaw channel` | 渠道管理 |
| `openclaw session` | 会话管理 |
| `openclaw cron` | 定时任务 |
| `openclaw message` | 消息操作 |
| `openclaw skills` | 技能管理 |
| `openclaw logs` | 日志查看 |

---

## 服务命令

### 启动服务

```bash
# 前台启动
openclaw serve

# 后台启动
openclaw serve --daemon

# 指定端口
openclaw serve --port 16784

# 指定配置文件
openclaw serve --config /path/to/config.json
```

### 停止服务

```bash
# 停止后台服务
openclaw stop

# 强制停止
openclaw stop --force
```

### 重启服务

```bash
openclaw restart
```

---

## 状态查看

### 基本状态

```bash
openclaw status
# 输出:
# Status: Running
# Version: 2026.2.9
# Uptime: 2 hours
# Channels: telegram(connected), feishu(connected)
```

### 详细状态

```bash
openclaw status --verbose
# 输出:
# {
#   "status": "running",
#   "version": "2026.2.9",
#   "uptime": 7200,
#   "channels": {...},
#   "model": {...},
#   "memory": {...}
# }
```

### 健康检查

```bash
openclaw status --health
# 检查所有组件状态
```

---

## 配置管理

### 查看配置

```bash
# 查看全部配置
openclaw config get

# 查看特定配置
openclaw config get model
openclaw config get gateway
openclaw config get channels.telegram
```

### 设置配置

```bash
# 设置单个值
openclaw config set model.provider anthropic

# 设置嵌套值
openclaw config set gateway.port 16784

# 设置对象
openclaw config set model '{"provider": "anthropic", "model": "claude-4-sonnet"}'
```

### 导入/导出配置

```bash
# 导出配置
openclaw config export > config-backup.json

# 导入配置
openclaw config import config-backup.json

# 重置为默认
openclaw config reset
```

---

## 渠道管理

### 列出渠道

```bash
openclaw channel list
# 输出:
# telegram  - enabled (connected)
# feishu    - enabled (connected)
# whatsapp  - disabled
```

### 启用/禁用渠道

```bash
openclaw channel enable telegram
openclaw channel disable whatsapp
```

### 渠道详情

```bash
openclaw channel info telegram
# 输出:
# {
#   "name": "telegram",
#   "enabled": true,
#   "status": "connected",
#   "users": 5,
#   "messages": 100
# }
```

---

## 会话管理

### 列出会话

```bash
# 所有会话
openclaw session list

# 活跃会话
openclaw session list --active

# 按渠道筛选
openclaw session list --channel telegram
```

### 会话详情

```bash
openclaw session show session_123
```

### 会话历史

```bash
# 查看最近 20 条消息
openclaw session history session_123

# 指定数量
openclaw session history session_123 --limit 50
```

### 删除会话

```bash
# 删除单个会话
openclaw session delete session_123

# 删除所有非活跃会话
openclaw session cleanup

# 删除超过 7 天的会话
openclaw session cleanup --older-than 7d
```

---

## 定时任务

### 列出任务

```bash
openclaw cron list
# 输出:
# [
#   {"id": "job_1", "name": "每日提醒", "schedule": "0 9 * * *", "enabled": true},
#   {"id": "job_2", "name": "天气查询", "schedule": "0 7 * * *", "enabled": true}
# ]
```

### 添加任务

```bash
# 简单消息
openclaw cron add "每日提醒" --schedule "0 9 * * *" \
  --message "早上好！" \
  --channel telegram \
  --target "@username"

# 复杂任务 (JSON)
openclaw cron add "天气推送" --schedule "0 7 * * *" \
  --task '{"type": "skill", "skill": "weather", "city": "上海"}'
```

### 启用/禁用任务

```bash
openclaw cron enable job_1
openclaw cron disable job_1
```

### 删除任务

```bash
openclaw cron remove job_1
```

### 手动触发

```bash
openclaw cron run job_1
```

---

## 消息操作

### 发送消息

```bash
# 简单文本
openclaw message send telegram --to "@username" --content "你好！"

# 带 Markdown
openclaw message send feishu --to "ou_xxx" --content "**粗体** 和 _斜体_"

# 发送文件
openclaw message send telegram --to "@username" --file /path/to/image.png
```

### 广播消息

```bash
# 到所有用户
openclaw message broadcast --channel telegram --content "系统公告"

# 到指定用户列表
openclaw message broadcast --channel telegram \
  --users "user1,user2,user3" \
  --content "通知"
```

---

## 技能管理

### 列出技能

```bash
openclaw skills list
# 输出:
# my-skill     - enabled  - v1.0.0
# weather      - enabled  - v2.1.0
# reminder     - disabled - v1.0.0
```

### 安装技能

```bash
# 从目录安装
openclaw skills install ./my-skill

# 从 ClawHub 安装
openclaw skills install weather

# 指定版本
openclaw skills install weather@2.0.0
```

### 启用/禁用

```bash
openclaw skills enable my-skill
openclaw skills disable my-skill
```

### 卸载技能

```bash
openclaw skills uninstall my-skill
```

---

## 日志查看

### 实时日志

```bash
# 全部日志
openclaw logs

# 实时跟踪
openclaw logs --follow

# 只看错误
openclaw logs --level error

# 只看某渠道
openclaw logs --channel telegram
```

### 历史日志

```bash
# 查看最近 100 行
openclaw logs --lines 100

# 查看指定时间
openclaw logs --since "2026-03-03 10:00:00"

# 查看历史日志文件
openclaw logs --file /var/log/openclaw/app.log.1
```

### 日志级别

```bash
# debug, info, warn, error
openclaw logs --level debug
```

---

## 更新升级

### 检查更新

```bash
openclaw update check
```

### 更新到最新版本

```bash
# 更新 CLI
openclaw update

# 更新 Docker 镜像
openclaw update --docker
```

### 版本信息

```bash
openclaw --version
# 2026.2.9
```

---

## 调试命令

### 测试配置

```bash
openclaw doctor
# 检查:
# - Node.js 版本
# - 配置文件有效性
# - API Keys 状态
# - 渠道连接状态
# - 磁盘空间
```

### 模拟消息

```bash
# 模拟用户消息
openclaw test message --channel telegram --from "user123" --content "你好"
```

### API 调用测试

```bash
# 测试 API
openclaw test api --endpoint /api/health
```

---

## 快捷键 (交互模式)

```
↑/↓     - 历史命令
Tab     - 自动补全
Ctrl+C  - 取消
Ctrl+L  - 清屏
Ctrl+D  - 退出
```

---

## 常见问题

### Q: 命令找不到
```bash
# 添加到 PATH
export PATH="$PATH:$(npm root -g)/openclaw/bin"

# 或重新加载
source ~/.bashrc
```

### Q: 权限拒绝
```bash
# 使用 sudo (不推荐)
sudo openclaw serve

# 或修复权限
chmod +x $(which openclaw)
```

### Q: 端口占用
```bash
# 查看占用
lsof -i :16784

# 杀死进程
kill $(lsof -t -i :16784)
```

---

*持续更新中...*