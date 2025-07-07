// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authentication

import spire_web_http.*
import spire_extensions_injection.*

public interface IAuthenticationHandlerProvider {
    func getHandler(context: HttpContext, schemeName: String): ?IAuthenticationHandler
}

class AuthenticationHandlerProvider <: IAuthenticationHandlerProvider {
    private let _schemes: IAuthenticationSchemeProvider

    public AuthenticationHandlerProvider(schemes: IAuthenticationSchemeProvider) {
        _schemes = schemes
    }

    public func getHandler(context: HttpContext, schemeName: String): ?IAuthenticationHandler {
        if (let Some(scheme) <- _schemes.getScheme(schemeName)) {
            if (let handler: IAuthenticationHandler <- context.services.getOrThrow(scheme.handlerType)) {
                handler.initialize(scheme, context)
                return handler
            }
        }
        return None
    }
}
