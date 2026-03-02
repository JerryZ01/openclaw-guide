# 🌤️ Weather Bot - 天气查询机器人

实时查询天气信息的机器人。

## 功能

- 查询任意城市天气
- 支持多种渠道
- 定时天气推送

## 使用方法

```bash
# 安装依赖
cd examples/weather-bot
npm install axios

# 复制到技能目录
cp -r . ~/.openclaw/workspace/skills/weather-bot

# 启用
openclaw skills enable weather-bot
```

## 代码

```javascript
// index.js
import axios from 'axios';

// 免费天气 API（需要替换为真实 API）
const WEATHER_API = 'https://api.example.com/weather';

export default {
  name: "weather-bot",
  version: "1.0.0",
  description: "天气查询机器人",
  
  rules: [
    {
      // 匹配天气查询
      pattern: /^天气\s*(.+)?/,
      handler: async (match) => {
        const city = match[1] || '上海';
        return await this.getWeather(city);
      }
    },
    {
      pattern: /(.*)天气/,
      handler: async (match) => {
        const city = match[1];
        return await this.getWeather(city);
      }
    }
  ],
  
  async getWeather(city) {
    try {
      // 实际使用时替换为真实 API
      // const res = await axios.get(`${WEATHER_API}?city=${encodeURIComponent(city)}`);
      
      // 模拟返回
      const weather = {
        city: city,
        temp: Math.floor(Math.random() * 20) + 10,
        condition: ['晴', '多云', '阴', '小雨'][Math.floor(Math.random() * 4)],
        humidity: Math.floor(Math.random() * 40) + 40,
        wind: Math.floor(Math.random() * 10) + 5
      };
      
      return `🌤️ ${city}天气

温度：${weather.temp}°C
天气：${weather.condition}
湿度：${weather.humidity}%
风速：${weather.wind}km/h

${this.getSuggestion(weather.condition)}`;
    } catch (error) {
      return `查询天气失败，请稍后重试`;
    }
  },
  
  getSuggestion(condition) {
    const suggestions = {
      '晴': '☀️ 天气很好，适合外出',
      '多云': '⛅ 天气不错，记得防晒',
      '阴': '☁️ 天气阴沉，注意心情',
      '小雨': '🌧️ 带好雨伞'
    };
    return suggestions[condition] || '';
  }
}
```

## 配置

```json
{
  "enabled": true,
  "settings": {
    "defaultCity": "上海",
    "apiKey": "your-api-key",
    "units": "metric"
  }
}
```

## 定时推送

```javascript
// 定时天气推送
export default {
  name: "weather-bot",
  schedule: "0 7 * * *", // 每天早上7点
  
  async onScheduled() {
    const cities = ['北京', '上海', '广州', '深圳'];
    
    for (const city of cities) {
      const weather = await this.getWeather(city);
      await this.sendMessage({
        channel: "telegram",
        target: "weather-channel",
        message: weather
      });
    }
  }
}
```

## API 推荐

- [OpenWeatherMap](https://openweathermap.org/) - 免费版足够个人使用
- [和风天气](https://dev.qweather.com/) - 国内首选
- [心知天气](https://www.seniverse.com/) - 免费版可用