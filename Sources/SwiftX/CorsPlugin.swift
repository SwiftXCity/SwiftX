import Foundation

/// A plugin that adds CORS headers to all responses.
public class CorsPlugin: SwiftXPlugin, @unchecked Sendable {
    private let allowOrigin: String
    private let allowMethods: String
    private let allowHeaders: String
    
    public init(origin: String = "*", methods: String = "GET, POST, PUT, DELETE, OPTIONS", headers: String = "Content-Type, Authorization") {
        self.allowOrigin = origin
        self.allowMethods = methods
        self.allowHeaders = headers
    }
    
    public func boot(app: SwiftXApp) {
        // Intercept all responses to add CORS headers
        app.onResponse { (res: inout Res) in
            var h = res.headers
            h["Access-Control-Allow-Origin"] = self.allowOrigin
            h["Access-Control-Allow-Methods"] = self.allowMethods
            h["Access-Control-Allow-Headers"] = self.allowHeaders
            res.headers = h
        }
        
        // Handle OPTIONS preflight requests if needed
        app.use { req, ctx in
            if req.method == "OPTIONS" {
                // Return immediate empty 200 with CORS headers?
                // Currently, middleware doesn't stop the flow unless it returns false.
                // We'll let the router handle it or add an OPTIONS route.
            }
            return true
        }
    }
}
