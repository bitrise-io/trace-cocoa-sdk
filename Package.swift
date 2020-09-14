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
        .binaryTarget(
            name: trace, 
            url: "https://github.com/bitrise-io/trace-cocoa-sdk/releases/download/1.6.1/Trace.xcframework.zip", 
            checksum: "82f10c051e7f7cb203006f066e80bb9dcab1e0da0771bcdb1622bdf644a62fae"
        )
    ],
    swiftLanguageVersions: [.v5]
)
