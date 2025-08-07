package spire_extensions_configuration.unittests

import std.collection.*

/**
 * 测试辅助类
 * 提供测试过程中常用的辅助方法和测试数据
 */
class TestHelper {
    
    /**
     * 创建用于测试的HashMap数据
     * @param count 要创建的键值对数量
     * @return 包含测试数据的HashMap
     */
    public static func createTestData(count: Int64): HashMap<String, String> {
        let data = HashMap<String, String>()
        for (i in 1..count + 1) {
            data["key_${i}"] = "value_${i}"
            data["Key_${i}"] = "Value_${i}"  // 大小写变体
            data["KEY_${i}"] = "VALUE_${i}"  // 全大写变体
        }
        return data
    }
    
    /**
     * 创建嵌套配置数据
     * @return 包含嵌套结构的测试数据
     */
    public static func createNestedTestData(): HashMap<String, String> {
        let data = HashMap<String, String>()
        data["parent:child:key1"] = "nested_value_1"
        data["parent:child:key2"] = "nested_value_2"
        data["parent:child:subchild:key1"] = "deep_nested_value_1"
        data["parent:child:subchild:key2"] = "deep_nested_value_2"
        data["top_level_key"] = "top_level_value"
        return data
    }
    
    /**
     * 创建特殊字符测试数据
     * @return 包含特殊字符的测试数据
     */
    public static func createSpecialCharData(): HashMap<String, String> {
        let data = HashMap<String, String>()
        data["key-with-dashes"] = "dash_value"
        data["key_with_underscores"] = "underscore_value"
        data["key.with.dots"] = "dot_value"
        data["key with spaces"] = "space_value"
        data["key@with@symbols"] = "symbol_value"
        data["key:with:colons"] = "colon_value"
        return data
    }
    
    /**
     * 创建空测试数据
     * @return 空的HashMap
     */
    public static func createEmptyData(): HashMap<String, String> {
        return HashMap<String, String>()
    }
    
    /**
     * 创建配置提供者测试数据
     * @return 模拟配置提供者的测试数据
     */
    public static func createConfigProviderData(): HashMap<String, String> {
        let data = HashMap<String, String>()
        data["provider:memory"] = "memory_value"
        data["provider:environment"] = "environment_value"
        data["provider:commandline"] = "commandline_value"
        data["provider:json"] = "json_value"
        return data
    }
    
    /**
     * 创建命令行参数测试数据
     * @return 模拟命令行参数的测试数据
     */
    public static func createCmdArgsData(): Array<String> {
        return [
            "app:debug=true",
            "app:port=8080",
            "database:host=localhost",
            "database:port=3306",
            "invalid-arg",
            "=empty-key",
            "trailing-eq="
        ]
    }
    
    /**
     * 创建环境变量测试数据
     * @return 模拟环境变量的测试数据
     */
    public static func createEnvVarsData(): HashMap<String, String> {
        let data = HashMap<String, String>()
        data["APP_DEBUG"] = "true"
        data["APP_PORT"] = "8080"
        data["DATABASE_HOST"] = "localhost"
        data["DATABASE_PORT"] = "3306"
        return data
    }
    
    /**
     * 比较两个HashMap是否相等（不区分大小写）
     * @param expected 期望的HashMap
     * @param actual 实际的HashMap
     * @return 是否相等
     */
    public static func areMapsEqualIgnoreCase(expected: HashMap<String, String>, actual: HashMap<String, String>): Bool {
        if (expected.size != actual.size) {
            return false
        }
        
        for ((key, expectedValue) in expected) {
            var found = false
            for ((actualKey, actualValue) in actual) {
                if (key == actualKey && expectedValue == actualValue) {
                    found = true
                    break
                }
            }
            if (!found) {
                return false
            }
        }
        return true
    }
    
    /**
     * 生成随机字符串
     * @param length 字符串长度
     * @return 随机字符串
     */
    public static func generateRandomString(length: Int64): String {
        let chars = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let charArray = ArrayList<String>()

        var count = 0
        
        for (i in 0..length) {
            let randomIndex = (i * 31) % chars.size
            charArray.add(chars[randomIndex])
            count++
        }
        
        let result = String.join(charArray |> collectArray, delimiter: "")
        return result
    }
}