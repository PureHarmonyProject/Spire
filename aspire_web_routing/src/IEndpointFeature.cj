// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_routing

public interface IEndpointFeature {
    mut prop endpoint: ?Endpoint
}

class EndpointFeature <: IEndpointFeature {
    private var _endpoint: ?Endpoint = None

    init(endpoint: ?Endpoint) {
        _endpoint = endpoint
    }

    public mut prop endpoint: ?Endpoint {
        get() {
            _endpoint
        }
        set(value) {
            _endpoint = value
        }
    }
}
