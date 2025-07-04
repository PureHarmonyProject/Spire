// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_hosting

public interface HttpContextAccessorExtensions {
    func addHttpContextAccessor(): ServiceCollection
}

extend ServiceCollection <: HttpContextAccessorExtensions{
    public func addHttpContextAccessor(): ServiceCollection {
        this.addScoped<IHttpContextAccessor, HttpContextAccessor>{_=> HttpContextAccessor()}
        return this
    }
}