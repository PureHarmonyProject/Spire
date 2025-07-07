// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_configuration

import std.reflect.*
import std.convert.*
import std.collection.*

/*
配置核心接口
 */
public interface IConfiguration {
    operator func [](name: String): ?String
    operator func [](name: String, value!: ?String): Unit
    func getSection(name: String): IConfigurationSection
    func getChildren(): Collection<IConfigurationSection>       
    
    func getValue(typeInfo: TypeInfo, name: String): ?Any {
        if (let Some(value) <- this[name]) {
            if (TypeInfo.of<String>() == typeInfo) {
                return value
            }
            if (TypeInfo.of<Int32>() == typeInfo) {
                return Int32.parse(value)
            }
            if (TypeInfo.of<UInt32>() == typeInfo) {
                return UInt32.parse(value)
            }
            if (TypeInfo.of<Int64>() == typeInfo) {
                return Int64.parse(value)
            }
            if (TypeInfo.of<UInt64>() == typeInfo) {
                return UInt64.parse(value)
            }
            if (TypeInfo.of<Float16>() == typeInfo) {
                return Float32.parse(value)
            }
            if (TypeInfo.of<Float32>() == typeInfo) {
                return Float32.parse(value)
            }
            if (TypeInfo.of<Float64>() == typeInfo) {
                return Float64.parse(value)
            }
            if (TypeInfo.of<Rune>() == typeInfo) {
                return value.toRuneArray().first.flatMap {f => f as Any}
            }
            if (TypeInfo.of<Bool>() == typeInfo) {
                return Bool.parse(value)
            }
            return value
        }
        return None
    }

    func getValue<T>(name: String): ?T {
        let typeInfo = TypeInfo.of<T>()
        return getValue(typeInfo, name).flatMap {f => f as T}
    }

    func bind(name: String, instance: Object): Unit {
        let typeInfo = ClassTypeInfo.of(instance)
        let section = getSection(name)
        for (pattern in typeInfo.instanceVariables) {
            if (!pattern.isMutable()) {
                continue
            }
            if (let Some(value) <- section.getValue(pattern.typeInfo, pattern.name)) {
                pattern.setValue(instance, value)
            }
        }
    }
}
