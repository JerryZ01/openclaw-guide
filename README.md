# 🦞 OpenClaw 实战指南

<div align="center">

[![OpenClaw Version](https://img.shields.io/badge/OpenClaw-2026.2.9-blue)](https://github.com/openclaw/openclaw)
[![Node Version](https://img.shields.io/badge/Node-22+-green)](https://nodejs.org)
[![License](https://img.shields.io/badge/License-MIT-orange)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/JerryZ01/openclaw-guide)](https://github.com/JerryZ01/openclaw-guide/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/JerryZ01/openclaw-guide)](https://github.com/JerryZ01/openclaw-guide/network)
[![Last Commit](https://img.shields.io/github/last-commit/JerryZ01/openclaw-guide)](https://github.com/JerryZ01/openclaw-guide/commits/main)

> 🤖 企业级 AI Agent 网关 | 多渠道消息管理 | 智能助手搭建手册

[English](./README.md) | [中文](./README.md) | [GitHub](https://github.com/JerryZ01/openclaw-guide) | [官方文档](https://docs.openclaw.ai)

</div>

---

## 📖 项目简介

本项目是一份全面、详尽的 **OpenClaw 实战指南**，旨在帮助开发者快速掌握 OpenClaw 的使用、部署和开发。从零基础入门到生产环境部署，从单一渠道到多渠道集成，从内置功能到自定义技能开发，本指南涵盖了你需要的一切。

### 🌟 为什么选择 OpenClaw？

| 特性 | 说明 |
|------|------|
| 🎯 **多渠道支持** | WhatsApp、Telegram、Discord、飞书、企业微信、Slack 等 |
| 🔌 **开箱即用** | 5 分钟内完成基础配置 |
| 🧠 **AI 原生** | 内置 Claude、GPT 等大模型支持 |
| 🛠️ **可扩展** | 自定义技能、插件开发 |
| 🔒 **自托管** | 数据完全可控，保证隐私 |
| 🆓 **开源免费** | MIT 许可证，社区活跃 |

---

## 📑 目录导航

```
📚 入门指南
├── 01-快速开始.md        # 5分钟快速入门
├── 02-配置详解.md        # 完整配置参考
└── 11-快速参考.md        # 命令速查表

📱 渠道接入 (Channel)
├── 03-渠道接入/WhatsApp.md
├── 03-渠道接入/Telegram.md
├── 03-渠道接入/Discord.md
├── 03-渠道接入/飞书.md
└── 03-渠道接入/企业微信.md

🛠️ 高级功能 (Advanced)
├── 04-高级功能/多代理路由.md
├── 04-高级功能/定时任务.md
├── 04-高级功能/技能开发.md
├── 04-高级功能/记忆系统.md
└── 04-高级功能/Skills技能系统详解.md

☁️ 部署运维 (DevOps)
├── 05-部署运维/Docker部署.md
├── 05-部署运维/系统服务.md
├── 05-部署运维/监控告警.md
├── 16-多平台部署指南.md   # 树莓派/Mac Mini/WSL2/VPS
└── 07-开发指南.md

💰 成本优化
└── 17-成本优化指南.md    # API 成本控制

💡 场景方案 (Scenarios)
├── 08-场景方案.md        # 11大企业场景
└── 09-版本选型.md        # 部署方式对比

🔧 问题解决
├── 06-故障排除.md
├── 12-问题排查.md
├── 10-词汇表.md
├── 13-安全配置.md
├── 15-安全强化指南.md    # 2026 安全强化
├── 18-CLI命令详解.md    # 命令行参考
└── 19-错误代码详解.md    # 错误解决

🦞 玩法探索 (Use Cases)
├── 20-OpenClaw玩法总览.md    # 玩法导航
├── 20-玩法/社交媒体自动化.md  # 发帖、分析
├── 20-玩法/商业效率自动化.md  # 邮件、日程
├── 20-玩法/生活家居自动化.md  # 智能家居、简报
├── 20-玩法/开发技术自动化.md  # 手机写代码、自愈
└── 20-玩法/骚操作案例.md      # 有趣玩法

🧩 示例项目 (Examples)
├── examples/basic-bot/           # 基础机器人
├── examples/ai-assistant/        # AI 助手
├── examples/weather-bot/         # 天气查询
├── examples/reminder-bot/        # 提醒机器人
├── examples/translation-bot/    # 翻译机器人
└── examples/multi-channel/      # 多渠道管理
```

---

## 🚀 快速开始

### 1. 安装

```bash
# 安装 OpenClaw CLI
npm install -g openclaw@latest

# 验证安装
openclaw --version
```

### 2. 初始化

```bash
# 启动引导（推荐）
openclaw onboard

# 或手动配置
openclaw setup
```

### 3. 启动 Gateway

```bash
# 启动服务
openclaw gateway --port 16784

# 后台运行
openclaw gateway start
```

### 4. 接入渠道

```bash
# WhatsApp
openclaw channels login whatsapp

# Telegram
openclaw config set channels.telegram.botToken "YOUR_TOKEN"
openclaw config set channels.telegram.enabled true
```

### 5. 发送消息

```bash
# 发送消息
openclaw message send \
  --channel telegram \
  --target @username \
  --message "你好！"
```

> 📖 详细步骤请阅读 [01-快速开始.md](docs/01-快速开始.md)

---

## 🎯 核心功能

### 📱 多渠道集成

支持同时连接多个消息渠道，统一管理：

| 渠道 | 状态 | 功能 |
|------|------|------|
| WhatsApp | ✅ | 文字、图片、视频、语音 |
| Telegram | ✅ | 文字、媒体、按钮、键盘 |
| Discord | ✅ | 文字、Embed、斜杠命令 |
| 飞书 | ✅ | 文字、卡片、文档 |
| 企业微信 | ✅ | 文字、文件、模板消息 |

### 🧠 AI 能力

- 🤖 多模型支持（Claude、GPT、Qwen 等）
- 💬 智能对话
- 📚 上下文记忆
- 🔧 函数调用
- 🎯 意图识别

### ⏰ 定时任务

```bash
# 一次性提醒
提醒我 下午3点 开会

# 每天提醒
每天 早上8点 跑步

# Cron 表达式
0 9 * * *  # 每天9点
```

### 🛠️ 技能系统

OpenClaw 的核心扩展机制：

| 技能 | 功能 |
|------|------|
| `qqbot-cron` | 定时提醒 |
| `qqbot-media` | 媒体发送 |
| `searxng` | 隐私搜索 |
| `weather` | 天气查询 |

> 📖 详见 [Skills技能系统详解.md](docs/04-高级功能/Skills技能系统详解.md)

---

## 📂 示例项目

我们提供了多个完整的示例项目，可以直接使用：

### 🤖 基础机器人
```bash
cp -r examples/basic-bot ~/.openclaw/workspace/skills/
openclaw skills enable basic-bot
```
功能：关键词回复、AI 对话、帮助命令

### 🌤️ 天气查询
```bash
cp -r examples/weather-bot ~/.openclaw/workspace/skills/
openclaw skills enable weather-bot
```
功能：实时天气、3天预报、定时推送

### ⏰ 提醒机器人
```bash
cp -r examples/reminder-bot ~/.openclaw/workspace/skills/
openclaw skills enable reminder-bot
```
功能：一次性提醒、周期性提醒、自动降级

### 🌐 翻译机器人
```bash
cp -r examples/translation-bot ~/.openclaw/workspace/skills/
openclaw skills enable translation-bot
```
功能：多语言翻译、语言检测

### 🔗 多渠道管理
```bash
cp -r examples/multi-channel ~/.openclaw/workspace/skills/
openclaw skills enable multi-channel
```
功能：统一管理、跨渠道广播

### 🤖 AI 助手
```bash
cp -r examples/ai-assistant ~/.openclaw/workspace/skills/
openclaw skills enable ai-assistant
```
功能：智能对话、上下文记忆、人格设定

---

## 🛠️ 常用命令

### Gateway 管理
```bash
openclaw gateway start     # 启动
openclaw gateway stop      # 停止
openclaw gateway restart   # 重启
openclaw gateway status    # 状态
openclaw logs              # 日志
openclaw doctor            # 诊断
```

### 渠道管理
```bash
openclaw channels list           # 渠道列表
openclaw channels login wa      # 登录 WhatsApp
openclaw config get/set          # 配置管理
```

### 消息
```bash
openclaw message send --channel telegram --target @xxx --message "Hi"
```

### 定时任务
```bash
openclaw cron list              # 任务列表
openclaw cron add --name "xxx" --schedule "0 9 * * *" --message "xxx"
openclaw cron remove <jobId>
```

### 会话
```bash
openclaw sessions list          # 会话列表
openclaw sessions history <id> # 历史记录
```

---

## ☁️ 部署方式

| 方式 | 适用场景 | 难度 |
|------|----------|------|
| 直接运行 | 个人/开发 | ⭐ |
| Systemd | VPS/服务器 | ⭐⭐ |
| Docker | 生产环境 | ⭐⭐ |
| Kubernetes | 大规模部署 | ⭐⭐⭐⭐ |

> 📖 详见 [05-部署运维/](docs/05-部署运维/)

---

## 📊 项目结构

```
openclaw-guide/
├── README.md                    # 本文件
├── CHANGELOG.md                 # 更新日志
├── CONTRIBUTING.md              # 贡献指南
├── LICENSE                      # MIT 许可证
├── SECURITY.md                  # 安全指南
│
├── docs/                        # 文档目录
│   ├── 01-快速开始.md
│   ├── 02-配置详解.md
│   ├── 03-渠道接入/             # 5个渠道指南
│   ├── 04-高级功能/             # 5个高级功能
│   ├── 05-部署运维/             # 3个部署方式
│   ├── 06-故障排除.md
│   ├── 07-开发指南.md
│   ├── 08-场景方案.md
│   ├── 09-版本选型.md
│   ├── 10-词汇表.md
│   ├── 11-快速参考.md
│   ├── 12-问题排查.md
│   ├── 13-安全配置.md
│   └── 14-插件开发.md
│
├── examples/                    # 示例项目
│   ├── basic-bot/
│   ├── ai-assistant/
│   ├── weather-bot/
│   ├── reminder-bot/
│   ├── translation-bot/
│   └── multi-channel/
│
├── scripts/                     # 实用脚本
│   ├── install.sh              # 一键安装
│   ├── backup.sh               # 备份脚本
│   ├── health-check.sh         # 健康检查
│   └── monitor.sh              # 监控脚本
│
├── configs/                     # 配置示例
│   ├── production.json
│   ├── development.json
│   └── grafana-dashboard.json
│
├── api/                         # API 文档
│   └── README.md
│
└── .github/                     # GitHub 配置
    ├── workflows/
    └── ISSUE_TEMPLATE/
```

---

## 🤝 贡献

欢迎贡献！请阅读 [CONTRIBUTING.md](CONTRIBUTING.md)。

### 贡献方式

- 📝 完善文档
- 🐛 报告问题
- 💡 提出建议
- 📦 贡献代码
- 📢 推广项目

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE)

---

## 🙏 致谢

- [OpenClaw 官方](https://github.com/openclaw/openclaw) - 核心项目
- [OpenClaw 文档](https://docs.openclaw.ai) - 参考资料
- [社区贡献者](https://github.com/JerryZ01/openclaw-guide/graphs/contributors) - 贡献者

---

## 📞 获取帮助

| 渠道 | 地址 |
|------|------|
| 🐛 问题反馈 | [GitHub Issues](https://github.com/JerryZ01/openclaw-guide/issues) |
| 💬 社区讨论 | [Discord](https://discord.com/invite/clawd) |
| 📖 官方文档 | [docs.openclaw.ai](https://docs.openclaw.ai) |

---

<div align="center">

**⭐ 如果对你有帮助，欢迎 Star！**

🦞 **OpenClaw** - 让 AI 助手触手可及

</div>