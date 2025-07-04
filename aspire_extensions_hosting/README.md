# aspire_extensions_hosting

通用主机（Generic Host） 库，能够用来创建后台服务、控制台应用、Web 应用等，并提供了依赖注入、日志、配置管理、生命周期管理等功能。


## 创建通用主机

``` cangjie
import aspire_extensions_hosting.*

main(args: Array<String>) {
    let builder = Host.createBuilder(args)
    let host = builder.build()    
    host.run()
    return 0
}

```
> 当然上面的代码啥也不干，只是启动一个主线程并阻塞    
> `Host.createBuilder(args)`为我们整合了`依赖注入`、`配置管`、`IHostEnvironment`

## 运行后台任务

``` cangjie
import aspire_extensions_hosting.*
import aspire_extensions_logging.*
import aspire_extensions_injection.*

main(args: Array<String>) {
    let builder = Host.createBuilder(args)
    builder.services.addTestWork()
    let host = builder.build()    
    host.run()
    return 0
}

public class TestWorker <: BackgroundService {
    private let _logger: ILogger

    public init(logFactory: ILoggerFactory) {
        _logger = logFactory.createLogger<TestWorker>()
    }

    public func run(): Unit {
        while (!Thread.currentThread.hasPendingCancellation) {
            _logger.info("hello cangjie")
            sleep(Duration.second * 3)
        }
    }
}

extend ServiceCollection{
    public func addTestWork() {
        this.addHostedService<TestWorker>()
    }
}
```

> 这样就可以让通用主机去执行`TestWorker`    
> `extend ServiceCollection`是可选的，但是是被推崇的

## IHostEnvironment

开发环境和测试环境可能注册服务的实现组件不一样。执行的逻辑获取也不一样。

``` cangjie
import aspire_extensions_hosting.*
import aspire_extensions_logging.*
import aspire_extensions_injection.*

main() {
    let builder = Host.createBuilder("environment=Development")

    //只有开发环境才注册TestWorker
    if (builder.environment.isDevelopment()) {
        builder.services.addTestWork()
    }
    let host = builder.build()    
    host.run()
    return 0
}

public class TestWorker <: BackgroundService {
    private let _logger: ILogger
    private let _env: IHostEnvironment

    public init(logFactory: ILoggerFactory, env: IHostEnvironment) {
        _logger = logFactory.createLogger<TestWorker>()
        _env = env
    }

    public func run(): Unit {
        while (!Thread.currentThread.hasPendingCancellation) {
            _logger.info("${_env.environmentName} hello cangjie")
            sleep(Duration.second * 3)
        }
    }
}

extend ServiceCollection{
    public func addTestWork() {
        this.addHostedService<TestWorker>()
    }
}
```
> 设置环境变量可以通过命令行参数，环境变量等方式

