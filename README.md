# 🚀 SwiftX

**SwiftX** is a high-performance, developer-first web framework for Swift, built on the ultra-clean `SwiftXCore` runtime. It abstracts away low-level complexities to provide a **TitanPl-like** development experience without sacrificing speed.

## 🌟 Multiplatform Support
SwiftX is born for versatility. It runs natively on:
- **Windows** (using WinSDK/MSVC)
- **Linux** (Glibc/NIO compatible)
- **macOS** (Darwin/NIO compatible)

---

## 🏗️ Developer Perfect Handlers (Recommended)
While inline closures are supported, SwiftX is designed for professional organization. Define your handlers in separate files for the best experience.

```swift
// Sources/MyProject/UserHandlers.swift
public func userProfileHandler(req: Req, ctx: Context) -> Res {
    return .json(["id": req.param("id") ?? "0"])
}

// Sources/MyProject/main.swift
app.get("/user/:id", handler: userProfileHandler)
```

## 🛠️ Official Plugins & Shared Ecosystem
SwiftX is entirely plugin-driven. You can create your own plugins, publish them as separate Swift Packages, and easily share them with the world.

### 📥 Using Shared Plugins
```swift
dependencies: [
    .package(url: "https://yourgithub.com/MyAwesomePlugin.git", from: "1.0.0")
]
```

---

## 🧠 Core Architecture & Async

### Async Management
Unlike standard frameworks that rely solely on `DispatchQueue`, SwiftX uses the **Managed Worker Pool** from `SwiftXCore`.
- **Co-operative Tasking**: Every request runs in a `TaskContext`.
- **Non-blocking I/O**: Driven by a custom Scheduler.
- **Async bridging**: Handlers can call standard Swift `async/await` code safely.

### Routing (Radix Tree)
SwiftX uses a high-speed **RadixRouter**, supporting:
- **Wildcards (`*`)**: For catch-all and custom 404s.
- **Path Parameters (`:id`)**: High-precision extraction.

---

## 📖 Deployment & DX

### Environment (.env)
SwiftX natively loads `.env` files on startup.
```text
PORT=5100
DEBUG=true
```

### Production Mode
Disable development logs for maximum performance:
```swift
app.start(development: false)
```

### Runtime Metrics
Monitor your engine health in real-time:
```swift
app.get("/metrics") { _, _ in
    return .json([
        "active_workers": app.metrics.workers,
        "connections": app.metrics.connections
    ])
}
```

---

## ⚖️ License
MIT License. Built for the next generation of Swift developers.
