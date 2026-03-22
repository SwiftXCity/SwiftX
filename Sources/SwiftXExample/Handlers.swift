import SwiftX
import Foundation

/**
 * 📂 SwiftX External Handlers
 * Defining handlers in separate files ensures a "Dev Perfect" architecture.
 * This is the preferred way to organize large APIs.
 */

/// GET /
public func homeHandler(req: Req, ctx: Context) -> Res {
    ctx.log("Home route hit via external handler")
    return .html("""
        <body style="background:#000;color:#fff;display:flex;align-items:center;justify-content:center;height:100vh;font-family:sans-serif;">
            <div style="text-align:center;">
                <h1>🏠 External Handler Active</h1>
                <p>Path: \(req.path)</p>
                <a href="/api/v1/user/123" style="color:yellow;">Test User Route</a>
            </div>
        </body>
    """)
}

/// GET /api/v1/user/:id
public func userProfileHandler(req: Req, ctx: Context) -> Res {
    let userId = req.param("id") ?? "0"
    ctx.log("Serving profile for ID: \(userId)")
    
    return .json([
        "user_id": userId,
        "handled_by": "External_File",
        "timestamp": Date().timeIntervalSince1970
    ])
}

/// GET /api/v1/metrics
public func engineMetricsHandler(req: Req, ctx: Context) -> Res {
    // Note: To access `app` metrics here, we usually pass it or use the global `app` instance.
    return .json([
        "active_workers": app.metrics.workers,
        "active_connections": app.metrics.connections
    ])
}
