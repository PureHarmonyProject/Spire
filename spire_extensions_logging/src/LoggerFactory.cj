// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_logging

import std.sync.*
import std.reflect.*
import std.collection.*
import std.collection.concurrent.*

public class LoggerFactory <: ILoggerFactory{
    private let _options: LoggerFilterOptions
    private let _loggers = ConcurrentHashMap<String, ILogger>()
    private let _providers: Collection<ILoggerProvider>

    internal init(providers: Collection<ILoggerProvider>, options: LoggerFilterOptions) {
        _options = options
        _providers = providers
    }

    public func createLogger(categoryName: String): ILogger {
        if (_loggers.contains(categoryName)) {
            return _loggers[categoryName]
        }
        
        return _loggers.entryView(categoryName) { view =>
           if (view.value.isNone()) {
                let loggers = createLoggers(categoryName)
                view.value =  Logger(loggers)
           }
        }.getOrThrow()
       
    }

    private func createLoggers(categoryName: String) {       
        let list = ArrayList<LoggerInformation>()
        for (provider in _providers) {
            let logger = provider.createLogger(categoryName)
            let (minLevel, filter) = LoggerRuleSelector.select(_options, provider.name, categoryName)
            list.add(LoggerInformation(logger, categoryName, provider.name, minLevel, filter))
        }
        return list
    }

    public static func create(configure: (LoggingBuilder) -> Unit): ILoggerFactory {
        let builder = LoggingBuilder()
        configure(builder)
        return builder.build()
    }
}
