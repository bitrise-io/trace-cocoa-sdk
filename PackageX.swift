// swift-tools-version:5.3
import PackageDescription

let version = "1.7.1"
let name = "BitriseTrace"
let trace = "Trace"
let traceInternal = "TraceInternal"
let product: Product = .library(name: trace, targets: [trace])
let targets: [Target] = [
    .target(
        name: trace,
        dependencies: [.target(name: traceInternal)],
        path: "\(trace)/",
        exclude: []
    ),
    .target(
        name: traceInternal,
        path: "\(traceInternal)/",
        exclude: [],
        publicHeadersPath: ".",
        cxxSettings: [
            .define("GCC_ENABLE_CPP_EXCEPTIONS", to: "YES"),
            .headerSearchPath(".."),
            .headerSearchPath("CrashReporting/llvm/Support"),
            .headerSearchPath("CrashReporting/llvm/Config"),
            .headerSearchPath("CrashReporting/llvm/ADT"),
            .headerSearchPath("CrashReporting/swift"),
            .headerSearchPath("CrashReporting/swift/Basic"),
            .headerSearchPath("CrashReporting/Recording"),
            .headerSearchPath("CrashReporting/Recording/Tools"),
            .headerSearchPath("CrashReporting/Recording/Monitors"),
            .headerSearchPath("CrashReporting/Reporting/Filters"),
            .headerSearchPath("CrashReporting/Reporting/Tools")
        ],
        linkerSettings: [
            .linkedLibrary("c++"),
            .linkedLibrary("z"),
            .linkedFramework("UIKit")
        ]
    )
]

let package = Package(
    name: name,
    platforms: [.iOS(.v14)],
    products: [product],
    targets: targets,
    swiftLanguageVersions: [.v5],
    cxxLanguageStandard: .gnucxx11
)
