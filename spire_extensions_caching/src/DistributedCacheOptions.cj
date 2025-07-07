// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_caching

public class DistributedCacheOptions {
    public let _expirationScanFrequency: Duration

    public init() {
        _expirationScanFrequency = Duration.minute * 60
    }

    public init(expirationScanFrequency: Duration) {
        _expirationScanFrequency = expirationScanFrequency
    }

    public prop expirationScanFrequency: Duration {
        get() {
            _expirationScanFrequency
        }
    }
}
