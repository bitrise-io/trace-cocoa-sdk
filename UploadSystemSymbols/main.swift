//
// WIP
// Warning this script only outputs the command and does not do the work to process and submit to the cloud
//
import Foundation

// MARK: - Enum

enum Parameter: String {
    case path = "-path"
}

enum Skip: String, CaseIterable {
    case DSStore = ".DS_Store"
}

// MARK: - Shell

final class Shell {
    
    // MARK: - Error
    
    enum Error: Swift.Error {
        case standardError(String?)
    }
    
    // MARK: - Property
    
    private let process = Process()
    
    // MARK: - Run
    
    @discardableResult
	func run(_ arguments: [String]) throws -> Result<String, Error> {
        let pipes = (stdout: Pipe(), stderr: Pipe())
        
        process.launchPath = "/usr/bin/env" // default shell i.e bash
        process.arguments = arguments
        process.qualityOfService = .userInitiated
		process.standardOutput = pipes.stdout
		process.standardError = pipes.stderr
		
        print("Running shell command: \(arguments.joined(separator: " "))")
        
        // TODO: Does not work on async code as one process can only be running at one giving time
        // Worth looking in to Runloop locks
        // Or calling all the async command in new processes
		try process.run()
        
        process.waitUntilExit()

        guard let stdout = siphon(pipes.stdout) else { return .failure(.standardError(siphon(pipes.stderr))) }
        
		return .success(stdout)
	}
    
    // MARK: - Siphon
    
    private func siphon(_ pipe: Pipe) -> String? {
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
        guard !data.isEmpty else { return nil }
        
        return String(decoding: data, as: UTF8.self)
    }
}

// MARK: - Zip

struct Zip {
    
    // MARK: - Enum
    
    enum Extension: String, CaseIterable {
        case sevenZ = ".7z"
        case gzip = ".gz"
        case zip = ".zip"
    }
    
    // MARK: - Property
    
    let shell: Shell
    
    // MARK: - Type
    
    static func isZip(atPath path: String) -> Bool {
        return Extension.allCases.contains { path.hasSuffix($0.rawValue) }
    }
    
    // MARK: - Unzip
    
    func unzip(atPath path: String) {
        // look at ways to unzip other types such as 7z
    }
}

// MARK: - Property

let process = ProcessInfo.processInfo
let environment = process.environment
let arguments = CommandLine.arguments
let fileManager = FileManager.default
var path = fileManager.currentDirectoryPath
var commands = [String]()

// MARK: - ENV

// Check for path, otherwise use current working directory
if let index = arguments.firstIndex(of: Parameter.path.rawValue) {
    print("Using custom path")
    
    path = arguments[index + 1]
    
    fileManager.changeCurrentDirectoryPath(path)
}

print("Current directory path: \(path) \n")

// MARK: - Run

do {
    try fileManager.contentsOfDirectory(atPath: path).forEach { subPath in
        guard !Skip.allCases.contains(where: { subPath.contains($0.rawValue) }) else {
            return print("Skipping file: \(subPath)")
        }
        guard !Zip.isZip(atPath: subPath) else {
            return print("Skipping zip: \(subPath)")
        }
        
        let regXRange = NSRange(location: 0, length: subPath.count)
        let regX = try NSRegularExpression(pattern: "(\\d.+)\\w\\)", options: .caseInsensitive)
        
        guard let result = regX.firstMatch(in: subPath, options: .reportCompletion, range: regXRange) else {
            return print("Regx failed for path: \(subPath)")
        }
        
        let range = result.range
        let start = subPath.index(subPath.startIndex, offsetBy: range.location)
        let end = subPath.index(start, offsetBy: range.length)
        let swiftRange = start..<end
        let rawVersion = String(subPath[swiftRange])
        let split = rawVersion.split(separator: " ")[0]
        let version = rawVersion
            .replacingOccurrences(of: " (", with: "_")
            .replacingOccurrences(of: ")", with: "")
        
        print("Path: \(subPath)")
        print("Version: \(version) \n")
        
        let command = "~/symbolicator/symsorter/target/release/symsorter -zz -o ~/OSSymbolsSplit/ios --prefix \"\(split)\" --bundle-id \"\(version)\" \"\(path)/\(subPath)\""
        
        commands.append(command)
    }
    
    print("Commands:")
    
    commands.forEach { print($0) }
    
    // Todo find a solution
    print("Open Terminal and call each one.. Can take 5min per request")
} catch {
    print(error)
}
