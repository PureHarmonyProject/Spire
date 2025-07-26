package spire_web_routing.matching

import std.collection.*
import spire_web_http.*

public interface INodeBuilderPolicy {
    /*
    评估该策略是否适用于给定的端点列表
     */
    func appliesToEndpoints(endpoints: ReadOnlyList<Endpoint>): Bool

    /*
    生成分支
     */
    func getEdges(endpoints: ReadOnlyList<Endpoint>): ReadOnlyList<PolicyNodeEdge>

    /*
    构建跳转表
     */
    func buildJumpTable(exitDestination: Int64, policyEntries: ReadOnlyList<PolicyJumpTableEdge>): PolicyJumpTable
}