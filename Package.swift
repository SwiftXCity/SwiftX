// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SwiftX",
    products: [
        .library(name: "SwiftX", targets: ["SwiftX"])
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftXCity/SwiftXCore.git", from: "1.0.1"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SwiftX",
            dependencies: [
                .product(name: "SwiftXCore", package: "SwiftXCore"),
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .executableTarget(
            name: "SwiftXExample",
            dependencies: [
                "SwiftX",
                .product(name: "Logging", package: "swift-log")
            ]
        ),

        .executableTarget(
            name: "FullShowcase",
            dependencies: [
                "SwiftX",
                .product(name: "Logging", package: "swift-log")
            ],
            path: "examples/FullShowcase",
            exclude: ["README.md"]
        ),
        .testTarget(
            name: "swiftxTests",
            dependencies: ["SwiftX"]
        )
    ]
)