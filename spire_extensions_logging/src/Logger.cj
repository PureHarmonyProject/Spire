// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_logging

import std.collection

class Logger <: ILogger {
    private let _loggers: Collection<LoggerInformation>

    init(loggers: Collection<LoggerInformation>) {
        _loggers = loggers
    }

    public func isEnabled(logLevel: LogLevel) {
        for (pattern in _loggers) {
            if (pattern.isEnabled(logLevel)) {
                return true
            }
        }
        return false
    }

    public func log(logLevel: LogLevel, message: String, exception: ?Exception): Unit {
        for (logInfo in _loggers) {
            if (!logInfo.isEnabled(logLevel)) {
                continue
            }
            logInfo.logger.log(logLevel, message, exception)
        }
    }
}
