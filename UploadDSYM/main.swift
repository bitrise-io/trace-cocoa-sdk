// #!/usr/bin/env xcrun swift

//
// Bitrise Trace SDK - Upload dSYM's
// https://www.bitrise.io/add-ons/trace-mobile-monitoring
// https://github.com/bitrise-io/trace-cocoa-sdk/
//
// This script uploads all dSYM files.
//
// By default the script check for APM collector token in the following order:
//  - Check Launch arguments.
//  - Check environment variable for `APM_COLLECTOR_TOKEN`.
//  - Check for `bitrise_configuration.plist` in the root of the project.
//  - If none of the above work, script fails.
//
// Call script directly using the following command on Terminal:
// Remote script
// /usr/bin/xcrun --sdk macosx swift <(curl -Ls --retry 3 --connect-timeout 20 https://raw.githubusercontent.com/bitrise-io/trace-cocoa-sdk/main/UploadDSYM/main.swift)
// Local script
// /usr/bin/xcrun --sdk macosx swift main.swift
//
// Features
//
// Using a folder path or zip file:
// Folder path
// /usr/bin/xcrun --sdk macosx swift main.swift APM_DSYM_PATH ~/Downloads/appDsyms/
//
// Zip file i.e iTunes connect dSYM file
// /usr/bin/xcrun --sdk macosx swift main.swift APM_DSYM_PATH ~/Downloads/appDsyms.zip
//
// Using a custom APM collector token:
// /usr/bin/xcrun --sdk macosx swift main.swift APM_COLLECTOR_TOKEN TOKEN
//
import Foundation

/// Keys
enum Keys: String, CodingKey {
    case token = "APM_COLLECTOR_TOKEN"
    case customDSYMPath = "APM_DSYM_PATH"
    case configuration = "bitrise_configuration"
    case product = "PRODUCT_NAME"
    case platform = "EFFECTIVE_PLATFORM_NAME"
    case iPhoneSimulator = "-iphonesimulator"
    case bitcode = "ENABLE_BITCODE"
    case debugInformationFormat = "DEBUG_INFORMATION_FORMAT"
    case dwarfWithDSYM = "dwarf-with-dsym"
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
            print("[Bitrise:Trace/dSYM] Found \(dSYMs.count) dSYM files \(dSYMs).")
        }
    }
    
    /// Paths of all dSYM files with root
    var paths: [String] { dSYMs.map { (path as NSString).appendingPathComponent($0) } }
    
    // MARK: - Init
    
    init(_ path: String?) throws {
        guard let unwrappedPath = path else { throw NSError(
            domain: "DSYMLocator.badFolderPath",
            code: 1,
            userInfo: ["path": path ?? "Unknown"])
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
        
        guard let index = arguments.firstIndex(of: Keys.customDSYMPath.rawValue) else { return nil }
        
        print("[Bitrise:Trace/dSYM] Additional launch arguments found. Checking for custom dSYM path.")
        
        let path = arguments[index + 1]
        
        guard URL(fileURLWithPath: path).isFileURL else { return nil }
        
        print("[Bitrise:Trace/dSYM] Additional launch arguments found for custom dSYM path.")
        
        return path
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
        let container = try decoder.container(keyedBy: Keys.self)
        
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
        
        guard let index = arguments.firstIndex(of: Keys.token.rawValue) else { return nil }
        
        let token = arguments[index + 1]
        
        print("[Bitrise:Trace/dSYM] Using token \(token) at position 1 from launch arguments.")
        
        return token
    }
    
    private static var environmentVariable: String? {
        let process = ProcessInfo.processInfo
        let environment = process.environment
        
        guard let token = environment[Keys.token.rawValue] else { return nil }
        
        print("[Bitrise:Trace/dSYM] Using token \(Keys.token.rawValue) from environment variable.")
        
        return token
    }
    
    private static var configurationPlist: String? {
        let configurationKey = Keys.configuration.rawValue + Extension.plist.rawValue
        let process = ProcessInfo.processInfo
        let environment = process.environment
        let name = environment[Keys.product.rawValue] ?? ""
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
    
    func upload(fileAtPath file: URL, _ completion: @escaping (Result<Void, Error>) -> Void) throws {
        guard let url = URL(string: "https://collector.apm.bitrise.io/api/v1/symbols") else {
            throw NSError(domain: "Uploader.failedToCreateURL", code: 1)
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("UploadDSYM 1.0.0", forHTTPHeaderField: "User-Agent")
        request.httpShouldUsePipelining = true
        request.networkServiceType = .responsiveData

        print("[Bitrise:Trace/dSYM] Uploading to: \(request)")
        print("[Bitrise:Trace/dSYM] Uploading dSYM's \(Date()).")
        
        session.uploadTask(with: request, fromFile: file) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            
            print("[Bitrise:Trace/dSYM] Upload complete with status code: (\(httpResponse?.statusCode ?? 0)) - \(Date()).")
            
            if let error = error {
                print("[Bitrise:Trace/dSYM] Warning!")
                print("[Bitrise:Trace/dSYM] Upload error: \(error.localizedDescription).")
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

print(" ")
print("[Bitrise:Trace/dSYM] Bitrise Trace upload dSYM's started at \(Date()).")
print("----------------------------------------------------------\n\n")

// swiftlint:disable all
let process = ProcessInfo.processInfo
let environment = process.environment
let arguments = CommandLine.arguments
var dSYMFolderPath = environment[DSYMLocator.Paths.dSYM.rawValue]
// swiftlint:enable all

if let path = DSYMLocator.customDSYMPath {
    print("[Bitrise:Trace/dSYM] Custom dSYM launch arguments found, overriding default path for: \(path).")
    
    dSYMFolderPath = path
}

if environment[Keys.platform.rawValue] == Keys.iPhoneSimulator.rawValue {
    print("[Bitrise:Trace/dSYM] Warning!")
    print("[Bitrise:Trace/dSYM] Environment set to iPhone simulator, future versions will skip build for releases build only!")
    print("[Bitrise:Trace/dSYM] Warning!")
    print(" ")
}

if let debugInformationFormat = environment[Keys.debugInformationFormat.rawValue], debugInformationFormat != Keys.dwarfWithDSYM.rawValue {
    print("[Bitrise:Trace/dSYM] Warning!")
    print("[Bitrise:Trace/dSYM] \(Keys.debugInformationFormat.rawValue) set to \(debugInformationFormat). Set it to \(Keys.debugInformationFormat.rawValue) under Xcode->Build Settings to generate a dSYM for your application.")
    print("[Bitrise:Trace/dSYM] Warning!")
    print(" ")
}

if environment[Keys.bitcode.rawValue] == "YES" {
    print("[Bitrise:Trace/dSYM] Enable Bitcode set to true. Please upload dSYM's files from iTunes Connect under Activity->Build->Download dSYM.")
    print("[Bitrise:Trace/dSYM] See script guide on top for upload dSYM's examples")
}

do {
    let dSYMLocator = try DSYMLocator(dSYMFolderPath)
    let path = dSYMLocator.paths
    let zippedDSYMs: String
    
    if let zippedDSYMPath = dSYMFolderPath, zippedDSYMPath.hasSuffix(Extension.zip.rawValue) {
        print("[Bitrise:Trace/zip] Custom path is a zip file, will not rezip file")
        
        // File is already zipped
        zippedDSYMs = zippedDSYMPath
    } else {
        zippedDSYMs = try Zip.paths(path, name: "dSYMs\(Extension.zip.rawValue)")
    }
    
    let token = try TokenLocator.token()
    let file = URL(fileURLWithPath: zippedDSYMs)
    let uploader = try Uploader(token: token)
    
    try uploader.upload(fileAtPath: file) {
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

RunLoop.main.run()

print("[Bitrise:Trace/dSYM] RunLoop stopped running.")
// swiftlint:disable file_length
print(" ")
