// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing.matching

import std.collection.*

struct DfaState {
    DfaState(let pathTransitions: JumpTable, let policyTransitions: ?PolicyJumpTable, let candidates: Array<Candidate>) {
    }

    internal func debuggerToString(): String {
        let candidatesStr = String.join(candidates |> map {f => f.debuggerToString()} |> collectArray, delimiter: ",")
        return '{\"jumpTable\": ${pathTransitions.debuggerToString()}, \"policyJumpTable\": ${policyTransitions?.debuggerToString() ?? "null"}, \"candidates\": [${candidatesStr}]}'
    }
}
