// swift-tools-version:5.3

import PackageDescription

let name = "BitriseTrace"
let trace = "Trace"
let product: Product = .library(name: trace, targets: [trace])

let target: Target = .binaryTarget(
    name: trace,
    url: "https://github.com/bitrise-io/trace-cocoa-sdk/releases/download/1.6.1/Trace.xcframework.zip",
    checksum: "82f10c051e7f7cb203006f066e80bb9dcab1e0da0771bcdb1622bdf644a62fae"
)
// target.linkerSettings = [.linkedLibrary("c++"), .linkedLibrary("z")]

let package = Package(
    name: name,
    platforms: [.iOS(.v10), .macOS(.v10_15)],
    products: [product],
    targets: [target],
    swiftLanguageVersions: [.v5]
)
