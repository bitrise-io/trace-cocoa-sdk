// swift-tools-version:5.3

import PackageDescription

let packageName = "BitriseTrace"
let trace = "Trace"

let package = Package(
    name: packageName,
    platforms: [
        .iOS(.v10),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: trace, targets: [trace])
    ],
    targets: [
        .binaryTarget(name: trace, path: "SDK/latest/\(trace).xcframework") // use Github release
    ],
    swiftLanguageVersions: [.v5]
)
