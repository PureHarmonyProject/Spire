// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing.matching

import std.collection.*
import spire_web_http.*

class DfaNode {
    private let _label: String
    private var _pathDepth: Int64
    private var _catchAll: ?DfaNode
    private var _parameters: ?DfaNode
    private var _matches: ?ArrayList<Endpoint> = None
    private var _nodeBuilder: ?INodeBuilderPolicy = None
    private var _literals: ?HashMap<String, DfaNode> = None
    private var _policyEdges: ?HashMap<IEdgeState, DfaNode> = None

    init(label!: String, pathDepth!: Int64 = -1, catchAll!: ?DfaNode = None, parameters!: ?DfaNode = None) {
        _label = label
        _catchAll = catchAll
        _pathDepth = pathDepth
        _parameters = parameters
    }

    public prop label: String {
        get() {
            _label
        }
    }

    public prop pathDepth: Int64 {
        get() {
            _pathDepth
        }
    }

    public mut prop catchAll: ?DfaNode {
        get() {
            _catchAll
        }
        set(value) {
            _catchAll = value
        }
    }

    public mut prop parameters: ?DfaNode {
        get() {
            _parameters
        }
        set(value) {
            _parameters = value
        }
    }

    public prop matches: ?ArrayList<Endpoint> {
        get() {
            _matches
        }
    }

    public prop policyEdges: ?HashMap<IEdgeState, DfaNode> {
        get() {
            _policyEdges
        }
    }

    public prop literals: ?HashMap<String, DfaNode> {
        get() {
            _literals
        }
    }

    public mut prop nodeBuilder: ?INodeBuilderPolicy {
        get() {
            _nodeBuilder
        }
        set(value) {
            _nodeBuilder = value
        }
    }

    public func addMatch(endpoint: Endpoint) {
        if (let Some(matches) <- _matches) {
            matches.add(endpoint)
        } else {
            _matches = ArrayList<Endpoint>([endpoint])
        }
    }

    public func addMatches(endpoints: Collection<Endpoint>) {
        if (let Some(matches) <- _matches) {
            matches.add(all: endpoints)
        } else {
            _matches = ArrayList<Endpoint>(endpoints)
        }
    }

    public func addPolicyEdge(state: IEdgeState, node: DfaNode) {
        if (let Some(policyEdges) <- _policyEdges) {
            policyEdges.add(state, node)
        } else {
            _policyEdges = HashMap<IEdgeState, DfaNode>([(state, node)])
        }
    }

    public func addLiteral(literal: String, node: DfaNode) {
        if (let Some(literals) <- _literals) {
            literals[literal] = node
        } else {
            _literals = HashMap<String, DfaNode>([(literal, node)])
        }
    }

    public func visit(visitor: (DfaNode) -> Unit): Unit {
        if (let Some(literals) <- _literals) {
            for ((_, value) in literals) {
                value.visit(visitor)
            }
        }

        //!refEq(this, parameter)是为了防止递归
        if (let Some(parameters) <- _parameters && !refEq(this, parameters)) {
            parameters.visit(visitor)
        }

        //!refEq(this, catchAll)是为了防止递归
        if (let Some(catchAll) <- _catchAll && !refEq(this, catchAll)) {
            catchAll.visit(visitor)
        }

        if (let Some(policyEdges) <- _policyEdges && !refEq(this, policyEdges)) {
            for ((_, dege) in policyEdges) {
                dege.visit(visitor)
            }
        }

        visitor(this)
    }
}
