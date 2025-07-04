// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_extensions_logging

public class LoggerFilterOptions {
    private let _minLevel: LogLevel
    private let _rules: Collection<LoggerFilterRule>

    init(minLogLevel: LogLevel, rules: Collection<LoggerFilterRule>) {
        _minLevel = minLogLevel
        _rules = rules
    }

    public prop minLevel: LogLevel {
        get() {
            _minLevel
        }
    }

    public prop rules: Collection<LoggerFilterRule> {
        get() {
            _rules
        }
    }
}
