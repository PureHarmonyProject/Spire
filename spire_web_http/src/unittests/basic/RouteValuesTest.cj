package spire_web_http.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import spire_web_http.*
import spire_web_http.unittests.*
import std.collection.*

/**
 * RouteValues构造函数测试
 * 测试RouteValues的构造函数和基本属性
 */
@Test
func RouteValues构造函数测试() {
    // 测试无参构造函数
    let routeValues1 = RouteValues()
    @Expect(routeValues1.isEmpty(), true)
    @Expect(routeValues1.size, 0)
    
    // 测试带集合参数的构造函数
    let testData = ArrayList<(String, String)>()
    testData.add(("id", "123"))
    testData.add(("name", "test"))
    testData.add(("action", "update"))
    
    let routeValues2 = RouteValues(testData)
    @Expect(routeValues2.isEmpty(), false)
    @Expect(routeValues2.size, 3)
    @Expect(routeValues2["id"], "123")
    @Expect(routeValues2["name"], "test")
    @Expect(routeValues2["action"], "update")
}

/**
 * RouteValues操作符重载测试
 * 测试[]操作符的获取和设置功能
 */
@Test
func RouteValues操作符重载测试() {
    let routeValues = RouteValues()
    
    // 使用[]设置值
    routeValues["id"] = "123"
    routeValues["name"] = "testuser"
    routeValues["action"] = "update"
    
    // 使用[]获取值
    @Expect(routeValues["id"], "123")
    @Expect(routeValues["name"], "testuser")
    @Expect(routeValues["action"], "update")
    
    // 测试不存在的键
    @Expect(!routeValues.contains("nonexistent"))
}

/**
 * RouteValues添加方法测试
 * 测试add方法的各种重载
 */
@Test
func RouteValues添加方法测试() {
    let routeValues = RouteValues()
    
    // 测试单个键值对添加
    routeValues.add("id", "123")
    @Expect(routeValues["id"], "123")
    @Expect(routeValues.size, 1)
    
    // 测试多个键值对添加
    let moreData = ArrayList<(String, String)>()
    moreData.add(("name", "test"))
    moreData.add(("category", "users"))
    routeValues.add(all: moreData)
    
    @Expect(routeValues["name"], "test")
    @Expect(routeValues["category"], "users")
    @Expect(routeValues.size, 3)
    
    // 测试更新现有键
    routeValues.add("id", "456")
    @Expect(routeValues["id"], "456")
    @Expect(routeValues.size, 3)  // 大小不应改变
}

/**
 * RouteValues获取方法测试
 * 测试get方法的获取功能
 */
@Test
func RouteValues获取方法测试() {
    let routeValues = RouteValues()
    routeValues.add("id", "123")
    routeValues.add("name", "test")
    
    // 测试获取存在的键
    @Expect(routeValues.get("id"), "123")
    @Expect(routeValues.get("name"), "test")
    
    // 测试获取不存在的键
    @Expect(!routeValues.contains("nonexistent"))
    @Expect(!routeValues.contains(""))
}

/**
 * RouteValues包含方法测试
 * 测试contains方法的各种重载
 */
@Test
func RouteValues包含方法测试() {
    let routeValues = RouteValues()
    routeValues.add("id", "123")
    routeValues.add("name", "test")
    routeValues.add("action", "update")
    
    // 测试单个键的包含检查
    @Expect(routeValues.contains("id"))
    @Expect(routeValues.contains("name"))
    @Expect(routeValues.contains("action"))
    @Expect(!routeValues.contains("nonexistent"))
    @Expect(!routeValues.contains(""))
    
    // 测试多个键的包含检查
    let keysToCheck = ArrayList<String>()
    keysToCheck.add("id")
    keysToCheck.add("name")
    @Expect(routeValues.contains(all: keysToCheck))
    
    let missingKeys = ArrayList<String>()
    missingKeys.add("id")
    missingKeys.add("nonexistent")
    @Expect(!routeValues.contains(all: missingKeys))
}

/**
 * RouteValues删除方法测试
 * 测试remove方法的各种重载
 */
@Test
func RouteValues删除方法测试() {
    let routeValues = RouteValues()
    routeValues.add("id", "123")
    routeValues.add("name", "test")
    routeValues.add("action", "update")
    
    // 测试删除单个键
    let removedValue = routeValues.remove("id")
    @Expect(removedValue, "123")
    @Expect(!routeValues.contains("id"))
    @Expect(routeValues.size, 2)
    
    // 测试删除不存在的键
    let nonExistent = routeValues.remove("nonexistent")
    @Expect(!routeValues.contains("nonexistent"))
    @Expect(routeValues.size, 2)
    
    // 测试删除多个键
    let keysToRemove = ArrayList<String>()
    keysToRemove.add("name")
    keysToRemove.add("action")
    routeValues.remove(all: keysToRemove)
    @Expect(!routeValues.contains("name"))
    @Expect(!routeValues.contains("action"))
    @Expect(routeValues.isEmpty(), true)
}

/**
 * RouteValues清空方法测试
 * 测试clear方法的功能
 */
@Test
func RouteValues清空方法测试() {
    let routeValues = RouteValues()
    routeValues.add("id", "123")
    routeValues.add("name", "test")
    routeValues.add("action", "update")
    
    @Expect(!routeValues.isEmpty())
    @Expect(routeValues.size, 3)
    
    // 清空所有数据
    routeValues.clear()
    
    @Expect(routeValues.isEmpty())
    @Expect(routeValues.size, 0)
    @Expect(!routeValues.contains("id"))
    @Expect(!routeValues.contains("name"))
    @Expect(!routeValues.contains("action"))
}

/**
 * RouteValues迭代器测试
 * 测试RouteValues的迭代功能
 */
@Test
func RouteValues迭代器测试() {
    let routeValues = RouteValues()
    routeValues.add("first", "value1")
    routeValues.add("second", "value2")
    routeValues.add("third", "value3")
    
    let keys = ArrayList<String>()
    let values = ArrayList<String>()
    
    // 测试迭代
    for ((key, value) in routeValues) {
        keys.add(key)
        values.add(value)
    }
    
    @Expect(keys.size, 3)
    @Expect(values.size, 3)
    @Expect(keys.contains("first"))
    @Expect(keys.contains("second"))
    @Expect(keys.contains("third"))
    @Expect(values.contains("value1"))
    @Expect(values.contains("value2"))
    @Expect(values.contains("value3"))
}

/**
 * RouteValues键集合测试
 * 测试keys方法返回的键集合
 */
@Test
func RouteValues键集合测试() {
    let routeValues = RouteValues()
    routeValues.add("KeyA", "ValueA")
    routeValues.add("KeyB", "ValueB")
    routeValues.add("KeyC", "ValueC")
    
    let keys = routeValues.keys()
    let keyList = ArrayList<String>(keys)
    
    @Expect(keyList.size, 3)
    @Expect(keyList.contains("KeyA"))
    @Expect(keyList.contains("KeyB"))
    @Expect(keyList.contains("KeyC"))
}

/**
 * RouteValues值集合测试
 * 测试values方法返回的值集合
 */
@Test
func RouteValues值集合测试() {
    let routeValues = RouteValues()
    routeValues.add("Key1", "Value1")
    routeValues.add("Key2", "Value2")
    routeValues.add("Key3", "Value3")
    
    let values = routeValues.values()
    let valueList = ArrayList<String>(values)
    
    @Expect(valueList.size, 3)
    @Expect(valueList.contains("Value1"))
    @Expect(valueList.contains("Value2"))
    @Expect(valueList.contains("Value3"))
}

/**
 * RouteValues条目视图测试
 * 测试entryView方法的功能
 */
@Test
func RouteValues条目视图测试() {
    let routeValues = RouteValues()
    routeValues.add("testKey", "testValue")
    
    let entryView = routeValues.entryView("testKey")
    // 注意：entryView的具体行为取决于实现，这里主要测试不抛出异常
    @Expect(routeValues.contains("testKey"))
    @Expect(routeValues.get("testKey"), "testValue")
}

/**
 * RouteValues条件删除测试
 * 测试removeIf方法的功能
 */
@Test
func RouteValues条件删除测试() {
    let routeValues = RouteValues()
    routeValues.add("keep1", "value1")
    routeValues.add("remove1", "value2")
    routeValues.add("keep2", "value3")
    routeValues.add("remove2", "value4")

    // 删除键名包含"remove"的条目
    func shouldRemove(key: String, value: String): Bool {
        return key.contains("remove")
    }

    routeValues.removeIf(shouldRemove)
    
    @Expect(routeValues.size, 2)
    @Expect(routeValues.contains("keep1"))
    @Expect(routeValues.contains("keep2"))
    @Expect(!routeValues.contains("remove1"))
    @Expect(!routeValues.contains("remove2"))
}

/**
 * RouteValues测试数据验证测试
 * 使用TestHelper中的测试数据进行验证
 */
@Test
func RouteValues测试数据验证测试() {
    let testData = TestHelper.createRouteValuesData()
    let routeValues = RouteValues()
    
    // 添加测试数据
    for ((key, value) in testData) {
        routeValues.add(key, value)
    }
    
    // 验证数据完整性
    @Expect(routeValues.size, testData.size)
    
    for ((key, expectedValue) in testData) {
        @Expect(routeValues.contains(key))
        @Expect(routeValues.get(key), expectedValue)
        @Expect(routeValues[key], expectedValue)
    }
}


/**
 * RouteValues大小属性测试
 * 测试size属性的准确性
 */
@Test
func RouteValues大小属性测试() {
    let routeValues = RouteValues()
    
    // 测试空集合
    @Expect(routeValues.size, 0)
    @Expect(routeValues.isEmpty(), true)
    
    // 测试添加元素
    routeValues.add("key1", "value1")
    @Expect(routeValues.size, 1)
    @Expect(!routeValues.isEmpty())
    
    routeValues.add("key2", "value2")
    @Expect(routeValues.size, 2)
    
    // 测试更新元素（大小不应改变）
    routeValues.add("key1", "newvalue1")
    @Expect(routeValues.size, 2)
    
    // 测试删除元素
    routeValues.remove("key1")
    @Expect(routeValues.size, 1)
    
    routeValues.remove("key2")
    @Expect(routeValues.size, 0)
    @Expect(routeValues.isEmpty(), true)
}

/**
 * RouteValues键更新测试
 * 测试更新已存在键的值
 */
@Test
func RouteValues键更新测试() {
    let routeValues = RouteValues()
    
    // 添加初始值
    routeValues.add("updateKey", "OriginalValue")
    @Expect(routeValues.get("updateKey"), "OriginalValue")
    
    // 更新值
    routeValues.add("updateKey", "UpdatedValue")
    @Expect(routeValues.get("updateKey"), "UpdatedValue")
    
    // 使用操作符更新
    routeValues["updateKey"] = "AnotherUpdatedValue"
    @Expect(routeValues["updateKey"], "AnotherUpdatedValue")
    
    // 验证大小不变
    @Expect(routeValues.size, 1)
}


/**
 * RouteValues实际应用场景测试
 * 测试实际应用中常见的路由值场景
 */
@Test
func RouteValues实际应用场景测试() {
    let routeValues = RouteValues()
    
    // 模拟RESTful API路由值
    routeValues.add("controller", "users")
    routeValues.add("action", "get")
    routeValues.add("id", "123")
    routeValues.add("format", "json")
    
    @Expect(routeValues["controller"], "users")
    @Expect(routeValues["action"], "get")
    @Expect(routeValues["id"], "123")
    @Expect(routeValues["format"], "json")
    @Expect(routeValues.size, 4)
    
    // 模拟分页路由值
    let pagingValues = RouteValues()
    pagingValues.add("page", "1")
    pagingValues.add("limit", "10")
    pagingValues.add("sort", "name")
    pagingValues.add("order", "asc")
    
    @Expect(pagingValues["page"], "1")
    @Expect(pagingValues["limit"], "10")
    @Expect(pagingValues["sort"], "name")
    @Expect(pagingValues["order"], "asc")
    @Expect(pagingValues.size, 4)
}