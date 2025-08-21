# 日志记录

Spire内置了一个现代化、高性能的日志记录框架，提供了统一的日志记录接口，支持多种输出目标、灵活的过滤机制和丰富的日志级别控制。

## 设计理念

### Spire日志系统的优势

```cangjie
// Spire日志系统方式
let logging = LoggingBuilder()
    .addConsole()                    // 统一的输出管理
    .setMinimumLevel(LogLevel.Info)  // 灵活的级别控制
    .addFilter("console", "Database", LogLevel.Error)  // 精确的过滤控制
    .build()

let logger = logging.createLogger("UserService")

logger.info("用户登录：${username}")   // 自动级别管理
logger.error("错误：${error}")        // 清晰的级别区分
logger.debug("调试信息：${info}")     // 智能的输出控制
```

**核心优势：**
-  **统一接口**：所有日志记录使用相同的API
-  **级别控制**：支持7个日志级别，精确控制输出
-  **多提供者**：支持控制台、文件等多种输出目标
-  **智能过滤**：基于提供者、类别、级别的复合过滤
-  **高性能**：延迟计算和级别检查优化
-  **类型安全**：编译时类型检查，减少运行时错误
-  **易扩展**：插件化架构，轻松添加自定义提供者

## 快速开始

只需要以下3个步骤即可开始使用日志系统：

```cangjie{3,9,12}
import spire_extensions_logging.*

// 1. 创建并配置日志系统
let logging = LoggingBuilder()
    .addConsole()                    // 添加控制台输出
    .setMinimumLevel(LogLevel.Info)  // 设置最低日志级别
    .build()

// 2. 创建日志器
let logger = logging.createLogger("MyApp")

// 3. 记录日志
logger.info("应用程序启动完成")
logger.warn("这是一个警告信息")
logger.error("这是一个错误信息")
```

### 基础示例

```cangjie
import spire_extensions_logging.*

main() {
    // 创建日志系统
    let loggerFactory = LoggingBuilder()
        .addConsole()
        .build()
    
    // 创建日志器
    let logger = loggerFactory.createLogger("Demo")
    
    // 记录不同级别的日志
    logger.trace("跟踪信息 - 非常详细的调试信息")
    logger.debug("调试信息 - 开发时的调试输出")  
    logger.info("信息 - 重要的业务信息")
    logger.warn("警告 - 需要注意的潜在问题")
    logger.error("错误 - 影响功能的错误情况")
    logger.fatal("致命 - 可能导致系统崩溃的严重错误")
}
```

## 核心概念

### 1. 日志级别（LogLevel）

日志级别定义了日志信息的重要性和详细程度：

```cangjie
public enum LogLevel <: Comparable<LogLevel> & ToString {
    Trace | Debug | Info | Warn | Error | Fatal | Off // [!code focus]
}
```

| 级别 | 优先级 | 使用场景 | 典型内容 |
|------|--------|----------|----------|
| Trace | 0 (最低) | 非常详细的调试 | 方法进入/退出、变量值 |
| Debug | 1 | 开发调试 | 业务逻辑流程、中间结果 |
| Info | 2 | 一般信息 | 业务操作完成、状态变更 |
| Warn | 3 | 警告信息 | 潜在问题、性能问题 |
| Error | 4 | 错误信息 | 处理失败、异常情况 |
| Fatal | 5 | 致命错误 | 系统崩溃、无法恢复 |
| Off | 6 (最高) | 关闭日志 | 不输出任何日志 |

**级别示例：**

```cangjie
let logger = loggerFactory.createLogger("OrderService")

// Trace - 方法跟踪
logger.trace("进入方法: processOrder(orderId=${orderId})")

// Debug - 调试信息  
logger.debug("订单验证通过，开始处理支付")

// Info - 业务信息
logger.info("订单 ${orderId} 处理完成，金额: ${amount}")

// Warn - 警告信息
logger.warn("库存不足，订单 ${orderId} 可能延迟发货")

// Error - 错误信息
logger.error("支付失败，订单 ${orderId} 需要人工处理")

// Fatal - 致命错误
logger.fatal("数据库连接断开，订单系统无法继续服务")
```

### 2. 日志器（ILogger）

日志器是记录日志的核心接口：

```cangjie
public interface ILogger {
    // 核心方法
    func log(logLevel: LogLevel, message: String, exception: ?Exception): Unit
    func isEnabled(logLevel: LogLevel): Bool
    
    // 便捷方法
    func trace(message: String): Unit
    func debug(message: String): Unit
    func info(message: String): Unit
    func warn(message: String): Unit
    func error(message: String): Unit
    func error(exception: Exception, message: String): Unit
    func fatal(message: String): Unit
}
```

**创建日志器的两种方式：**

```cangjie{3-5}
let loggerFactory = LoggingBuilder().addConsole().build()

// 方式1: 通过泛型类型创建（推荐）
let userServiceLogger = loggerFactory.createLogger<UserService>()
let orderServiceLogger = loggerFactory.createLogger<OrderService>()

// 方式2: 通过字符串名称创建
let customLogger = loggerFactory.createLogger("CustomModule")
let apiLogger = loggerFactory.createLogger("API.Controllers")
```

### 3. 日志工厂（ILoggerFactory）

日志工厂负责创建和管理日志器实例：

```cangjie
public interface ILoggerFactory {
    func createLogger<T>(): ILogger
    func createLogger(categoryName: String): ILogger
}
```

### 4. 日志提供者（ILoggerProvider）

日志提供者负责实际的日志输出：

```cangjie
public interface ILoggerProvider {
    prop name: String
    func createLogger(category: String): ILogger
}
```

## 日志系统配置

### 1. 基础配置

```cangjie
// 最简配置
let basicLogging = LoggingBuilder()
    .addConsole()
    .build()

// 带级别控制的配置
let levelControlLogging = LoggingBuilder()
    .addConsole()
    .setMinimumLevel(LogLevel.Warn)  // 只显示警告及以上级别
    .build()
```

### 2. 级别控制配置

```cangjie
// 开发环境配置
let devLogging = LoggingBuilder()
    .addConsole()
    .setMinimumLevel(LogLevel.Debug)  // 显示调试信息
    .build()

// 生产环境配置  
let prodLogging = LoggingBuilder()
    .addConsole()
    .setMinimumLevel(LogLevel.Info)   // 只显示重要信息
    .build()

// 错误监控配置
let errorLogging = LoggingBuilder()
    .addConsole() 
    .setMinimumLevel(LogLevel.Error)  // 只显示错误和致命错误
    .build()
```

### 3. 多环境配置管理

```cangjie
func createLoggingForEnvironment(environment: String): ILoggerFactory {
    let builder = LoggingBuilder().addConsole()
    
    match (environment.toLower()) {
        case "development" => {
            builder.setMinimumLevel(LogLevel.Trace)  // 开发环境显示所有日志
        }
        case "testing" => {
            builder.setMinimumLevel(LogLevel.Debug)  // 测试环境显示调试及以上
        }
        case "production" => {
            builder.setMinimumLevel(LogLevel.Info)   // 生产环境只显示重要信息
        }
        case _ => {
            builder.setMinimumLevel(LogLevel.Debug)  // 默认配置
        }
    }
    
    return builder.build()
}

// 使用环境配置
let logging = createLoggingForEnvironment("production")
```

## 日志过滤

日志过滤允许精确控制哪些日志应该被记录：

### 1. 基础过滤器

#### 按级别过滤

```cangjie
let logging = LoggingBuilder()
    .addConsole()
    .setMinimumLevel(LogLevel.Warn)  // 全局最低级别为警告
    .build()
```

#### 按提供者和类别过滤

```cangjie
let logging = LoggingBuilder()
    .addConsole()
    .addFilter("console", "Database", LogLevel.Error)    // 数据库相关只显示错误
    .addFilter("console", "Security", LogLevel.Info)     // 安全相关显示信息及以上
    .addFilter("console", "Performance", LogLevel.Warn)  // 性能监控只显示警告
    .build()
```

### 2. 自定义过滤器

```cangjie
// 定义过滤器类型
type LoggerFilter = (providerName: String, categoryName: String, level: LogLevel) -> Bool

// 时间敏感的过滤器
let timeBasedFilter: LoggerFilter = {providerName, categoryName, logLevel =>
    let currentHour = getCurrentHour()
    // 工作时间（9:00-18:00）显示所有日志，非工作时间只显示错误
    if (currentHour >= 9 && currentHour <= 18) {
        return logLevel >= LogLevel.Debug
    } else {
        return logLevel >= LogLevel.Error
    }
}

// 模块敏感的过滤器
let moduleBasedFilter: LoggerFilter = {providerName, categoryName, logLevel =>
    if (categoryName.startsWith("ThirdParty")) {
        return logLevel >= LogLevel.Error  // 第三方组件只显示错误
    }
    if (categoryName.startsWith("Internal")) {
        return logLevel >= LogLevel.Debug  // 内部模块显示调试信息
    }
    return logLevel >= LogLevel.Info       // 其他模块显示一般信息
}

let logging = LoggingBuilder()
    .addConsole()
    .addFilter(timeBasedFilter)
    .addFilter(moduleBasedFilter)
    .build()
```

### 3. 复合过滤策略

```cangjie
let complexLogging = LoggingBuilder()
    .addConsole()
    .setMinimumLevel(LogLevel.Debug)                     // 全局最低级别
    .addFilter("console", "Database", LogLevel.Warn)     // 数据库组件只显示警告
    .addFilter("console", "Cache", LogLevel.Info)        // 缓存组件显示信息
    .addFilter("console", "External", LogLevel.Error)    // 外部服务只显示错误
    .addFilter {providerName, categoryName, logLevel =>  // 自定义过滤逻辑
        // 过滤掉所有包含"Temp"的临时日志
        if (categoryName.contains("Temp")) {
            return false
        }
        // 性能敏感模块在高负载时减少日志
        if (categoryName.contains("Performance") && isHighLoad()) {
            return logLevel >= LogLevel.Warn
        }
        return true
    }
    .build()
```

### 4. 通配符支持

```cangjie
let logging = LoggingBuilder()
    .addConsole()
    .addFilter("console", "Services.*", LogLevel.Info)      // 所有服务层模块
    .addFilter("console", "Controllers.*", LogLevel.Debug)  // 所有控制器模块
    .addFilter("console", "Data.*", LogLevel.Warn)          // 所有数据访问模块
    .build()
```

## 异常日志记录

### 1. 基础异常记录

```cangjie
let logger = loggerFactory.createLogger("ExceptionDemo")

try {
    performRiskyOperation()
} catch (e: DatabaseException) {
    // 记录异常和上下文信息
    logger.error(e, "数据库操作失败，表: ${tableName}, 操作: ${operation}")
} catch (e: NetworkException) {
    logger.error(e, "网络请求失败，URL: ${url}, 超时: ${timeout}ms")
} catch (e: Exception) {
    logger.fatal(e, "未知异常，操作: ${currentOperation}")
}
```

### 2. 异常级别策略

```cangjie
func handleException(e: Exception, logger: ILogger) {
    match (e) {
        case is BusinessException => {
            // 业务异常通常是预期的，记录为警告
            logger.warn("业务规则违反: ${e.message}")
        }
        case is ValidationException => {
            // 验证异常是用户输入错误，记录为信息
            logger.info("输入验证失败: ${e.message}")
        }
        case is TimeoutException => {
            // 超时异常可能是临时问题，记录为错误
            logger.error(e, "操作超时，可能需要重试")
        }
        case is SecurityException => {
            // 安全异常是严重问题，记录为致命错误
            logger.fatal(e, "安全威胁检测到")
        }
        case _ => {
            // 未知异常默认记录为错误
            logger.error(e, "未处理的异常类型")
        }
    }
}
```

## 控制台日志提供者

### 1. 基础使用

```cangjie
let logging = LoggingBuilder()
    .addConsole()  // 添加控制台提供者
    .build()
```

### 2. 彩色输出

控制台提供者支持彩色输出，不同级别使用不同颜色：

| 日志级别 | 颜色 | 效果 |
|----------|------|------|
| Trace | 灰色 | 低对比度，不干扰 |
| Debug | 青色 | 清晰可读的调试信息 |
| Info | 绿色 | 积极的成功信息 |
| Warn | 黄色 | 引起注意的警告 |
| Error | 红色 | 明显的错误标识 |
| Fatal | 明亮红色 | 极其醒目的致命错误 |

### 3. 输出格式

```
INFO: UserService
      用户登录成功: zhang_san

ERROR: DatabaseService
      java.sql.SQLException: 连接超时
          at Database.connect(Database.cj:45)
          at UserService.authenticate(UserService.cj:23)
```

## 扩展和自定义

### 1. 自定义日志提供者

实现`ILoggerProvider`接口创建自定义提供者：

```cangjie
// 文件日志提供者示例
class FileLoggerProvider <: ILoggerProvider {
    private let _filePath: String
    private let _dateFormat: String

    init(filePath: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") {
        _filePath = filePath
        _dateFormat = dateFormat
    }

    public prop name: String {
        get() { "file" }
    }

    public func createLogger(categoryName: String): ILogger {
        return FileLogger(_filePath, categoryName, _dateFormat)
    }
}

class FileLogger <: ILogger {
    private let _filePath: String
    private let _categoryName: String
    private let _dateFormat: String

    init(filePath: String, categoryName: String, dateFormat: String) {
        _filePath = filePath
        _categoryName = categoryName
        _dateFormat = dateFormat
    }

    public func log(logLevel: LogLevel, message: String, exception: ?Exception): Unit {
        let timestamp = formatCurrentTime(_dateFormat)
        let logLine = "${timestamp} [${logLevel.toString().toUpper()}] ${_categoryName}: ${message}\n"
        
        // 写入文件
        appendToFile(_filePath, logLine)
        
        // 记录异常堆栈
        if (let Some(ex) <- exception) {
            appendToFile(_filePath, "${ex.toString()}\n")
        }
    }

    public func isEnabled(logLevel: LogLevel): Bool {
        return logLevel != LogLevel.Off
    }
}

// 添加扩展方法便于使用
extend LoggingBuilder {
    public func addFile(filePath: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") {
        addProvider(FileLoggerProvider(filePath, dateFormat))
        return this
    }
}

// 使用自定义提供者
let logging = LoggingBuilder()
    .addConsole()
    .addFile("logs/app.log")
    .build()
```

### 2. 数据库日志提供者

```cangjie
class DatabaseLoggerProvider <: ILoggerProvider {
    private let _connectionString: String
    private let _tableName: String

    init(connectionString: String, tableName: String = "application_logs") {
        _connectionString = connectionString
        _tableName = tableName
    }

    public prop name: String {
        get() { "database" }
    }

    public func createLogger(categoryName: String): ILogger {
        return DatabaseLogger(_connectionString, _tableName, categoryName)
    }
}

class DatabaseLogger <: ILogger {
    private let _connectionString: String
    private let _tableName: String  
    private let _categoryName: String

    init(connectionString: String, tableName: String, categoryName: String) {
        _connectionString = connectionString
        _tableName = tableName
        _categoryName = categoryName
    }

    public func log(logLevel: LogLevel, message: String, exception: ?Exception): Unit {
        let sql = "INSERT INTO ${_tableName} (timestamp, level, category, message, exception) VALUES (?, ?, ?, ?, ?)"
        
        // 执行数据库插入（伪代码）
        executeQuery(sql, [
            getCurrentTimestamp(),
            logLevel.toString(),
            _categoryName, 
            message,
            exception?.toString()
        ])
    }
}

// 使用数据库提供者
let logging = LoggingBuilder()
    .addConsole()
    .addProvider(DatabaseLoggerProvider("jdbc:mysql://localhost:3306/logs"))
    .build()
```

## 实际应用示例

### 1. Web应用日志架构

```cangjie
class WebApplicationLogger {
    private let _loggerFactory: ILoggerFactory
    
    init(environment: String) {
        _loggerFactory = createWebAppLogging(environment)
    }
    
    // 创建专用日志器
    public func getControllerLogger(): ILogger {
        _loggerFactory.createLogger("Controllers")
    }
    
    public func getServiceLogger(): ILogger {
        _loggerFactory.createLogger("Services")
    }
    
    public func getDatabaseLogger(): ILogger {
        _loggerFactory.createLogger("Database")
    }
    
    public func getSecurityLogger(): ILogger {
        _loggerFactory.createLogger("Security")
    }
    
    private func createWebAppLogging(environment: String): ILoggerFactory {
        let builder = LoggingBuilder().addConsole()
        
        match (environment) {
            case "development" => {
                builder.setMinimumLevel(LogLevel.Debug)
            }
            case "production" => {
                builder.setMinimumLevel(LogLevel.Info)
                       .addFilter("console", "Database", LogLevel.Warn)
                       .addFilter("console", "External", LogLevel.Error)
            }
        }
        
        return builder.build()
    }
}

// 在控制器中使用
class UserController {
    private let _logger: ILogger
    
    init(appLogger: WebApplicationLogger) {
        _logger = appLogger.getControllerLogger()
    }
    
    func handleLogin(request: LoginRequest): LoginResponse {
        _logger.info("用户登录请求: ${request.username}")
        
        try {
            let user = validateUser(request)
            _logger.info("用户 ${request.username} 登录成功")
            return LoginResponse.success(user)
        } catch (e: InvalidCredentialsException) {
            _logger.warn("用户 ${request.username} 登录失败: 凭据无效")
            return LoginResponse.failure("凭据无效")
        } catch (e: Exception) {
            _logger.error(e, "用户 ${request.username} 登录过程中发生错误")
            return LoginResponse.failure("系统错误")
        }
    }
}
```

### 2. 微服务日志管理

```cangjie
class MicroserviceLogger {
    private let _serviceLogger: ILogger
    private let _requestLogger: ILogger
    private let _performanceLogger: ILogger
    
    init(serviceName: String, loggerFactory: ILoggerFactory) {
        _serviceLogger = loggerFactory.createLogger("Service.${serviceName}")
        _requestLogger = loggerFactory.createLogger("Request.${serviceName}")
        _performanceLogger = loggerFactory.createLogger("Performance.${serviceName}")
    }
    
    func logServiceStart(version: String, port: Int32) {
        _serviceLogger.info("微服务启动 - 版本: ${version}, 端口: ${port}")
    }
    
    func logRequestStart(requestId: String, method: String, path: String) {
        _requestLogger.info("请求开始 - ID: ${requestId}, ${method} ${path}")
    }
    
    func logRequestEnd(requestId: String, statusCode: Int32, duration: Int64) {
        _requestLogger.info("请求结束 - ID: ${requestId}, 状态: ${statusCode}, 耗时: ${duration}ms")
        
        // 性能监控
        if (duration > 5000) {
            _performanceLogger.warn("慢请求 - ID: ${requestId}, 耗时: ${duration}ms")
        }
    }
}
```

### 3. 后台任务调度器

```cangjie
class TaskScheduler {
    private let _schedulerLogger: ILogger
    private let _taskLogger: ILogger
    
    init(loggerFactory: ILoggerFactory) {
        _schedulerLogger = loggerFactory.createLogger("Scheduler")
        _taskLogger = loggerFactory.createLogger("Tasks")
    }
    
    func scheduleTask(task: ScheduledTask) {
        _schedulerLogger.info("任务调度 - ID: ${task.id}, 类型: ${task.type}, 下次执行: ${task.nextRunTime}")
    }
    
    func executeTask(task: ScheduledTask) {
        let startTime = getCurrentTime()
        
        _taskLogger.info("任务开始 - ID: ${task.id}, 类型: ${task.type}")
        
        try {
            task.execute()
            
            let duration = getCurrentTime() - startTime
            _taskLogger.info("任务完成 - ID: ${task.id}, 耗时: ${duration}ms")
            
        } catch (e: Exception) {
            let duration = getCurrentTime() - startTime
            _taskLogger.error(e, "任务失败 - ID: ${task.id}, 耗时: ${duration}ms")
            
            // 重试逻辑
            if (task.retryCount < task.maxRetries) {
                task.retryCount++
                _schedulerLogger.warn("任务重试 - ID: ${task.id}, 第${task.retryCount}次重试")
            }
        }
    }
}
```

## 性能优化

### 1. 级别检查优化

使用`isEnabled`避免不必要的计算：

```cangjie
// ✅ 高效的方式
if (logger.isEnabled(LogLevel.Debug)) {
    let expensiveData = performExpensiveCalculation()
    logger.debug("详细信息: ${expensiveData}")
}

// ❌ 低效的方式  
logger.debug("详细信息: ${performExpensiveCalculation()}")  // 总是计算
```

### 2. 字符串构建优化

```cangjie
// ✅ 延迟字符串构建
func logUserOperation(logger: ILogger, user: User, operation: String) {
    if (logger.isEnabled(LogLevel.Info)) {
        logger.info("用户操作 - 用户: ${user.name}, 操作: ${operation}, 时间: ${getCurrentTime()}")
    }
}

// ✅ 结构化日志信息
func logStructuredInfo(logger: ILogger, data: Map<String, String>) {
    if (logger.isEnabled(LogLevel.Info)) {
        let message = buildLogMessage(data)  // 只在需要时构建
        logger.info(message)
    }
}
```

### 3. 过滤器性能

```cangjie
// ✅ 高效的过滤器
let fastFilter: LoggerFilter = {providerName, categoryName, logLevel =>
    return logLevel >= LogLevel.Warn  // 简单比较
}

// ❌ 低效的过滤器
let slowFilter: LoggerFilter = {providerName, categoryName, logLevel =>
    let config = loadConfiguration()      // 避免在过滤器中进行I/O操作
    let threshold = config.getThreshold() // 避免复杂计算
    return logLevel.value() >= threshold
}
```

## 最佳实践

### 1. 日志级别使用指导

```cangjie
class LoggingBestPractices {
    private let _logger: ILogger

    func demonstrateLogLevels() {
        // TRACE: 方法跟踪，变量值
        _logger.trace("进入方法: calculateScore(userId=${userId})")
        
        // DEBUG: 业务逻辑流程，中间结果
        _logger.debug("评分计算: 基础分=${baseScore}, 权重=${weight}")
        
        // INFO: 重要业务信息，操作完成
        _logger.info("用户 ${username} 评分计算完成: ${finalScore}")
        
        // WARN: 潜在问题，性能警告
        _logger.warn("响应时间过长: ${responseTime}ms > ${threshold}ms")
        
        // ERROR: 功能错误，但系统可继续
        _logger.error("支付接口调用失败，订单 ${orderId} 需要重试")
        
        // FATAL: 系统级错误，可能崩溃
        _logger.fatal("数据库连接池耗尽，系统无法提供服务")
    }
}
```

### 2. 异常处理最佳实践

```cangjie
func handleExceptionsCorrectly() {
    try {
        performBusinessOperation()
    } catch (e: BusinessException) {
        // 业务异常：记录为警告，包含业务上下文
        logger.warn("业务规则违反: ${e.message}, 用户: ${currentUser}")
    } catch (e: ValidationException) {
        // 验证异常：记录为信息，这是正常用户错误
        logger.info("输入验证失败: ${e.fieldName} = ${e.value}")
    } catch (e: NetworkException) {
        // 网络异常：记录为错误，包含重试信息
        logger.error(e, "网络操作失败，将重试。目标: ${e.url}")
    } catch (e: Exception) {
        // 未知异常：记录为致命，包含完整上下文
        logger.fatal(e, "未处理的异常，操作: ${operation}, 用户: ${user}")
    }
}
```

### 3. 安全日志记录

```cangjie
class SecurityLogging {
    private let _securityLogger: ILogger
    private let _auditLogger: ILogger

    func logSecurityEvents() {
        // ✅ 记录重要信息但不包含敏感数据
        _securityLogger.info("用户登录 - 用户: ${username}, IP: ${clientIp}")
        
        // ✅ 审计日志
        _auditLogger.info("权限变更 - 操作员: ${operatorId}, 目标: ${targetUser}")

        // ❌ 绝对不要记录敏感信息
        // _securityLogger.info("用户登录 - 密码: ${password}")  // 危险！
        // _securityLogger.info("API令牌: ${fullToken}")        // 危险！

        // ✅ 记录令牌的部分信息用于调试
        let maskedToken = maskSensitiveData(apiToken)
        _securityLogger.debug("API调用 - 令牌: ${maskedToken}")
    }

    private func maskSensitiveData(data: String): String {
        if (data.size <= 8) return "****"
        return data.substring(0, 4) + "****" + data.substring(data.size - 4)
    }
}
```

### 4. 环境配置管理

```cangjie
class EnvironmentLogging {
    public static func createForEnvironment(env: String): ILoggerFactory {
        match (env.toLower()) {
            case "development" => {
                return LoggingBuilder()
                    .addConsole()
                    .setMinimumLevel(LogLevel.Trace)  // 开发环境显示所有
                    .build()
            }
            case "testing" => {
                return LoggingBuilder()
                    .addConsole()
                    .setMinimumLevel(LogLevel.Debug)
                    .addFilter("console", "External", LogLevel.Warn)  // 测试时过滤外部服务
                    .build()
            }
            case "production" => {
                return LoggingBuilder()
                    .addConsole()
                    .setMinimumLevel(LogLevel.Info)
                    .addFilter("console", "Debug", LogLevel.Off)      // 生产环境关闭调试
                    .addFilter("console", "Performance", LogLevel.Warn)
                    .build()
            }
            case _ => {
                // 默认配置
                return LoggingBuilder()
                    .addConsole()
                    .setMinimumLevel(LogLevel.Info)
                    .build()
            }
        }
    }
}
```

## 注意事项

### 1. 性能考虑

- ✅ 使用`isEnabled`检查避免不必要的计算
- ✅ 简单的日志消息直接记录
- ❌ 避免在日志中进行复杂计算
- ❌ 避免在过滤器中执行I/O操作

### 2. 内存管理

- ✅ 避免在日志中创建大量临时对象
- ✅ 合理使用字符串插值
- ❌ 不要在日志中创建不必要的复杂对象

### 3. 线程安全

- ✅ 日志组件完全线程安全
- ✅ 多线程环境下可安全使用同一个logger实例
- ✅ LoggerFactory线程安全，可以并发创建日志器

### 4. 敏感信息保护

- ❌ 绝对不要记录密码、API密钥、信用卡号等敏感信息
- ✅ 可以记录用户名、操作类型、API端点等非敏感信息
- ✅ 如需调试令牌，使用掩码技术只显示部分信息

### 5. 日志分类命名规范

```cangjie
// ✅ 推荐的命名规范
let controllerLogger = factory.createLogger("Controllers.UserController")
let serviceLogger = factory.createLogger("Services.UserService")
let dataLogger = factory.createLogger("DataAccess.UserRepository")
let securityLogger = factory.createLogger("Security.Authentication")

// ❌ 不一致的命名
let logger1 = factory.createLogger("user_ctrl")
let logger2 = factory.createLogger("USER-SERVICE")
```

## 总结

Spire日志系统提供了完整的、企业级的日志记录解决方案：

- **易于使用**：简单的API和直观的配置
- **功能强大**：丰富的级别控制和过滤机制
- **高性能**：优化的记录机制和智能级别检查
- **易扩展**：插件化架构支持自定义提供者
- **生产就绪**：线程安全、内存优化、性能可靠

通过遵循本指南的最佳实践，您可以构建高效、安全、可维护的日志系统，为应用程序提供强大的监控和调试能力。 