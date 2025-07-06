// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package aspire_web_cors

import std.collection.*

public class CorsPolicy {
    private let _headers = ArrayList<String>()
    private let _methods = ArrayList<String>()
    private let _origins = ArrayList<String>()
    private var _supportsCredentials = false
    internal var isDefaultIsOriginAllowed = true
    private var _preflightMaxAge: ?Duration = None
    private let _exposedHeaders = ArrayList<String>()
    private var _isOriginAllowed: ?(String) -> Bool = None

    public init() {
        _isOriginAllowed = {
            origin => return _origins |> any {f => f == origin}
        }
    }

    public prop allowAnyHeader: Bool {
        get() {
            if (_headers.size != 1 || _methods[0] != CorsConstants.AnyHeader) {
                return false
            }
            return true
        }
    }

    public prop allowAnyMethod: Bool {
        get() {
            if (_methods.size != 1 || _methods[0] != CorsConstants.AnyMethod) {
                return false
            }
            return true
        }
    }

    public prop allowAnyOrigin: Bool {
        get() {
            if (_origins.size != 1 || _methods[0] != CorsConstants.AnyOrigin) {
                return false
            }
            return true
        }
    }

    public mut prop isOriginAllowed: (String) -> Bool {
        get() {
            _isOriginAllowed.getOrThrow()
        }
        set(value) {
            _isOriginAllowed = value
            isDefaultIsOriginAllowed = false
        }
    }

    public prop exposedHeaders: List<String> {
        get() {
            _exposedHeaders
        }
    }

    public mut prop preflightMaxAge: ?Duration {
        get() {
            _preflightMaxAge
        }
        set(value) {
            if (value.flatMap {f => f < Duration.Zero} == true) {
                throw IllegalArgumentException()
            }
            _preflightMaxAge = value
        }
    }

    public mut prop supportsCredentials: Bool {
        get() {
            _supportsCredentials
        }
        set(value) {
            _supportsCredentials = value
        }
    }

    public prop headers: List<String> {
        get() {
            _headers
        }
    }

    public prop methods: List<String> {
        get() {
            _methods
        }
    }

    public prop origins: List<String> {
        get() {
            _origins
        }
    }
}
