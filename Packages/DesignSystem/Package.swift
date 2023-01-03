// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [
        .iOS(.v16),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.0"),
        .package(url: "https://github.com/markiv/SwiftUI-Shimmer", exact: "1.1.0"),
        .package(url: "https://github.com/kean/Nuke", from: "11.5.0")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                .product(name: "Shimmer", package: "SwiftUI-Shimmer"),
                .product(name: "NukeUI", package: "Nuke"),
                .product(name: "Nuke", package: "Nuke")
            ],
            path: "Source"
        ),
    ]
)

