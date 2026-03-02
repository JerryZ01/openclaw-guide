# 🦞 OpenClaw 实战指南

<div align="center">

[![OpenClaw Version](https://img.shields.io/badge/OpenClaw-2026.2.9-blue)](https://github.com/openclaw/openclaw)
[![Node Version](https://img.shields.io/badge/Node-22+-green)](https://nodejs.org)
[![License](https://img.shields.io/badge/License-MIT-orange)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/JerryZ01/openclaw-guide)](https://github.com/JerryZ01/openclaw-guide/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/JerryZ01/openclaw-guide)](https://github.com/JerryZ01/openclaw-guide/network)
[![CI Status](https://github.com/JerryZ01/openclaw-guide/actions/workflows/ci.yml/badge.svg)](https://github.com/JerryZ01/openclaw-guide/actions)
[![Last Commit](https://img.shields.io/github/last-commit/JerryZ01/openclaw-guide)](https://github.com/JerryZ01/openclaw-guide/commits/main)

> 企业级 AI Agent 网关、多渠道消息管理实战手册

[English](./README.md) | [中文](./README.md)

</div>

## ⭐ 项目简介

本项目提供 OpenClaw 的完整实战指南，从安装配置到高级应用，帮助你快速搭建企业级 AI 助手。

### 🌟 特性

- 📚 **完整教程**：覆盖所有主流渠道（WhatsApp、Telegram、Discord、飞书、企业微信等）
- 🚀 **快速开始**：5 分钟内完成基础配置
- 💡 **最佳实践**：生产环境配置推荐
- 🛠️ **实用脚本**：开箱即用的自动化脚本
- 🔧 **故障排除**：常见问题解决方案
- 🤖 **示例项目**：可直接使用的机器人示例
- 📖 **API 参考**：完整的接口文档

## 📑 目录

```
openclaw-guide/
├── docs/                          # 文档目录
│   ├── 01-快速开始.md             # 5分钟入门
│   ├── 02-配置详解.md              # 完整配置参考
│   ├── 03-渠道接入/               # 各渠道接入指南
│   │   ├── WhatsApp.md
│   │   ├── Telegram.md
│   │   ├── Discord.md
│   │   ├── 飞书.md
│   │   └── 企业微信.md
│   ├── 04-高级功能/               # 高级功能
│   │   ├── 多代理路由.md
│   │   ├── 定时任务.md
│   │   ├── 技能开发.md
│   │   └── 记忆系统.md
│   ├── 05-部署运维/               # 部署运维
│   │   ├── Docker部署.md
│   │   ├── 系统服务.md
│   │   └── 监控告警.md
│   └── 06-故障排除.md             # 问题解决
├── examples/                       # 示例项目
│   ├── basic-bot/                 # 基础机器人
│   ├── ai-assistant/              # AI 助手
│   ├── weather-bot/               # 天气查询
│   ├── reminder-bot/              # 提醒机器人
│   ├── translation-bot/           # 翻译机器人
│   └── multi-channel/             # 多渠道管理
├── scripts/                       # 实用脚本
│   ├── install.sh                 # 一键安装
│   ├── backup.sh                  # 备份脚本
│   └── health-check.sh           # 健康检查
├── configs/                       # 配置示例
│   ├── production.json            # 生产环境
│   └── development.json           # 开发环境
├── api/                           # API 文档
│   └── README.md                  # API 参考
├── .github/                       # GitHub 配置
│   ├── workflows/                 # CI/CD
│   └── ISSUE_TEMPLATE/            # Issue 模板
├── CONTRIBUTING.md                # 贡献指南
├── CHANGELOG.md                   # 更新日志
├── SECURITY.md                    # 安全指南
└── README.md                      # 本文件
```

## 🚀 快速开始

### 1. 安装 OpenClaw

```bash
# 安装 CLI
npm install -g openclaw@latest

# 验证安装
openclaw --version
```

### 2. 初始化配置

```bash
# 启动引导
openclaw onboard
```

### 3. 启动 Gateway

```bash
# 启动服务
openclaw gateway --port 16784
```

### 4. 接入渠道

```bash
# WhatsApp 登录
openclaw channels login whatsapp

# Telegram Bot
openclaw channels login telegram
```

详细步骤请查看 [快速开始指南](docs/01-快速开始.md)

## 📱 支持的渠道

| 渠道 | 状态 | 说明 |
|------|------|------|
| WhatsApp | ✅ | 支持 Web & Business API |
| Telegram | ✅ | Bot API |
| Discord | ✅ | Bot + Webhook |
| 飞书 | ✅ | 机器人 + 文档 API |
| 企业微信 | ✅ | 企业微信应用 |
| Slack | ✅ | Bot |

## 🛠️ 常用命令

```bash
# Gateway 管理
openclaw gateway start/stop/restart/status
openclaw logs
openclaw doctor

# 渠道管理
openclaw channels list
openclaw channels login whatsapp

# 消息发送
openclaw message send --channel telegram --target @xxx --message "Hi"

# 配置
openclaw config get/set

# 会话管理
openclaw sessions list
```

## 🤖 示例项目

### 基础机器人

```bash
# 复制示例
cp -r examples/basic-bot ~/.openclaw/workspace/skills/
# 启用
openclaw skills enable basic-bot
```

### 天气查询

```bash
# 复制示例
cp -r examples/weather-bot ~/.openclaw/workspace/skills/
# 配置 API（可选）
# 使用内置模拟数据
```

### 提醒机器人

```bash
# 使用定时任务功能
# 见 docs/04-高级功能/定时任务.md
```

更多示例见 [examples](examples/) 目录

## 📖 文档导航

| 分类 | 内容 |
|------|------|
| 入门 | [快速开始](docs/01-快速开始.md) · [配置详解](docs/02-配置详解.md) |
| 渠道 | [WhatsApp](docs/03-渠道接入/WhatsApp.md) · [Telegram](docs/03-渠道接入/Telegram.md) · [飞书](docs/03-渠道接入/飞书.md) |
| 进阶 | [定时任务](docs/04-高级功能/定时任务.md) · [技能开发](docs/04-高级功能/技能开发.md) |
| 部署 | [Docker](docs/05-部署运维/Docker部署.md) · [系统服务](docs/05-部署运维/系统服务.md) |
| 参考 | [API](api/README.md) · [故障排除](docs/06-故障排除.md) |

## 🤝 贡献

欢迎贡献！请阅读 [贡献指南](CONTRIBUTING.md)。

## 📄 许可证

MIT License - 查看 [LICENSE](LICENSE) 了解详情。

## 🙏 致谢

- [OpenClaw](https://github.com/openclaw/openclaw) - 项目核心
- 贡献者们

---

<div align="center">

**⭐ 如果对你有帮助，欢迎 Star！**

🦞 OpenClaw - 让 AI 助手触手可及

</div>