// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_cors

import spire_web_http.*

public interface CorsMiddlewareExtensions {
    func useCors(): ApplicationBuilder
    func useCors(policyName: String): ApplicationBuilder
    func useCors(configurePolicy: (CorsPolicyBuilder)->Unit): ApplicationBuilder
}

extend ApplicationBuilder <: CorsMiddlewareExtensions {
    
    public func useCors(): ApplicationBuilder {
        this.use<CorsMiddleware>()
        return this
    }

    public func useCors(policyName: String): ApplicationBuilder {
        this.use<CorsMiddleware>(policyName)
        return this
    }

    public func useCors(configurePolicy: (CorsPolicyBuilder) -> Unit): ApplicationBuilder {
        let policyBuilder = CorsPolicyBuilder()
        configurePolicy(policyBuilder)
        let policy = policyBuilder.build()
        this.use<CorsMiddleware>(policy)
        return this
    }
}