// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_authorization

import std.collection.*
import aspire_extensions_options.*

public class PassThroughAuthorizationHandler <: IAuthorizationHandler {
    private let _options: AuthorizationOptions

    public init(options: IOptions<AuthorizationOptions>) {
        _options = options.value
    }

    public func handle(context: AuthorizationHandlerContext) {
        let handlers = context.requirements |> filterMap {f => f as IAuthorizationHandler}
        for (pattern in handlers) {
            pattern.handle(context)
            if (!_options.invokeHandlersAfterFailure && context.hasFailed) {
                break
            }
        }
    }
}
