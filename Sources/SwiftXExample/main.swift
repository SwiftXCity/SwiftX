import SwiftX
import Foundation
import Logging 

// 1. Setup Standard Swift Logger
// Making it a constant to ensure it's safe to share across threads
let logger = Logger(label: "com.swiftx.demo")

// 2. Custom Plugin demonstrating .env access
class EnvironmentPlugin: SwiftXPlugin, @unchecked Sendable {
    func boot(app: SwiftXApp) {
        app.use { req, ctx in
            // Access environment variable loaded from .env
            let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? "NONE"
            ctx.set("api_key", apiKey)
            return true
        }
    }
}

// 3. App Setup
let appInstance = SwiftXApp(envPath: ".env") 

appInstance.use(EnvironmentPlugin())
appInstance.use(LoggerPlugin())
appInstance.use(StaticFilesPlugin(at: "/public", from: "./public"))

// 4. Routes
appInstance.get("/") { req, ctx in
    let key = ctx.get("api_key") as String? ?? "Unknown"
    
    // Logger is Sendable, so we can use it here
    logger.info("Serving home page with API Key access")
    
    return .html("""
        <body style="background:#0a0a0a;color:#fff;display:flex;align-items:center;justify-content:center;height:100vh;font-family:sans-serif;">
            <div style="text-align:center; border:1px solid #333; padding:3rem; border-radius:12px; background:#000;">
                <h1 style="font-size:3.5rem; letter-spacing:-2px;">SwiftX <span style="font-weight:200;">Pro</span></h1>
                <p style="color:#666; margin-bottom:2rem;">High-Precision Engine Over Managed SwiftXCore</p>
                <div style="background:#111; padding:10px; border-radius:4px; font-family:monospace; color:#0f0; margin-bottom:2rem;">
                    API_KEY: \(key)
                </div>
                <a href="/metrics" style="color:#fff; border:1px solid #fff; padding:10px 20px; text-decoration:none;">Engine Metrics</a>
            </div>
        </body>
    """)
}

appInstance.get("/metrics") { req, ctx in
    return .json([
        "workers": appInstance.metrics.workers,
        "connections": appInstance.metrics.connections,
        "env": "production_mode"
    ])
}

// 5. Start Server
print("[SwiftX] Booting managed engine...")

let port = Int(ProcessInfo.processInfo.environment["PORT"] ?? "5100") ?? 5100

appInstance.start(
    port: port,
    threads: 16,
    development: false 
)
