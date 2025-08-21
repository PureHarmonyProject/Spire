package spire_web_http

import std.collection.*

main() {
    EndpointMetadataCollection获取操作测试()
}

func EndpointMetadataCollection获取操作测试() {
    let items = ArrayList<Any>()
    items.add("first")
    items.add("second")
    items.add("third")
    
    let metadata = EndpointMetadataCollection(items)
    
    // 测试索引访问
    let value0 = metadata[0]
    if (value0 is String) {
        println((value0 as String) == "first")
    } else {
        println(false)
    }
    
    let value1 = metadata[1]
    if (value1 is String) {
        println((value1 as String) == "second")
    } else {
        println(false)
    }

    let value2 = metadata[2]
    if (value2 is String) {
        println((value2 as String) == "third")
    } else {
        println(false)
    }
    
    // 测试get方法
    let getValue0 = metadata.get(0)
    println(getValue0 as String)
    match (getValue0) {
        case Some(s) => println("get0: ${s as String}")
        case None => println("getValue0 is None")
    }

    let getValue1 = metadata.get(1)
    match (getValue1) {
        case Some(s) => println("get1: ${s is String}")
        case None => println("getValue1 is None")
    }

    let getValue2 = metadata.get(2)
    match (getValue2) {
        case Some(s) => println("get2: ${s is String}")
        case None => println("getValue2 is None")
    }
}