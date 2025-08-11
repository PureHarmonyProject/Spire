package spire_extensions_configuration.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_configuration.*
import spire_extensions_configuration.unittests.*

/**
 * 操作符重载测试
 * 测试[]操作符的获取和设置功能
 */
@Test
func 操作符重载测试() {
    let map = IgnoreCaseHashMap<String>()
    
    // 使用[]设置值
    map["ConfigKey"] = "ConfigValue"
    
    // 使用[]获取值
    @Expect(map["ConfigKey"], Some("ConfigValue"))
    @Expect(map["configkey"], Some("ConfigValue"))
    @Expect(map["CONFIGKEY"], Some("ConfigValue"))
}

/**
 * 包含检查测试
 * 测试contains方法的功能
 */
@Test
func 包含检查测试() {
    let map = IgnoreCaseHashMap<String>()
    
    map.add("DatabaseConnection", "localhost:3306")
    
    // 验证各种大小写形式
    @Expect(map.contains("DatabaseConnection"))
    @Expect(map.contains("databaseconnection"))
    @Expect(map.contains("DATABASECONNECTION"))
    @Expect(map.contains("DatabaseConnection"))
    
    // 验证不存在的键
    @Expect(!map.contains("NonExistentKey"))
    @Expect(!map.contains("nonexistentkey"))
}

/**
 * 删除功能测试
 * 测试remove方法的功能
 */
@Test
func 删除功能测试() {
    let map = IgnoreCaseHashMap<String>()
    
    map.add("TempKey", "TempValue")
    @Expect(map.contains("TempKey"))
    
    // 删除键
    let removedValue = map.remove("TempKey")
    @Expect(removedValue, Some("TempValue"))
    @Expect(!map.contains("TempKey"))
    
    // 删除不存在的键
    let nonExistent = map.remove("NonExistentKey")
    @Expect(nonExistent, None)
}

/**
 * 迭代器测试
 * 测试IgnoreCaseHashMap的迭代功能
 * 存入的键都是小写，值不变
 */
@Test
func 迭代器测试() {
    let map = IgnoreCaseHashMap<String>()
    map.add("First", "Value1")
    map.add("Second", "Value2")
    map.add("Third", "Value3")
    
    let keys = ArrayList<String>()
    let values = ArrayList<String>()
    
    for ((key, value) in map) {
        keys.add(key)
        values.add(value)
    }
    
    @Expect(keys.size, 3)
    @Expect(values.size, 3)
    @Expect(keys.contains("first"))
    @Expect(keys.contains("second"))
    @Expect(keys.contains("third"))
    @Expect(values.contains("Value1"))
    @Expect(values.contains("Value2"))
    @Expect(values.contains("Value3"))
}

/**
 * 键集合测试
 * 测试keys方法返回的键集合
 */
@Test
func 键集合测试() {
    let map = IgnoreCaseHashMap<String>()
    map.add("KeyA", "ValueA")
    map.add("KeyB", "ValueB")
    map.add("KeyC", "ValueC")
    
    let keys = map.keys()
    let keyList = ArrayList<String>(keys)
    
    @Expect(keyList.size, 3)
    @Expect(keyList.contains("keya"))
    @Expect(keyList.contains("keyb"))
    @Expect(keyList.contains("keyc"))
}

/**
 * 值集合测试
 * 测试values方法返回的值集合
 */
@Test
func 值集合测试() {
    let map = IgnoreCaseHashMap<String>()
    map.add("Key1", "Value1")
    map.add("Key2", "Value2")
    map.add("Key3", "Value3")
    
    let values = map.values()
    let valueList = ArrayList<String>(values)
    
    @Expect(valueList.size, 3)
    @Expect(valueList.contains("Value1"))
    @Expect(valueList.contains("Value2"))
    @Expect(valueList.contains("Value3"))
}

/**
 * 条目集合测试
 * 测试entries方法返回的键值对集合
 */
@Test
func 条目集合测试() {
    let map = IgnoreCaseHashMap<String>()
    map.add("Entry1", "Data1")
    map.add("Entry2", "Data2")
    
    let entryList = ArrayList<(String, String)>()
    for ((key, value) in map) {
        entryList.add((key, value))
    }
    
    @Expect(entryList.size, 2)
    
    // 验证所有条目都存在
    var foundEntry1 = false
    var foundEntry2 = false
    
    for ((key, value) in entryList) {
        if (key == "entry1" && value == "Data1") {
            foundEntry1 = true
        }
        if (key == "entry2" && value == "Data2") {
            foundEntry2 = true
        }
    }
    
    @Expect(foundEntry1)
    @Expect(foundEntry2)
}

/**
 * 原始键保留测试（不支持原始键保留）
 * 验证原始键格式被正确保留
 */
// @Test
// func 原始键保留测试() {
//     let map = IgnoreCaseHashMap<String>()
    
//     // 添加不同格式的键
//     map.add("CamelCaseKey", "Value1")
//     map.add("snake_case_key", "Value2")
//     map.add("kebab-case-key", "Value3")
//     map.add("UPPERCASE_KEY", "Value4")
    
//     // 验证迭代时返回的是原始键
//     var foundCamelCase = false
//     var foundSnakeCase = false
//     var foundKebabCase = false
//     var foundUpperCase = false
    
//     for ((key, value) in map) {
//         if (key == "CamelCaseKey" && value == "Value1") {
//             foundCamelCase = true
//         }
//         if (key == "snake_case_key" && value == "Value2") {
//             foundSnakeCase = true
//         }
//         if (key == "kebab-case-key" && value == "Value3") {
//             foundKebabCase = true
//         }
//         if (key == "UPPERCASE_KEY" && value == "Value4") {
//             foundUpperCase = true
//         }
//     }
    
//     @Expect(foundCamelCase)
//     @Expect(foundSnakeCase)
//     @Expect(foundKebabCase)
//     @Expect(foundUpperCase)
// }

/**
 * 键更新测试
 * 测试更新已存在键的值
 */
@Test
func 键更新测试() {
    let map = IgnoreCaseHashMap<String>()
    
    map.add("UpdateKey", "OriginalValue")
    @Expect(map.get("UpdateKey"), Some("OriginalValue"))
    
    // 更新值
    map.add("UpdateKey", "UpdatedValue")
    @Expect(map.get("UpdateKey"), Some("UpdatedValue"))
    
    // 使用不同大小写更新
    map.add("updatekey", "AnotherUpdatedValue")
    @Expect(map.get("UpdateKey"), Some("AnotherUpdatedValue"))
}

/**
 * 空键处理测试
 * 测试对空字符串键的处理
 */
@Test
func 空键处理测试() {
    let map = IgnoreCaseHashMap<String>()
    
    map.add("", "EmptyKeyValue")
    @Expect(map.get(""), Some("EmptyKeyValue"))
    @Expect(map.contains(""))
    @Expect(!map.isEmpty())
    
    let removedValue = map.remove("")
    @Expect(removedValue, Some("EmptyKeyValue"))
    @Expect(map.get(""), None)
    @Expect(!map.contains(""))
}

/**
 * 特殊字符键测试
 * 测试包含特殊字符的键
 */
@Test
func 特殊字符键测试() {
    let map = IgnoreCaseHashMap<String>()
    let specialData = TestHelper.createSpecialCharData()
    
    for ((key, value) in specialData) {
        map.add(key, value)
    }
    
    // 验证特殊字符键的访问
    @Expect(map.get("key with spaces"), Some("space_value"))
    @Expect(map.get("key-with-dashes"), Some("dash_value"))
    @Expect(map.get("key_with_underscores"), Some("underscore_value"))
    @Expect(map.get("key.with.dots"), Some("dot_value"))
    @Expect(map.get("key@with@symbols"), Some("symbol_value"))
    @Expect(map.get("key:with:colons"), Some("colon_value"))
}