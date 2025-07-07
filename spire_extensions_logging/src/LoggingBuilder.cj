// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_logging

import std.reflect.TypeInfo
import std.collection.{ArrayList, HashMap}

public class LoggingBuilder {
    private var _minLevel = LogLevel.Trace
    private let _rules = ArrayList<LoggerFilterRule>()
    private let _providers = HashMap<TypeInfo, ILoggerProvider>()

    public func addFilter(filter: LoggerFilter) {
        _rules.add(LoggerFilterRule(filter))
        return this
    }

    public func addFilter(providerName: ?String, categoryName: ?String, logLevel: LogLevel) {
        _rules.add(LoggerFilterRule(providerName, categoryName, logLevel))
        return this
    }

    public func setMinimumLevel(minLevel: LogLevel) {
        _minLevel = minLevel
        return this
    }   

    public func addProvider(provider: ILoggerProvider) {
        let key = TypeInfo.of(provider)
        if (_providers.contains(key)) {
            return
        }
        _providers.add(key, provider)
        return this
    }

    public func clearProviders() {
        _providers.clear()
        return this
    }

    public func build(): ILoggerFactory {
        return LoggerFactory(_providers.values(), LoggerFilterOptions(_minLevel, _rules))
    }
}
