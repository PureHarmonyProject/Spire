# 选项配置（Options）快速入门

选项配置（Options）是一种类型安全、统一、规范的应用程序配置方式，适用于多架构、多租户场景。它是依赖注入的重要扩展，帮助你将配置与业务逻辑解耦，提高代码的可维护性和灵活性。

## 快速上手

只需5步即可开始使用选项配置：

```cangjie{3,8,13,16,19}
import spire_extensions_options.*
import spire_extensions_injection.*

// 1. 定义选项类型
public class ApplicationOptions {
    var name = ""
}

// 2. 创建服务集合
let services = ServiceCollection()

// 3. 注册选项配置
services.configure<ApplicationOptions>({configureOptions =>
    configureOptions.name = "spire"
})

// 4. 构建服务提供者
let provider = services.build()

// 5. 解析并使用选项
let options = provider.getOrThrow<IOptions<ApplicationOptions>>()
options.value.name |> println // spire
```

> `configure`方法用于注册选项的配置逻辑。

## 配置后置处理（configureAfter）

有时需要在所有`configure`配置完成后再进行一次统一处理，可以使用`configureAfter`：

```cangjie
services.configure<ApplicationOptions>({configureOptions =>
    configureOptions.name = "spire"
})
services.configureAfter<ApplicationOptions>({configureOptions =>
    configureOptions.name = "cangjie"
})
// ...
let options = provider.getOrThrow<IOptions<ApplicationOptions>>()
options.value.name |> println // cangjie
```

> `configureAfter`会在所有`configure`执行后统一处理。

## 命名选项

支持多租户或多配置场景，可以为不同名称注册不同配置：

```cangjie
services.configure<ApplicationOptions>({configureOptions =>
    configureOptions.name = "default"
})
services.configure<ApplicationOptions>("tenant1", {configureOptions =>
    configureOptions.name = "tenant1"
})
services.configure<ApplicationOptions>("tenant2", {configureOptions =>
    configureOptions.name = "tenant2"
})
let provider = services.build()
let optionsMonitor = provider.getOrThrow<IOptionsMonitor<ApplicationOptions>>()
optionsMonitor.currentValue.name |> println // default
optionsMonitor.get("tenant1").name |> println // tenant1
optionsMonitor.get("tenant2").name |> println // tenant2
```

## 常见用法

- **类型安全**：所有选项均为强类型，避免魔法字符串。
- **依赖注入集成**：选项对象可直接注入到服务中。
- **后置处理**：通过`configureAfter`实现统一收尾配置。
- **命名选项**：支持多租户/多环境配置。

## 最佳实践

- 推荐将所有选项类型集中定义，便于管理和维护。
- 配置逻辑建议拆分为多个`configure`，最后用`configureAfter`统一收尾。
- 命名选项适合多租户、分环境等复杂场景。
- 选项对象建议只读，避免运行时被修改。

## 与依赖注入的集成

选项配置与依赖注入完美结合，可以轻松实现配置驱动的服务：

```cangjie
// 定义选项类型
public class WorkServiceOptions {
    var delay = 10
}

// 定义服务类，通过构造函数注入选项
public class WorkService {
    public WorkService(let options: IOptions<WorkServiceOptions>){}

    public func working() {
        while (!Thread.currentThread.hasPendingCancellation) {
            print("WorkService working\n")
            sleep(Duration.second * options.value.delay)
        }
        print("WorkService working end")
    }
}

// 扩展方法，简化服务注册
extend ServiceCollection {
    public func addWorkService() {
        this.addOptions<WorkServiceOptions>()
        this.addSingleton<WorkService, WorkService>()
    }
}

// 使用示例
main() {
    let services = ServiceCollection()
    services.addWorkService()
    services.configureAfter<WorkServiceOptions>{options => 
        options.delay = 1
    }
    let provider = services.build()
    let work = provider.getOrThrow<WorkService>()
    work.working()
}
```

> 通过`addOptions<T>()`方法注册选项类型，然后服务可以通过构造函数注入`IOptions<T>`来获取配置。
