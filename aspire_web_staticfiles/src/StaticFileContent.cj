// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_staticfiles

import std.convert.*
import std.collection.*

class StaticFileContent {

    StaticFileContent(let fileInfo: IFileInfo, let contentType: String) {
    }

    public func serve(context: HttpContext) {
        let etagValue = calcEtagValue(fileInfo)
        if(isNotModified(context, etagValue)) {
            context.response.status(HttpStatusCode.NotModified)
        }else {
            context.response.addHeader("ETag", etagValue)
            context.response.addHeader("Content-Type", contentType)
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

    private func calcEtagValue(fileInfo: IFileInfo) {
        let etagHash = fileInfo.lastModified.inUTC().toUnixTimeStamp().toMicroseconds() ^ fileInfo.size
        return etagHash.format('x')
    }
}
