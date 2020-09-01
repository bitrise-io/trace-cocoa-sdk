// swift-tools-version:5.3
// swiftlint:disable prefixed_toplevel_constant

import PackageDescription

let packageName = "BitriseTrace"
let trace = "Trace"
let testsName = "Tests"

let package = Package(
    name: packageName,
    platforms: [
        .iOS(.v10),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: trace, targets: [trace]) // type: .`static`
    ],
    targets: [
        .target(name: trace, path: "SDK/latest/libTrace")
    ],
    swiftLanguageVersions: [.v5]
)