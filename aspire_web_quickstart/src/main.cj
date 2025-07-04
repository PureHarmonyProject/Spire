package aspire_web_quickstart

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