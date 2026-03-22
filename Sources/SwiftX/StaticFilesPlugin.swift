import Foundation

/// A plugin that serves static file placeholders and demonstrates path parameters.
public class StaticFilesPlugin: SwiftXPlugin, @unchecked Sendable {
    private let path: String
    private let directory: String
    
    public init(at path: String, from directory: String) {
        self.path = path
        self.directory = directory
    }
    
    public func boot(app: SwiftXApp) {
        app.get("\(path)/:filename") { req, ctx in
            guard let filename = req.param("filename") else { return .text("File Name Required") }
            ctx.log("[STATIC] Request for: \(filename)")
            
            // In a production environment, you would use FileManager.default.contents(atPath:)
            // For this demo, we acknowledge the path mapping.
            return .text("Serving static asset '\(filename)' from local directory: \(self.directory)")
        }
    }
    
    public func onStart() {
        print("[SwiftX] [STATIC] Monitoring assets in: \(directory)")
    }
}
