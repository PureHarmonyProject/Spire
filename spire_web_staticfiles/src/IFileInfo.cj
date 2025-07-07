// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_staticfiles

import std.io.*
import std.time.*

public interface IFileInfo {    
    prop name: String
    prop size: Int64
    prop exists: Bool
    prop isDirectory: Bool
    prop physicalPath: ?String
    prop lastModified: DateTime
    func createReadStream(): InputStream
}