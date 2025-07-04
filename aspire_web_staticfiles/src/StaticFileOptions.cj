// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package aspire_web_staticfiles

public class StaticFileOptions <: SharedOptionsBase {
    public var serveUnknownFileTypes = false
    public var defaultContentType:? String = None
    public var contentTypeProvider: ?IContentTypeProvider = None
}
