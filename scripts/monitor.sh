#!/bin/bash
# OpenClaw 监控脚本 - 检查系统健康状态

# 配置
CHECK_INTERVAL=60  # 检查间隔（秒）
ALERT_THRESHOLD=3 # 连续失败次数阈值
NOTIFY_WEBHOOK=""  # 告警 Webhook（可选）

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 计数
ERROR_COUNT=0

log_info() { echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] [INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] [WARN]${NC} $1"; }
log_error() { echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR]${NC} $1"; }

# 发送告警
send_alert() {
  local message="$1"
  log_error "发送告警: $message"
  
  # Telegram 告警
  if [ -n "$TELEGRAM_BOT_TOKEN" ] && [ -n "$TELEGRAM_CHAT_ID" ]; then
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
      -d "chat_id=$TELEGRAM_CHAT_ID" \
      -d "text=🚨 OpenClaw 告警: $message" \
      > /dev/null 2>&1
  fi
  
  # 飞书告警
  if [ -n "$FEISHU_WEBHOOK" ]; then
    curl -s -X POST "$FEISHU_WEBHOOK" \
      -H "Content-Type: application/json" \
      -d "{\"msg_type\":\"text\",\"content\":{\"text\":\"🚨 OpenClaw 告警: $message\"}}" \
      > /dev/null 2>&1
  fi
}

# 检查 Gateway 进程
check_gateway_process() {
  if pgrep -f "openclaw gateway" > /dev/null; then
    log_info "✓ Gateway 进程运行中"
    return 0
  else
    log_error "✗ Gateway 进程未运行"
    return 1
  fi
}

# 检查端口
check_gateway_port() {
  if nc -z 127.0.0.1 16784 2>/dev/null; then
    log_info "✓ Gateway 端口 16784 正常"
    return 0
  else
    log_error "✗ Gateway 端口 16784 无法访问"
    return 1
  fi
}

# 检查健康端点
check_health() {
  local response=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:16784/health 2>/dev/null)
  
  if [ "$response" = "200" ]; then
    log_info "✓ Health 检查通过"
    return 0
  else
    log_error "✗ Health 检查失败 (HTTP $response)"
    return 1
  fi
}

# 检查日志错误
check_log_errors() {
  local log_file="/tmp/openclaw/openclaw-$(date +%Y-%m-%d).log"
  
  if [ -f "$log_file" ]; then
    local error_count=$(grep -c "error" "$log_file" 2>/dev/null || echo "0")
    local warn_count=$(grep -c "warn" "$log_file" 2>/dev/null || echo "0")
    
    log_info "日志: $error_count 错误, $warn_count 警告"
    
    if [ "$error_count" -gt 100 ]; then
      log_warn "⚠️ 错误日志过多"
    fi
  fi
}

# 检查磁盘空间
check_disk() {
  local usage=$(df ~ | tail -1 | awk '{print $5}' | sed 's/%//')
  
  if [ "$usage" -lt 80 ]; then
    log_info "✓ 磁盘使用率: ${usage}%"
    return 0
  elif [ "$usage" -lt 90 ]; then
    log_warn "⚠️ 磁盘使用率: ${usage}%"
    return 0
  else
    log_error "✗ 磁盘使用率: ${usage}% (过高)"
    return 1
  fi
}

# 检查内存
check_memory() {
  local available=$(free -m | awk 'NR==2{print $7}')
  
  if [ "$available" -gt 500 ]; then
    log_info "✓ 可用内存: ${available}MB"
    return 0
  else
    log_warn "⚠️ 可用内存: ${available}MB (不足)"
    return 1
  fi
}

# 检查渠道状态
check_channels() {
  local status=$(openclaw status 2>/dev/null)
  
  if echo "$status" | grep -q "connected"; then
    log_info "✓ 渠道状态正常"
    return 0
  else
    log_warn "⚠️ 渠道状态异常"
    return 1
  fi
}

# 主检查函数
run_check() {
  local failed=0
  
  ((ERROR_COUNT++)) || true
  
  # 基础检查
  check_gateway_process || ((failed++)) || true
  check_gateway_port || ((failed++)) || true
  check_health || ((failed++)) || true
  
  # 系统检查
  check_disk || ((failed++)) || true
  check_memory || ((failed++)) || true
  
  # 日志
  check_log_errors
  
  # 渠道
  check_channels
  
  return $failed
}

# 连续检查
continuous_check() {
  log_info "开始连续监控..."
  
  while true; do
    if run_check; then
      ERROR_COUNT=0
      log_info "========== 检查通过 =========="
    else
      log_error "========== 检查失败 =========="
      
      if [ "$ERROR_COUNT" -ge "$ALERT_THRESHOLD" ]; then
        send_alert "OpenClaw 连续 $ERROR_COUNT 次检查失败"
        ERROR_COUNT=0
      fi
    fi
    
    sleep "$CHECK_INTERVAL"
  done
}

# 单次检查
single_check() {
  log_info "执行单次检查..."
  
  if run_check; then
    log_info "✓ 所有检查通过"
    exit 0
  else
    log_error "✗ 部分检查失败"
    exit 1
  fi
}

# 主程序
case "${1:-single}" in
  continuous)
    continuous_check
    ;;
  single|*)
    single_check
    ;;
esac