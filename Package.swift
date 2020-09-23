// swift-tools-version:5.3

import PackageDescription

let version = "1.7.1"
let name = "BitriseTrace"
let trace = "Trace"
let product: Product = .library(name: trace, targets: [trace])
let url = "https://github.com/bitrise-io/trace-cocoa-sdk/releases/download/\(version)/Trace.xcframework.zip"
let checksum = "82f10c051e7f7cb203006f066e80bb9dcab1e0da0771bcdb1622bdf644a62fae"

let target: Target = .binaryTarget(
    name: trace,
    url: url,
    checksum: checksum
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
