import SwiftX
import Foundation
import Logging

/**
 * 🚀 SwiftX Full Showcase (Professional Architecture)
 * High-performance runtime demonstrating all features with externalized handlers.
 */

// --- 🧩 1. CUSTOM PLUGIN ---
public class AuthPlugin: SwiftXPlugin, @unchecked Sendable {
    public init() {}
    public func boot(app: SwiftXApp) {
        app.use { req, ctx in
            ctx.log("🛡️ Auth Plugin Check for: \(req.path)")
            return true // Check headers here
        }
    }
}

// --- 🏗️ 2. SERVER INITIALIZATION ---
let appInstance = SwiftXApp(envPath: ".env")

// Official and custom plugins
appInstance.use(LoggerPlugin())
appInstance.use(AuthPlugin())
appInstance.use(CorsPlugin(origin: "*"))
appInstance.use(StaticFilesPlugin(at: "/cdn", from: "./public"))

// --- 🎯 3. ROUTING WITH EXTERNAL HANDLERS ---

// Map / to showcaseHomeHandler (from ShowcaseHandlers.swift)
appInstance.get("/", handler: showcaseHomeHandler)

// Advanced API grouping
appInstance.group("/api/v1") { v1 in
    
    // Map /api/v1/user/:id to userProfileHandler (reusing example handlers)
    v1.get("/user/:id", handler: userProfileHandler)
    
    // Auth test using external handler
    v1.get("/auth/test", handler: showcaseAuthTestHandler)
    
    // Fast metrics using external handler
    v1.get("/metrics", handler: engineMetricsHandler)
}

// Custom 404 branding
appInstance.notFound { req, ctx in
    ctx.log("🚨 Not Found: \(req.path)")
    return .html("<h1 style='color:red;'>Custom 404 - Path Not Found</h1><a href='/'>Go Home</a>")
}

// --- ⚡ 4. START THE ENGINE ---
print("[SwiftX] Booting showcase runtime...")

appInstance.start(
    port: 5300, 
    threads: 8, 
    development: true
)
