// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package spire_web_authentication_jwtbearer

import std.unicode.*
import spire_web_http.*
import spire_identity_tokens.*
import spire_identity_claims.*
import spire_web_authentication.*
import spire_extensions_options.*
import spire_extensions_logging.*
import spire_identity_tokens_jwt.*

public class JwtBearerHandler <: AuthenticationHandler<JwtBearerOptions> {
    public init(options: IOptionsMonitor<JwtBearerOptions>, logger: ILoggerFactory) {
        super(options, logger)
    }

    public func handleAuthenticate() {
        if (let Some(accessToken) <- messageReceived()) {
            let jwtTokenHandler = JwtSecurityTokenHandler()
            let tokenValidationParameters = this.options.tokenValidationParameters
            let result = jwtTokenHandler.validateToken(accessToken, tokenValidationParameters)
            if (result.isValid) {
                let properties = AuthenticationProperties()
                if (this.options.saveToken) {
                    properties.storeTokens(AuthenticationToken("access_token", accessToken))
                }
                let subject = ClaimsPrincipal(result.identity)
                let ticket = AuthenticationTicket(subject, JwtBearerDefaults.Scheme, properties)
                return AuthenticateResult.success(ticket)
            } else {
                AuthenticateResult.fail(result.exception.getOrThrow())
            }
        }
        return AuthenticateResult.noResult()
    }

    protected override func handleChallenge(properties: ?AuthenticationProperties): Unit {
        let authenticateResult = handleAuthenticateOnceSafe()
        let error_description = authenticateResult.failure.flatMap {f => f.message} ?? String.empty
        this.context.response.addHeader("WWW-Authenticate", "${this.options.challenge} error=\"invalid_token\", error_description=\"${error_description}\", charset=\"UTF-8\"")
        super.handleChallenge(properties)
    }

    private func messageReceived(): ?String {
        var accessToken: ?String = if (let Some(onMessageReceived) <- this.options.events.onMessageReceived) {
            onMessageReceived(this.context)
        } else {
            None
        }

        if (accessToken.isNone()) {
            if (let Some(authorizationValue) <- this.context.request.headers.getFirst("Authorization") &&
                startWithBearer(authorizationValue)) {
                accessToken = authorizationValue[7..]
            }
        }
        return accessToken
    }

    private func startWithBearer(authorizationValue: String) {
        return authorizationValue.toUpper().startsWith("BEARER")
    }
}
