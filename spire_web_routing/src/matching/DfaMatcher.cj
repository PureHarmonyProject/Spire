package spire_web_routing.matching

import std.collection.*
import spire_web_http.*
import spire_web_routing.http.*

protected class DfaMatcher <: Matcher {
    DfaMatcher(let endpointSelector: EndpointSelector, let states: Array<DfaState>) {
    }

    public func invoke(context: HttpContext) {
        let path = PathSegment.parse(context.request.path.value)
        //查找候选集
        let candidates = findCandidateSet(context, path)
        //筛选最终的候选结果
        let candidateStates = ArrayList<CandidateState>()
        for (candidate in candidates) {
            var routeValues: ?RouteValues = None
            if (candidate.captures.size > 0 || candidate.catchAll.isSome()) {
                routeValues = RouteValues()
            }
            for ((name, segmentIndex) in candidate.captures) {
                routeValues?.add(name, path.segments[segmentIndex])
            }
            if (let Some((name, segmentIndex)) <- candidate.catchAll) {
                let values = path.segments[segmentIndex..]
                routeValues?.add(name, String.join(values, delimiter: '/'))
            }
            candidateStates.add(CandidateState(candidate.endpoint, candidate.score, routeValues))
        }
        //选举
        endpointSelector.select(context, CandidateSet(candidateStates.toArray()))
    }

    private func findCandidateSet(context: HttpContext, path: PathSegment) {
        var destination = 0
       
        //1. 使用路径跳转
        for (segment in path.segments) {
            destination = states[destination].pathTransitions.getDestination(segment)
        }

        //2. 使用策略跳转
        while (let Some(policyTransitions) <- states[destination].policyTransitions) {
            destination = policyTransitions.getDestination(context)
        }

        //3. 得到最终状态
        let state = states[destination]
        return state.candidates
    }

    public func debuggerToString() {
        return String.join(states |> map {f => f.debuggerToString()} |> collectArray, delimiter: '\r\n')
    }
}
