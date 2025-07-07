// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_staticfiles

import spire_extensions_options.*
import spire_extensions_injection.*

public interface DefaultFileExtensions {
    func useDefaultFiles(): Unit
    func useDefaultFiles(options: DefaultFilesOptions): Unit
    func useDefaultFiles(configureOptions: (DefaultFilesOptions) -> Unit): Unit
}

extend ApplicationBuilder <: DefaultFileExtensions {
    public func useDefaultFiles(): Unit {
        let options = DefaultFilesOptions()
        useDefaultFiles(options)
    }

    public func useDefaultFiles(configureOptions: (DefaultFilesOptions) -> Unit): Unit {
        let options = DefaultFilesOptions()
        configureOptions(options)
        useDefaultFiles(options)
    }

    public func useDefaultFiles(options: DefaultFilesOptions): Unit {
        use<DefaultFileMiddleware>(Options.create(options))
    }
}
