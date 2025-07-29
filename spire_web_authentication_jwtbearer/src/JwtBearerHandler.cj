// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package spire_web_authentication_jwtbearer

import std.collection.*
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
            let tokenValidationParameters = setupTokenValidationParameters()
            let tokenValidateResult = jwtTokenHandler.validateToken(accessToken, tokenValidationParameters)
            if (tokenValidateResult.isValid) {
                let properties = AuthenticationProperties()
                if (this.options.saveToken) {
                    properties.storeTokens(AuthenticationToken("access_token", accessToken))
                }
                let subject = ClaimsPrincipal(tokenValidateResult.identity)
                let ticket = AuthenticationTicket(subject, JwtBearerDefaults.Scheme, properties)
                return AuthenticateResult.success(ticket)
            } else {
                AuthenticateResult.fail(tokenValidateResult.exception.getOrThrow())
            }
        }
        return AuthenticateResult.noResult()
    }

    protected override func handleChallenge(properties: ?AuthenticationProperties): Unit {
        let authenticateResult = handleAuthenticateOnceSafe()
        let error_description = authenticateResult.failure.flatMap {f => f.message} ?? String.empty
        let WWWAuthenticate = "${this.options.challenge} error=\"invalid_token\", error_description=\"${error_description}\", charset=\"UTF-8\""
        context.response.addHeader("WWW-Authenticate", WWWAuthenticate)
        super.handleChallenge(properties)
    }

    private func messageReceived(): ?String {
        //form event
        var accessToken: ?String = if (let Some(onMessageReceived) <- this.options.events.onMessageReceived) {
            onMessageReceived(this.context)
        } else {
            None
        }

        // form header
        if (accessToken.isNone()) {
            if (let Some(authorizationValue) <- this.context.request.headers.getFirst("Authorization") && IsJwtBearer(
                authorizationValue)) {
                accessToken = authorizationValue[7..]
            }
        }
        return accessToken
    }

    private func IsJwtBearer(authorizationValue: String) {
        return authorizationValue.toAsciiLower().startsWith("bearer")
    }

    private func setupTokenValidationParameters() {
        println(11)
        let tokenValidationParameters = options.tokenValidationParameters.clone()
        if (let Some(configurationManager) <- options.configurationManager) {
            println(22)
            let configuration = configurationManager.getConfiguration()
           
            let issuers = ArrayList<String>([configuration.issuer])
            issuers.add(all: tokenValidationParameters.validIssuers)
            tokenValidationParameters.validIssuers = issuers |> collectArray
           
            let signingKeys = ArrayList<SecurityKey>()
            signingKeys.add(all: tokenValidationParameters.issuerSigningKeys)
            signingKeys.add(all: configuration.signingKeys)

            return tokenValidationParameters
        }

        return tokenValidationParameters
    }
}
