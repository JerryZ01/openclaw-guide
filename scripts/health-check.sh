#!/bin/bash
# OpenClaw 健康检查脚本

set -e

echo "🏥 OpenClaw 健康检查"
echo "===================="
ERRORS=0

# 检查 Gateway 进程
echo -n "Gateway 进程: "
if pgrep -f "openclaw gateway" > /dev/null; then
    echo "✓ 运行中"
else
    echo "✗ 未运行"
    ERRORS=$((ERRORS + 1))
fi

# 检查端口
echo -n "Gateway 端口 (16784): "
if lsof -i :16784 > /dev/null 2>&1; then
    echo "✓ 正常"
else
    echo "✗ 未监听"
    ERRORS=$((ERRORS + 1))
fi

# 检查日志
echo -n "日志文件: "
if [ -f /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log ]; then
    echo "✓ 存在"
else
    echo "✗ 不存在"
    ERRORS=$((ERRORS + 1))
fi

# 检查配置
echo -n "配置文件: "
if [ -f ~/.openclaw/openclaw.json ]; then
    echo "✓ 存在"
else
    echo "✗ 不存在"
    ERRORS=$((ERRORS + 1))
fi

# 检查磁盘空间
echo -n "磁盘空间: "
DISK_USAGE=$(df -h ~ | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -lt 90 ]; then
    echo "✓ ${DISK_USAGE}%"
else
    echo "⚠️ ${DISK_USAGE}% (建议清理)"
fi

# 检查内存
echo -n "可用内存: "
MEM_AVAILABLE=$(free -m | awk 'NR==2{print $7}')
if [ "$MEM_AVAILABLE" -gt 500 ]; then
    echo "✓ ${MEM_AVAILABLE}MB"
else
    echo "⚠️ ${MEM_AVAILABLE}MB (可能不足)"
fi

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "✅ 健康检查通过"
    exit 0
else
    echo "❌ 发现 $ERRORS 个问题"
    exit 1
fi