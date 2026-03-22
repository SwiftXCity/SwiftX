# SwiftX 🚀


[HomePage](https://swiftxdocs.vercel.app/)
[Docs](https://swiftxdocs.vercel.app/docs)

![Platforms](https://img.shields.io/badge/Platforms-macOS%20%7C%20Linux%20%7C%20Windows-blue)
![Swift](https://img.shields.io/badge/Swift-6.2%20%7C%206.1%20%7C%206.0-orange)

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

Explore the [Routing](https://swiftxdocs.vercel.app/docs/routing) documentation to learn more about defining routes and handling requests.
