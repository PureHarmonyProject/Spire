// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authentication

import spire_extensions_options.*
import spire_extensions_injection.*

public interface AuthenticationServiceCollectionExtensions {
    func addAuthentication(): AuthenticationBuilder
    func addAuthentication(defaultScheme: String): AuthenticationBuilder
    func addAuthentication(configureOptions: (AuthenticationOptions) -> Unit): AuthenticationBuilder
}

extend ServiceCollection <: AuthenticationServiceCollectionExtensions {
    public func addAuthentication(): AuthenticationBuilder {
        addAuthentication {_ =>}
    }

    public func addAuthentication(defaultScheme: String): AuthenticationBuilder {
        addAuthentication { configureOptions => 
            configureOptions.defaultScheme = defaultScheme
        }
    }

    public func addAuthentication(configureOptions: (AuthenticationOptions) -> Unit): AuthenticationBuilder {
        this.configure(configureOptions)
        this.tryAddScoped<IAuthenticationService, AuthenticationService>()
        this.tryAddSingleton<IAuthenticationSchemeProvider, AuthenticationSchemeProvider>()
        this.tryAddSingleton<IAuthenticationHandlerProvider, AuthenticationHandlerProvider>()
        return AuthenticationBuilder(this)
    }
}
