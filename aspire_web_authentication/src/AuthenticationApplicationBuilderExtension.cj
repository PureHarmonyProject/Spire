// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_authentication

import aspire_web_http.*

public interface AuthenticationApplicationBuilderExtension {
    func useAuthentication(): ApplicationBuilder
}

extend ApplicationBuilder <: AuthenticationApplicationBuilderExtension {
    public func useAuthentication() {
        this.use<AuthenticationMiddleware>()
        return this
    }
}
