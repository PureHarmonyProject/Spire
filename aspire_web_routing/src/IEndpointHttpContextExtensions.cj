// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_routing

public interface IEndpointHttpContextExtensions {
    func setEndpoint(endpoint: Endpoint): Unit
    func getEndpoint(): ?Endpoint
}

extend HttpContext <: IEndpointHttpContextExtensions {
    public func setEndpoint(endpoint: Endpoint): Unit {
        if (let Some(feature) <- this.features.get<IEndpointFeature>()) {
            feature.endpoint = endpoint
        } else {
            this.features.set<IEndpointFeature>(EndpointFeature(endpoint))
        }
    }

    public func getEndpoint(): ?Endpoint {
        if (let Some(feature) <- this.features.get<IEndpointFeature>()) {
            return feature.endpoint
        }
        return None
    }
}
