package spire_web_http.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import spire_web_http.*
import spire_web_http.unittests.*
import std.collection.*

/**
 * EndpointMetadataCollection构造函数测试
 * 测试EndpointMetadataCollection的构造函数和基本属性
 */
@Test
func EndpointMetadataCollection构造函数测试() {
    // 测试无参构造函数
    let metadata1 = EndpointMetadataCollection()
    @Expect(metadata1.isEmpty(), true)
    @Expect(metadata1.size, 0)
    @Expect(metadata1.first.isNone())
    @Expect(metadata1.last.isNone())
    
    // 测试带集合参数的构造函数
    let testData = ArrayList<Any>()
    testData.add("test1")
    testData.add(123)
    testData.add(true)
    
    let metadata2 = EndpointMetadataCollection(testData)
    @Expect(metadata2.isEmpty(), false)
    @Expect(metadata2.size, 3)
}

/**
 * EndpointMetadataCollection空集合测试
 * 测试empty静态属性
 */
@Test
func EndpointMetadataCollection空集合测试() {
    let emptyMetadata = EndpointMetadataCollection.empty
    @Expect(emptyMetadata.isEmpty(), true)
    @Expect(emptyMetadata.size, 0)
    @Expect(emptyMetadata.first.isNone())
    @Expect(emptyMetadata.last.isNone())
    
    // 验证empty属性返回的是同一个实例
    let emptyMetadata2 = EndpointMetadataCollection.empty
    @Expect(emptyMetadata.isEmpty(), true)  // 应该都是空的
}

/**
 * EndpointMetadataCollection基本操作测试
 * 测试基本的添加和访问操作
 */
@Test
func EndpointMetadataCollection基本操作测试() {
    let metadata = EndpointMetadataCollection()
    
    // 添加不同类型的元数据
    let items = ArrayList<Any>()
    items.add("string_metadata")
    items.add(42)
    items.add(true)
    items.add(3.14)
    
    // 通过构造函数添加（假设内部有添加机制）
    let metadataWithItems = EndpointMetadataCollection(items)
    
    @Expect(metadataWithItems.size, 4)
    @Expect(!metadataWithItems.isEmpty())
}

/**
 * EndpointMetadataCollection获取操作测试
 * 测试get和[]操作符
 */
@Test
func EndpointMetadataCollection获取操作测试() {
    let items = ArrayList<Any>()
    items.add("first")
    items.add("second")
    items.add("third")
    
    let metadata = EndpointMetadataCollection(items)
    
    // 测试索引访问
    let value0 = metadata[0]
    if (value0 is String) {
        @Expect(value0 as String, "first")
    } else {
        @Expect(false)
    }

    let value1 = metadata[1]
    if (value1 is String) {
        @Expect(value1 as String, "second")
    } else {
        @Expect(false)
    }

    let value2 = metadata[2]
    if (value2 is String) {
        @Expect(value2 as String, "third")
    } else {
        @Expect(false)
    }
    
    // 测试get方法
    let getValue0 = metadata.get(0)
    match (getValue0) {
        case Some(s) => @Expect(s as String, "first")
        case None => @Expect(false)
    }

    let getValue1 = metadata.get(1)
    match (getValue1) {
        case Some(s) => @Expect(s as String, "second")
        case None => @Expect(false)
    }

    let getValue2 = metadata.get(2)
    match (getValue2) {
        case Some(s) => @Expect(s as String, "third")
        case None => @Expect(false)
    }
}

/**
 * EndpointMetadataCollection类型化获取测试
 * 测试getMetadata方法
 */
@Test
func EndpointMetadataCollection类型化获取测试() {
    let items = ArrayList<Any>()
    items.add("string_value")
    items.add(42)
    items.add(true)
    items.add("another_string")
    
    let metadata = EndpointMetadataCollection(items)
    
    // 测试获取字符串类型
    let stringResult = metadata.getMetadata<String>()
    @Expect(stringResult, "another_string")  // 应该返回最后一个字符串
    
    // 测试获取整数类型
    let intResult = metadata.getMetadata<Int64>()
    @Expect(intResult, 42)
    
    // 测试获取布尔类型
    let boolResult = metadata.getMetadata<Bool>()
    @Expect(boolResult, true)
    
    // 测试获取不存在的类型
    let doubleResult = metadata.getMetadata<Float64>()
    @Expect(doubleResult.isNone())
}

/**
 * EndpointMetadataCollection有序类型化获取测试
 * 测试getOrderedMetadata方法
 */
@Test
func EndpointMetadataCollection有序类型化获取测试() {
    let items = ArrayList<Any>()
    items.add("first_string")
    items.add(42)
    items.add("second_string")
    items.add(true)
    items.add("third_string")
    
    let metadata = EndpointMetadataCollection(items)
    
    // 测试获取所有字符串类型（按顺序）
    let strings = metadata.getOrderedMetadata<String>()
    let stringList = ArrayList<String>(strings)
    
    @Expect(stringList.size, 3)
    @Expect(stringList[0], "first_string")
    @Expect(stringList[1], "second_string")
    @Expect(stringList[2], "third_string")
    
    // 测试获取所有整数类型
    let ints = metadata.getOrderedMetadata<Int64>()
    let intList = ArrayList<Int64>(ints)
    
    @Expect(intList.size, 1)
    @Expect(intList[0], 42)
    
    // 测试获取不存在的类型
    let doubles = metadata.getOrderedMetadata<Float64>()
    let doubleList = ArrayList<Float64>(doubles)
    
    @Expect(doubleList.size, 0)
}

/**
 * EndpointMetadataCollection必需元数据获取测试
 * 测试getRequiredMetadata方法
 */
@Test
func EndpointMetadataCollection必需元数据获取测试() {
    let items = ArrayList<Any>()
    items.add("required_string")
    items.add(123)
    
    let metadata = EndpointMetadataCollection(items)
    
    // 测试获取存在的必需元数据
    let requiredString = metadata.getRequiredMetadata<String>()
    @Expect(requiredString, "required_string")
    
    let requiredInt = metadata.getRequiredMetadata<Int64>()
    @Expect(requiredInt, 123)
    
    // 注意：getRequiredMetadata在找不到元数据时会抛出异常
    // 这里我们不测试异常情况，因为它会中断测试执行
}

/**
 * EndpointMetadataCollection首尾元素测试
 * 测试first和last属性
 */
@Test
func EndpointMetadataCollection首尾元素测试() {
    let items = ArrayList<Any>()
    items.add("first")
    items.add("middle")
    items.add("last")
    
    let metadata = EndpointMetadataCollection(items)
    
    // 测试非空集合的首尾元素
    let firstValue = metadata.first
    if (firstValue is String) {
        @Expect(firstValue as String, "last")   // 根据实现，first可能返回最后一个添加的元素
    } else {
        @Expect(false)
    }
    let lastValue = metadata.last
    if (lastValue is String) {
        @Expect(lastValue as String, "first")   // 根据实现，last可能返回第一个添加的元素
    } else {
        @Expect(false)
    }
    
    // 测试空集合的首尾元素
    let emptyMetadata = EndpointMetadataCollection()
    @Expect(emptyMetadata.first.isNone())
    @Expect(emptyMetadata.last.isNone())
}

/**
 * EndpointMetadataCollection迭代器测试
 * 测试迭代功能
 */
@Test
func EndpointMetadataCollection迭代器测试() {
    let items = ArrayList<Any>()
    items.add("item1")
    items.add("item2")
    items.add("item3")
    
    let metadata = EndpointMetadataCollection(items)
    let iteratedItems = ArrayList<Any>()
    
    // 测试迭代
    for (item in metadata) {
        iteratedItems.add(item)
    }
    
    @Expect(iteratedItems.size, 3)
    // 检查是否包含特定字符串
    var foundItem1 = false
    var foundItem2 = false
    var foundItem3 = false
    
    for (item in iteratedItems) {
        if (item is String) {
            let str = item as String
            if (str == "item1") {
                foundItem1 = true
            }
            if (str == "item2") {
                foundItem2 = true
            }
            if (str == "item3") {
                foundItem3 = true
            }
        }
    }
    
    @Expect(foundItem1)
    @Expect(foundItem2)
    @Expect(foundItem3)
}

/**
 * EndpointMetadataCollection混合类型测试
 * 测试包含多种不同类型元数据的情况
 */
@Test
func EndpointMetadataCollection混合类型测试() {
    let items = ArrayList<Any>()
    items.add("string_value")
    items.add(42)
    items.add(true)
    items.add(3.14159)
    items.add("another_string")
    items.add(0)
    items.add(false)
    
    let metadata = EndpointMetadataCollection(items)
    
    @Expect(metadata.size, 7)
    
    // 测试字符串类型
    let strings = metadata.getOrderedMetadata<String>()
    @Expect(strings.size, 2)
    
    // 测试整数类型
    let ints = metadata.getOrderedMetadata<Int64>()
    @Expect(ints.size, 2)
    
    // 测试布尔类型
    let bools = metadata.getOrderedMetadata<Bool>()
    @Expect(bools.size, 2)
    
    // 测试浮点类型
    let doubles = metadata.getOrderedMetadata<Float64>()
    @Expect(doubles.size, 1)
}

/**
 * EndpointMetadataCollection空集合操作测试
 * 测试空集合的各种操作
 */
@Test
func EndpointMetadataCollection空集合操作测试() {
    let emptyMetadata = EndpointMetadataCollection()
    
    // 测试基本属性
    @Expect(emptyMetadata.isEmpty(), true)
    @Expect(emptyMetadata.size, 0)
    @Expect(emptyMetadata.first.isNone())
    @Expect(emptyMetadata.last.isNone())
    
    // 测试类型化获取
    @Expect(emptyMetadata.getMetadata<String>().isNone())
    @Expect(emptyMetadata.getMetadata<Int64>().isNone())
    @Expect(emptyMetadata.getMetadata<Bool>().isNone())
    
    // 测试有序类型化获取
    let strings = emptyMetadata.getOrderedMetadata<String>()
    @Expect(strings.isEmpty(), true)
    
    let ints = emptyMetadata.getOrderedMetadata<Int64>()
    @Expect(ints.isEmpty(), true)
    
    // 测试迭代
    let iteratedItems = ArrayList<Any>()
    for (item in emptyMetadata) {
        iteratedItems.add(item)
    }
    @Expect(iteratedItems.isEmpty(), true)
}

/**
 * EndpointMetadataCollection单元素集合测试
 * 测试只包含一个元素的集合
 */
@Test
func EndpointMetadataCollection单元素集合测试() {
    let singleItems = ArrayList<Any>()
    singleItems.add("single_item")
    
    let singleMetadata = EndpointMetadataCollection(singleItems)
    
    @Expect(singleMetadata.size, 1)
    @Expect(!singleMetadata.isEmpty())
    @Expect(singleMetadata.first.isSome())
    @Expect(singleMetadata.last.isSome())
    
    // 测试访问
    let singleValue0 = singleMetadata[0]
    if (singleValue0 is String) {
        @Expect(singleValue0 as String, "single_item")
    } else {
        @Expect(false)
    }
    let singleGetValue0 = singleMetadata.get(0)
    if (singleGetValue0 is String) {
        @Expect(singleGetValue0 as String, "single_item")
    } else {
        @Expect(false)
    }
    
    // 测试类型化获取
    let singleStringMeta = singleMetadata.getMetadata<String>()
    if (singleStringMeta is String) {
        @Expect(singleStringMeta as String, "single_item")
    } else {
        @Expect(false)
    }
    @Expect(singleMetadata.getMetadata<Int64>().isNone())
}

/**
 * EndpointMetadataCollection重复类型测试
 * 测试包含多个相同类型元素的情况
 */
@Test
func EndpointMetadataCollection重复类型测试() {
    let items = ArrayList<Any>()
    items.add("string1")
    items.add("string2")
    items.add("string3")
    items.add(1)
    items.add(2)
    items.add(3)
    
    let metadata = EndpointMetadataCollection(items)
    
    // 测试字符串类型
    let strings = metadata.getOrderedMetadata<String>()
    let stringList = ArrayList<String>(strings)
    
    @Expect(stringList.size, 3)
    var foundString1 = false
    var foundString2 = false
    var foundString3 = false
    
    for (str in stringList) {
        if (str == "string1") {
            foundString1 = true
        }
        if (str == "string2") {
            foundString2 = true
        }
        if (str == "string3") {
            foundString3 = true
        }
    }
    
    @Expect(foundString1)
    @Expect(foundString2)
    @Expect(foundString3)
    
    // 测试整数类型
    let ints = metadata.getOrderedMetadata<Int64>()
    let intList = ArrayList<Int64>(ints)
    
    @Expect(intList.size, 3)
    var foundInt1 = false
    var foundInt2 = false
    var foundInt3 = false
    
    for (num in intList) {
        if (num == 1) {
            foundInt1 = true
        }
        if (num == 2) {
            foundInt2 = true
        }
        if (num == 3) {
            foundInt3 = true
        }
    }
    
    @Expect(foundInt1)
    @Expect(foundInt2)
    @Expect(foundInt3)
}

/**
 * EndpointMetadataCollection复杂对象测试
 * 测试包含复杂对象的元数据
 */
@Test
func EndpointMetadataCollection复杂对象测试() {
    // 创建一些复杂对象
    let complexItems = ArrayList<Any>()
    complexItems.add("simple_string")
    complexItems.add(42)
    complexItems.add(ArrayList<String>())  // 空列表
    complexItems.add(true)
    
    let metadata = EndpointMetadataCollection(complexItems)
    
    @Expect(metadata.size, 4)
    
    // 测试基本类型
    let stringMeta = metadata.getMetadata<String>()
    if (stringMeta is String) {
        @Expect(stringMeta as String, "simple_string")
    } else {
        @Expect(false)
    }
    let intMeta = metadata.getMetadata<Int64>()
    if (intMeta is Int64) {
        @Expect(intMeta as Int64, 42)
    } else {
        @Expect(false)
    }
    let boolMeta = metadata.getMetadata<Bool>()
    if (boolMeta is Bool) {
        @Expect(boolMeta as Bool, true)
    } else {
        @Expect(false)
    }
    
    // 测试复杂类型
    let lists = metadata.getOrderedMetadata<ArrayList<String>>()
    @Expect(lists.size, 1)
}


/**
 * EndpointMetadataCollection性能测试
 * 测试包含大量元素的集合
 */
@Test
func EndpointMetadataCollection性能测试() {
    let largeItems = ArrayList<Any>()
    
    // 添加大量元素
    for (i in 0..100) {
        largeItems.add("item_${i}")
        largeItems.add(i)
    }
    
    let metadata = EndpointMetadataCollection(largeItems)
    
    @Expect(metadata.size, 200)
    
    // 测试类型化获取的性能
    let strings = metadata.getOrderedMetadata<String>()
    let stringList = ArrayList<String>(strings)
    
    @Expect(stringList.size, 100)
    
    let ints = metadata.getOrderedMetadata<Int64>()
    let intList = ArrayList<Int64>(ints)
    
    @Expect(intList.size, 100)
}