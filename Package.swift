// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SPStorkController",
    platforms: [
       .iOS(.v10)
    ],
    products: [
        .library(name: "SPStorkController", targets: ["SPStorkController"])
    ],
    targets: [
        .target(name: "SPStorkController", dependencies: [], path: "Source/SPStorkController")
    ]
)
