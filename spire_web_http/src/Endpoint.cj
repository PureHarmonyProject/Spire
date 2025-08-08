// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_http

import std.collection.*

public abstract class Endpoint <: ToString {
    private let _displayName: ?String
    private let _delegate: RequestDelegate
    private let _metadata: EndpointMetadataCollection

    public init(delegate: RequestDelegate, metadata: EndpointMetadataCollection, displayName: ?String) {
        _delegate = delegate
        _metadata = metadata
        _displayName = displayName
    }

    public prop delegate: RequestDelegate {
        get() {
            _delegate
        }
    }

    public prop metadata: EndpointMetadataCollection {
        get() {
            _metadata
        }
    }

    public prop displayName: ?String {
        get() {
            _displayName
        }
    }

    public open func toString() {
        return _displayName ?? String.empty
    }
}
