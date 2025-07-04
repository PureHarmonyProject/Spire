// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_authorization

import aspire_web_http.*
import aspire_web_authentication.*

/*
策略执行器
*/
public interface IPolicyEvaluator {
    func authenticate(policy: AuthorizationPolicy, context: HttpContext): AuthenticateResult
    func authorize(policy: AuthorizationPolicy, authenticationResult: AuthenticateResult, context: HttpContext,
        resource: ?Object): PolicyAuthorizationResult
}
