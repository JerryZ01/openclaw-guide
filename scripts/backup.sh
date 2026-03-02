#!/bin/bash
# OpenClaw 备份脚本

set -e

BACKUP_DIR="${OPENCLAW_BACKUP_DIR:-$HOME/openclaw-backups}"
DATE=$(date +%Y%m%d-%H%M%S)

echo "📦 OpenClaw 备份"
echo "=============="

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 备份配置
echo "备份配置文件..."
cp ~/.openclaw/openclaw.json "$BACKUP_DIR/config-$DATE.json"

# 备份会话（如需要）
if [ -d ~/.openclaw/sessions ]; then
    echo "备份会话数据..."
    tar -czf "$BACKUP_DIR/sessions-$DATE.tar.gz" ~/.openclaw/sessions/
fi

# 备份技能（如有）
if [ -d ~/.openclaw/workspace/skills ]; then
    echo "备份技能..."
    tar -czf "$BACKUP_DIR/skills-$DATE.tar.gz" ~/.openclaw/workspace/skills/
fi

# 清理旧备份（保留 7 天）
echo "清理旧备份..."
find "$BACKUP_DIR" -name "*.json" -mtime +7 -delete
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete

echo ""
echo "✅ 备份完成: $BACKUP_DIR"
echo "备份文件:"
ls -lh "$BACKUP_DIR" | tail -5