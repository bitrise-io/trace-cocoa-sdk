// #!/usr/bin/env xcrun swift

//
// Bitrise Trace SDK - Upload dSYM's
// Trace - https://www.bitrise.io/add-ons/trace-mobile-monitoring
// Github - https://github.com/bitrise-io/trace-cocoa-sdk/
// Script - https://github.com/bitrise-io/trace-cocoa-sdk/blob/main/UploadDSYM/main.swift
//
// This script uploads all dSYM files.
//
// By default the script check for APM collector token in the following order:
//  - Check launch arguments.
//  - Check environment variable for `APM_COLLECTOR_TOKEN`.
//  - Check for `bitrise_configuration.plist` in the root of the project.
//  - If none of the above work, script fails.
//
// Call script directly using the following command on Terminal:
// Remote script:
// /usr/bin/xcrun --sdk macosx swift <(curl -Ls --retry 3 --connect-timeout 20 -H "Cache-Control: max-age=604800" https://raw.githubusercontent.com/bitrise-io/trace-cocoa-sdk/main/UploadDSYM/main.swift)
// Local script:
// /usr/bin/xcrun --sdk macosx swift main.swift
//
// The API requires the following parameters if using directly:
//
// `APM_APP_VERSION`: The app's version number found on iTunes Connect site or the `Info.plist` file. i.e 1.0.0
// `APM_BUILD_VERSION`: The app's version number found on iTunes Connect site or the `Info.plist` file. i.e 123
// `APM_DSYM_PATH`: Path to the DSYM folder or zip file.
//
// Note: The script assumes the current shell working directory has the bitrise_configuration.plist file. Otherwise use
// `APM_COLLECTOR_TOKEN token_here`
//
// `APM_COLLECTOR_TOKEN`: Trace token found in `bitrise_configuration.plist` or Trace->Settings.
//

//
// Features
// --------
//
// Using a folder path or zip file:
// Folder path
// /usr/bin/xcrun --sdk macosx swift main.swift APM_APP_VERSION version_here APM_BUILD_VERSION build_version APM_DSYM_PATH path_here
//
// Zip file i.e iTunes connect dSYM file
// /usr/bin/xcrun --sdk macosx swift main.swift APM_APP_VERSION version_here APM_BUILD_VERSION build_version APM_DSYM_PATH path_here
//
// Using a custom APM collector token:
// /usr/bin/xcrun --sdk macosx swift main.swift APM_COLLECTOR_TOKEN token_here APM_APP_VERSION version_here APM_BUILD_VERSION build_version
//
import Foundation

// swiftlint:disable prefixed_toplevel_constant

// Upload dSYM script version
let version = "1.0.0"

/// Keys
enum Keys: String, CodingKey {
    case bitriseConfiguration = "bitrise_configuration"
    case iPhoneSimulator = "-iphonesimulator"
    case dwarfWithDSYM = "dwarf-with-dsym"
    case stabs
    case dwarf
    case yes = "YES"
    case no = "NO"
    case debug = "Debug"
}

enum EnvironmentVariable: String, CodingKey {
    case product = "PRODUCT_NAME"
    case platform = "EFFECTIVE_PLATFORM_NAME"
    case bitcode = "ENABLE_BITCODE"
    case debugInformationFormat = "DEBUG_INFORMATION_FORMAT"
    case configuration = "CONFIGURATION"
    case productDir = "BUILT_PRODUCTS_DIR"
    case infoPlistPath = "INFOPLIST_PATH"
}

enum Extension: String, CodingKey {
    case app = ".app/"
    case plist = ".plist"
    case zip = ".zip"
}

/// Simple wrapper around of shell
enum Shell {
    
    // MARK: - Static - Command
    
    /// Run shell command
    @discardableResult
    static func command(_ arguments: String...) throws -> Process.TerminationReason {
        return try command(arguments)
    }
    
    /// Run shell command
    @discardableResult
    static func command(_ arguments: [String]) throws -> Process.TerminationReason {
        // Run command in the default environment
        let task = Process()
        task.launchPath = "/usr/bin/env" // default shell i.e bash
        task.arguments = arguments
        task.qualityOfService = .userInitiated
        
        print("[Bitrise:Trace/dSYM] Running shell command: \(arguments.joined(separator: " "))")
        
        // Run a shell command
        try task.run()
        
        // Wait for request to complete and return a exit code response
        task.waitUntilExit()

        return task.terminationReason
    }
}

/// Helper to append string to data
extension Data {
    
    // MARK: - String
    
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

/// Locate dSYM files from a given path
final class DSYMLocator {
    
    // MARK: - Enum
    
    enum Paths: String {
        case dSYM = "DWARF_DSYM_FOLDER_PATH" // Check Xcode environment for keys
    }
    
    // MARK: - Property
    
    /// Root path of dSYM location
    private let path: String
    
    /// List of dSYM's. Only the name and not the full path
    var dSYMs = [String]() {
        didSet {
            if !dSYMs.isEmpty {
                print("[Bitrise:Trace/dSYM] Found \(dSYMs.count) dSYM files \(dSYMs).")
            } else {
                print("[Bitrise:Trace/dSYM] Couldn't find any dSYM files for one of the following reasons: custom DSYM path used, zip file specified or no dSYM's exist in the path")
            }
        }
    }
    
    /// Paths of all dSYM files with root
    var paths: [String] { dSYMs.map { (path as NSString).appendingPathComponent($0) } }
    
    // MARK: - Init
    
    init(_ path: String?) throws {
        guard let unwrappedPath = path else { throw NSError(
            domain: "DSYMLocator.badFolderPath",
            code: 1,
            userInfo: ["path": path ?? "Unknown",
                       "Set path using": " dwarf-with-dsym in Xcode setting or APM_DSYM_PATH in shell"]
            )
        }
        
        self.path = unwrappedPath
        
        try setup()
    }
    
    // MARK: - Setup
    
    private func setup() throws {
        print("[Bitrise:Trace/dSYM] Looking for dSYM files in \(Paths.dSYM.rawValue): \(path).")
        
        do {
            let fileManager = FileManager.default
            
            // Check the path and filter for .dSYM suffix
            dSYMs = try fileManager
                .subpathsOfDirectory(atPath: path)
                .filter { $0.hasSuffix(".dSYM") } // Remove extra files and folders
        } catch {
            print("[Bitrise:Trace/dSYM] Failed to read dSYM files in \(Paths.dSYM.rawValue).")
            
            throw error
        }
    }
    
    // MARK: - Static - Helper
    
    static var customDSYMPath: String? {
        let arguments = CommandLine.arguments
        
        guard let index = arguments.firstIndex(of: Argument.Keys.customDSYMPath.rawValue) else { return nil }
        
        print("[Bitrise:Trace/dSYM] Additional launch arguments found. Checking for custom dSYM path.")
        
        let path = arguments[index + 1]
        
        guard URL(fileURLWithPath: path).isFileURL else { return nil }
        
        print("[Bitrise:Trace/dSYM] Additional launch arguments found for custom dSYM path.")
        
        return path
    }
    
    // MARK: - Helper - Size
    
    func size(for path: String) -> String {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: path), let size = attributes[.size] as? Int64 else {
            return "Unknown"
        }
        
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        formatter.includesUnit = true
        formatter.allowedUnits = [.useKB, .useMB]
        
        let sizeInFormat = formatter.string(fromByteCount: size)
        
        return sizeInFormat
    }
}

/// Zip files/folder
struct Zip {
 
    // MARK: - Property
    
    private let command = ["zip", "-r", "-D", "-q"] // Run zip command, see man zip for more details
    
    /// Name of zip file
    private let name: String
    
    /// Lists of paths to zip
    private let paths: [String]
    
    // MARK: - Static
    
    static func paths(_ paths: [String], name: String) throws -> String {
        let zip = try Self(paths: paths, name: name)
        
        try zip.zip()
        
        let path = try zip.zippedPath()
        
        return path
    }
    
    // MARK: - Init
    
    init(paths: [String], name: String) throws {
        self.name = name
        self.paths = paths
        
        try setup()
    }
    
    // MARK: - Setup
    
    private func setup() throws {
        guard !paths.isEmpty else {
            print("[Bitrise:Trace/dSYM] Paths to be zipped is empty")
            
            throw NSError(domain: "Zip.pathsToZipFilesIsEmpty", code: 1, userInfo: ["Paths to zip": paths])
        }
    }
    
    // MARK: - Zip
    
    @discardableResult
    func zip() throws -> Process.TerminationReason {
        print("[Bitrise:Trace/dSYM] Starting zipping \(name) \(Date()).")
        
        // i.e $ zip output.zip inputPaths
        var zipDSYMs = command // Command
        zipDSYMs.append(name) // Output
        zipDSYMs.append(contentsOf: paths) // Input
        
        let result = try Shell.command(zipDSYMs)
        
        switch result {
        case .exit: print("[Bitrise:Trace/dSYM] Finished zipping \(name) \(Date()).")
        case .uncaughtSignal: print("[Bitrise:Trace/dSYM] Failed to zip \(name) \(Date()).")
        @unknown default: print("[Bitrise:Trace/dSYM] Failed to zip \(name) \(Date()).")
        }
        
        return result
    }
    
    func zippedPath() throws -> String {
        let path = (FileManager.default.currentDirectoryPath as NSString).appendingPathComponent(name)
        
        guard FileManager.default.fileExists(atPath: path) else { throw NSError(domain: "FileManager.fileDoesNotExist", code: 1) }
     
        print("[Bitrise:Trace/dSYM] Zipped path \(path).")
        
        return path
    }
}

struct BitriseConfiguration: Decodable {

    // MARK: - Property
    
    let token: String
    
    // MARK: - Init
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Argument.Keys.self)
        
        token = try container.decode(String.self, forKey: .token)
    }
}

enum TokenLocator {
    
    // MARK: - Locate
    
    static func token() throws -> String {
        if let token = launchArguments {
            return token
        } else if let token = environmentVariable {
            return token
        } else if let token = configurationPlist {
            return token
        }
        
        throw NSError(domain: "TokenLocator.failedToFindAPMCollectorToken", code: 1)
    }
    
    // MARK: - Private - Locate
    
    private static var launchArguments: String? {
        // 0: Script path
        // 1: Token
        // 2+: Ignore...
        let arguments = CommandLine.arguments
        
        guard let index = arguments.firstIndex(of: Argument.Keys.token.rawValue) else { return nil }
        
        let token = arguments[index + 1]
        
        print("[Bitrise:Trace/dSYM] Using token \(token) at position 1 from launch arguments.")
        
        return token
    }
    
    private static var environmentVariable: String? {
        let process = ProcessInfo.processInfo
        let environment = process.environment
        
        guard let token = environment[Argument.Keys.token.rawValue] else { return nil }
        
        print("[Bitrise:Trace/dSYM] Using token \(Argument.Keys.token.rawValue) from environment variable.")
        
        return token
    }
    
    private static var configurationPlist: String? {
        let configurationKey = Keys.bitriseConfiguration.rawValue + Extension.plist.rawValue
        let process = ProcessInfo.processInfo
        let environment = process.environment
        let name = environment[EnvironmentVariable.product.rawValue] ?? "Unknown"
        let fileManager = FileManager.default
        var currentDirectoryPath = fileManager.currentDirectoryPath
        
        print("[Bitrise:Trace/dSYM] Product name: \(name).")
        print("[Bitrise:Trace/dSYM] Current path: \(currentDirectoryPath).")
        
        do {
            var subpaths = try fileManager.subpathsOfDirectory(atPath: currentDirectoryPath) // all
            var configurationFilter = subpaths.filter { $0.contains(configurationKey) } // filter for
            
            if configurationFilter.isEmpty {
                print("[Bitrise:Trace/dSYM] Failed to locate \(configurationKey) at current directory. Checking one directory back for \(configurationKey).")
                
                currentDirectoryPath = (currentDirectoryPath as NSString).deletingLastPathComponent
                
                print("[Bitrise:Trace/dSYM] Current path: \(currentDirectoryPath).")
                
                subpaths = try fileManager.subpathsOfDirectory(atPath: currentDirectoryPath)
                configurationFilter = subpaths.filter { $0.contains(configurationKey) }
            }
            
            let appFilter = configurationFilter.filter { $0.contains(Extension.app.rawValue) } // filter for build directory
            let productFilter = appFilter.filter { $0.contains(name) } // filter for product name

            var configuration = productFilter.first ?? appFilter.first
            
            if configuration == nil {
                print("[Bitrise:Trace/dSYM] Default path for \(configurationKey) file not found, defaulting to root.")
                
                configuration = configurationFilter.first
            }
            
            if let path = configuration, let data = fileManager.contents(atPath: (currentDirectoryPath as NSString).appendingPathComponent(path)) {
                let configuration = try PropertyListDecoder().decode(BitriseConfiguration.self, from: data)
                
                print("[Bitrise:Trace/dSYM] Found \(configurationKey) in path \(path).")
                print("[Bitrise:Trace/dSYM] Using token from \(configurationKey).")
                
                return configuration.token
            } else {
                print("[Bitrise:Trace/dSYM] Failed to find file at path \(configuration ?? "Unknown").")
            }
        } catch {
            print("[Bitrise:Trace/dSYM] Failed to find \(configurationKey) with error: \(error.localizedDescription).")
        }
        
        print("[Bitrise:Trace/dSYM] Failed to find \(configurationKey) in the Xcode project directory.")
        
        return nil
    }
}

struct Uploader {
    
    // MARK: - Enum
    
    enum Keys: String, CodingKey {
        case version = "app_version" // app version
        case build = "build_version" // build version
    }
    
    // MARK: - Property
    
    private let session: URLSession = {
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 20.0
        
        return session
    }()
    
    let token: String
    
    // MARK: - Init
    
    init(token: String) throws {
        self.token = token
        
        try setup()
    }
    
    // MARK: - Setup
    
    private func setup() throws {
        guard token.isEmpty || token != " " else { throw NSError(
            domain: "Uploader.tokenIsEmpty",
            code: 1,
            userInfo: ["token": token])
        }
        guard token.count > 2 else { throw NSError(
            domain: "Uploader.tokenIsMalformed",
            code: 1,
            userInfo: ["token": token])
        }
    }

    // MARK: - Upload
    
    func upload(fileAtPath file: URL, withParameters parameters: [String: String], _ completion: @escaping (Result<Void, Error>) -> Void) throws {
        let api = "https://collector.apm.bitrise.io/api/v1/symbols"
        
        guard let url = URL(string: api) else {
            throw NSError(domain: "Uploader.failedToCreateURL", code: 1)
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("UploadDSYM \(version)", forHTTPHeaderField: "User-Agent")
        request.httpShouldUsePipelining = true
        request.networkServiceType = .responsiveData

        parameters.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        print("[Bitrise:Trace/dSYM] Uploading to: \(request)")
        print("[Bitrise:Trace/dSYM] Uploading dSYM's \(Date()).")
        
        session.uploadTask(with: request, fromFile: file) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            
            print("[Bitrise:Trace/dSYM] Upload complete with status code: (\(httpResponse?.statusCode ?? 0)) - \(Date()).")
            
            if let error = error {
                print("[Bitrise:Trace/dSYM] Warning!")
                print("[Bitrise:Trace/dSYM] Upload error: \(error).")
                print("[Bitrise:Trace/dSYM] Upload response: \(String(describing: httpResponse)).")
                
                if let data = data, let rawString = String(data: data, encoding: .utf8) {
                    print("[Bitrise:Trace/dSYM] Upload data: \(rawString).")
                }
                
                print("[Bitrise:Trace/dSYM] Warning!")
                print(" ")
                
                completion(.failure(error))
            } else {
                print("[Bitrise:Trace/dSYM] Upload complete.")
                
                completion(.success(()))
            }
        }.resume()
    }
}

struct Argument {
    
    // MARK: - Enum
    
    enum Keys: String, CodingKey {
        case appVersion = "APM_APP_VERSION"
        case buildVersion = "APM_BUILD_VERSION"
        case token = "APM_COLLECTOR_TOKEN"
        case customDSYMPath = "APM_DSYM_PATH"
    }
    
    // MARK: - Property
    
    private let appkey = Keys.appVersion.rawValue
    private let buildkey = Keys.buildVersion.rawValue
    
    let appVersion: String
    let buildVersion: String
    
    // MARK: - Init
    
    init(appVersion: String, buildVersion: String) throws {
        self.appVersion = appVersion
        self.buildVersion = buildVersion
        
        try setup()
    }
    
    init(with arguments: [String]) throws {
        print("[Bitrise:Trace/argument] Looking for arguments in Script argument list")
        
        // App version check
        guard let appIndex = arguments.firstIndex(of: appkey) else {
            print("[Bitrise:Trace/dSYM] Failed to find app version with key \(appkey)")
            
            throw NSError(domain: "Argument.appVersionNotFound", code: 1, userInfo: ["Missing key": appkey])
        }
        
        // Build version check
        guard let buildIndex = arguments.firstIndex(of: buildkey) else {
            print("[Bitrise:Trace/dSYM] Failed to find build version with key \(buildkey)")
            
            throw NSError(domain: "Argument.buildVersionNotFound", code: 1, userInfo: ["Missing key": buildkey])
        }
        
        appVersion = arguments[appIndex + 1]
        buildVersion = arguments[buildIndex + 1]
        
        try setup()
    }
    
    // MARK: - Setup
    
    private func setup() throws {
        guard !appVersion.isEmpty || !buildVersion.isEmpty else {
            print("[Bitrise:Trace/dSYM] App and Build version must not be empty")
            
            let userInfo = [
                Uploader.Keys.version.rawValue: appVersion,
                Uploader.Keys.build.rawValue: buildVersion
            ]
            
            throw NSError(domain: "Argument.AppOrBuildVersionIsEmpty", code: 1, userInfo: userInfo)
        }
    }
}

struct Validation {
    
    // MARK: - Property
    
    private let environment: [String: String]
    
    // MARK: - Init
    
    init(with environment: [String: String]) {
        self.environment = environment
    }
    
    // MARK: - Validate
    
    func validate() throws {
        let debugInformationFormat = environment[EnvironmentVariable.debugInformationFormat.rawValue]
        
        guard environment[EnvironmentVariable.platform.rawValue] != Keys.iPhoneSimulator.rawValue else {
            print("[Bitrise:Trace/dSYM] Warning!")
            print("[Bitrise:Trace/dSYM] Environment set to iPhone simulator, skipping build!")
            print("[Bitrise:Trace/dSYM] Warning!")
            print(" ")
            
            throw NSError(domain: "Validation.SkippingPlatoformIsiPhoneSimulator", code: 1)
        }
        
        guard debugInformationFormat != Keys.dwarf.rawValue || debugInformationFormat != Keys.stabs.rawValue else {
            print("[Bitrise:Trace/dSYM] Warning!")
            print("[Bitrise:Trace/dSYM] \(EnvironmentVariable.debugInformationFormat.rawValue) set to \(debugInformationFormat ?? "Unknown"). Set it to \(Keys.dwarfWithDSYM.rawValue) under Xcode->Build Settings to generate a dSYM for your application.")
            print("[Bitrise:Trace/dSYM] Warning!")
            print(" ")
            
            throw NSError(domain: "Validation.SkippingDwarfOrStabsHasBeenSet", code: 1)
        }
        
        guard environment[EnvironmentVariable.configuration.rawValue] != Keys.debug.rawValue else {
            print("[Bitrise:Trace/dSYM] Warning!")
            print("[Bitrise:Trace/dSYM] Skipping Debug build")
            print("[Bitrise:Trace/dSYM] Warning!")
            print(" ")
            
            throw NSError(domain: "Validation.SkippingDebugBuild", code: 1)
        }
        
        if environment[EnvironmentVariable.bitcode.rawValue] == Keys.yes.rawValue {
            print("[Bitrise:Trace/dSYM] Enable Bitcode set to true. Please upload dSYM's files from iTunes Connect under Activity->Build->Download dSYM.")
            print("[Bitrise:Trace/dSYM] See script guide on top for uploading dSYM's examples")
            
            // no throw required - soft warning
        }
    }
}

struct InfoPlistLocator {
    
    // MARK: - Model
    
    struct Model: Decodable {
        
        // MARK: - Enum
        
        private enum CodingKeys: String, CodingKey {
            case app = "CFBundleShortVersionString"
            case build = "CFBundleVersion"
        }
        
        // MARK: - Property
        
        let app: String
        let build: String
    }
    
    // MARK: - Property
    
    private let environment: [String: String]
    
    // MARK: - Init
    
    init(with environment: [String: String]) {
        self.environment = environment
    }
    
    // MARK: - setup
    
    func infoPlist() throws -> Model {
        let kProductDir = EnvironmentVariable.productDir.rawValue
        let kInfoPlistPath = EnvironmentVariable.infoPlistPath.rawValue
        
        guard let productDir = environment[kProductDir] else {
            print("[Bitrise:Trace/infoplist] Failed to find path: \(kProductDir) in environment")
            
            throw NSError(domain: "Infoplist.failedToFind\(kProductDir)", code: 1)
        }
        guard let infoPlistPath = environment[kInfoPlistPath] else {
            print("[Bitrise:Trace/infoplist] Failed to find path: \(kInfoPlistPath) in environment")
            
            throw NSError(domain: "Infoplist.failedToFind\(kInfoPlistPath)", code: 1)
        }
        
        let path = (productDir as NSString).appendingPathComponent(infoPlistPath)
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        
        print("[Bitrise:Trace/infoplist] Found InfoPlist")
        
        let model = try PropertyListDecoder().decode(Model.self, from: data)
        
        print("[Bitrise:Trace/infoplist] InfoPlist model created")
        
        return model
    }
}

// MARK: - Run Script

print(" ")
print("[Bitrise:Trace/dSYM] Bitrise Trace upload dSYM's started at \(Date()).")
print("----------------------------------------------------------\n\n")
print("[Bitrise:Trace/dSYM] version \(version)")

let process = ProcessInfo.processInfo
let environment = process.environment
let arguments = CommandLine.arguments
var dSYMFolderPath = environment[DSYMLocator.Paths.dSYM.rawValue]
let argument: Argument

do {
    do {
        argument = try Argument(with: arguments) // Check arguments first
        
        print("[Bitrise:Trace/argument] Found arguments in Script argument list")
    } catch {
        print("[Bitrise:Trace/argument] Looking for arguments in Info.plist since nothing could be located in arguments list")
        
        guard let infoPlist = try? InfoPlistLocator(with: environment).infoPlist() else { throw error }
        
        argument = try Argument(appVersion: infoPlist.app, buildVersion: infoPlist.build)
    }
    
    try Validation(with: environment).validate()
    
    if let path = DSYMLocator.customDSYMPath {
        print("[Bitrise:Trace/dSYM] Custom dSYM path launch arguments found, overriding default path to: \(path).")

        dSYMFolderPath = path
    }
    
    let dSYMLocator = try DSYMLocator(dSYMFolderPath)
    let path = dSYMLocator.paths
    let zippedDSYMs: String = try {
        let zippedDSYMs: String
        
        if let zippedDSYMPath = dSYMFolderPath, zippedDSYMPath.hasSuffix(Extension.zip.rawValue) {
            print("[Bitrise:Trace/zip] Custom path is a zip file, will not rezip file")
            
            zippedDSYMs = zippedDSYMPath // File is already zipped
        } else {
            zippedDSYMs = try Zip.paths(path, name: "dSYMs\(Extension.zip.rawValue)")
        }
        
        print("[Bitrise:Trace/zip] dSYM file size: \(dSYMLocator.size(for: zippedDSYMs)) to be uploaded")
        
        return zippedDSYMs
    }()
    let token = try TokenLocator.token()
    let file = URL(fileURLWithPath: zippedDSYMs)
    let uploader = try Uploader(token: token)
    let parameters = [
        Uploader.Keys.version.rawValue: argument.appVersion,
        Uploader.Keys.build.rawValue: argument.buildVersion
    ]
    
    try uploader.upload(fileAtPath: file, withParameters: parameters) {
        switch $0 {
        case .success: break
        case .failure: break
        }
        
        print("\n\n----------------------------------------------------------")
        print("[Bitrise:Trace/dSYM] Bitrise Trace upload dSYM's finished \(Date()).")
        
        exit(EXIT_SUCCESS)
    }
} catch {
    print("\n\n----------------------------------------------------------")
    print("[Bitrise:Trace/dSYM] Bitrise Trace upload dSYM's failed: \((error as NSError).description) \(Date()).")
    print("[Bitrise:Trace/dSYM] Bitrise Trace upload dSYM's unsuccessful.")
    
    exit(EXIT_SUCCESS)
}

print("[Bitrise:Trace/dSYM] Running RunLoop for duration of the upload task.")

// Keep the script running while async code is executing. Use EXIT_SUCCESS to exit
RunLoop.main.run()

print("[Bitrise:Trace/dSYM] RunLoop stopped running.")
// swiftlint:disable file_length
print(" ")
