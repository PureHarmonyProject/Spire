package spire_web_routing.matching

import std.reflect.*
import spire_web_http.*

public abstract class Matcher {
    public func invoke(context: HttpContext): Unit

    public open func debuggerToString() {
        return ClassTypeInfo.of(this).qualifiedName
    }
}
