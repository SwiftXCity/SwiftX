import Foundation

public class LoggerPlugin: SwiftXPlugin, @unchecked Sendable {
    public init() {}
    
    public func boot(app: SwiftXApp) {
        app.use { @Sendable req, ctx in
            // Use ctx.log to ensure the development/production flag is respected
            ctx.log("\(req.method) \(req.path)")
            return true
        }
    }
}
