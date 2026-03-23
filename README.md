# SwiftX 🚀


[HomePage](https://swiftxdocs.vercel.app/)
[Docs](https://swiftxdocs.vercel.app/docs)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSwiftXCity%2FSwiftXCore%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/SwiftXCity/SwiftXCore)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSwiftXCity%2FSwiftXCore%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/SwiftXCity/SwiftXCore)


Quick Start

This guide will help you create your first SwiftX application and get it running on your local machine.

Prerequisites

* **Swift 6.0+** installed on your system.
* Basic knowledge of Swift programming.

Installation

Add SwiftX as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/swiftxcity/swiftx.git", from: "1.0.0")
],
targets: [
    .executableTarget(
        name: "MyProject",
        dependencies: [
            .product(name: "SwiftX", package: "swiftx")
        ]
    )
]
```

Your First App

Create a `main.swift` file in your project's `Sources` directory and add the following code:

```swift
import SwiftX

let app = SwiftX()

// Define a simple route
app.get("/") { req, res in
    return .text("Hello, SwiftX!")
}

// Route with path parameters
app.get("/hello/:name") { req, res in
    let name = req.param("name") ?? "Guest"
    return .json(["message": "Welcome, \(name)!"])
}

// Start the server
app.start(port: 5100)
```

Running the App

Run the following command in your terminal:

```bash
swift run MyProject
```

Your server should now be running at `http://localhost:5100`.

Next Steps 

Explore the [Runtime Apis](https://swiftxdocs.vercel.app/docs/routing](https://swiftxdocs.vercel.app/docs/runtime-api)) documentation to learn more about defining routes and handling requests.
