# spire_extensions_logging

日志记录（logging）组件，提供了模块化、可扩展的日志记录框架，支持 控制台、文件等多种日志存储方式，并可以自定义存储介质。

## 创建日志

``` cangjie
let logging = LoggingBuilder()
//添加控制台日志提供程序
logging.addConsole()
let loggerFactory = logging.build()
//1. 通过字符串的方式创建日志
let logger1 = loggerFactory.createLogger("test1")

//2. 通过类型完全限定名创建日志
let logger2 = loggerFactory.createLogger<Object>()
```

## 日志级别

``` cangjie
let logging = LoggingBuilder()
//设置日志的最低级别
logging.setMinimumLevel(LogLevel.Warn)

let logger = loggerFactory.createLogger("test1")
logger.info("hello cangjie!")//不打印

logger.error("hello cangjie!")//打印

```

## 日志过滤器

``` cangjie
let logging = LoggingBuilder()

//如果日志提供程序是console并且日志级别大于Warn才打印
logging.addFilter{providerName, categoryName, logLevel =>
    if (providerName == "console" && logLevel >= LogLevel.Warn) {
        return true
    }
    return false
}

logger.info("hello cangjie!")//不打印

logger.error("hello cangjie!")//打印
```