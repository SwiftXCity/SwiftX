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
