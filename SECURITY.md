# 🔐 安全指南

本项目安全相关说明和处理流程。

## 报告安全漏洞

如果你发现安全漏洞，请发送邮件至 security@openclaw.ai，不要在 GitHub Issue 中公开。

## 安全最佳实践

### 1. API Key 管理

```bash
# 使用环境变量
export ANTHROPIC_API_KEY="sk-..."

# 不要提交到 Git
echo "*.env" >> .gitignore
```

### 2. 配置文件

```json
{
  "gateway": {
    "auth": {
      "token": "使用强随机字符串"
    }
  }
}
```

### 3. 网络安全

- 生产环境使用 HTTPS
- 限制端口访问
- 使用防火墙

### 4. 定期更新

```bash
# 更新 OpenClaw
openclaw update check
openclaw update run
```

## 依赖安全

```bash
# 检查依赖漏洞
npm audit

# 更新依赖
npm update
```

## 数据安全

### 敏感数据

- 用户密码
- API Keys
- Token
- 个人隐私信息

### 存储建议

```javascript
// 加密存储敏感信息
import crypto from 'crypto';

function encrypt(text, key) {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);
  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  return iv.toString('hex') + ':' + encrypted;
}
```

## 事件响应

发现安全事件时：

1. **立即响应** - 隔离受影响系统
2. **评估影响** - 确定泄露范围
3. **通知** - 告知相关用户
4. **修复** - 修复漏洞
5. **复盘** - 改进安全措施

## 合规

- GDPR 合规
- 数据本地化
- 隐私政策

---

如有问题，请联系 security@openclaw.ai