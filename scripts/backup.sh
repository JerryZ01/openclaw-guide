#!/bin/bash
# OpenClaw 定时备份脚本

# 配置
BACKUP_DIR="${OPENCLAW_BACKUP_DIR:-$HOME/openclaw-backups}"
DATE=$(date +%Y%m%d-%H%M%S)
RETENTION_DAYS=30

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 检查 root
if [ "$EUID" -eq 0 ]; then
  log_warn "建议不要使用 root 运行此脚本"
fi

# 创建备份目录
mkdir -p "$BACKUP_DIR"

log_info "开始备份 OpenClaw 配置..."

# 1. 备份配置文件
CONFIG_FILE="$HOME/.openclaw/openclaw.json"
if [ -f "$CONFIG_FILE" ]; then
  cp "$CONFIG_FILE" "$BACKUP_DIR/config-$DATE.json"
  log_info "✓ 配置文件已备份"
else
  log_error "✗ 配置文件不存在"
  exit 1
fi

# 2. 备份会话数据
SESSION_DIR="$HOME/.openclaw/sessions"
if [ -d "$SESSION_DIR" ]; then
  tar -czf "$BACKUP_DIR/sessions-$DATE.tar.gz" -C "$HOME/.openclaw" sessions/
  log_info "✓ 会话数据已备份"
else
  log_warn "○ 会话目录不存在，跳过"
fi

# 3. 备份工作空间
WORKSPACE_DIR="$HOME/.openclaw/workspace"
if [ -d "$WORKSPACE_DIR" ]; then
  tar -czf "$BACKUP_DIR/workspace-$DATE.tar.gz" -C "$HOME/.openclaw" workspace/
  log_info "✓ 工作空间已备份"
else
  log_warn "○ 工作空间目录不存在，跳过"
fi

# 4. 备份技能
SKILLS_DIR="$HOME/.openclaw/workspace/skills"
if [ -d "$SKILLS_DIR" ]; then
  tar -czf "$BACKUP_DIR/skills-$DATE.tar.gz" -C "$HOME/.openclaw/workspace" skills/
  log_info "✓ 技能已备份"
else
  log_warn "○ 技能目录不存在，跳过"
fi

# 5. 清理旧备份
log_info "清理 $RETENTION_DAYS 天前的备份..."
find "$BACKUP_DIR" -name "*.json" -mtime +$RETENTION_DAYS -delete 2>/dev/null
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete 2>/dev/null

# 6. 显示备份结果
echo ""
log_info "========== 备份完成 =========="
echo ""
echo "备份位置: $BACKUP_DIR"
echo "备份时间: $DATE"
echo ""
echo "备份文件:"
ls -lh "$BACKUP_DIR" | grep "$DATE" | awk '{print "  " $9 " (" $5 ")"}'
echo ""

# 7. 检查备份大小
TOTAL_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
log_info "总备份大小: $TOTAL_SIZE"

# 8. 验证备份
log_info "验证备份文件..."
for file in "$BACKUP_DIR"/*"$DATE"*; do
  if [ -f "$file" ]; then
    if tar -tzf "$file" > /dev/null 2>&1 || [ "${file: -5}" == ".json" ]; then
      log_info "✓ $(basename $file) 验证通过"
    else
      log_error "✗ $(basename $file) 验证失败"
    fi
  fi
done

# 9. 发送通知（可选）
if command -v curl &> /dev/null; then
  # 可以添加 Telegram/飞书 等通知
  :
fi

echo ""
log_info "备份任务完成！"