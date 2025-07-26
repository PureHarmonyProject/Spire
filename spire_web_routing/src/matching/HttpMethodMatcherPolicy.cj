package spire_web_routing.matching

import std.collection.*
import spire_web_http.*
import spire_web_routing.http.*

let ANY_METHOD = '*'
let ANY_METHOD_LIST = ArrayList<String>([ANY_METHOD])

public class HttpMethodMatcherPolicy <: INodeBuilderPolicy {
    /*
    评估该策略是否适用于给定的端点列表
     */
    public func appliesToEndpoints(endpoints: ReadOnlyList<Endpoint>): Bool {
        for (endpoint in endpoints) {
            if (endpoint.metadata.getMetadata<IHttpMethodMetadata>().isSome()) {
                return true
            }
        }
        return false
    }

    /*
    生成分支
     */
    public func getEdges(endpoints: ReadOnlyList<Endpoint>): ReadOnlyList<PolicyNodeEdge> {
        let allHttpMethods = HashSet<String>()
        let edges = HashMap<EdgeState, ArrayList<Endpoint>>()

        //计算出所有的请求方式
        for (endpoint in endpoints) {
            let httpMethods = getHttpMethods(endpoint)
            allHttpMethods.add(all: httpMethods)
            for (httpMethod in httpMethods) {
                edges.add(EdgeState(httpMethod), ArrayList<Endpoint>())
            }
        }

        //计算匹配项
        for (endpoint in endpoints) {
            for (httpMethod in getHttpMethods(endpoint)) {
                edges[EdgeState(httpMethod)].add(endpoint)
            }
        }

        let policyNodeEdges = ArrayList<PolicyNodeEdge>(edges.size)

        for ((key, value) in edges) {
            policyNodeEdges.add(PolicyNodeEdge(key, value))
        }

        return policyNodeEdges
    }

    /*
    构建跳转表
     */
    public func buildJumpTable(exitDestination: Int64, policyEntries: ReadOnlyList<PolicyJumpTableEdge>): PolicyJumpTable {
        let destinations = HashMap<String, Int64>()

        for (entry in policyEntries) {
            let state = (entry.state as EdgeState).getOrThrow()
            let destination = entry.destination
            destinations.add(state.httpMethod, destination)
        }

        return HttpMethodDictionaryPolicyJumpTable(exitDestination, destinations)
    }

    private func getHttpMethods(endpoint: Endpoint) {
        endpoint.metadata.getMetadata<IHttpMethodMetadata>().flatMap {f => f.httpMethods} ?? ANY_METHOD_LIST
    }
}

private struct EdgeState <: IEdgeState & ToString & Equatable<EdgeState> {
    EdgeState(let httpMethod: String) {
    }

    public operator func ==(that: EdgeState) {
        return this.httpMethod.equalsIgnoreAsciiCase(that.httpMethod)
    }

    public operator func ==(that: IEdgeState) {
        if (let that: EdgeState <- that) {
            this == that
        } else {
            return false
        }
    }

    public func hashCode() {
        return httpMethod.toAsciiLower().hashCode()
    }

    public func toString() {
        return "HTTP: ${httpMethod}"
    }
}

private class HttpMethodDictionaryPolicyJumpTable <: PolicyJumpTable {
    private let _exitDestination: Int64
    private let _entries: HashMap<String, Int64>

    init(exitDestination: Int64, entries: ReadOnlyMap<String, Int64>) {
        _exitDestination = exitDestination
        _entries = HashMap<String, Int64>(entries)
    }

    public func getDestination(context: HttpContext): Int64 {
        if (let Some(destination) <- _entries.get(context.request.method)) {
            return destination
        }
        return _exitDestination
    }

    public func debuggerToString(): String {
        let sb = StringBuilder()
        for ((state, index) in _entries) {
            sb.append('{"${state}": ${index}}')
        }
        return '{"exit": ${_exitDestination}, "entries": ${sb}}'
    }
}
