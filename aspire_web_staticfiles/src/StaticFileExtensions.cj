// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package aspire_web_staticfiles

import aspire_extensions_injection.*

public interface StaticFileExtensions {
    func useStaticFiles(): Unit
    func useStaticFiles(options: StaticFileOptions): Unit
    func useStaticFiles(configureOptions: (StaticFileOptions)-> Unit): Unit
}

extend ApplicationBuilder <: StaticFileExtensions {
    
    public func useStaticFiles(): Unit {
        let options = StaticFileOptions()
        useStaticFiles(options)
    }

    public func useStaticFiles(configureOptions: (StaticFileOptions)-> Unit): Unit {
        let options = StaticFileOptions()
        configureOptions(options)
        useStaticFiles(options)
    }

    public func useStaticFiles(options: StaticFileOptions): Unit {
        let environment = this.applicationServices.getOrThrow<IWebHostEnvironment>()
        use(StaticFileMiddleware(options, environment))
    }
}
