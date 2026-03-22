import SwiftXCore

public class Req: @unchecked Sendable {
    private let coreReq: Request

    internal init(coreReq: Request) {
        self.coreReq = coreReq
    }

    public var path: String { coreReq.path }
    public var method: String { coreReq.method }

    public func param(_ key: String) -> String? {
        return coreReq.params[key]
    }

    public func json() -> [String: Any]? {
        return coreReq.json()
    }
}
