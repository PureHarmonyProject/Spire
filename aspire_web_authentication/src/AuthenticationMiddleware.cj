// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package aspire_web_authentication

import aspire_web_http.*

public class AuthenticationMiddleware <: IMiddleware {
    private let _schemes: IAuthenticationSchemeProvider
    private let _handlers: IAuthenticationHandlerProvider

    public init(schemes: IAuthenticationSchemeProvider, handlers: IAuthenticationHandlerProvider) {
        _schemes = schemes
        _handlers = handlers
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        if (let Some(defaultAuthenticate) <- _schemes.getDefaultAuthenticateScheme()) {
             let result = context.authenticate(defaultAuthenticate.name)
            if (let Some(user) <- result.principal) {
                context.user = user
            }
            if (result.succeeded) {
                let features = AuthenticationFeatures(result)
                context.features.set<IHttpAuthenticationFeature>(features)
                context.features.set<IAuthenticateResultFeature>(features)
            }
        }
        next()
    }
}
