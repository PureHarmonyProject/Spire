package spire_web_routing.matching

import std.collection.*
import spire_web_http.*
import spire_web_routing.http.*

let ANY_HTTP_METHOD = '*'
let ANY_HTTP_METHOD_LIST = ArrayList<String>([ANY_HTTP_METHOD])

public class HttpMethodMatcherPolicy <: INodeBuilderPolicy {
    /*
    评估该策略是否适用于给定的端点列表
     */
    public func appliesToEndpoints(endpoints: ReadOnlyList<Endpoint>): Bool {
        for (endpoint in endpoints) {
            if (endpoint.metadata.getMetadata<IHttpMethodMetadata>().flatMap {f => f.httpMethods.size > 0} == true) {
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
            for (httpMethod in httpMethods) {
                let state = EdgeState(httpMethod)
                if (!edges.contains(state)) {
                    edges.add(EdgeState(httpMethod), ArrayList<Endpoint>())
                }
                if (!httpMethod.equalsIgnoreAsciiCase(ANY_HTTP_METHOD) && !allHttpMethods.contains(httpMethod)) {
                    allHttpMethods.add(httpMethod)
                }
            }
        }

        //计算匹配的终结点
        for (endpoint in endpoints) {
            for (httpMethod in getHttpMethods(endpoint)) {
                edges[EdgeState(httpMethod)].add(endpoint)
            }
        }

        //添加一个支持任意method，返回405的分支作为默认分支，使得便于开发调试
        let anyEdgeState = EdgeState(ANY_HTTP_METHOD)
        if (!edges.contains(anyEdgeState)) {
            let endpoint = createRejectionEndpoint(allHttpMethods)
            edges[anyEdgeState] = ArrayList<Endpoint>([endpoint])
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
        endpoint.metadata.getMetadata<IHttpMethodMetadata>().flatMap {f => f.httpMethods} ?? ANY_HTTP_METHOD_LIST
    }

    private func createRejectionEndpoint(allHttpMethods: Collection<String>): RejectionEndpoint {
        let allow = String.join(allHttpMethods |> collectArray, delimiter: ', ')
        return RejectionEndpoint { context =>
            context.response.addHeader(HeaderNames.Allow, allow)
            context.response.status(StatusCodes.MethodNotAllowed)
        }
    }
}

private class RejectionEndpoint <: Endpoint {
    init(delegate: RequestDelegate) {
        super(delegate, EndpointMetadataCollection.empty, "405 HTTP Method Not Supported")
    }
}

private struct EdgeState <: IEdgeState & Equatable<EdgeState> {
    EdgeState(let httpMethod: String) {
    }

    public operator func ==(that: EdgeState) {
        return this.httpMethod.equalsIgnoreAsciiCase(that.httpMethod)
    }

    public operator func ==(that: IEdgeState) {
        if (let that: EdgeState <- that) {
            return this == that
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
    private let _entries: ReadOnlyMap<String, Int64>

    init(exitDestination: Int64, entries: ReadOnlyMap<String, Int64>) {
        _exitDestination = exitDestination
        _entries = entries
    }

    public func getDestination(context: HttpContext): Int64 {
        if (let Some(destination) <- _entries.get(context.request.method.toAsciiLower())) {
            return destination
        }
        if (let Some(destination) <- _entries.get(ANY_HTTP_METHOD)) {
            return destination
        }
        return _exitDestination
    }

    public func debuggerToString(): String {
        let entries = ArrayList<String>()
        for ((state, index) in _entries) {
            entries.add('{\"${state}\": ${index}}')
        }
        let entriesJson = String.join(entries |> collectArray, delimiter: ', ')
        return '{\"exit\": ${_exitDestination}, \"entries\": [${entriesJson}]}'
    }
}
