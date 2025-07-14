// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing

import std.collection.*

public interface IHttpMethodMetadata {
    prop acceptCorsPreflight: Bool
    prop httpMethods: ReadOnlyList<String>
}

public class HttpMethodMetadata <: IHttpMethodMetadata {
    private let _acceptCorsPreflight: Bool
    private let _httpMethods: ArrayList<String>

    public init(httpMethods: Collection<String>) {
        this(httpMethods, false)
    }

    public init(httpMethods: Collection<String>, acceptCorsPreflight: Bool) {
        _httpMethods = ArrayList(httpMethods)
        _acceptCorsPreflight = acceptCorsPreflight
    }

    public prop httpMethods: ReadOnlyList<String> {
        get() {
            _httpMethods
        }
    }

    public prop acceptCorsPreflight: Bool {
        get() {
            _acceptCorsPreflight
        }
    }
}
