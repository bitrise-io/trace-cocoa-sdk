// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "KSCrash",
    products: [
        .library(
            name: "KSCrash",
            targets: [
                "KSCrash/Installations",
                "KSCrash/Recording",
                "KSCrash/Recording/Monitors",
                "KSCrash/Recording/Tools",
                "KSCrash/Reporting/Filters",
                "KSCrash/Reporting/Filters/Tools",
                "KSCrash/Reporting/Tools",
                "KSCrash/swift/Basic"
            ]
        )
    ],
    targets: [
        .target(
            name: "KSCrash/Installations",
            path: "TraceInternal/Installations",
            publicHeadersPath: ".",
            cxxSettings: [
                .headerSearchPath("../CrashReporting/Reporting/Filters"),
                .headerSearchPath("../CrashReporting/Reporting/Tools"),
                .headerSearchPath("../CrashReporting/Recording"),
                .headerSearchPath("../CrashReporting/Recording/Monitors"),
                .headerSearchPath("../CrashReporting/Recording/Tools")
            ]
        ),
        .target(
            name: "KSCrash/Recording",
            path: "TraceInternal/CrashReporting/Recording",
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
            name: "KSCrash/Recording/Monitors",
            path: "TraceInternal/CrashReporting/Recording/Monitors",
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
            name: "KSCrash/Recording/Tools",
            path: "TraceInternal/CrashReporting/Recording/Tools",
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
            name: "KSCrash/Reporting/Filters",
            path: "TraceInternal/CrashReporting/Reporting/Filters",
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
            name: "KSCrash/Reporting/Filters/Tools",
            path: "TraceInternal/CrashReporting/Reporting/Filters/Tools",
            publicHeadersPath: ".",
            cxxSettings: [
                .headerSearchPath("../../../Recording/Tools")
            ]
        ),
        .target(
            name: "KSCrash/Reporting/Tools",
            path: "TraceInternal/CrashReporting/Reporting/Tools",
            publicHeadersPath: ".",
            cxxSettings: [
                .headerSearchPath("../../Recording"),
                .headerSearchPath("../../Recording/Tools")
            ]
        ),
        .target(
            name: "KSCrash/swift/Basic",
            path: "TraceInternal/CrashReporting/swift/Basic",
            publicHeadersPath: ".",
            cxxSettings: [
                .headerSearchPath(".."),
                .headerSearchPath("../../llvm/ADT"),
                .headerSearchPath("../../llvm/Config"),
                .headerSearchPath("../../llvm/Support")
            ]
        )
    ],
    cxxLanguageStandard: .gnucxx11
)