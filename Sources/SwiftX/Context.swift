import SwiftXCore

public class Context: @unchecked Sendable {
    private let _core: TaskContext?
    private let showLogs: Bool

    internal init(coreCtx: TaskContext?, showLogs: Bool) {
        self._core = coreCtx
        self.showLogs = showLogs
    }

    public func sleep(ms: Int) {
        _core?.sleep(ms: ms)
    }

    public func set(_ key: String, _ value: Any) {
        _core?.set(key, value)
    }

    public func get<T>(_ key: String) -> T? {
        return _core?.get(key)
    }

    public func log(_ message: String) {
        if showLogs {
            print("[SwiftX] LOG: \(message)")
        }
    }
}
