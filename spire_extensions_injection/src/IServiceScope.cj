// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

/*
用于实现容器和生命周期分离，创建者才有权限释放
*/
public interface IServiceScope <: Resource {
    prop services: IServiceProvider
}

class ServiceScope <: IServiceScope  {
    private var _isClosed = false
    private let _services :ServiceProvider

    init(services: ServiceProvider) {
        _services = services
    }

    public prop services: IServiceProvider {
        get() {
            _services
        }
    }

    public func isClosed() {
        _isClosed
    }
    
    public func close() {
        if (isClosed()) {
            return
        }
        for (pattern in _services.resources) {
            try {
                pattern.close()
            } catch (_ :Exception) {
                
            }
        }
        _isClosed = true
    }
}
