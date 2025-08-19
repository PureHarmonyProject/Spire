package spire_extensions_caching.unittests

import std.collection.*
import std.time.*
import spire_extensions_caching.*

/**
 * 测试辅助类
 * 提供测试过程中常用的辅助方法和测试数据
 */
class TestHelper {
    
    /**
     * 创建测试用的字节数组
     * @param data 要转换的字符串数据
     * @return 字节数组
     */
    public static func createTestData(data: String): Array<Byte> {
        return data.toArray()
    }
    
    /**
     * 创建多个测试数据
     * @param count 要创建的数据数量
     * @return 包含测试数据的HashMap
     */
    public static func createMultipleTestData(count: Int64): HashMap<String, Array<Byte>> {
        let data = HashMap<String, Array<Byte>>()
        for (i in 1..count + 1) {
            let key = "test_key_${i}"
            let value = "test_value_${i}"
            data[key] = value.toArray()
        }
        return data
    }
    
    /**
     * 创建字符串测试数据
     * @param count 要创建的数据数量
     * @return 包含字符串测试数据的HashMap
     */
    public static func createStringTestData(count: Int64): HashMap<String, String> {
        let data = HashMap<String, String>()
        for (i in 1..count + 1) {
            let key = "string_key_${i}"
            let value = "string_value_${i}"
            data[key] = value
        }
        return data
    }
    
    /**
     * 创建特殊字符键的测试数据
     * @return 包含特殊字符键的测试数据
     */
    public static func createSpecialCharTestData(): HashMap<String, Array<Byte>> {
        let data = HashMap<String, Array<Byte>>()
        data["key-with-dashes"] = "dash_value".toArray()
        data["key_with_underscores"] = "underscore_value".toArray()
        data["key.with.dots"] = "dot_value".toArray()
        data["key with spaces"] = "space_value".toArray()
        data["key@with@symbols"] = "symbol_value".toArray()
        data["key:with:colons"] = "colon_value".toArray()
        data[""] = "empty_key_value".toArray()
        return data
    }
    
    /**
     * 创建滑动过期配置
     * @param seconds 过期秒数
     * @return DistributedCacheEntryOptions
     */
    public static func createSlidingExpirationOptions(seconds: Int64): DistributedCacheEntryOptions {
        return DistributedCacheEntryOptions(
            slidingExpiration: Some(Duration.second * seconds)
        )
    }
    
    /**
     * 创建绝对过期配置
     * @param seconds 从现在开始的过期秒数
     * @return DistributedCacheEntryOptions
     */
    public static func createAbsoluteExpirationOptions(seconds: Int64): DistributedCacheEntryOptions {
        return DistributedCacheEntryOptions(
            absoluteExpirationRelativeToNow: Some(Duration.second * seconds)
        )
    }
    
    /**
     * 创建混合过期配置
     * @param slidingSeconds 滑动过期秒数
     * @param absoluteSeconds 绝对过期秒数
     * @return DistributedCacheEntryOptions
     */
    public static func createMixedExpirationOptions(slidingSeconds: Int64, absoluteSeconds: Int64): DistributedCacheEntryOptions {
        return DistributedCacheEntryOptions(
            slidingExpiration: Some(Duration.second * slidingSeconds),
            absoluteExpirationRelativeToNow: Some(Duration.second * absoluteSeconds)
        )
    }
    
    /**
     * 创建特定时间的绝对过期配置
     * @param expirationTime 过期时间
     * @return DistributedCacheEntryOptions
     */
    public static func createAbsoluteExpirationAtOptions(expirationTime: DateTime): DistributedCacheEntryOptions {
        return DistributedCacheEntryOptions(
            absoluteExpiration: Some(expirationTime)
        )
    }
    
    /**
     * 生成随机字符串
     * @param length 字符串长度
     * @return 随机字符串
     */
    public static func generateRandomString(length: Int64): String {
        let chars = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let charArray = ArrayList<String>()

        for (i in 0..length) {
            let randomIndex = (i * 31) % chars.size
            charArray.add(chars[randomIndex])
        }
        
        return String.join(charArray |> collectArray, delimiter: "")
    }
    
    /**
     * 生成随机字节数组
     * @param length 数组长度
     * @return 随机字节数组
     */
    public static func generateRandomBytes(length: Int64): Array<Byte> {
        return generateRandomString(length).toArray()
    }
}