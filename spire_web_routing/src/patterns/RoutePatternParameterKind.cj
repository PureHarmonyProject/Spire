// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing.patterns

public enum RoutePatternParameterKind {
    Standard | Optional | CatchAll

    public func debuggerToString() {
        match (this) {
            case Standard => ""
            case Optional => "?"
            case CatchAll => "*"
        }
    }

    public prop isStandard: Bool {
        get() {
            match (this) {
                case Standard => true
                case _ => false
            }
        }
    }

    public prop isOptional: Bool {
        get() {
            match (this) {
                case Optional => true
                case _ => false
            }
        }
    }

    public prop isCatchAll: Bool {
        get() {
            match (this) {
                case CatchAll => true
                case _ => false
            }
        }
    }
}
