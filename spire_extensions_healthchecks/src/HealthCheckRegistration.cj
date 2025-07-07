// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_healthchecks

import spire_extensions_injection.*

public class HealthCheckRegistration {
    private let _name: String
    private let _timeout: Duration
    private let _factory: (IServiceProvider) -> IHealthCheck
    private let _tags: Array<String>

    init(name: String, timeout: Duration, tags: Array<String>, factory: (IServiceProvider) -> IHealthCheck) {
        _name = name
        _tags = tags
        _timeout = timeout
        _factory = factory
    }
   
    public prop name: String {
        get() {
            _name
        }
    }

    public prop timeout: Duration {
        get() {
            _timeout
        }
    }
    
    public prop tags: Array<String> {
        get() {
            _tags
        }
    }

    public prop factory: (IServiceProvider) -> IHealthCheck {
        get() {
            _factory
        }
    }
}
