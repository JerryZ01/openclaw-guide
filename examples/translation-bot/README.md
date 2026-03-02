# 🌐 Translation Bot - 翻译机器人

多语言翻译支持。

## 功能

- 多语言翻译
- 语言自动检测
- 快捷翻译命令

## 使用方法

```bash
# 安装依赖
cd examples/translation-bot
npm install axios

# 复制并启用
cp -r . ~/.openclaw/workspace/skills/translation-bot
openclaw skills enable translation-bot
```

## 代码

```javascript
// index.js
import axios from 'axios';

// 支持的语言
const LANGUAGES = {
  'en': '英语',
  'zh': '中文',
  'ja': '日语',
  'ko': '韩语',
  'fr': '法语',
  'de': '德语',
  'es': '西班牙语',
  'ru': '俄语',
  'ar': '阿拉伯语',
  'it': '意大利语'
};

export default {
  name: "translation-bot",
  version: "1.0.0",
  description: "多语言翻译机器人",
  
  rules: [
    // 翻译命令
    {
      pattern: /^翻译\s*(.+?)\s*(到|into)?\s*(\w+)?/,
      handler: async (match) => {
        const [_, text, , targetLang] = match;
        return await this.translate(text.trim(), targetLang || 'en');
      }
    },
    // 快捷翻译
    {
      pattern: /^(\w+):\s*(.+)/,
      handler: async (match) => {
        const [_, lang, text] = match;
        if (LANGUAGES[lang]) {
          return await this.translate(text.trim(), lang);
        }
        return null; // 不匹配
      }
    },
    // 语言代码查询
    {
      pattern: /^语言代码|^支持的语言/,
      handler: async () => {
        return this.listLanguages();
      }
    }
  ],
  
  async translate(text, targetLang) {
    // 验证语言
    if (!LANGUAGES[targetLang]) {
      return `不支持的语言: ${targetLang}\n\n${this.listLanguages()}`;
    }
    
    try {
      // 这里使用免费翻译 API（需要自行配置）
      // const res = await axios.post('https://api.mymemory.translated.net/get', {
      //   q: text,
      //   langpair: `|${targetLang}`
      // });
      // const result = res.data.responseData.translatedText;
      
      // 模拟返回
      const result = `[${LANGUAGES[targetLang]}] ${text}`;
      
      return `🌐 翻译结果（${LANGUAGES[targetLang]}）：

${result}

原文：${text}`;
    } catch (error) {
      return "翻译失败，请稍后重试";
    }
  },
  
  listLanguages() {
    let list = "🌍 支持的语言：\n\n";
    for (const [code, name] of Object.entries(LANGUAGES)) {
      list += `• ${code} - ${name}\n`;
    }
    list += "\n📝 用法：翻译 [内容] 到 [语言代码]";
    list += "\n例如：翻译 Hello 到 zh";
    return list;
  }
}
```

## 使用示例

```
用户：翻译 Hello 到 zh
小二：🌐 翻译结果（中文）：

[中文] Hello

原文：Hello

用户：en: Good morning
小二：🌐 翻译结果（英语）：

[英语] Good morning

原文： Good morning

用户：语言代码
小二：🌍 支持的语言：

• en - 英语
• zh - 中文
• ja - 日语
...
```

## 推荐翻译 API

| API | 免费额度 | 说明 |
|-----|----------|------|
| MyMemory | 1000字/天 | 无需注册 |
| Google Translate | 付费 | 效果好 |
| DeepL | 50万字符/月 | 质量高 |
| 百度翻译 | 字符免费 | 国内首选 |
| 有道翻译 | 100万字/月 | 免费稳定 |

## 配置

```json
{
  "enabled": true,
  "settings": {
    "defaultTargetLang": "zh",
    "api": "mymemory",
    "apiKey": ""
  }
}
```