// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_staticfiles

import std.time.*
import std.convert.*
import std.collection.*

class StaticFileContent {

    StaticFileContent(let fileInfo: IFileInfo, let contentType: String) {
    }

    public func serve(context: HttpContext) {
        let etag = calcEtagValue(fileInfo)
        if(isNotModified(context, etag)) {
            applyResponseHeaders(context, etag)
            context.response.status(StatusCodes.NotModified)
        }else {
            applyResponseHeaders(context, etag)
            context.response.write(fileInfo.createReadStream())
        }
    }

    private func isNotModified(context: HttpContext, etagValue: String) {
        let ifNoneMatchValues = context.request.headers.get("If-None-Match")
        if ((ifNoneMatchValues |> any{f => f == "*"}) || (ifNoneMatchValues |> any{f => f == etagValue})) {
            return true
        }
        return false
    }

    private func applyResponseHeaders(context: HttpContext, etagValue: String) {
        context.response.addHeader(HeaderNames.ETag, etagValue)
        context.response.addHeader(HeaderNames.ContentType, contentType)
        context.response.addHeader(HeaderNames.LastModified, fileInfo.lastModified.inUTC().format(DateTimeFormat.RFC1123))
    }

    private func calcEtagValue(fileInfo: IFileInfo) {
        let etagHash = fileInfo.lastModified.inUTC().toUnixTimeStamp().toMicroseconds() ^ fileInfo.size
        return etagHash.format('x')
    }
}
