package spire_web_routing.matching

import std.collection.*
import spire_web_http.*
import spire_web_routing.http.*

public class DfaMatcher <: Matcher {
    DfaMatcher(let endpointSelector: EndpointSelector, let states: Array<DfaState>) {
    }

    public func invoke(context: HttpContext) {
        //查找候选集
        let candidates = findCandidateSet(context)
        //筛选最终的候选结果
        endpointSelector.select(context, CandidateSet(candidates))
    }

    private func findCandidateSet(context: HttpContext) {
        let path = context.request.path.value
        var destination = 0
       
        //1. 使用路径跳转
        for (segment in path.split('/', removeEmpty: true)) {
            destination = states[destination].pathTransitions.getDestination(segment)
        }

        //2. 使用策略跳转
        while (let Some(policyTransitions) <- states[destination].policyTransitions) {
            destination = policyTransitions.getDestination(context)
        }

        //3. 得到最终状态
        let state = states[destination]
        state.debuggerToString()
        println("${path}: ${state.debuggerToString()}")
        return state.candidates
    }

    public func debuggerToString() {
        return String.join(states |> map {f => f.debuggerToString()} |> collectArray, delimiter: '\r\n')
    }
}
