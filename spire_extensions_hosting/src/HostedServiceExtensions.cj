// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_hosting

public interface HostedServiceExtensions {
    func addHostedService<THostedService>(): ServiceCollection where THostedService <: IHostedService & Object
}

extend ServiceCollection <: HostedServiceExtensions {
    public func addHostedService<THostedService>() where THostedService <: IHostedService & Object {
        addSingleton<IHostedService, THostedService>()
        return this
    }
}
