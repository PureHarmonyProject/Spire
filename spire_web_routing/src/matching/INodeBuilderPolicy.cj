// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing.matching

import std.collection.*
import spire_web_http.*

public interface INodeBuilderPolicy {
    /*
    评估该策略是否适用于给定的端点列表
     */
    func appliesToEndpoints(endpoints: ReadOnlyList<Endpoint>): Bool

    /*
    生成策略分支路径
     */
    func getEdges(endpoints: ReadOnlyList<Endpoint>): ReadOnlyList<PolicyNodeEdge>

    /*
    构建跳转表
     */
    func buildJumpTable(exitDestination: Int64, policyEntries: ReadOnlyList<PolicyJumpTableEdge>): PolicyJumpTable
}