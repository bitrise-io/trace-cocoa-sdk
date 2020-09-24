// swift-tools-version:5.3

import PackageDescription

let version = "1.7.1"
let name = "BitriseTrace"
let trace = "Trace"
let product: Product = .library(name: trace, targets: [trace])
let path = "/SDK/\(version)/Trace.xcframework"

let target: Target = .binaryTarget(
    name: trace,
    path: path
)
/**
Adding linkerSettings in Xcode 12.2 beta causes:
- Xcode crashes
- Swift CLI reports exceptions

TODO: Wait for Xcode 12 GM to be released
*/
//target.linkerSettings = [.linkedLibrary("c++"), .linkedLibrary("z")] // Adds libz and libc++ library.

let package = Package(
    name: name,
    platforms: [.iOS(.v10), .macOS(.v10_15)],
    products: [product],
    targets: [target],
    swiftLanguageVersions: [.v5]
)
