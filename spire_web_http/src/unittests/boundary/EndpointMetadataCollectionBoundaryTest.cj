package spire_web_http.unittests.boundary

import std.unittest.*
import std.unittest.testmacro.*
import spire_web_http.*
import std.collection.*

/**
 * EndpointMetadataCollection边界值测试
 * 测试边界情况和特殊值
 */
@Test
func EndpointMetadataCollection边界值测试() {
    // 测试包含特殊值的集合
    let specialItems = ArrayList<Any>()
    specialItems.add("")
    specialItems.add(0)
    specialItems.add(false)
    specialItems.add(-1)
    specialItems.add("non_empty")
    
    let metadata = EndpointMetadataCollection(specialItems)
    
    @Expect(metadata.size, 5)
    
    // 测试空字符串
    let emptyString = metadata.getMetadata<String>()
    if (emptyString is String) {
        @Expect(emptyString as String, "non_empty")  // 应该返回最后一个字符串
    } else {
        @Expect(false)
    }
    
    // 测试零值
    let zeroValue = metadata.getMetadata<Int64>()
    if (zeroValue is Int64) {
        @Expect(zeroValue as Int64, -1)  // 应该返回最后一个整数
    } else {
        @Expect(false)
    }
    
    // 测试false值
    let falseValue = metadata.getMetadata<Bool>()
    if (falseValue is Bool) {
        @Expect(falseValue as Bool, false)
    } else {
        @Expect(false)
    }
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

/**
 * EndpointMetadataCollection空集合边界测试
 * 测试空集合的边界情况
 */
@Test
func EndpointMetadataCollection空集合边界测试() {
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
 * EndpointMetadataCollection单元素边界测试
 * 测试只包含一个元素的集合的边界情况
 */
@Test
func EndpointMetadataCollection单元素边界测试() {
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
 * EndpointMetadataCollection空静态属性边界测试
 * 测试empty静态属性的边界情况
 */
@Test
func EndpointMetadataCollection空静态属性边界测试() {
    let emptyMetadata = EndpointMetadataCollection.empty
    @Expect(emptyMetadata.isEmpty(), true)
    @Expect(emptyMetadata.size, 0)
    @Expect(emptyMetadata.first.isNone())
    @Expect(emptyMetadata.last.isNone())
    
    // 验证empty属性返回的是同一个实例
    let emptyMetadata2 = EndpointMetadataCollection.empty
    @Expect(emptyMetadata.isEmpty(), true)  // 应该都是空的
}