# 🐳 Docker 部署指南

## 拉取镜像

```bash
# 官方镜像
docker pull openclaw/openclaw:latest

# 或使用阿里云镜像
docker pull registry.cn-hangzhou.aliyuncs.com/openclaw/openclaw:latest
```

## 快速启动

```bash
# 创建数据目录
mkdir -p ~/.openclaw

# 启动容器
docker run -d \
  --name openclaw \
  -p 16784:16784 \
  -v ~/.openclaw:/home/admin/.openclaw \
  -e OPENCLAW_PORT=16784 \
  openclaw/openclaw:latest
```

## 使用 Docker Compose

### 1. 创建 docker-compose.yml

```yaml
version: '3.8'

services:
  openclaw:
    image: openclaw/openclaw:latest
    container_name: openclaw
    ports:
      - "16784:16784"
    volumes:
      - ./openclaw-data:/home/admin/.openclaw
    environment:
      - OPENCLAW_PORT=16784
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "-q", "--spider", "http://localhost:16784/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### 2. 启动服务

```bash
# 启动
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止
docker-compose down
```

## 高级配置

### 使用自定义配置

```bash
# 挂载配置文件
docker run -d \
  --name openclaw \
  -p 16784:16784 \
  -v ./openclaw.json:/home/admin/.openclaw/openclaw.json:ro \
  -v ./workspace:/home/admin/.openclaw/workspace \
  openclaw/openclaw:latest
```

### 多渠道配置

```yaml
version: '3.8'

services:
  openclaw:
    image: openclaw/openclaw:latest
    container_name: openclaw
    ports:
      - "16784:16784"
    volumes:
      - ./openclaw-data:/home/admin/.openclaw
    environment:
      - OPENCLAW_PORT=16784
      - TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
      - FEISHU_APP_ID=${FEISHU_APP_ID}
      - FEISHU_APP_SECRET=${FEISHU_APP_SECRET}
    env_file:
      - .env
    restart: unless-stopped
```

### 数据持久化

```yaml
volumes:
  - ./openclaw-data/.openclaw:/home/admin/.openclaw
  - ./openclaw-data/sessions:/home/admin/.openclaw/sessions
  - ./openclaw-data/workspace:/home/admin/.openclaw/workspace
```

## GPU 加速

```bash
# NVIDIA GPU 支持
docker run -d \
  --name openclaw \
  --gpus all \
  -p 16784:16784 \
  openclaw/openclaw:latest
```

## 网络配置

### 使用自定义网络

```bash
# 创建网络
docker network create openclaw-net

# 运行容器
docker run -d \
  --name openclaw \
  --network openclaw-net \
  -p 16784:16784 \
  openclaw/openclaw:latest
```

### 代理配置

```bash
docker run -d \
  --name openclaw \
  -p 16784:16784 \
  -e HTTP_PROXY=http://proxy:8080 \
  -e HTTPS_PROXY=http://proxy:8080 \
  openclaw/openclaw:latest
```

## 常用操作

### 查看状态

```bash
docker ps
docker logs openclaw
```

### 进入容器调试

```bash
docker exec -it openclaw sh
```

### 更新版本

```bash
docker-compose pull
docker-compose up -d
```

### 备份数据

```bash
docker run --rm -v openclaw_openclaw-data:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz /data
```

### 恢复数据

```bash
docker run --rm -v openclaw_openclaw-data:/data -v $(pwd):/backup alpine tar xzf /backup/backup.tar.gz -C /
```

## 安全建议

### 运行非 root 用户

```yaml
services:
  openclaw:
    image: openclaw/openclaw:latest
    user: "1000:1000"
    volumes:
      - ./data:/home/admin/.openclaw
```

### 限制资源

```yaml
services:
  openclaw:
    image: openclaw/openclaw:latest
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '0.5'
          memory: 512M
```

### 启用日志轮转

```yaml
services:
  openclaw:
    image: openclaw/openclaw:latest
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## 故障排查

### 容器无法启动

```bash
# 查看详细日志
docker logs openclaw

# 检查端口占用
netstat -tlnp | grep 16784
```

### 权限问题

```bash
# 修复权限
docker exec -it openclaw chown -R admin:admin /home/admin/.openclaw
```

### 网络问题

```bash
# 检查网络
docker network ls
docker network inspect openclaw-net
```

## 生产环境示例

完整的 docker-compose.yml：

```yaml
version: '3.8'

services:
  openclaw:
    image: openclaw/openclaw:latest
    container_name: openclaw
    ports:
      - "16784:16784"
    volumes:
      - ./data:/home/admin/.openclaw
    environment:
      - OPENCLAW_PORT=16784
      - TZ=Asia/Shanghai
    env_file:
      - .env
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "-q", "--spider", "http://localhost:16784/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G

  # 可选：反向代理
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - openclaw
```

## 相关链接

- [Docker 官方文档](https://docs.docker.com/)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)