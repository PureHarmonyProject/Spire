// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_authorization

import aspire_web_http.*

public interface AuthorizationAppBuilderExtensions {
    func useAuthorization(): ApplicationBuilder
}

extend ApplicationBuilder <: AuthorizationAppBuilderExtensions {
    public func useAuthorization(): ApplicationBuilder {
        this.use<AuthorizationMiddleware>()
        return this
    }
}
