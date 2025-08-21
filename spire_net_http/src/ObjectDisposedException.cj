package spire_net_http

public class ObjectDisposedException <: Exception {
    private let _objectName: String

    init(objectName: String) {
        super("Cannot access a disposed object.")
        _objectName = objectName
    }

    public prop objectName: String {
        get() {
            _objectName
        }
    }
}
