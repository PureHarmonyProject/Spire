// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_hosting

public abstract class BackgroundService <: IHostedService & Resource {
    private var _future: ?Future<Unit> = None

    public func start(): Unit {
        _future = spawn {
            run()
        }
    }

    public func stop(): Unit {
        _future?.cancel()
    }

    public func run(): Unit

    public open func isClosed() {        
        return true
    }

    public open func close() {
        
    }
}
