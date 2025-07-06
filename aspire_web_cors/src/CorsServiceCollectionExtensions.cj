// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_cors
import aspire_extensions_options.*

import aspire_extensions_injection.*

public interface CorsServiceCollectionExtensions {
   
    func addCors(configureOptions: (CorsOptions)-> Unit): ServiceCollection
    
    func addCors(): ServiceCollection {
        addCors{ _=> }
    }
}

extend ServiceCollection <: CorsServiceCollectionExtensions {
    public func addCors(configureOptions: (CorsOptions)-> Unit): ServiceCollection {
        this.configure<CorsOptions>(configureOptions)
        this.tryAddTransient<ICorsService, CorsService>()
        this.tryAddTransient<ICorsPolicyProvider, CorsPolicyProvider>()
        return this
    }
}

