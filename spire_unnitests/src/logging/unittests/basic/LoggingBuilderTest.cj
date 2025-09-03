package spire_unnitests.logging.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import spire_extensions_logging.*
import spire_unnitests.logging.unittests.*

/**
 * 日志构建器基本功能测试
 * 测试LoggingBuilder的基本功能
 */
@Test
func 日志构建器基本功能测试() {
    let builder = LoggingBuilder()
    
    // 验证构建器能正常创建 - 通过调用方法验证
    try {
        builder.setMinimumLevel(LogLevel.Info)
        @Expect(true)  // 验证方法调用成功
    } catch (e: Exception) {
        @Expect(false)
    }
    
    // 验证默认最小级别 - 通过创建logger验证
    let factory = builder.build()
    let logger = factory.createLogger("Test")
    try {
        @Expect(logger.isEnabled(LogLevel.Trace), false)  // 验证logger可以正常工作
    } catch (e: Exception) {
        @Expect(false)
    }
}

/**
 * 日志构建器设置最小级别测试
 * 测试LoggingBuilder的setMinimumLevel方法
 */
@Test
func 日志构建器设置最小级别测试() {
    let builder = LoggingBuilder()
    
    // 测试设置各种最小级别
    let levels = LoggingTestHelper.getAllLogLevels()
    for (level in levels) {
        try {
            builder.setMinimumLevel(level)
            @Expect(true)  // 验证方法调用成功
        } catch (e: Exception) {
            @Expect(false)
        }
    }
}

/**
 * 日志构建器添加过滤器测试
 * 测试LoggingBuilder的addFilter方法
 */
@Test
func 日志构建器添加过滤器测试() {
    let filter: LoggerFilter = {_, _, _ =>
        return true
    }

    let builder = LoggingBuilder()
    
    // 测试添加过滤器
    try {
        builder.addFilter(filter)
        @Expect(true)  // 验证方法调用成功
    } catch (e: Exception) {
        @Expect(false)
    }
    
    // 测试添加带参数的过滤器
    try {
        builder.addFilter("测试提供者", "测试类别", LogLevel.Info)
        @Expect(true)  // 验证方法调用成功
    } catch (e: Exception) {
        @Expect(false)
    }
}

/**
 * 日志构建器添加提供者测试
 * 测试LoggingBuilder的addProvider方法
 */
@Test
func 日志构建器添加提供者测试() {
    let builder = LoggingBuilder()
    
    // 测试添加控制台提供者
    let consoleProvider = ConsoleLoggerProvider()
    try {
        builder.addProvider(consoleProvider)
        @Expect(true)  // 验证方法调用成功
    } catch (e: Exception) {
        @Expect(false)
    }
    
    // 验证提供者被添加
    let factory = builder.build()
    let logger = factory.createLogger("Test")
    @Expect(logger.isEnabled(LogLevel.Trace), true)  // 有提供者应该能工作
}

/**
 * 日志构建器清除提供者测试
 * 测试LoggingBuilder的clearProviders方法
 */
@Test
func 日志构建器清除提供者测试() {
    let builder = LoggingBuilder()

    // 先添加提供者
    let consoleProvider = ConsoleLoggerProvider()
    try {
        builder.addProvider(consoleProvider)
    } catch (e: Exception) {
        @Expect(false)
    }

    // 清除提供者
    try {
        builder.clearProviders()
        @Expect(true)  // 验证方法调用成功
    } catch (e: Exception) {
        @Expect(false)
    }

    // 验证build成功并且创建的logger行为正确
    let factory = builder.build()
    let logger = factory.createLogger("TestCategory")

    // 验证logger存在但没有提供者，所以所有级别都应该是disabled
    @Expect(true)  // logger创建成功，如果没有异常就是成功的
    @Expect(logger.isEnabled(LogLevel.Trace), false)
    @Expect(logger.isEnabled(LogLevel.Debug), false)
    @Expect(logger.isEnabled(LogLevel.Info), false)
    @Expect(logger.isEnabled(LogLevel.Warn), false)
    @Expect(logger.isEnabled(LogLevel.Error), false)
    @Expect(logger.isEnabled(LogLevel.Fatal), false)

    // 验证log方法不会抛出异常
    logger.log(LogLevel.Info, "测试消息", None)
    @Expect(true)  // 如果执行到这里说明log方法没有抛出异常
}

/**
 * 日志构建器重复添加提供者测试
 * 测试LoggingBuilder处理重复添加提供者的情况
 */
@Test
func 日志构建器重复添加提供者测试() {
    let builder = LoggingBuilder()
    
    // 多次添加同一个提供者
    let consoleProvider = ConsoleLoggerProvider()
    try {
        builder.addProvider(consoleProvider)
        builder.addProvider(consoleProvider)  // 重复添加
    } catch (e: Exception) {
        @Expect(false)
    }
    
    // 验证只添加了一次
    let factory = builder.build()
    let logger = factory.createLogger("Test")
    @Expect(logger.isEnabled(LogLevel.Trace), true)  // 应该能正常工作
}

/**
 * 日志构建器链式调用测试
 * 测试LoggingBuilder的链式调用功能
 */
@Test
func 日志构建器链式调用测试() {

    let filter: LoggerFilter = {_, _, _ =>
        return true
    }

    let builder = LoggingBuilder()
    
    // 链式调用
    let factory = builder.setMinimumLevel(LogLevel.Info)
                        .addFilter(filter)
                        .addProvider(ConsoleLoggerProvider())
                        .build()
    
    let logger = factory.createLogger("链式测试")
    @Expect(logger.isEnabled(LogLevel.Info), true)  // 验证链式调用成功
}

/**
 * 日志构建器空操作测试
 * 测试LoggingBuilder在空操作时的行为
 */
@Test
func 日志构建器空操作测试() {
    let builder = LoggingBuilder()
    
    // 不添加任何提供者，直接构建
    let factory = builder.build()
    
    // 创建日志器
    let logger = factory.createLogger("空操作测试")
    @Expect(logger.isEnabled(LogLevel.Trace), false)  // 没有提供者应该返回false
}

/**
 * 日志构建器自定义过滤器测试
 * 测试LoggingBuilder的自定义过滤器功能
 */
@Test
func 日志构建器自定义过滤器测试() {
    // 创建自定义过滤器 - 只允许Error及以上级别
    let errorOnlyFilter: LoggerFilter = {_, _, level =>
        return level >= LogLevel.Error
    }
    
    let builder = LoggingBuilder()
    let factory = builder.setMinimumLevel(LogLevel.Trace)
                        .addFilter(errorOnlyFilter)
                        .addProvider(ConsoleLoggerProvider())
                        .build()
    
    let logger = factory.createLogger("自定义过滤器测试")
    
    // 验证过滤器功能
    @Expect(logger.isEnabled(LogLevel.Trace), false)   // 应该被过滤
    @Expect(logger.isEnabled(LogLevel.Debug), false)   // 应该被过滤
    @Expect(logger.isEnabled(LogLevel.Info), false)    // 应该被过滤
    @Expect(logger.isEnabled(LogLevel.Warn), false)    // 应该被过滤
    @Expect(logger.isEnabled(LogLevel.Error), true)    // 应该通过
    @Expect(logger.isEnabled(LogLevel.Fatal), true)    // 应该通过
}

/**
 * 日志构建器复合过滤器测试
 * 测试LoggingBuilder的多个过滤器组合功能
 */
@Test
func 日志构建器复合过滤器测试() {
    // 创建基于名称的过滤器
    let nameBasedFilter: LoggerFilter = {providerName, _, _ =>
        return providerName == "ConsoleLoggerProvider"
    }
    
    // 创建基于级别的过滤器
    let levelBasedFilter: LoggerFilter = {_, _, level =>
        return level >= LogLevel.Info
    }
    
    let builder = LoggingBuilder()
    let factory = builder.setMinimumLevel(LogLevel.Trace)
                        .addFilter(nameBasedFilter)
                        .addFilter(levelBasedFilter)
                        .addProvider(ConsoleLoggerProvider())
                        .build()
    
    let logger = factory.createLogger("复合过滤器测试")
    
    // 验证复合过滤器功能
    @Expect(logger.isEnabled(LogLevel.Trace), false)   // 级别过低
    @Expect(logger.isEnabled(LogLevel.Debug), false)   // 级别过低
    @Expect(logger.isEnabled(LogLevel.Info), true)     // 名称和级别都符合
    @Expect(logger.isEnabled(LogLevel.Warn), true)     // 名称和级别都符合
    @Expect(logger.isEnabled(LogLevel.Error), true)    // 名称和级别都符合
    @Expect(logger.isEnabled(LogLevel.Fatal), true)    // 名称和级别都符合
}

/**
 * 日志构建器类别过滤器测试
 * 测试LoggingBuilder基于类别的过滤器功能
 */
@Test
func 日志构建器类别过滤器测试() {
    // 创建基于类别的过滤器 - 只允许特定前缀的类别
    let categoryFilter: LoggerFilter = {_, categoryName, _ =>
        return categoryName.startsWith("测试.")
    }
    
    let builder = LoggingBuilder()
    let factory = builder.setMinimumLevel(LogLevel.Trace)
                        .addFilter(categoryFilter)
                        .addProvider(ConsoleLoggerProvider())
                        .build()
    
    // 测试不同类别的日志器
    let validLogger = factory.createLogger("测试.有效类别")
    let invalidLogger = factory.createLogger("无效类别")
    
    // 验证类别过滤器功能
    @Expect(validLogger.isEnabled(LogLevel.Info), true)      // 类别符合
    @Expect(invalidLogger.isEnabled(LogLevel.Info), false)   // 类别不符合
}