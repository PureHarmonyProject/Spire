// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package spire_web_staticfiles

import std.io.*
import std.fs.*
import std.convert.*
import spire_extensions_options.*

class StaticFileMiddleware <: IMiddleware {
    private let _options: StaticFileOptions
    private let _fileProvider: IFileProvider
    private let _environment: IWebHostEnvironment
    private let _contentTypeProvider: IContentTypeProvider

    public init(options: IOptions<StaticFileOptions>, environment: IWebHostEnvironment) {
        _options = options.value
        _environment = environment
        _fileProvider = _options.fileProvider ?? PhysicalFileProvider()
        _contentTypeProvider = _options.contentTypeProvider ?? ContentTypeProvider()
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
       
        if (!validateNoEndpointDelegate(context)) {
            next()
        } else if (!validateRequestMethod(context)) {
            next()
        } else if((let Some(contentType) <- validateContentType(context.request.path.value))) {
            let fileInfo = getFileInfo(context)
            let content = StaticFileContent(fileInfo, contentType)
            if (fileInfo.exists) {
                content.serve(context)
            }else {
                next()
            }
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

    private func validateContentType(path: String): ?String {
        if (let Some(contentType) <- _contentTypeProvider.getContentType(path)) {
            return contentType
        }

        if (_options.serveUnknownFileTypes && (let Some(contentType) <- _options.defaultContentType)) {
            return contentType
        }

        return None
    }

    private func getFileInfo(context: HttpContext) {
        let subpath = if (let Some(requestPath) <- _options.requestPath) {
            "${_environment.webRootPath}${requestPath}${context.request.path.value}"
        }else {
            "${_environment.webRootPath}${context.request.path.value}"
        }

        return _fileProvider.getFileInfo(subpath)
    }
}
