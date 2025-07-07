// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

import std.sort.*
import std.reflect.*
import std.collection.*

/*
用于创建依赖容器中但是未注册的服务
*/
public class ActivatorUtilities {
    public static func createInstance<T>(serviceProvider: IServiceProvider, args: Array<Any>): T {
        let obj = createInstance(serviceProvider, TypeInfo.of<T>(), args) as T
        return obj.getOrThrow()
    }

    public static func createInstance(serviceProvider: IServiceProvider, typeInfo: TypeInfo, args: Array<Any>): Object {
        if (let classTypeInfo: ClassTypeInfo <- typeInfo) {
            let constructors = classTypeInfo.constructors |> collectArray
            if (constructors.size > 1) {
                sort(constructors, by: {x, y =>
                    if ( x.parameters.size > y.parameters.size) {
                        Ordering.LT
                    } else if ( x.parameters.size < y.parameters.size) {
                        Ordering.GT
                    } else {
                        Ordering.EQ
                    }
                })
            }
            for ((index, constructor) in constructors |> enumerate) {
                let isFinal = index + 1 == constructors.size
                if (let Some(instance) <- apply(constructor, serviceProvider, isFinal, args)) {
                    return instance
                }
            }
        }
        throw UnsupportedException(
            "Failed to create an instance because no applicable constructor was found for the type '${typeInfo}'. Ensure that the provided arguments match one of the constructors' signatures."
        )
    }

    private static func apply(constructor: ConstructorInfo, sp: IServiceProvider, isFinal: Bool, customArguments: Array<Any>): ?Object {
        var customArgumentIndex = 0
        let arguments = ArrayList<Any>()
        for (pattern in constructor.parameters) {
            if (let Some(argument) <- sp.getOrDefault(pattern.typeInfo)) {
                arguments.add(argument)
            } else {
                if (customArguments.size <= customArgumentIndex) {
                    return noServiceResult(isFinal, pattern.typeInfo)
                }
                let customArgument = customArguments[customArgumentIndex]
                let customArgumentType = TypeInfo.of(customArgument)
                if (!(customArgumentType == pattern.typeInfo || customArgumentType.isSubtypeOf(pattern.typeInfo))) {
                    return noServiceResult(isFinal, pattern.typeInfo)
                }
                arguments.add(customArguments[customArgumentIndex])
                customArgumentIndex += 1
            }
        }
        return constructor.apply(arguments |> collectArray) as Object
    }

    private static func noServiceResult(isFinal: Bool, typeInfo: TypeInfo): ?Object {
        if (isFinal) {
            //如果是最后一个构造器依赖的服务未注册
            throw NoneValueException("No service for type ${typeInfo}' has been registered.")
        } else {
            return None
        }
    }
}
