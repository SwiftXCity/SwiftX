public protocol SwiftXPlugin: Sendable {
    func boot(app: SwiftXApp)
    func onStart()
    func onStop()
}

extension SwiftXPlugin {
    public func onStart() {}
    public func onStop() {}
}
