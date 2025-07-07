// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_healthchecks

public enum HealthStatus <: ToString {
    unhealthy | degraded | healthy

    public func toString() {
        match (this) {
            case unhealthy => "unhealthy"
            case degraded => "degraded"
            case healthy => "healthy"
        }
    }
}
