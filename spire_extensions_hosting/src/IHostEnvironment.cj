// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_hosting

public interface IHostEnvironment {
    prop environmentName: String
    prop contentRootPath: String
    prop applicationName: String
   
    func isEnvironment(name: String) {
        environmentName == name
    }
   
    func IsStaging() {
        isEnvironment(Environments.Staging)
    }
   
    func IsProduction() {
        isEnvironment(Environments.Production)
    }
   
    func isDevelopment() {
        isEnvironment(Environments.Development)
    }
}

