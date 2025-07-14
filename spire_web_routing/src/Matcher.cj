// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing

import std.sync.*
import std.collection.*
import spire_web_http.*
import spire_extensions_options.*

class DfaMatcher <: IMatcher {
    private var _dataSource: EndpointDataSource

    public init(dataSource: EndpointDataSource) {
        _dataSource = dataSource
    }

    public func invoke(context: HttpContext): RouteFlags {
        let request = RoutePattern.parse(context.request.path.value)
        let routeValues = context.request.routeValues
        var flag = RouteFlags.Notfound
        for (endpoint in _dataSource.endpoints |> filterMap {f => f as RouteEndpoint}) {
            if (tryMatch(routeValues, request, endpoint.routePattern)) {
                flag = RouteFlags.MethodNotAllowed
                if (isAllowedRequestMethod(context, endpoint)) {
                    context.setEndpoint(endpoint)
                    return RouteFlags.Ok
                }
            } else {
                routeValues.clear()
            }
        }
        return flag
    }

    private func tryMatch(routeValues: RouteValues, request: RoutePattern, pattern: RoutePattern): Bool {
        if (request.segments.size != pattern.segments.size) {
            return false
        }

        if (pattern.parameters.size == 0) {
            return request.rawText.equalsIgnoreAsciiCase(pattern.rawText)
        } else {
            for ((index, segment) in pattern.segments |> enumerate) {
                if (pattern.parameters.contains(segment)) {
                    let name = pattern.parameters[segment]
                    let value = request.segments[index]
                    routeValues.add(name, value)
                } else if (!segment.equalsIgnoreAsciiCase(request.segments[index])) {
                    return false
                }
            }
            return true
        }
    }

    private func isAllowedRequestMethod(context: HttpContext, endpoint: Endpoint) {
        let (httpMethods, _) = getHttpMethods(endpoint)
        if (httpMethods |> any {method => context.request.method.equalsIgnoreAsciiCase(method)}) {
            return true
        }else if(httpMethods.size == 0) {
            return true
        }
        return false
    }

    private func getHttpMethods(endpoint: Endpoint): (Collection<String>, Bool) {
        if (let Some(httpMethodMetadata) <- endpoint.metadata.getMetadata<IHttpMethodMetadata>()) {
            return (httpMethodMetadata.httpMethods, httpMethodMetadata.acceptCorsPreflight)
        }else {
            return ([], false)
        }
    }
}
