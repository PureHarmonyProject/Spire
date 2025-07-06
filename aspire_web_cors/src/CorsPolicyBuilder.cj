// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_cors

public class CorsPolicyBuilder {
    private let _policy = CorsPolicy()

    public init(origins: Array<String>) {
        withOrigins(origins)
    }

    public func withOrigins(origins: Array<String>) {
        _policy.origins.add(all: origins)
        return this
    }

    public func withHeaders(headers: Array<String>) {
        _policy.headers.add(all: headers)
        return this
    }

    public func withMethods(methods: Array<String>) {
        _policy.methods.add(all: methods)
        return this
    }

    public func allowAnyOrigin() {
        _policy.origins.clear()
        _policy.origins.add(CorsConstants.AnyOrigin)
        return this
    }

    public func allowAnyMethod() {
        _policy.methods.clear()
        _policy.methods.add(CorsConstants.AnyOrigin)
        return this
    }

    public func allowAnyHeader() {
        _policy.headers.clear()
        _policy.headers.add(CorsConstants.AnyOrigin)
        return this
    }

    public func allowCredentials() {
        _policy.supportsCredentials = true
        return this
    }

    public func disallowCredentials() {
        _policy.supportsCredentials = false
        return this
    }

    public func setPreflightMaxAge(preflightMaxAge: Duration) {
        _policy.preflightMaxAge = preflightMaxAge
        return this
    }

    public func setIsOriginAllowed(isOriginAllowed: (String) -> Bool) {
        _policy.isOriginAllowed  = isOriginAllowed
        return this
    }

    public func build() {
        if (_policy.allowAnyOrigin && _policy.supportsCredentials) {
            throw UnsupportedException("The CORS protocol does not allow specifying a wildcard (any) origin and credentials at the same time. Configure the CORS policy by listing individual origins if credentials needs to be supported.")
        }
        return _policy
    }
}