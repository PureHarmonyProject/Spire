// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_extensions_healthchecks

public class HealthCheckContext {
    private let _registration: HealthCheckRegistration

    init(registration: HealthCheckRegistration) {
        _registration = registration
    }

    public prop registration: HealthCheckRegistration {
        get() {
            _registration
        }
    }
}
