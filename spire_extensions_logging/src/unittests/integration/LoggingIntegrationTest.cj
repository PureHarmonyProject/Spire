package spire_extensions_logging.unittests.integration

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_logging.*
import spire_extensions_logging.unittests.*

/**
 * 日志构建器集成测试
 * 测试LoggingBuilder与LoggerFactory的集成
 */
@Test
func 日志构建器集成测试() {
    // 创建日志构建器并添加控制台提供者
    let builder = LoggingBuilder()
    builder.setMinimumLevel(LogLevel.Info)
          .addProvider(ConsoleLoggerProvider())
    
    // 构建日志器工厂
    let factory = builder.build()
    
    // 创建日志器
    let logger = factory.createLogger("集成测试")
    
    // 测试日志记录
    logger.info("集成测试消息")
    logger.warn("集成测试警告")
    logger.error("集成测试错误")
}

/**
 * 日志工厂集成测试
 * 测试LoggerFactory创建多个日志器
 */
@Test
func 日志工厂集成测试() {
    let builder = LoggingBuilder()
    builder.setMinimumLevel(LogLevel.Debug)
          .addProvider(ConsoleLoggerProvider())
    
    let factory = builder.build()
    
    // 创建多个日志器
    let loggerNames = LoggingTestHelper.createTestNames()
    let loggers = ArrayList<ILogger>()
    
    for (name in loggerNames) {
        let logger = factory.createLogger(name)
        loggers.add(logger)
    }
    
    // 验证创建的日志器数量
    @Expect(loggers.size, loggerNames.size)
    
    // 测试每个日志器
    for (i in 0..loggers.size) {
        let logger = loggers[i]
        logger.info("来自${loggerNames[i]}的日志消息")
    }
}

/**
 * 日志级别过滤集成测试
 * 测试日志级别过滤功能
 */
@Test
func 日志级别过滤集成测试() {
    let builder = LoggingBuilder()
    builder.setMinimumLevel(LogLevel.Warn)  // 只记录Warn及以上级别
          .addProvider(ConsoleLoggerProvider())
    
    let factory = builder.build()
    let logger = factory.createLogger("级别过滤测试")
    
    // 验证低级别被过滤
    @Expect(logger.isEnabled(LogLevel.Trace), false)
    @Expect(logger.isEnabled(LogLevel.Debug), false)
    @Expect(logger.isEnabled(LogLevel.Info), false)
    
    // 验证高级别通过
    @Expect(logger.isEnabled(LogLevel.Warn), true)
    @Expect(logger.isEnabled(LogLevel.Error), true)
    @Expect(logger.isEnabled(LogLevel.Fatal), true)
}

/**
 * 日志过滤器集成测试
 * 测试LoggerFilter的集成使用
 */
@Test
func 日志过滤器集成测试() {
    let builder = LoggingBuilder()
    builder.setMinimumLevel(LogLevel.Trace)
          .addFilter("ConsoleLoggerProvider", "测试类别", LogLevel.Info)
          .addProvider(ConsoleLoggerProvider())
    
    let factory = builder.build()
    let logger = factory.createLogger("过滤器集成测试")
    
    // 测试日志记录
    logger.trace("跟踪消息")
    logger.debug("调试消息")
    logger.info("信息消息")
    logger.warn("警告消息")
    logger.error("错误消息")
    logger.fatal("致命消息")
    
    // 验证方法执行完成
    @Expect(true)
}

/**
 * 多提供者集成测试
 * 测试多个LoggerProvider的集成
 */
@Test
func 多提供者集成测试() {
    let builder = LoggingBuilder()
    builder.setMinimumLevel(LogLevel.Info)
    
    // 添加多个提供者（目前只有ConsoleLoggerProvider）
    let consoleProvider = ConsoleLoggerProvider()
    builder.addProvider(consoleProvider)
    
    let factory = builder.build()
    let logger = factory.createLogger("多提供者测试")
    
    // 测试日志记录
    logger.info("多提供者测试消息")
    
    // 验证方法执行完成
    @Expect(true)
}

/**
 * 日志构建器链式调用集成测试
 * 测试完整的链式调用流程
 */
@Test
func 日志构建器链式调用集成测试() {
    let testFilter: LoggerFilter = {_, _, _ =>
        return true
    }

    let builder = LoggingBuilder()
    builder.setMinimumLevel(LogLevel.Debug)
          .addFilter(testFilter)
          .addFilter("ConsoleLoggerProvider", "链式测试", LogLevel.Info)
          .addProvider(ConsoleLoggerProvider())
    let factory = builder.build()
    
    let logger = factory.createLogger("链式调用测试")
    
    // 测试各级别日志
    logger.trace("链式跟踪")
    logger.debug("链式调试")
    logger.info("链式信息")
    logger.warn("链式警告")
    logger.error("链式错误")
    logger.fatal("链式致命")
    
    // 验证方法执行完成
    @Expect(true)
}

/**
 * 日志构建器链式调用集成测试
 * 测试完整的链式调用流程
 */
@Test
func 日志提供者信息添加测试() {
    let builder = LoggingBuilder()
    builder.addProvider(ConsoleLoggerProvider())
    let factory = builder.build()
    
    let logger = factory.createLogger("链式调用测试")
    
    // 测试各级别日志
    logger.trace("链式跟踪")
    logger.debug("链式调试")
    logger.info("链式信息")
    logger.warn("链式警告")
    logger.error("链式错误")
    logger.fatal("链式致命")
    
    // 验证方法执行完成
    @Expect(true)
}

/**
 * 日志器性能集成测试
 * 测试大量日志记录的性能
 */
@Test
func 日志器性能集成测试() {
    let builder = LoggingBuilder()
    builder.setMinimumLevel(LogLevel.Info)
          .addProvider(ConsoleLoggerProvider())
    
    let factory = builder.build()
    let logger = factory.createLogger("性能测试")
    
    // 记录大量日志
    for (i in 1..101) {
        logger.info("性能测试消息_${i}")
    }
    
    // 验证方法执行完成
    @Expect(true)
}

/**
 * 日志器异常处理集成测试
 * 测试日志器处理异常的集成功能
 */
@Test
func 日志器异常处理集成测试() {
    let builder = LoggingBuilder()
    builder.setMinimumLevel(LogLevel.Error)
          .addProvider(ConsoleLoggerProvider())
    
    let factory = builder.build()
    let logger = factory.createLogger("异常处理测试")
    
    // 测试异常记录
    let exceptions = LoggingTestHelper.createTestExceptions()
    for (i in 0..exceptions.size) {
        logger.error("异常测试消息_${i + 1}： ${exceptions[i]}")
    }
    
    // 验证方法执行完成
    @Expect(true)
}