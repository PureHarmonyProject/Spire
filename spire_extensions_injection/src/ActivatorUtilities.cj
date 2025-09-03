// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

import std.sort.*
import std.reflect.*
import std.collection.*

public class ActivatorUtilities {
    private init() {
    }

    public static func createInstance<T>(provider: IServiceProvider, parameters: Array<Any>): T {
        let instance = createInstance(provider, TypeInfo.of<T>(), parameters) as T
        return instance.getOrThrow()
    }

    public static func createInstance(provider: IServiceProvider, serviceType: TypeInfo, parameters: Array<Any>): Object {
        if (!(serviceType is ClassTypeInfo) || (serviceType as ClassTypeInfo).flatMap {f => f.isAbstract()} == true) {
            throw UnsupportedException("Instances of abstract classes cannot be created.")
        }

        let callSiteFactory = provider.getOrThrow<IServiceProviderIsService>()
        let matcher = ConstructorMatcher(serviceType, callSiteFactory, parameters)

        if (let Some(constructor) <- matcher.find()) {
            return matcher.createInstance(provider, constructor)
        }

        throw UnsupportedException(
            "A suitable constructor for type '${serviceType}' could not be located. Ensure the type is concrete and all parameters of a public constructor are either registered as services or passed as arguments. Also ensure no extraneous arguments are provided.")
    }
}

private struct ConstructorMatcher {
    private let parameterValueTypes: Array<TypeInfo>
    ConstructorMatcher(let typeInfo: TypeInfo, let callSiteFactory: IServiceProviderIsService,
        let parameterValues: Array<Any>) {
        parameterValueTypes = parameterValues |> map {f => TypeInfo.of(f)} |> collectArray
    }

    public func createInstance(provider: IServiceProvider, constructor: ConstructorInfo): Object {
        let parameters = constructor.parameters
        let args = Array<Any>(parameters.size, repeat: None)
        var parameterValueIndex = 0
        for ((index, parameterInfo) in parameters |> enumerate) {
            // 用户传入参数优先
            if (parameterValueTypes[parameterValueIndex].isSubtypeOf(parameterInfo.typeInfo)) {
                args[index] = parameterValues[parameterValueIndex]
                parameterValueIndex++
            } else {
                args[index] = provider.getOrThrow(parameterInfo.typeInfo)
            }
        }

        return (constructor.apply(args) as Object).getOrThrow()
    }

    public func find(): ?ConstructorInfo {
        var bestConstructor: ?ConstructorInfo = None
        if (let classTypeInfo: ClassTypeInfo <- typeInfo) {
            let constructors = classTypeInfo.constructors.toArray()
            sort(constructors, key: {a => a.parameters.size}, descending: true)
            for (constructor in constructors) {
                if (isMatch(constructor, parameterValueTypes)) {
                    if (bestConstructor.isNone()) {
                        bestConstructor = constructor
                    } else {
                        throw UnsupportedException(
                            "Multiple constructors accepting all given argument types have been found in type '${typeInfo}'. There should only be one applicable constructor.")
                    }
                }
            }
        }

        return bestConstructor
    }

    /*
    判断构造器是否匹配
    1. 参数必须是服务类型，或者和用户输入的类型匹配
    2. 必须和用户输入的参数数量匹配
     */
    private func isMatch(constructor: ConstructorInfo, parameterTypes: Array<TypeInfo>) {
        var parameterTypeMatchCount = 0
        for (parameter in constructor.parameters) {
            let isService = callSiteFactory.isService(parameter.typeInfo)
            let isSubtype = parameterTypes |> any {f => f.isSubtypeOf(parameter.typeInfo)}
            if (!(isService || isSubtype)) {
                return false
            }
            if (!isService || isSubtype) {
                parameterTypeMatchCount++
            }
        }
        return parameterTypeMatchCount == parameterTypes.size
    }
}
