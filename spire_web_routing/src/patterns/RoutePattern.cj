// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing.patterns

import std.collection.*

public class RoutePattern {
    private let _rwaText: String
    private let _pathSegments: ReadOnlyList<RoutePatternPathSegment>

    init(rawText: String, pathSegments: ReadOnlyList<RoutePatternPathSegment>) {
        _rwaText = rawText
        _pathSegments = pathSegments
    }

    public prop rawText: String {
        get() {
            _rwaText
        }
    }

    public prop pathSegments: ReadOnlyList<RoutePatternPathSegment> {
        get() {
            _pathSegments
        }
    }

    public func debuggerToString() {
        return String.join(_pathSegments |> map {f => f.debuggerToString()} |> collectArray, delimiter: '/')
    }

    public static func parse(pattern: String) {
        let pathSegments = ArrayList<RoutePatternPathSegment>()

        for (segment in pattern.split("/", removeEmpty: true)) {
            pathSegments.add(parseSegment(segment))
        }

        return RoutePattern(pattern, pathSegments)
    }

    private static func parseSegment(segment: String): RoutePatternPathSegment {
        if (segment.startsWith('{') && segment.endsWith('}')) {
            return parseParameter(segment)
        }
        return parseLiteral(segment)
    }

    private static func parseParameter(parameter: String) {
        if (parameter[1..].startsWith("*")) {
            let name = parameter[2..parameter.size - 1]
            return RoutePatternPathSegment.Parameter(name, RoutePatternParameterKind.CatchAll)
        } else if (parameter[1..].startsWith("?")) {
            let name = parameter[2..parameter.size - 1]
            return RoutePatternPathSegment.Parameter(name, RoutePatternParameterKind.Optional)
        } else {
            let name = parameter[1..parameter.size - 1]
            return RoutePatternPathSegment.Parameter(name, RoutePatternParameterKind.Standard)
        }
    }

    private static func parseLiteral(content: String) {
        return RoutePatternPathSegment.Literal(content)
    }
}
