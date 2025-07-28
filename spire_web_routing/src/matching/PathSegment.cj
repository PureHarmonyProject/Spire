// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing.matching

struct PathSegment <: ToString {
    private PathSegment(let rawText: String, let segments: Array<String>) {
    }

    public static func parse(rawText: String) {
        let segments = rawText.split('/', removeEmpty: true)
        return PathSegment(rawText, segments)
    }

    public func toString() {
        return rawText
    }
}
