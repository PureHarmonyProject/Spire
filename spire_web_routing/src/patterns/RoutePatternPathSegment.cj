// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing.patterns

public enum RoutePatternPathSegment {
    Literal(String) | Parameter(String, RoutePatternParameterKind)

    public func debuggerToString(): String {
        match (this) {
            case Literal(content) => "${content}"
            case Parameter(name, kind) => "{${kind.debuggerToString()}${name}}"
        }
    }

    public prop isLiteral: Bool {
        get() {
            match (this) {
                case Literal(_) => true
                case _ => false
            }
        }
    }

    public prop isParameter: Bool {
        get() {
            match (this) {
                case Parameter(_, _) => true
                case _ => false
            }
        }
    }
}
