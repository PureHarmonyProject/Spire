package spire_web_routing.matching

import std.collection.*
import spire_web_http.*

public class DfaMatcher <: Matcher {
    DfaMatcher(let states: Array<DfaState>) {
    }

    public func invoke(context: HttpContext) {
        var destination = 0
        let path = context.request.path.value

        //1. 使用路径跳转
        for (segment in path.split('/', removeEmpty: true)) {
            destination = states[destination].pathTransitions.getDestination(segment)
        }

        //2. 使用策略跳转
        while (let Some(policyTransitions) <- states[destination].policyTransitions) {
            destination = policyTransitions.getDestination(context)
        }
    }

    public func debuggerToString() {
        return String.join(states |> map {f => f.debuggerToString()} |> collectArray, delimiter: '\r\n')
    }
}
