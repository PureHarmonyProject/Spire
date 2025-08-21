# 分布式缓存

分布式缓存（Distributed Cache）是一种跨多个节点存储数据的缓存机制，Spire 内置的现代化、高性能的分布式缓存框架，提供统一的缓存接口，支持多种过期策略、自动清理机制和灵活的配置选项。该框架基于分布式架构设计，能够有效应对高并发访问场景，通过数据在多个节点间的分布存储与同步，提升系统响应速度与可用性，同时具备良好的扩展性与容错能力，便于开发者高效管理和优化缓存资源。

## 快速启动

只需 4 步即可使用分布式缓存：

```cangjie
import spire_extensions_caching.*
import spire_extensions_options.*

// 1. 创建缓存实例 //[!code highlight]
let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions())) 

// 2. 设置缓存项 //[!code highlight]
cache.setString("access_token", "fkgyzj&2j&62jlg==")

// 3. 获取缓存项 //[!code highlight]
let access_token = cache.getString("access_token")	

// 4. 删除缓存项 //[!code highlight]
cache.remove("access_token")
```

::: tip 核心步骤
调用 `cache.setString("access_token", "fkgyzj&2j&62jlg==")` 方法，将 access_token 及其值写入缓存，实现数据的快速存取。
:::


## 过期策略配置
三种不同过期策略选项
| 策略类型                                                     | 说明                 | 典型场景    |
| ------------------------------------------------------------ | -------------------- | ----------- |
| slidingExpiration                                         滑动过期 | 每次访问重置计时器   | 会话、Token |
| absoluteExpiration                                     绝对过期 | 固定时间点过期       | 临时验证码  |
| absoluteExpirationRelativeToNow          相对过期            | 从设置时刻起计时过期 | 缓存数据    |

### 绝对过期与相对过期策略：

适用于验证码派发场景

```cangjie
import std.time.*
import spire_extensions_options.Options

main() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    // 绝对过期时间点：10秒后
    let absTime = DateTime.now() + Duration.second * 10
    // 相对过期：5秒后
    cache.setString("access_token", "fkgyzj&2j&62jlg==", DistributedCacheEntryOptions(
        absoluteExpiration: absTime,
        absoluteExpirationRelativeToNow: Duration.second * 5
    ))

    println("初次写入：access_token -> fkgyzj&2j&62jlg==")
    sleep(Duration.second * 3)
    println("3秒后访问：access_token = " + (cache.getString("access_token") ?? "None"))

    sleep(Duration.second * 3)
    println("再等3秒访问：access_token = " + (cache.getString("access_token") ?? "None"))
}
```
```bash
初次写入：access_token -> fkgyzj&2j&62jlg==
3秒后访问：access_token = fkgyzj&2j&62jlg==
再等3秒访问：access_token = None
```
> [!TIP] 组合策略
> 使用混合策略时，满足其中一个过期策略即为过期

### 滑动过期策略：

适用于会话场景
```cangjie
import std.time.*
import spire_extensions_options.Options

main() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    cache.setString("access_token", "fkgyzj&2j&62jlg==", DistributedCacheEntryOptions(slidingExpiration: Duration.second * 5))

    println("初次写入：access_token -> fkgyzj&2j&62jlg==")
    sleep(Duration.second * 3)
    println("3秒后访问：access_token = " + (cache.getString("access_token") ?? "None"))

    sleep(Duration.second * 4)
    println("再等4秒访问：access_token = " + (cache.getString("access_token") ?? "None"))

    sleep(Duration.second * 6)
    println("再等6秒访问：access_token = " + (cache.getString("access_token") ?? "None"))
}
```
```bash
初次写入：access_token -> fkgyzj&2j&62jlg==
3秒后访问：access_token = fkgyzj&2j&62jlg==
再等4秒访问：access_token = fkgyzj&2j&62jlg==
再等6秒访问：access_token = None
```

滑动过期策略内部使用refresh刷新缓存项：

```cangjie
cache.refresh("session:1")
```
缓存清理频率配置可自定义

```cangjie
let options = DistributedCacheOptions(expirationScanFrequency: Duration.minute * 10)
let cache = MemoryDistributedCache(Options.create(options))
```

## 容器环境集成

当前实现为单节点内存缓存，若需支持多节点共享缓存数据，需通过容器环境集成并实现分布式存储：

### 分布式改造（一行代码）
由于Spire强大的业务数据分离特性，从单节点缓存到分布式缓存的实现只需修改一行代码：

```cangjie
// 原代码
let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))

// 改造后代码
let cache = container.resolve(IDistributedCache::type)
```

> [!IMPORTANT]
> 容器环境需配置具体的分布式缓存实现（如Redis、Memcached），需要实现`IDistributedCache`接口


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

