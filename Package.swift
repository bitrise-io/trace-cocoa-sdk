// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "KSCrash",
    products: [
        .library(
            name: "TraceInternal",
            targets: [
                "TraceInternal_Installations",
                "TraceInternal_Recording",
                "TraceInternal_Recording_Monitors",
                "TraceInternal_Recording_Tools",
                "TraceInternal_Reporting_Filters",
                "TraceInternal_Reporting_Filters_Tools",
                "TraceInternal_Reporting_Tools",
                "TraceInternal_Swift"
            ]
        )
    ],
    targets: [
        .target(
            name: "TraceInternal_Installations",
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
            name: "TraceInternal_Recording",
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
            name: "TraceInternal_Recording_Monitors",
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
            name: "TraceInternal_Recording_Tools",
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
            name: "TraceInternal_Reporting_Filters",
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
            name: "TraceInternal_Reporting_Filters_Tools",
            path: "TraceInternal/CrashReporting/Reporting/Filters/Tools",
            publicHeadersPath: ".",
            cxxSettings: [
                .headerSearchPath("../../../Recording/Tools")
            ]
        ),
        .target(
            name: "TraceInternal_Reporting_Tools",
            path: "TraceInternal/CrashReporting/Reporting/Tools",
            publicHeadersPath: ".",
            cxxSettings: [
                .headerSearchPath("../../Recording"),
                .headerSearchPath("../../Recording/Tools")
            ]
        ),
        .target(
            name: "TraceInternal_Swift",
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