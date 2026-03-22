import SwiftXCore
import Foundation

#if os(Windows)
import WinSDK
#elseif os(Linux)
import Glibc
#elseif os(macOS)
import Darwin
#endif

// MARK: - Route Handler Definition
public typealias RouteHandler = @Sendable (Req, Context) -> Res

// MARK: - Route Definition
private struct RouteDefinition {
    let method: String
    let path: String
    let name: String?
    let handler: RouteHandler
}

public final class SwiftXApp: @unchecked Sendable {
    private var routes: [RouteDefinition] = []
    private var middlewares: [@Sendable (Req, Context) -> Bool] = []
    private var plugins: [SwiftXPlugin] = []
    private var core: SwiftXCore?
    private var isDevelopment: Bool = false

    // MARK: - Metrics
    public struct Metrics: Sendable {
        private weak var host: SwiftXApp?
        init(host: SwiftXApp) { self.host = host }
        
        public var workers: Int { host?.core?.activeWorkersCount ?? 0 }
        public var connections: Int { host?.core?.totalActiveConnections ?? 0 }
    }

    public var metrics: Metrics { Metrics(host: self) }

    public init(envPath: String? = ".env") {
        if let path = envPath {
            loadDotEnv(at: path)
        }
    }
    
    private func loadDotEnv(at path: String) {
        let fullPath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(path).path
        guard let content = try? String(contentsOfFile: fullPath, encoding: .utf8) else { return }
        let lines = content.components(separatedBy: .newlines)
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty || trimmed.hasPrefix("#") { continue }
            let parts = trimmed.split(separator: "=", maxSplits: 1)
            if parts.count == 2 {
                let key = String(parts[0]).trimmingCharacters(in: .whitespaces)
                let value = String(parts[1]).trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "\"", with: "")
                
                #if os(Windows)
                _ = key.withCString { k in
                    value.withCString { v in
                        _putenv_s(k, v)
                    }
                }
                #else
                setenv(key, value, 1)
                #endif
            }
        }
    }

    // MARK: - Routing
    public func get(_ path: String, name: String? = nil, handler: @escaping RouteHandler) {
        routes.append(RouteDefinition(method: "GET", path: path, name: name, handler: handler))
    }

    public func post(_ path: String, name: String? = nil, handler: @escaping RouteHandler) {
        routes.append(RouteDefinition(method: "POST", path: path, name: name, handler: handler))
    }

    public func put(_ path: String, name: String? = nil, handler: @escaping RouteHandler) {
        routes.append(RouteDefinition(method: "PUT", path: path, name: name, handler: handler))
    }

    public func delete(_ path: String, name: String? = nil, handler: @escaping RouteHandler) {
        routes.append(RouteDefinition(method: "DELETE", path: path, name: name, handler: handler))
    }

    public func notFound(handler: @escaping RouteHandler) {
        for m in ["GET", "POST", "PUT", "DELETE"] {
            routes.append(RouteDefinition(method: m, path: "*", name: "notFound", handler: handler))
        }
    }

    public func group(_ prefix: String, builder: (RouteGroup) -> Void) {
        let group = RouteGroup(app: self, prefix: prefix)
        builder(group)
    }

    // MARK: - Middleware & Plugins
    public func use(_ middleware: @escaping @Sendable (Req, Context) -> Bool) {
        middlewares.append(middleware)
    }

    public func use(_ plugin: SwiftXPlugin) {
        plugins.append(plugin)
    }

    // MARK: - Lifecycle
    public func start(port: Int = 8080, threads: Int = ProcessInfo.processInfo.processorCount, development: Bool = false) {
        self.isDevelopment = development
        
        // 1. Boot plugins
        for plugin in plugins {
            plugin.boot(app: self)
        }

        // Auto-Register 404 if not manually set
        if !routes.contains(where: { $0.path == "*" }) {
            self.notFound { _, _ in
                return .html(self.defaultNotFoundPage())
            }
        }

        // 2. Initialize Core
        let config = ServerConfig(port: port, workerCount: threads)
        let coreInstance = SwiftXCore(config: config)
        self.core = coreInstance

        // 3. Bind Middlewares
        for mw in middlewares {
            coreInstance.use { cReq, cCtx in
                let req = Req(coreReq: cReq)
                let ctx = Context(coreCtx: cCtx, showLogs: self.isDevelopment)
                return mw(req, ctx)
            }
        }

        // 4. Bind Routes
        for rDef in routes {
            coreInstance.route(rDef.method, rDef.path) { cReq, cCtx in
                let req = Req(coreReq: cReq)
                let ctx = Context(coreCtx: cCtx, showLogs: self.isDevelopment)

                let start = Date()
                let result = rDef.handler(req, ctx)
                let end = Date()

                if self.isDevelopment {
                    let duration = end.timeIntervalSince(start) * 1000
                    let methodStr = rDef.method
                    let pathStr = rDef.path
                    let handlerName = rDef.name ?? "closure"
                    let typeStr = self.developmentTypeString(result)
                    
                    let precision = duration < 1.0 ? 3 : 2
                    let durationStr = String(format: "%.\(precision)fms", duration)
                    
                    print("[SwiftX] [DEV] \(methodStr) \(pathStr) → handler: \(handlerName)")
                    print("[SwiftX] [DEV] Response: \(typeStr) (\(durationStr))")
                }

                return result.toCore()
            }
        }

        // 5. Lifecycle: onStart
        for plugin in plugins {
            plugin.onStart()
        }

        print("[SwiftX] Server started on http://localhost:\(port)")
        coreInstance.listen()
    }
    
    public func stop() {
        print("[SwiftX] Shutting down...")
        // 6. Lifecycle: onStop
        for plugin in plugins {
            plugin.onStop()
        }
    }

    private func developmentTypeString(_ res: Res) -> String {
        switch res {
        case .text: return "TEXT"
        case .json: return "JSON"
        case .html: return "HTML"
        }
    }

    private func defaultNotFoundPage() -> String {
        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>404 - SwiftX</title>
            <style>
                body {
                    margin: 0; padding: 0; background: #0a0a0a; color: #fff;
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                    height: 100vh; display: flex; align-items: center; justify-content: center; overflow: hidden;
                }
                .container { text-align: center; border: 1px solid #333; padding: 4rem; border-radius: 4px; background: #000; box-shadow: 0 0 50px rgba(0,0,0,0.5); }
                h1 { font-size: 8rem; margin: 0; line-height: 0.8; font-weight: 900; letter-spacing: -5px; color: #fff; }
                p { font-size: 1.2rem; margin-top: 1rem; color: #888; text-transform: uppercase; letter-spacing: 2px; }
                .brand { position: absolute; top: 40px; left: 40px; font-weight: 800; font-size: 1.5rem; letter-spacing: -1px; }
                .decor { position: absolute; bottom: -50px; right: -45px; opacity: 0.05; font-size: 20rem; font-weight: 900; }
            </style>
        </head>
        <body>
            <div class="brand">SwiftX</div>
            <div class="decor">404</div>
            <div class="container">
                <h1>404</h1>
                <p>Path Not Found</p>
            </div>
        </body>
        </html>
        """
    }
}

// MARK: - Route Group
public struct RouteGroup {
    private let app: SwiftXApp
    private let prefix: String
    
    init(app: SwiftXApp, prefix: String) {
        self.app = app
        self.prefix = prefix
    }
    
    private func cleanPath(_ path: String) -> String {
        let p = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return prefix.hasSuffix("/") ? "\(prefix)\(p)" : "\(prefix)/\(p)"
    }
    
    public func get(_ path: String, name: String? = nil, handler: @escaping RouteHandler) {
        app.get(cleanPath(path), name: name, handler: handler)
    }
    
    public func post(_ path: String, name: String? = nil, handler: @escaping RouteHandler) {
        app.post(cleanPath(path), name: name, handler: handler)
    }
    
    public func put(_ path: String, name: String? = nil, handler: @escaping RouteHandler) {
        app.put(cleanPath(path), name: name, handler: handler)
    }
    
    public func delete(_ path: String, name: String? = nil, handler: @escaping RouteHandler) {
        app.delete(cleanPath(path), name: name, handler: handler)
    }
}

// Global instance
public let app = SwiftXApp()
