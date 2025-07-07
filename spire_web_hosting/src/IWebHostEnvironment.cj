// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_hosting

public interface IWebHostEnvironment <: IHostEnvironment {
    prop webRootPath: String
}

class WebHostEnvironment <: IWebHostEnvironment {
    private let _webRootPath: String
    private let _hostEnvironment: IHostEnvironment

    public init(webRootPath: String, hostEnvironment: IHostEnvironment) {
        _webRootPath = webRootPath
        _hostEnvironment = hostEnvironment
    }

    public prop webRootPath: String {
        get() {
            _webRootPath
        }
    }

    public prop environmentName: String {
        get() {
            _hostEnvironment.environmentName
        }
    }

    public prop contentRootPath: String {
        get() {
            _hostEnvironment.contentRootPath
        }
    }

    public prop applicationName: String {
        get() {
            _hostEnvironment.applicationName
        }
    }
}
