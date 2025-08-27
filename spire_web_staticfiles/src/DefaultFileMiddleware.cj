// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_staticfiles

import spire_extensions_options.*

class DefaultFileMiddleware <: IMiddleware {
    private let _fileProvider: IFileProvider
    private let _options: DefaultFilesOptions
    private let _environment: IWebHostEnvironment

    public init(options: IOptions<DefaultFilesOptions>, environment: IWebHostEnvironment) {
        _options = options.value
        _environment = environment
        _fileProvider = _options.fileProvider ?? PhysicalFileProvider()
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        if (context.request.path != "/") {
            next()
        }
        else if (!validateNoEndpointDelegate(context)) {
            next()
        } else if (!validateRequestMethod(context)) {
            next()
        } else if(let Some(fileInfo) <- getFileInfo()) {
            let content = StaticFileContent(fileInfo, "text/html")
            content.serve(context)
        }else {
            next()
        }
    }

    private func validateNoEndpointDelegate(context: HttpContext) {
        context.getEndpoint().isNone()
    }

    private func validateRequestMethod(context: HttpContext) {
        Helpers.isGetOrHeadMethod(context.request.method)
    }

    private func getFileInfo(): ?IFileInfo {
        let subpath = if (let Some(requestPath) <- _options.requestPath) {
            "${_environment.webRootPath}${requestPath}"
        }else {
            "${_environment.webRootPath}/"
        }
         for (defaultFile in _options.defaultFileNames) {
            let fileInfo = _fileProvider.getFileInfo("${subpath}${defaultFile}")
            if (fileInfo.exists) {
               return fileInfo
            }
        }
        return None
    }
}
