// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authentication_jwtbearer

import spire_extensions_options.*
import spire_web_authentication.*
import spire_extensions_injection.*

public interface JwtBearerBuilderExtensions {
    func addJwtBearer(authenticateScheme: String, displayName: Option<String>, configureOptions: (JwtBearerOptions) -> Unit): AuthenticationBuilder

    func addJwtBearer(authenticateScheme: String, configureOptions: (JwtBearerOptions) -> Unit): AuthenticationBuilder {
        addJwtBearer(authenticateScheme, None, configureOptions)
    }

    func addJwtBearer(configureOptions: (JwtBearerOptions) -> Unit): AuthenticationBuilder {
        addJwtBearer(JwtBearerDefaults.Scheme, None, configureOptions)
    }
}

extend AuthenticationBuilder <: JwtBearerBuilderExtensions {
    public func addJwtBearer(authenticateScheme: String, displayName: Option<String>, configureOptions: (JwtBearerOptions) -> Unit): AuthenticationBuilder {
        this.services.tryAddEnumerable(ServiceDescriptor.singleton<IConfigureAfterOptions<JwtBearerOptions>, JwtBearerConfigureAfterOptions>())
        this.addScheme<JwtBearerOptions, JwtBearerHandler>(authenticateScheme, displayName, configureOptions)
    }
}