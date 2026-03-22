import SwiftX
import Foundation

/**
 * 📂 Showcase Handlers (External File)
 * Professional API organization for massive projects.
 */

public func showcaseHomeHandler(req: Req, ctx: Context) -> Res {
    return .html("<h1>SwiftX Showcase Dashboard</h1><p>Routed via external file!</p>")
}

public func showcaseAuthTestHandler(req: Req, ctx: Context) -> Res {
    return .json([
        "auth_verified": true,
        "token_expiration": Date().addingTimeInterval(3600).timeIntervalSince1970
    ])
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
    return .json([
        "active_workers": appInstance.metrics.workers,
        "active_connections": appInstance.metrics.connections
    ])
}
