#!/bin/bash
# OpenClaw 安装脚本

set -e

echo "🦞 OpenClaw 安装脚本"
echo "======================"

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js 未安装"
    echo "请先安装 Node.js 22+: https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 22 ]; then
    echo "❌ Node.js 版本过低: $(node -v)"
    echo "需要 Node.js 22+"
    exit 1
fi

echo "✓ Node.js 版本: $(node -v)"

# 安装 OpenClaw
echo ""
echo "📦 安装 OpenClaw..."
npm install -g openclaw@latest

# 验证安装
echo ""
echo "✓ 验证安装..."
openclaw --version

# 初始化配置
echo ""
echo "⚙️  初始化配置..."
read -p "是否运行引导配置？(y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    openclaw onboard
fi

# 启动服务
echo ""
echo "🚀 启动 Gateway..."
openclaw gateway start

echo ""
echo "✅ 安装完成！"
echo "控制面板: http://127.0.0.1:16784/"
echo "查看状态: openclaw status"
echo "查看日志: openclaw logs --follow"