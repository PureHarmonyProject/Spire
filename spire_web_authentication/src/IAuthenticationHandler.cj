// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authentication

import spire_web_http.*

public interface IAuthenticationHandler {
    func initialize(scheme: AuthenticationScheme, context: HttpContext): Unit
    func authenticate(): AuthenticateResult
    func challenge(properties: ?AuthenticationProperties): Unit
    func forbid(properties: ?AuthenticationProperties): Unit
}
