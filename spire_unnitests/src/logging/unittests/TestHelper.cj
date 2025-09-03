package spire_unnitests.logging.unittests

import std.collection.*
import spire_extensions_logging.*

/**
 * Logging Test Helper
 * Provides helper methods and test data for testing
 */
class LoggingTestHelper {
    /**
     * 创建测试用的日志级别数组
     * @return 包含所有日志级别的数组
     */
    public static func getAllLogLevels(): Array<LogLevel> {
        return [
            LogLevel.Trace,
            LogLevel.Debug, 
            LogLevel.Info,
            LogLevel.Warn,
            LogLevel.Error,
            LogLevel.Fatal,
            LogLevel.Off
        ]
    }
    
    /**
     * 创建测试用的日志消息
     * @param count 要创建的消息数量
     * @return 包含测试消息的数组
     */
    public static func createTestMessages(count: Int64): Array<String> {
        let messages = ArrayList<String>()
        for (i in 1..count + 1) {
            messages.add("测试消息_${i}")
        }
        return messages.toArray()
    }
    
    /**
     * 创建测试用的日志器名称
     * @return 包含测试名称的数组
     */
    public static func createTestNames(): Array<String> {
        return [
            "测试日志器",
            "TestLogger",
            "com.example.test",
            "system.core",
            "database.connection",
            "api.controller"
        ]
    }
    
    /**
     * 创建测试用的异常
     * @return 包含测试异常的数组
     */
    public static func createTestExceptions(): Array<Exception> {
        return [
            Exception("测试异常1"),
            Exception("空指针异常"),
            Exception("数组越界异常"),
            Exception("网络连接异常")
        ]
    }
    
    /**
     * 验证日志级别比较结果
     * @param level1 第一个日志级别
     * @param level2 第二个日志级别
     * @param expected 期望的比较结果
     * @return 是否符合期望
     */
    public static func verifyLevelComparison(level1: LogLevel, level2: LogLevel, expected: Ordering): Bool {
        return level1.compare(level2) == expected
    }
    
    /**
     * 创建包含特殊字符的测试消息
     * @return 包含特殊字符的消息数组
     */
    public static func createSpecialCharacterMessages(): Array<String> {
        return [
            "消息包含中文",
            "Message with English",
            "消息包含特殊符号: @#$%",
            "换行符测试\n第二行",
            "制表符测试\t制表内容",
            "引号测试\"双引号\"'单引号'",
            "路径测试 C:\\Windows\\System32",
            "URL测试 https://www.example.com"
        ]
    }
    
    /**
     * 创建空值测试数据
     * @return 包含空值的测试数据
     */
    public static func createEmptyValueTestData(): HashMap<String, ?String> {
        let data = HashMap<String, ?String>()
        data["null_message"] = None
        data["valid_message"] = "有效消息"
        data["empty_message"] = ""
        return data
    }

}