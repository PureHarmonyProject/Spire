// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_logging

import std.reflect.*

public interface ILoggerFactory {
    func createLogger<T>(): ILogger {
        createLogger(TypeInfo.of<T>().qualifiedName)
    }
    
    func createLogger(categoryName: String): ILogger
}