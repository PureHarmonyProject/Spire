package spire_web_routing.matching

import std.reflect.*
import spire_web_http.*

/*策略跳转表*/
public abstract class PolicyJumpTable {
    public func getDestination(context: HttpContext): Int64

    protected open func debuggerToString(): String {
        ClassTypeInfo.of(this).qualifiedName
    }
}

class ExistPolicyJumpTable <: PolicyJumpTable {
    ExistPolicyJumpTable(let exitDestination: Int64) {
    }

    public func getDestination(_: HttpContext): Int64 {
        return exitDestination
    }
}
