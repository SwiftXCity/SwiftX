import SwiftXCore
import Foundation

public enum Res: @unchecked Sendable {
    case text(String, headers: [String: String] = [:])
    case json([String: Any], headers: [String: String] = [:])
    case html(String, headers: [String: String] = [:])

    public var headers: [String: String] {
        get {
            switch self {
            case .text(_, let h): return h
            case .json(_, let h): return h
            case .html(_, let h): return h
            }
        }
        set {
            switch self {
            case .text(let c, _): self = .text(c, headers: newValue)
            case .json(let c, _): self = .json(c, headers: newValue)
            case .html(let c, _): self = .html(c, headers: newValue)
            }
        }
    }

    internal func toCore() -> Response {
        switch self {
        case .text(let content, let h):
            var res = Response.text(content)
            for (k, v) in h { res = Response(status: res.status, headers: res.headers.merging([k: v], uniquingKeysWith: { $1 }), body: res.body) }
            return res
        case .json(let content, let h):
            var res = Response.json(content)
            for (k, v) in h { res = Response(status: res.status, headers: res.headers.merging([k: v], uniquingKeysWith: { $1 }), body: res.body) }
            return res
        case .html(let content, let h):
            var res = Response.html(content)
            for (k, v) in h { res = Response(status: res.status, headers: res.headers.merging([k: v], uniquingKeysWith: { $1 }), body: res.body) }
            return res
        }
    }
}
// Helper to simplify creation
extension Res {
    public static func text(_ content: String) -> Res { .text(content, headers: [:]) }
    public static func json(_ content: [String: Any]) -> Res { .json(content, headers: [:]) }
    public static func html(_ content: String) -> Res { .html(content, headers: [:]) }
}
