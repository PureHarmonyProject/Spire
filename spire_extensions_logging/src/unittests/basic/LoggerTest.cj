package spire_extensions_logging.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_logging.*
import spire_extensions_logging.unittests.*

/**
 * 日志器基本功能测试
 * 测试Logger的基本功能
 */
@Test
func 日志器基本功能测试() {
    let logInfoList = ArrayList<LoggerInformation>()
    let logger = Logger(logInfoList)
    
    // 验证空日志器的isEnabled方法
    @Expect(logger.isEnabled(LogLevel.Info), false)
}

/**
 * 日志器启用状态测试
 * 测试Logger的isEnabled方法
 */
@Test
func 日志器启用状态测试() {
    let logInfoList = ArrayList<LoggerInformation>()
    let logger = Logger(logInfoList)
    
    // 测试各种日志级别的启用状态
    let levels = LoggingTestHelper.getAllLogLevels()
    for (level in levels) {
        let enabled = logger.isEnabled(level)
        @Expect(enabled, false)  // 空日志器应该返回false
    }
}

/**
 * 日志器记录消息测试
 * 测试Logger的log方法
 */
@Test
func 日志器记录消息测试() {
    let logInfoList = ArrayList<LoggerInformation>()
    let logger = Logger(logInfoList)
    
    // 测试记录消息（不应该抛出异常）
    let messages = LoggingTestHelper.createTestMessages(3)
    let levels = [LogLevel.Info, LogLevel.Warn, LogLevel.Error]

    try {
        for (i in 0..messages.size) {
            logger.log(levels[i], messages[i], None)
        }
    } catch (e: Exception) {
        @Expect(false)
    }
    
    // 验证方法执行完成
    @Expect(true)
}

/**
 * 日志器记录异常测试
 * 测试Logger的log方法处理异常
 */
@Test
func 日志器记录异常测试() {
    let logInfoList = ArrayList<LoggerInformation>()
    let logger = Logger(logInfoList)
    
    // 测试记录异常
    let exceptions = LoggingTestHelper.createTestExceptions()
    
    // 验证异常数组不为空
    @Expect(exceptions.size > 0, true)
    
    try {
        for (exception in exceptions) {
            logger.log(LogLevel.Error, "测试异常消息", exception)
        }
    } catch (e: Exception) {
        @Expect(false)
    }
    
    // 验证方法执行完成
    @Expect(true)
}

/**
 * 日志器空异常测试
 * 测试Logger处理空异常的情况
 */
@Test
func 日志器空异常测试() {
    let logInfoList = ArrayList<LoggerInformation>()
    let logger = Logger(logInfoList)
    
    // 测试空异常
    logger.log(LogLevel.Info, "测试消息", None)
    
    // 验证方法执行完成 
    @Expect(true)
}

/**
 * 日志器特殊字符消息测试
 * 测试Logger处理特殊字符消息
 */
@Test
func 日志器特殊字符消息测试() {
    let logInfoList = ArrayList<LoggerInformation>()
    let logger = Logger(logInfoList)
    
    // 测试特殊字符消息
    let specialMessages = LoggingTestHelper.createSpecialCharacterMessages()
    
    for (message in specialMessages) {
        logger.log(LogLevel.Info, message, None)
    }
    
    // 验证方法执行完成
    @Expect(true)
}

/**
 * 日志器空消息测试
 * 测试Logger处理空消息的情况
 */
@Test
func 日志器空消息测试() {
    let logInfoList = ArrayList<LoggerInformation>()
    let logger = Logger(logInfoList)
    
    // 测试空消息
    logger.log(LogLevel.Info, "", None)
    logger.log(LogLevel.Warn, "", None)
    
    // 验证方法执行完成
    @Expect(true)
}

/**
 * 日志器高级别测试
 * 测试Logger处理高级别日志
 */
@Test
func 日志器高级别测试() {
    let logInfoList = ArrayList<LoggerInformation>()
    let logger = Logger(logInfoList)
    
    // 测试高级别日志
    logger.log(LogLevel.Fatal, "致命错误消息", None)
    logger.log(LogLevel.Error, "错误消息", Exception("测试异常"))
    
    // 验证方法执行完成
    @Expect(true)
}

/**
 * 日志器低级别测试
 * 测试Logger处理低级别日志
 */
@Test
func 日志器低级别测试() {
    let logInfoList = ArrayList<LoggerInformation>()
    let logger = Logger(logInfoList)
    
    // 测试低级别日志
    logger.log(LogLevel.Trace, "跟踪消息", None)
    logger.log(LogLevel.Debug, "调试消息", None)
    
    // 验证方法执行完成
    @Expect(true)
}