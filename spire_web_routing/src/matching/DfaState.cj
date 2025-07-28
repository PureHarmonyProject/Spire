package spire_web_routing.matching

import std.collection.*

public struct DfaState {
    DfaState(let pathTransitions: JumpTable, let policyTransitions: ?PolicyJumpTable, let candidates: Array<Candidate>) {
    }

    internal func debuggerToString(): String {
        let candidatesStr = String.join(candidates |> map {f => f.debuggerToString()} |> collectArray, delimiter: ",")
        return '{\"jumpTable\": ${pathTransitions.debuggerToString()}, \"policyJumpTable\": ${policyTransitions?.debuggerToString() ?? "null"}, \"candidates\": [${candidatesStr}]}'
    }
}
