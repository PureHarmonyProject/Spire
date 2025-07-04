// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_extensions_healthchecks

import aspire_extensions_options.*
import aspire_extensions_injection.*


public interface HealthCheckExtension {
    func addHealthChecks(): HealthChecksBuilder
}

extend ServiceCollection <: HealthCheckExtension {
    public func addHealthChecks() {
        this.addOptions<HealthCheckServiceOptions>()
        this.tryAddSingleton<IHealthCheckService, HealthCheckService> {sp => HealthCheckService(sp, sp.getOrThrow<IOptions<HealthCheckServiceOptions>>())}
        return HealthChecksBuilder(this)
    }
}
