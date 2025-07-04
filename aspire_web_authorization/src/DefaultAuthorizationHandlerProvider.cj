// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_authorization

public class DefaultAuthorizationHandlerProvider <: IAuthorizationHandlerProvider {
    private let _handlers: Collection<IAuthorizationHandler>

    init(handlers: Collection<IAuthorizationHandler>) {
        _handlers = handlers
    }

    public func getHandlers(_: AuthorizationHandlerContext) {
        _handlers
    }
}
