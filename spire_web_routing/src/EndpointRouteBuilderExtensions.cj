// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing

import std.collection.*

private let GetVerb = [HttpMethods.Get]
private let PostVerb = [HttpMethods.Post]
private let PutVerb = [HttpMethods.Put]
private let DeleteVerb = [HttpMethods.Delete]
private let PatchVerb = [HttpMethods.Patch]

extend EndpointRouteBuilder {
    public func mapGet(pattern: String, delegate: RequestDelegate) {
        mapMethods(pattern, delegate, GetVerb)
    }

    public func mapPut(pattern: String, delegate: RequestDelegate) {
        mapMethods(pattern, delegate, PutVerb)
    }

    public func mapPatch(pattern: String, delegate: RequestDelegate) {
        mapMethods(pattern, delegate, PatchVerb)
    }

    public func mapPost(pattern: String, delegate: RequestDelegate) {
        mapMethods(pattern, delegate, PostVerb)
    }

    public func mapDelete(pattern: String, delegate: RequestDelegate) {
        mapMethods(pattern, delegate, DeleteVerb)
    }

    public func map(pattern: String, delegate: RequestDelegate) {
        return map(pattern, delegate, [])
    }

    private func mapMethods(routePattern: String, delegate: RequestDelegate, httpMethods: Collection<String>) {
        return map(routePattern, delegate, httpMethods)
    }
   
    private func map(routePattern: String, delegate: RequestDelegate, httpMethods: Collection<String>) {
        let dataSource = getOrAddRouteEndpointDataSource()
        return dataSource.addRequestDelegate(routePattern, delegate, httpMethods)
    }

    private func getOrAddRouteEndpointDataSource() {
        for (pattern in this.dataSources) {
            if (let foundDataSource: RouteEndpointDataSource <- pattern) {
                return foundDataSource
            }
        }
        let dataSource = RouteEndpointDataSource(this.serviceProivder)
        this.dataSources.add(dataSource)
        return dataSource
    }
}
