# 分布式缓存

分布式缓存（Distributed Cache）是一种跨多个节点存储数据的缓存机制，Spire 内置的现代化、高性能的分布式缓存框架，提供统一的缓存接口，支持多种过期策略、自动清理机制和灵活的配置选项。该框架基于分布式架构设计，能够有效应对高并发访问场景，通过数据在多个节点间的分布存储与同步，提升系统响应速度与可用性，同时具备良好的扩展性与容错能力，便于开发者高效管理和优化缓存资源。

## 快速开始

只需 3 步即可使用分布式缓存：

```cangjie{4,7,11}
import spire_extensions_caching.*
import spire_extensions_options.*

// 1. 创建缓存实例
let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))

// 2. 设置与获取缓存
cache.setString("user:1", "Spire") 		// 存储字符串
let user = cache.getString("user:1")	// 获取字符串

// 3. 删除缓存项
cache.remove("user:1")
```

## 过期策略

```cangjie
public class DistributedCacheEntryOptions {
    public var slidingExpiration: ?Duration           // 滑动过期
    public var absoluteExpiration: ?DateTime          // 绝对过期
    public var absoluteExpirationRelativeToNow: ?Duration  // 相对过期
}
```

| 策略类型   | 说明                   | 典型场景         |
|------------|------------------------|------------------|
| 滑动过期   | 每次访问重置计时器     | 会话、Token      |
| 绝对过期   | 固定时间点过期         | 临时验证码       |
| 相对过期   | 从设置时刻起计时过期   | 缓存数据         |


## 缓存系统配置

### 1. 基础配置

```cangjie
let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
```

### 2. 自定义清理频率

```cangjie
let options = DistributedCacheOptions(expirationScanFrequency: Duration.minute * 10)
let cache = MemoryDistributedCache(Options.create(options))
```

### 3. 过期策略配置

验证码缓存场景将会涉及到相对过期策略的利用

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

> [!TIP]
> 可组合多种过期策略，最先满足者生效。

```cangjie
// 同时设置滑动与绝对过期，最先满足者生效
cache.setString("multi:expire", "data", 
    DistributedCacheEntryOptions(
        slidingExpiration: Duration.minute * 10,
        absoluteExpiration: DateTime.now().addMinutes(30)
    )
)
```

而涉及到用户会话等场景会使用滑动过期策略：
```cangjie
class SessionManager {
    private let _cache: IDistributedCache

    init(cache: IDistributedCache) {
        _cache = cache
    }

    func setSession(userId: String, data: String) {
        _cache.setString("session:${userId}", data, 
            DistributedCacheEntryOptions(slidingExpiration: Duration.minute * 30))//[!code focus]
    }

    func getSession(userId: String): ?String {
        return _cache.getString("session:${userId}")
    }

    func removeSession(userId: String) {
        _cache.remove("session:${userId}")
    }
}
```
手动刷新缓存项：
```cangjie
// 仅对滑动过期有效
cache.refresh("session:1")
```

## 实际应用示例

### 3. 配置缓存

```cangjie
cache.setString("config:homepage", "{...}")
let config = cache.getString("config:homepage")
```

## 最佳实践

- **合理设置过期时间**：会话用滑动过期，验证码用相对过期
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

