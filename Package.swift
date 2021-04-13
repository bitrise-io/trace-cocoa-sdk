// swift-tools-version:5.2
import PackageDescription

let version = "1.7.30"
let name = "BitriseTrace"
let trace = "Trace"
let traceInternal = "TraceInternal"
let product: Product = .library(name: trace, targets: [trace])
let targets: [Target] = [
    .target(
        name: trace,
        dependencies: [.target(name: traceInternal)],
        path: "\(trace)/",
        linkerSettings: [.linkedFramework("UIKit")]
    ),
    .target(
        name: traceInternal,
        dependencies: [
            .target(name: "\(traceInternal)_Recording"),
            .target(name: "\(traceInternal)_Recording_Monitors"),
            .target(name: "\(traceInternal)_Recording_Tools"),
            .target(name: "\(traceInternal)_Reporting_Filters"),
            .target(name: "\(traceInternal)_Reporting_Filters_Tools"),
            .target(name: "\(traceInternal)_Reporting_Tools"),
            .target(name: "\(traceInternal)_Swift")
        ],
        path: "\(traceInternal)/Installations",
        publicHeadersPath: ".",
        cxxSettings: [
            .headerSearchPath("../CrashReporting/Reporting/Filters"),
            .headerSearchPath("../CrashReporting/Reporting/Tools"),
            .headerSearchPath("../CrashReporting/Recording"),
            .headerSearchPath("../CrashReporting/Recording/Monitors"),
            .headerSearchPath("../CrashReporting/Recording/Tools")
        ],
        linkerSettings: [
            .linkedLibrary("c++"),
            .linkedLibrary("z"),
            .linkedFramework("UIKit")
        ]
    ),
    .target(
        name: "\(traceInternal)_Recording",
        path: "\(traceInternal)/CrashReporting/Recording",
        exclude: [
            "Monitors",
            "Tools"
        ],
        publicHeadersPath: ".",
        cxxSettings: [
            .headerSearchPath("Tools"),
            .headerSearchPath("Monitors"),
            .headerSearchPath("../Reporting/Filters"),
            .headerSearchPath("../../Installations")
        ]
    ),
    .target(
        name: "\(traceInternal)_Recording_Monitors",
        path: "\(traceInternal)/CrashReporting/Recording/Monitors",
        publicHeadersPath: ".",
        cxxSettings: [
            .define("GCC_ENABLE_CPP_EXCEPTIONS", to: "YES"),
            .headerSearchPath(".."),
            .headerSearchPath("../Tools"),
            .headerSearchPath("../../Reporting/Filters"),
            .headerSearchPath("../../../Installations")
        ]
    ),
    .target(
        name: "\(traceInternal)_Recording_Tools",
        path: "\(traceInternal)/CrashReporting/Recording/Tools",
        publicHeadersPath: ".",
        cxxSettings: [
            .headerSearchPath(".."),
            .headerSearchPath("../../swift"),
            .headerSearchPath("../../swift/Basic"),
            .headerSearchPath("../../llvm/ADT"),
            .headerSearchPath("../../llvm/Support"),
            .headerSearchPath("../../llvm/Config")
        ]
    ),
    .target(
        name: "\(traceInternal)_Reporting_Filters",
        path: "\(traceInternal)/CrashReporting/Reporting/Filters",
        exclude: [
            "Tools"
        ],
        publicHeadersPath: ".",
        cxxSettings: [
            .headerSearchPath("Tools"),
            .headerSearchPath("../../Recording"),
            .headerSearchPath("../../Recording/Monitors"),
            .headerSearchPath("../../Recording/Tools"),
            .headerSearchPath("../../../Installations")
        ]
    ),
    .target(
        name: "\(traceInternal)_Reporting_Filters_Tools",
        path: "\(traceInternal)/CrashReporting/Reporting/Filters/Tools",
        publicHeadersPath: ".",
        cxxSettings: [
            .headerSearchPath("../../../Recording/Tools")
        ]
    ),
    .target(
        name: "\(traceInternal)_Reporting_Tools",
        path: "\(traceInternal)/CrashReporting/Reporting/Tools",
        publicHeadersPath: ".",
        cxxSettings: [
            .headerSearchPath("../../Recording"),
            .headerSearchPath("../../Recording/Tools")
        ]
    ),
    .target(
        name: "\(traceInternal)_Swift",
        path: "\(traceInternal)/CrashReporting/swift/Basic",
        publicHeadersPath: ".",
        cxxSettings: [
            .headerSearchPath(".."),
            .headerSearchPath("../../llvm/ADT"),
            .headerSearchPath("../../llvm/Config"),
            .headerSearchPath("../../llvm/Support")
        ]
    )
]

let package = Package(
    name: name,
    platforms: [.iOS(.v10)],
    products: [product],
    targets: targets,
    swiftLanguageVersions: [.v5],
    cxxLanguageStandard: .gnucxx11
)
