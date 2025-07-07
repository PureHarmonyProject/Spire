// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_net_http

public class HttpRequestException <: Exception {
    
    private let _status: ?UInt16

    init(message: String, status: ?UInt16) {
        super(message)
        _status = status
    }

    public prop status: ?UInt16{
        get() {
            _status
        }
    }
}
