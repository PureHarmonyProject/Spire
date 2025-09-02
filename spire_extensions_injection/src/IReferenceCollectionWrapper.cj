// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

import std.reflect.*

/*
通过该接口来规避cangjie不能协变问题
 */
interface IReferenceCollectionWrapper {
    operator func [](index: Int64, value!: Object): Unit

    static func create(itemType: TypeInfo, size: Int64): IReferenceCollectionWrapper {
        let arrayType = ClassTypeInfo.get("spire_extensions_injection.ReferenceCollection<${itemType.qualifiedName}>")
        return (arrayType.construct(size) as IReferenceCollectionWrapper).getOrThrow()
    }
}

/*
定义一个引用类型的数组
 */
class ReferenceCollection<T> <: Collection<T> & IReferenceCollectionWrapper {
    private let _items: Array<T>

    public init(size: Int64) {
        _items = Array<T>(size, repeat: unsafe {
            zeroValue<T>()
        })
    }

    public func iterator(): Iterator<T> {
        _items.iterator()
    }

    public operator func [](index: Int64, value!: Object): Unit {
        _items[index] = (value as T).getOrThrow()
    }

    public func isEmpty() {
        return _items.isEmpty()
    }

    public prop size: Int64 {
        get() {
            return _items.size
        }
    }
}
