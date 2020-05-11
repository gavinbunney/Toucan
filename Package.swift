// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Toucan",
    platforms: [
        .iOS(.v8),
    ],
    products: [
        .library(name: "Toucan", targets: ["Toucan"])
    ],
    targets: [
        .target(
            name: "Toucan",
            dependencies: []),
    ],
    swiftLanguageVersions: [
        .v5
    ]
    
)
