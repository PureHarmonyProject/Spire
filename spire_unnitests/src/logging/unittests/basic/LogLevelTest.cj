package spire_unnitests.logging.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import spire_extensions_logging.*
import spire_extensions_logging.unittests.*

/**
 * 日志级别基本功能测试
 * 测试LogLevel枚举的基本功能
 */
@Test
func 日志级别基本功能测试() {
    let levels = LoggingTestHelper.getAllLogLevels()
    
    // 验证所有日志级别都能正常创建
    @Expect(levels.size, 7)
    
    // 验证日志级别的toString功能
    @Expect(LogLevel.Trace.toString(), "trace")
    @Expect(LogLevel.Debug.toString(), "debug")
    @Expect(LogLevel.Info.toString(), "info")
    @Expect(LogLevel.Warn.toString(), "warn")
    @Expect(LogLevel.Error.toString(), "error")
    @Expect(LogLevel.Fatal.toString(), "fatal")
    @Expect(LogLevel.Off.toString(), "off")
}

/**
 * 日志级别比较测试
 * 测试LogLevel的比较功能
 */
@Test
func 日志级别比较测试() {
    // 验证Trace级别最低
    @Expect(LogLevel.Trace.compare(LogLevel.Debug), Ordering.LT)
    @Expect(LogLevel.Trace.compare(LogLevel.Info), Ordering.LT)
    @Expect(LogLevel.Trace.compare(LogLevel.Fatal), Ordering.LT)
    
    // 验证Fatal级别较高
    @Expect(LogLevel.Fatal.compare(LogLevel.Error), Ordering.GT)
    @Expect(LogLevel.Fatal.compare(LogLevel.Warn), Ordering.GT)
    @Expect(LogLevel.Fatal.compare(LogLevel.Trace), Ordering.GT)
    
    // 验证相同级别比较
    @Expect(LogLevel.Info.compare(LogLevel.Info), Ordering.EQ)
    @Expect(LogLevel.Error.compare(LogLevel.Error), Ordering.EQ)
    
    // 验证Off级别最高
    @Expect(LogLevel.Off.compare(LogLevel.Fatal), Ordering.GT)
    @Expect(LogLevel.Off.compare(LogLevel.Trace), Ordering.GT)
    
    // 验证相邻级别比较
    @Expect(LogLevel.Trace.compare(LogLevel.Debug), Ordering.LT)
    @Expect(LogLevel.Debug.compare(LogLevel.Info), Ordering.LT)
    @Expect(LogLevel.Info.compare(LogLevel.Warn), Ordering.LT)
    @Expect(LogLevel.Warn.compare(LogLevel.Error), Ordering.LT)
    @Expect(LogLevel.Error.compare(LogLevel.Fatal), Ordering.LT)
    @Expect(LogLevel.Fatal.compare(LogLevel.Off), Ordering.LT)
}

/**
 * 日志级别值测试
 * 测试LogLevel的内部值映射
 */
@Test
func 日志级别值测试() {
    // 验证日志级别对应的数值
    @Expect(LogLevel.Trace.compare(LogLevel.Trace), Ordering.EQ)  // 0
    @Expect(LogLevel.Debug.compare(LogLevel.Debug), Ordering.EQ)  // 1
    @Expect(LogLevel.Info.compare(LogLevel.Info), Ordering.EQ)    // 2
    @Expect(LogLevel.Warn.compare(LogLevel.Warn), Ordering.EQ)    // 3
    @Expect(LogLevel.Error.compare(LogLevel.Error), Ordering.EQ)  // 4
    @Expect(LogLevel.Fatal.compare(LogLevel.Fatal), Ordering.EQ)  // 5
    @Expect(LogLevel.Off.compare(LogLevel.Off), Ordering.EQ)      // 6
}

/**
 * 日志级别边界条件测试
 * 测试LogLevel的边界条件处理
 */
@Test
func 日志级别边界条件测试() {
    // 验证最小级别
    let minLevel = LogLevel.Trace
    let allLevels = LoggingTestHelper.getAllLogLevels()
    
    for (level in allLevels) {
        if (level != minLevel) {
            @Expect(minLevel.compare(level), Ordering.LT)
        }
    }
    
    // 验证最大级别
    let maxLevel = LogLevel.Off
    for (level in allLevels) {
        if (level != maxLevel) {
            @Expect(maxLevel.compare(level), Ordering.GT)
        }
    }
}

/**
 * 日志级别模式匹配测试
 * 测试LogLevel的模式匹配功能
 */
@Test
func 日志级别模式匹配测试() {
    let testLevel = LogLevel.Info
    let result = match (testLevel) {
        case LogLevel.Trace => "trace"
        case LogLevel.Debug => "debug" 
        case LogLevel.Info => "info"
        case LogLevel.Warn => "warn"
        case LogLevel.Error => "error"
        case LogLevel.Fatal => "fatal"
        case LogLevel.Off => "off"
    }
    
    @Expect(result, "info")
}