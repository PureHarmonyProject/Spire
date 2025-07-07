# spire_extensions_logging_configuration

通过配置文件来扩展日志过滤

## 配置文件

- 在项目根路径下创建`appsettings.json`文件

* logging:logLevel:默认规则  
* logging:{provider}:提供程序配置

``` cangjie
{
    "logging": {
      "logLevel": {
        "default": "Info"
      },
      "console":{
        "logLevel": {
          "asp": "Warn"
        }
      }
    }
}
```
> 配置文件支持*号统配符，比如`asp.*`或者`*.asp`

## 构建配置和日志

``` cangjie
//构建配置
let configuration = ConfigurationManager()
    .addJsonFile("./appsettings.json", true)

let builder = LoggingBuilder()
builder.addConsole()
//使用配置文件来配置日志过滤规则
builder.addConfiguration(configuration.getSection("logging"))
let loggerFactory = builder.build()

let logger1 = loggerFactory.createLogger("asp.web)
let logger2 = loggerFactory.createLogger("std.web)

logger1.info("hello")//控制台不打印，因为asp开头的最低级别要求是warn
logger1.info("hello")//控制台不打印，因为asp开头的最低级别要求是warn
logger1.warn("hello")//控制台打印，因为asp开头的最低级别要求是warn

logger2.info("hello")//打印，因为没有匹配的规则，而默认规则是Info
logger2.warn("hello")//打印，因为没有匹配的规则，而默认规则是Info
```