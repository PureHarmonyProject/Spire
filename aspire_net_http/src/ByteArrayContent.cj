// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_net_http

import std.io.*

public open class ByteArrayContent <: HttpContent {
    private let _bytes: Array<Byte>

    public init(bytes: Array<Byte>) {
        _bytes = bytes
    }

    public func readAsStream(): InputStream {
        return ByteBuffer(_bytes)
    }
}
