// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SPStorkController",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "SPStorkController",
            targets: ["SPStorkController"]),
    ],
    targets: [
        .target(
            name: "SPStorkController",
            dependencies: [],
            path: "Source/SPStorkController"
            )
    ]
)
