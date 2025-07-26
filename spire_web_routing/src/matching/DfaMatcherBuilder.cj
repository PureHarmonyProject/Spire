package spire_web_routing.matching

import std.sort.*
import std.collection.*
import spire_web_http.*
import spire_web_routing.http.*
import spire_web_routing.patterns.*

let EMPTY_ENDPOINT_LIST = ArrayList<Endpoint>()

public class DfaMatcherBuilder {
    private var _stateIndex = 0
    private var _stateCount = 1
    private let _endpoints = ArrayList<RouteEndpoint>()
    private let _nodeBuilders: ReadOnlyList<INodeBuilderPolicy>

    init(nodeBuilders: ReadOnlyList<INodeBuilderPolicy>) {
        _nodeBuilders = nodeBuilders
    }

    public func addEndpoint(endpoint: RouteEndpoint) {
        _endpoints.add(endpoint)
    }

    public func build(): DfaMatcher {
        let root = buildDfaTree()

        //构建状态机
        root.visit {
            _ => _stateCount++
        }
        let exitDestination = _stateCount - 1
        //默认全部设置为退出状态
        let repeatState = DfaState(JumpTableBuilder.build(exitDestination, exitDestination, None), None)
        let states = Array<DfaState>(_stateCount, repeat: repeatState)
        addNode(root, exitDestination, states)
        return DfaMatcher(states)
    }

    private func buildDfaTree() {
        let root = DfaNode(label: "/", pathDepth: 0)
        let work = ArrayList<DfaBuilderWorkerWorkItem>(_endpoints.size)

        //初始化工作队列
        var maxDepth = 0
        for (endpoint in _endpoints) {
            let precedenceDigit = DfaBuilderWorker.getPrecedenceDigitAtDepth(endpoint, 0)
            work.add(DfaBuilderWorkerWorkItem(endpoint, precedenceDigit, ArrayList<DfaNode>([root])))
            maxDepth = max(maxDepth, endpoint.routePattern.pathSegments.size)
        }

        let dfaWorker = DfaBuilderWorker(work)

        for (depth in 0..maxDepth + 1) {
            dfaWorker.processLevel(depth)
        }

        //构建策略节点
        root.visit(applyPolicies)
        return root
    }

    private func addNode(node: DfaNode, exitDestination: Int64, states: Array<DfaState>): Int64 {
        let currentStateIndex = _stateIndex
        // 默认跳转和退出跳转目标，初始为退出状态
        var currentDefaultDestination = exitDestination
        var currentExitDestination = exitDestination

        func transition(next: DfaNode): Int64 {
            // 如果跳转目标是自己，直接返回当前索引
            if (refEq(node, next)) {
                return _stateIndex
            } else {
                _stateIndex++
                return addNode(next, exitDestination, states)
            }
        }

        // 路径跳转项
        let pathEntries = if (let Some(literals) <- node.literals && literals.size > 0) {
            let entries = Array<(String, Int64)>(literals.size, repeat: (String.empty, 0))

            //生成跳转项
            for ((i, (key, value)) in literals |> enumerate) {
                entries[i] = (key, transition(value))
            }

            entries
        } else {
            Option<Array<(String, Int64)>>.None
        }

        // 只有catchall参数时，默认和退出都跳到该分支
        if (let Some(parameters) <- node.parameters && let Some(catchAll) <- node.catchAll && refEq(parameters, catchAll)) {
            currentDefaultDestination = transition(parameters)
        } else if (let Some(parameters) <- node.parameters && let Some(catchAll) <- node.catchAll) {
            //当catchall参数和parameters参数都存在，但是不相等
            currentDefaultDestination = transition(parameters)
            currentExitDestination = transition(catchAll)
        } else if (let Some(parameters) <- node.parameters) {
            //当只有parameters参数存在，默认跳到参数
            currentDefaultDestination = transition(parameters)
        } else if (let Some(catchAll) <- node.catchAll) {
            // 只有catchall分支时，默认和退出都跳到catchall
            currentDefaultDestination = transition(catchAll)
            currentExitDestination = currentDefaultDestination
        }

        //构建策略分支集合
        let policyEntries: ?ArrayList<PolicyJumpTableEdge> = if (let Some(policyEdges) <- node.policyEdges && policyEdges.size > 0) {
            let policyEntries = ArrayList<PolicyJumpTableEdge>(policyEdges.size)
            for ((i, (key, value)) in policyEdges |> enumerate) {
                policyEntries[i] = PolicyJumpTableEdge(key, transition(value))
            }
            policyEntries
        } else {
            None
        }

        //生成候选集
        var candidates = createCandidates(node.matches)

        //生成当前状态
        let pathJumpTable = JumpTableBuilder.build(currentDefaultDestination, currentExitDestination, pathEntries) //路径跳转表
        let policyJumpTable =  buildPolicyJumpTable(currentExitDestination, node.nodeBuilder, policyEntries)
        states[currentStateIndex] = DfaState(pathJumpTable, policyJumpTable , candidates)
        return currentStateIndex
    }

    private func applyPolicies(node: DfaNode): Unit {
        //跳过非终端节点
        if (node.matches?.size == 0) {
            return
        }

        // 当前工作项
        var work = ArrayList<DfaNode>([node])
        //前一个工作项
        var previousWork: ?ArrayList<DfaNode> = None

        //使用每个策略构建器，计算

        for (nodeBuilder in _nodeBuilders) {
            //准备下一个工作项，复用上一个工作列表边
            let nextWork = if (let Some(previousWork) <- previousWork) {
                previousWork.clear()
                previousWork
            } else {
                ArrayList<DfaNode>()
            }

            //处理当前工作项
            for (parent in work) {
                if (!nodeBuilder.appliesToEndpoints(parent.matches ?? ArrayList<Endpoint>())) {
                    //节点构建器不适用于当前节点，交由下一个节点构建器处理
                    nextWork.add(parent)
                    continue
                }

                // 该节点构建器确实适用于此节点，因此需要为每条边创建新节点
                // 然后将其附加到父节点上。
                let edges = nodeBuilder.getEdges(parent.matches ?? EMPTY_ENDPOINT_LIST)
                for (edge in edges) {
                    //新建节点
                    let next = DfaNode(label: "${parent.label} ${edge.state}", pathDepth: parent.pathDepth - 1)

                    if (edge.endpoints.size > 0) {
                        next.addMatches(edge.endpoints)
                    }
                    //待后续节点构建器处理
                    nextWork.add(next)
                    parent.addPolicyEdge(edge.state, next)
                }

                parent.nodeBuilder = nodeBuilder

                //父节点不再有匹配项，因此不被视为终端节点
                parent.matches?.clear()
            }

            previousWork = work
            work = nextWork
        }
    }

    private func buildPolicyJumpTable(exitDestination: Int64, nodeBuilder: ?INodeBuilderPolicy, policyEntries: ?ArrayList<PolicyJumpTableEdge>): ?PolicyJumpTable {
        if (let Some(policyEntries) <- policyEntries && let Some(nodeBuilder) <- nodeBuilder) {
            nodeBuilder.buildJumpTable(exitDestination, policyEntries)
        }
        return None
    }

    private func createCandidates(endpoints: ?ArrayList<Endpoint>): Array<Candidate> {
        if (let Some(endpoints) <- endpoints) {
            let candiates = ArrayList<Candidate>(endpoints.size)

            for (endpoint in endpoints) {
                candiates.add(createCandidate(endpoint, 1))
            }
            candiates |> collectArray
        } else {
            return []
        }
    }

    private func createCandidate(endpoint: Endpoint, score: Int64): Candidate {
        return Candidate(endpoint, score)
    }
}

class DfaBuilderWorker {
    private var _workCount: Int64
    private var _work: ArrayList<DfaBuilderWorkerWorkItem>
    private var _previousWork: ArrayList<DfaBuilderWorkerWorkItem>

    init(work: ArrayList<DfaBuilderWorkerWorkItem>) {
        _work = work
        _workCount = work.size
        _previousWork = ArrayList<DfaBuilderWorkerWorkItem>()
    }

    public func processLevel(depth: Int64) {
        let nextWork = _previousWork
        var nextWorkCount = 0

        sort(_work)

        //处理当前工作队列
        for (work in _work) {
            let (endpoint, parents) = work.deconstruct()

            //如果指定深度之后无必须处理的路径段
            if (!hasAdditionalRequiredSegments(endpoint, depth)) {
                for (parent in parents) {
                    parent.addMatch(endpoint)
                }
            }

            //准备下一层工作项
            let nextParents: ArrayList<DfaNode> = if (nextWorkCount < nextWork.size) {
                let nextParents = nextWork[nextWorkCount].parents
                //内存复用
                nextParents.clear()
                let precedenceDigit = getPrecedenceDigitAtDepth(endpoint, 0)
                nextWork[nextWorkCount] = DfaBuilderWorkerWorkItem(endpoint, precedenceDigit, nextParents)
                nextParents
            } else {
                //新建工作项内存
                let nextParents = ArrayList<DfaNode>()
                let precedenceDigit = getPrecedenceDigitAtDepth(endpoint, 0)
                nextWork.add(DfaBuilderWorkerWorkItem(endpoint, precedenceDigit, nextParents))
                nextParents
            }

            //处理当前段落
            if (let Some(segment) <- getCurrentSegment(endpoint, depth)) {

                //处理路径段
                processSegment(segment, endpoint, parents, nextParents)

                if (nextParents.size > 0) {
                    nextWorkCount++
                }
            }
        }

        _previousWork = _work
        _work = nextWork
        _workCount = nextWorkCount
    }

    private func processSegment(segment: RoutePatternPathSegment, endpoint: RouteEndpoint, parents: ArrayList<DfaNode>,
        nextParents: ArrayList<DfaNode>) {
        for (parent in parents) {
            if (let Literal(literal) <- segment) {
                //文本段
                if (let Some(next) <- parent.literals.flatMap {f => f.get(literal)}) {
                    nextParents.add(next)
                } else {
                    let next = DfaNode(label: "${parent.label}${literal}/", pathDepth: parent.pathDepth + 1)
                    parent.addLiteral(literal, next)
                    nextParents.add(next)
                }
            } else if (let Parameter(_, kind) <- segment && kind.isCatchAll) { //通配参数段

                //加入到后续处理
                if (let Some(literals) <- parent.literals) {
                    nextParents.add(all: literals.values())
                }

                //加入到后续处理
                if (let Some(parameters) <- parent.parameters) {
                    nextParents.add(parameters)
                }

                //通配参数的后续参数节点都将是自身
                if (parent.catchAll.isNone()) {
                    parent.catchAll = DfaNode(label: "${parent.label}{*...}/", pathDepth: parent.pathDepth + 1)
                    parent.catchAll?.catchAll = parent.catchAll
                    parent.catchAll?.parameters = parent.catchAll
                }

                parent.catchAll?.addMatch(endpoint)
            } else { //其它参数类型
                if (parent.parameters.isNone()) {
                    parent.parameters = DfaNode(label: "${parent.label}{*...}/", pathDepth: parent.pathDepth + 1)
                }

                //如果此节点存在文本段
                if (let Some(literals) <- parent.literals) {
                    //加入到后续处理
                    nextParents.add(all: literals.values())
                }

                //上面进行了非空判定
                nextParents.add(parent.parameters.getOrThrow())
            }
        }
    }

    /*
    返回指定深度的路径段
     */
    private static func getCurrentSegment(endpoint: RouteEndpoint, depth: Int64): ?RoutePatternPathSegment {
        if (depth < endpoint.routePattern.pathSegments.size) {
            return endpoint.routePattern.pathSegments[depth]
        }

        return None
    }

    /*
    判定后续是否还有必须处理的路径段
     */
    private func hasAdditionalRequiredSegments(endpoint: RouteEndpoint, depth: Int64) {
        for (i in depth..endpoint.routePattern.pathSegments.size) {
            let segment = endpoint.routePattern.pathSegments[i]

            //字面量
            if (let Literal(_) <- segment) {
                return true
            }

            //标准参数
            if (let Parameter(_, kind) <- segment && kind.isStandard) {
                return true
            }
        }
        return false
    }

    public static func getPrecedenceDigitAtDepth(endpoint: RouteEndpoint, depth: Int64): Int64 {
        var segment = getCurrentSegment(endpoint, depth)
        /*
        字面量：1
        通配参数：5
        普通参数：3
        其它：0
         */
        if (let Some(segment) <- segment) {
            return match (segment) {
                case Literal(_) => 1
                case Parameter(_, kind) =>
                    if (kind.isCatchAll) {
                        5
                    } else {
                        3
                    }
            }
        } else {
            return 0
        }
    }
}

struct DfaBuilderWorkerWorkItem <: Comparable<DfaBuilderWorkerWorkItem> {
    DfaBuilderWorkerWorkItem(let endpoint: RouteEndpoint, let precedenceDigit: Int64, let parents: ArrayList<DfaNode>) {
    }

    public func deconstruct() {
        return (endpoint, parents)
    }

    public func compare(that: DfaBuilderWorkerWorkItem) {
        if (precedenceDigit > that.precedenceDigit) {
            Ordering.GT
        } else if (precedenceDigit < that.precedenceDigit) {
            Ordering.LT
        }
        return Ordering.EQ
    }
}
