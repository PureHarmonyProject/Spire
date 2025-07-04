// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_extensions_injection

/*
服务生命周期
 */
public enum ServiceLifetime <: ToString {
    Singleton | Scoped | Transient

    public func isScoped() {
        match (this) {
            case Scoped => true
            case _ => false
        }
    }

    public func isTransient() {
        match (this) {
            case Transient => true
            case _ => false
        }
    }

    public func isSingleton() {
        match (this) {
            case Singleton => true
            case _ => false
        }
    }

    public func toString() {
        return match (this) {
            case Singleton => "Singleton"
            case Scoped => "Scoped"
            case Transient => "Transient"
        }
    }
}
