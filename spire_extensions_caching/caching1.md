# 分布式缓存

分布式缓存（Distributed Cache）是一种跨多个节点存储数据的缓存机制，Spire 内置的现代化、高性能的分布式缓存框架，提供统一的缓存接口，支持多种过期策略、自动清理机制和灵活的配置选项。该框架基于分布式架构设计，能够有效应对高并发访问场景，通过数据在多个节点间的分布存储与同步，提升系统响应速度与可用性，同时具备良好的扩展性与容错能力，便于开发者高效管理和优化缓存资源。

## 设计理念

**核心优势：**

- **统一接口**：所有缓存操作使用相同 API
- **多种过期策略**：滑动、绝对、相对过期灵活组合
- **自动清理**：后台定时清理过期项，保障内存健康
- **高性能**：基于内存，毫秒级响应，线程安全
- **类型安全**：支持字节数组与字符串缓存
- **易扩展**：插件化架构，便于集成与自定义

## 快速开始

只需 3 步即可使用分布式缓存：

```cangjie{4,7,11}
import spire_extensions_caching.*
import spire_extensions_options.*

// 1. 创建缓存实例
let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))

// 2. 设置与获取缓存（如会话、验证码、配置等）
cache.setString("user:1", "Spire")        // 存储字符串
let user = cache.getString("user:1")       // 获取字符串
cache.setString("sms:code:13800138000", "123456") // 存储验证码
cache.setString("config:homepage", "{...}")       // 存储配置信息

// 3. 删除缓存项
cache.remove("user:1")
```

### 2. 验证码缓存场景（绝对/相对过期）

```cangjie
import spire_extensions_caching.*
import spire_extensions_options.*

let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))

// 发送短信验证码，设置 3 分钟绝对过期
cache.setString("sms:code:13800138000", "123456", 
    DistributedCacheEntryOptions(absoluteExpirationRelativeToNow: Duration.minute * 3))

// 用户提交验证码时获取
let code = cache.getString("sms:code:13800138000")

// 验证成功后删除验证码
cache.remove("sms:code:13800138000")
```

### 3. 配置缓存场景（长期有效）

```cangjie
import spire_extensions_caching.*
import spire_extensions_options.*

let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))

// 缓存配置信息（无过期，长期有效）
cache.setString("config:homepage", "{...}")

// 读取配置信息
let config = cache.getString("config:homepage")

// 配置变更时可直接覆盖
cache.setString("config:homepage", "{...新内容...}")
```

## 配置与依赖注入

```cangjie
import spire_extensions_injection.*
import spire_extensions_caching.*

let services = ServiceCollection()
services.addDistributedMemoryCache { options =>
    options.expirationScanFrequency = Duration.second * 30
}
let cache = services.buildServiceProvider().getService<IDistributedCache>()
```

## 过期策略说明

| 策略类型   | 说明                   | 典型场景         |
|------------|------------------------|------------------|
| 滑动过期   | 每次访问重置计时器     | 会话、Token      |
| 绝对过期   | 固定时间点过期         | 验证码           |
| 相对过期   | 从设置时刻起计时过期   | 临时数据         |

可组合多种过期策略，最先满足者生效。

## 异常与错误处理

```cangjie
let value = cache.getString("not_exist")
match (value) {
    case Some(v) => { /* 正常处理 */ }
    case None => { /* 缓存未命中，需降级处理 */ }
}
```
- 非法 key（空字符串、特殊字符）将抛出异常
- 设置过期策略时参数不合法会报错

## 最佳实践

- **合理设置过期时间**：会话用滑动过期，验证码用绝对过期
- **监控内存使用**：定期检查缓存项数量，防止溢出
- **依赖注入集成**：推荐通过 DI 管理缓存实例
- **错误处理**：注意 `get`/`getString` 可能返回 `None`
- **清理频率调整**：根据业务需求调整 `expirationScanFrequency`

## 注意事项

- **线程安全**：所有操作均为线程安全
- **内存限制**：大数据量场景需关注内存占用
- **过期策略组合**：可同时设置多种过期条件，最先满足者生效
- **refresh 仅重置滑动过期**，不影响绝对过期
- **删除/过期项自动清理**，无需手动干预

## 总结

Spire 缓存系统为企业级应用提供高效、灵活、易用的分布式缓存解决方案：

- **易于使用**：简单 API 和直观配置
- **功能强大**：多种过期策略与自动清理
- **高性能**：线程安全、内存优化
- **易扩展**：支持自定义实现与集成
- **生产就绪**：高并发、低延迟、易维护

通过本指南的最佳实践，您可为应用构建高效、可靠的缓存体系，提升系统性能与可维护性。

---