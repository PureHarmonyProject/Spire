# aspire_extensions_options
选项配置（Options）库。它提供了统一的、类型安全的、规范的方式来配置应用程序，并且支持多架构多租户。它是对依赖注入的扩展和补充。

## 基础使用

``` cangjie
public class ApplicationOptions {
   var name = ""
}

let services = ServiceCollection()

services.configureAfter<ApplicationOptions>({configureOptions => 
    configureOptions.name = "cangjie"
})

services.configure<ApplicationOptions>({configureOptions => 
    configureOptions.name = "aspire"
})

//构建容器
let provider = services.build()

//解析选项
let options = provider.getOrThrow<IOptions<ApplicationOptions>>()

//打印选项
options.value.name |> println //cangjie
```

> `configureAfter`配置函数在所有的`configure`函数运行结束之后执行。

## 命名选项


``` cangjie

let services = ServiceCollection()

services.configure<ApplicationOptions>({configureOptions => 
    configureOptions.name = "default"
})

services.configure<ApplicationOptions>("tenant1", {configureOptions => 
    configureOptions.name = "tenant1"
})

services.configure<ApplicationOptions>("tenant2", {configureOptions => 
    configureOptions.name = "tenant2"
})

//构建容器
let provider = services.build()

//解析选项
let optionsMonitor = provider.getOrThrow<IOptionsMonitor<ApplicationOptions>>()

//打印租户1的选项
optionsMonitor.currentValue.name |> println //default

//打印租户1的选项
optionsMonitor.get("tenant1").name |> println //tenant1

//打印租户2的选项
optionsMonitor.get("tenant1").name |> println //tenant1
```
