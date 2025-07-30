// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authentication

import std.collection.*
import spire_web_http.*
import spire_extensions_options.*

public interface IAuthenticationService {
    func authenticate(context: HttpContext, scheme: ?String): AuthenticateResult
    func challenge(context: HttpContext, scheme: ?String, properties: ?AuthenticationProperties): Unit
    func forbid(context: HttpContext, scheme: ?String, properties: ?AuthenticationProperties): Unit
}

class AuthenticationService <: IAuthenticationService {
    private let _options: AuthenticationOptions
    private let _schemes: IAuthenticationSchemeProvider
    private let _handlers: IAuthenticationHandlerProvider

    public init(schemes: IAuthenticationSchemeProvider, handlers: IAuthenticationHandlerProvider,
        options: IOptions<AuthenticationOptions>) {
        _schemes = schemes
        _handlers = handlers
        _options = options.value
    }

    public func authenticate(context: HttpContext, scheme: ?String): AuthenticateResult {
        let authenticateScheme = if (let Some(scheme) <- scheme) {
            scheme
        } else {
            if (let Some(scheme) <- _schemes.getDefaultChallengeScheme().flatMap {f => f.name}) {
                scheme
            } else {
                throw UnsupportedException(
                    "No authenticationScheme was specified, and there was no DefaultChallengeScheme found. The default schemes can be set using either AddAuthentication(string defaultScheme) or AddAuthentication(Action<AuthenticationOptions> configureOptions).")
            }
        }

        let handler = _handlers.getHandler(context, authenticateScheme) ?? throw createMissingHandlerException(
            authenticateScheme)
        return handler.authenticate()
    }

    public func challenge(context: HttpContext, scheme: ?String, properties: ?AuthenticationProperties) {
        let challengeScheme = if (let Some(scheme) <- scheme) {
            scheme
        } else {
            if (let Some(scheme) <- _schemes.getDefaultChallengeScheme().flatMap {f => f.name}) {
                scheme
            } else {
                throw UnsupportedException(
                    "No authenticationScheme was specified, and there was no DefaultChallengeScheme found. The default schemes can be set using either AddAuthentication(string defaultScheme) or AddAuthentication(Action<AuthenticationOptions> configureOptions).")
            }
        }

        let handler = _handlers.getHandler(context, challengeScheme) ?? throw createMissingHandlerException(
            challengeScheme)
        handler.challenge(properties)
    }

    public func forbid(context: HttpContext, scheme: ?String, properties: ?AuthenticationProperties) {
        let forbidScheme = if (let Some(scheme) <- scheme) {
            scheme
        } else {
            if (let Some(scheme) <- _schemes.getDefaultChallengeScheme().flatMap {f => f.name}) {
                scheme
            } else {
                throw UnsupportedException(
                    "No authenticationScheme was specified, and there was no DefaultChallengeScheme found. The default schemes can be set using either AddAuthentication(string defaultScheme) or AddAuthentication(Action<AuthenticationOptions> configureOptions).")
            }
        }

        let handler = _handlers.getHandler(context, forbidScheme) ?? throw createMissingHandlerException(forbidScheme)
        handler.forbid(properties)
    }

    private func createMissingHandlerException(scheme: String): Exception {
        let schemes = String.join(_schemes.getAllSchemes() |> map {f => f.name} |> collectArray, delimiter: ', ')
        let footer = " Did you forget to call AddAuthentication().Add[SomeAuthHandler](\"${scheme}\",...)?"

        if (schemes.isEmpty()) {
            throw UnsupportedException("No authentication handlers are registered.${footer}")
        }

        return UnsupportedException(
            "No authentication handler is registered for the scheme '${scheme}'. The registered schemes are: ${schemes}.${footer}")
    }
}
