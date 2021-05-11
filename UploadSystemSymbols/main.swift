import Foundation

// swiftlint:disable prefixed_toplevel_constant
// swiftlint:disable switch_case_alignment
// swiftlint:disable force_unwrapping

// MARK: - Enum

enum Parameter: String {
    case path = "-path"
    case architecture = "-architecture"
}

enum Skip: String, CaseIterable {
    case pdf = ".pdf"
    case localized = ".localized"
    case DSStore = ".DS_Store"
}

// MARK: - Shell

/**
 Examples
 
 // In the root of the repo
 swift UploadSystemSymbols/main.swift -path ~/Downloads/
 
 // In the root of the repo and hae set architecture that are already in the path
 swift UploadSystemSymbols/main.swift -path ~/Downloads/ -architecture arm64
 */
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

        guard let stdout = siphon(pipes.stdout) else {
            let error = siphon(pipes.stderr)
            
            print("Shell error: \(error ?? "Unknown")")
            
            return .failure(.standardError(error))
        }
        
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
    
    // MARK: - Model
    
    struct Content {
        let size: Int
        let name: String
    }
    
    // MARK: - Enum
    
    enum Extension: String, CaseIterable {
        case sevenZ = ".7z"
        case gzip = ".gz"
        case zip = ".zip"
    }
    
    // MARK: - Property
    
    private let shell = Shell()
    
    // MARK: - Validation
    
    static func isZip(atPath path: String) -> Bool {
        return Extension.allCases.contains { path.hasSuffix($0.rawValue) }
    }
    
    // MARK: - Content
    
    func content(atPath path: String, filter: String = "") throws -> Result<[Content], Shell.Error> {
        let result = try shell.run(["unzip", "-l", path, "*\(filter)"])
        
        switch result {
            case .success(let value):
                var split = value.split(whereSeparator: { $0.isNewline })
                split.removeAll { !$0[$0.startIndex].isNumber }
                
                if split.last?.contains(filter) == false {
                    split.removeLast()
                }
                
                split.sort()
                split.reverse()
                
                var contents: [Content] = split.compactMap {
                    let splited = $0.split(separator: " ")
                    
                    guard let first = splited.first,
                          let last = splited.last,
                          let size = Int(first) else {
                        return nil
                    }
                    
                    return Content(size: size, name: String(last))
                }
                
                contents.sort(by: { lhs, rhs in lhs.size > rhs.size })
                
                return .success(contents)
            case .failure:
                return .failure(Shell.Error.standardError("failed to process shell command"))
        }
    }

    // MARK: - Unzip
    
    func unzip(atPath path: String, filter: String = "") throws {
        try shell.run(["unzip", path, filter])
    }
}

class Symsorter {
    
    // MARK: - Typealias
    
    typealias Command = (command: String, version: String, build: String)
    
    // MARK: - Build
    
    func build(_ path: String, root: String, forArchitecture architecture: String) throws -> Command {
        let name: String! = try fileManager.contentsOfDirectory(atPath: path).first(where: { subPath in
            func skipping(_ subPath: String) -> Bool {
                return false
            }
            
            guard !subPath.hasPrefix(".") else { return skipping(subPath) }
            guard !Skip.allCases.contains(where: { subPath.contains($0.rawValue) }) else { return skipping(subPath) }
            guard !Zip.isZip(atPath: subPath) else { return skipping(subPath) }
            guard subPath.contains(".ipsw") else { return skipping(subPath) }
            
            return true
        })
        var names = name.split(separator: "_")
        
        _ = names.removeLast()
        let build = String(names.removeLast())
        let version = String(names.removeLast())

        print("Found IPSW version: \(version), build: \(build)")
        
        let command = "\(root)/UploadSystemSymbols/symsorter -zz -o \(path)Output/ios --prefix \"\(version)\" --bundle-id \"\(version)_\(build)\" \"\(path)\(architecture)\""
        
        return Command(command: command, version: version, build: build)
    }
}

// Upload to GCP
enum Bucket: String {
    case prod = "gs://prod-1-symbols-store"
}

struct Structure {
    let path: String
    let fullPath: String
    let isDirectory: Bool
}

struct Locater {
    
    // MARK: - Typealias
    
    typealias BiggestDMG = (ipsw: Structure, content: Zip.Content)
    
    // MARK: - Enum
    
    enum Error: Swift.Error {
        case failedToFindDMG
        case failedToFindVolume
    }
    
    // MARK: - Property
    
    let fileManager: FileManager
    let path: String
    
    // MARK: - Locate
    
    func findIpsw() throws -> [Structure] {
        func skipping(_ subPath: String) -> Structure? {
            print("Skipping file: \(subPath)")
            
            return nil
        }
        
        let models = try fileManager.contentsOfDirectory(atPath: path).compactMap { subPath -> Structure? in
            guard !subPath.hasPrefix(".") else { return skipping(subPath) }
            guard !Skip.allCases.contains(where: { subPath.contains($0.rawValue) }) else { return skipping(subPath) }
            guard !Zip.isZip(atPath: subPath) else { return skipping(subPath) }
            guard subPath.contains(".ipsw") else { return skipping(subPath) }
            
            var isDirectory: ObjCBool = false
            _ = fileManager.fileExists(atPath: subPath, isDirectory: &isDirectory)
            
            guard !isDirectory.boolValue else { return skipping(subPath) }
            
            let fullPath = (path as NSString).appendingPathComponent(subPath)
            
            return Structure(
                path: subPath,
                fullPath: fullPath,
                isDirectory: isDirectory.boolValue
            )
        }
        
        return models
    }
    
    // MARK: - DMG
    
    func findBiggestDMG(from structures: [Structure]) throws -> [BiggestDMG] {
        let structure: [BiggestDMG] = try structures.compactMap {
            switch try Zip().content(atPath: $0.path, filter: ".dmg") {
                case .success(let contents):
                    if let max = contents.max(by: { lhs, rhs in lhs.size < rhs.size }) {
                        return BiggestDMG(ipsw: $0, content: max)
                    }
                    
                    return nil
                case .failure:
                    return nil
            }
        }
        
        return structure
    }
    
    // MARK: - Volume
    
    func findVolume(from response: Result<String, Shell.Error>) throws -> String {
        switch response {
            case .success(let value):
                let volumes = value
                    .replacingOccurrences(of: "\n", with: "")
                    .components(separatedBy: "\t")
            
                if let last = volumes.last {
                    return last
                } else {
                    print("Volumes: \(volumes)")
                }
            case .failure(let error):
                print("Volumes failed with error: \(error)")
        }
         
        throw Error.failedToFindVolume
    }
}

// MARK: - Property

print("\nUploadSystemSymbols")
print("Starting Upload system symbols script")

let process = ProcessInfo.processInfo
let environment = process.environment
let arguments = CommandLine.arguments
let fileManager = FileManager.default
var path = fileManager.currentDirectoryPath
let orginalPath = path
var knownArchitectures = [String]()

// MARK: - ENV

// Check for path, otherwise use current working directory
if let index = arguments.firstIndex(of: Parameter.path.rawValue) {
    print("Using custom path")
    
    path = arguments[index + 1]
    
    fileManager.changeCurrentDirectoryPath(path)
}

for (index, value) in arguments.enumerated() where value == Parameter.architecture.rawValuev {
    let architecture = arguments[index + 1]
        
    print("Found known architecture: \(architecture)")
        
    knownArchitectures.append(architecture)
}

print("Current directory path: \(path) \n")

// MARK: - Run

do {
    if knownArchitectures.isEmpty {
        // Find IPSW
        let locater = Locater(fileManager: fileManager, path: path)
        let ipsws = try locater.findIpsw()
        
        print("\nIPSW")
        ipsws.forEach { print($0) }
        
        // Find biggest sized DMG file
        print("\nBiggest DMG content file")

        let contents = try locater.findBiggestDMG(from: ipsws)
        try contents.forEach { content in
            // Unzip IPSW for the DMG
            print("\nUnzipping: \(content)")
            try Zip().unzip(atPath: content.ipsw.fullPath, filter: content.content.name)

            // Mount .DMG to OS
            let dmg = (path as NSString).appendingPathComponent(content.content.name)
            let volumeResults = try Shell().run(["hdiutil", "attach", dmg])
            let volume = try locater.findVolume(from: volumeResults)

            // Move OS debug file to root
            let OSDebugPath = (volume as NSString).appendingPathComponent("System/Library/Caches/com.apple.dyld/")
            let dyldName = try fileManager.contentsOfDirectory(atPath: OSDebugPath).first ?? ""
            let dyldPath = (OSDebugPath as NSString).appendingPathComponent(dyldName)
            let dyldFolderName = String(dyldName[dyldName.lastIndex(of: "_")!..<dyldName.endIndex]).replacingOccurrences(of: "_", with: "")

            try Shell().run(["mv", dyldPath, fileManager.currentDirectoryPath])

            // DSC extractor
            let dyldCopiedLocation = (fileManager.currentDirectoryPath as NSString).appendingPathComponent(dyldName)
            let dyldCopiedOutputLocation = (fileManager.currentDirectoryPath as NSString).appendingPathComponent(dyldFolderName)

            try Shell().run(["\(orginalPath)/UploadSystemSymbols/dsc_extractor", dyldCopiedLocation, dyldCopiedOutputLocation])

            knownArchitectures.append(dyldFolderName)
        }
    } else {
        print("Skipping to Merge symbols and Symsorter since architectures slices have been extracted")
    }

    // Merge symbols i.e arm64 and arm64e
    print("\nKnown architectures: \(knownArchitectures)")

    if knownArchitectures.count == 2 {
        print("Merging known architectures")
        
        let folder0 = "\(path)\(knownArchitectures[0])"
        let folder1 = "\(path)\(knownArchitectures[1])"
        let size0before = try Shell().run(["du", "-sh", folder0]).get()
        let size1before = try Shell().run(["du", "-sh", folder1]).get()
        
        print("Current folder size for \(size0before)")
        print("Current folder size for \(size1before)")
        
        let commands = ["\(orginalPath)/UploadSystemSymbols/merge_symbols", folder0, folder1]
        
        switch try Shell().run(commands) {
            case .success(let result): print(result)
            case .failure(let error): print(error)
        }

        let size0after = try Shell().run(["du", "-sh", folder0]).get()
        let size1after = try Shell().run(["du", "-sh", folder1]).get()
        
        print("Current folder size after processing for \(size0after)")
        print("Current folder size after processing for \(size1after)")
    }
    
    // Symsorter
    let command = try Symsorter().build(path, root: orginalPath, forArchitecture: knownArchitectures[0])
    try Shell().run([command.command])
    
    // Upload to GCP
    try Shell().run(["gsutil", "-o", "GSUtil:parallel_process_count=1", "-o", "GSUtil:parallel_thread_count=8", "-m", "cp", "-r", "\(path)Output/ios/", Bucket.prod.rawValue])
    
    // Confirm uploaded to GCP
    try Shell().run(["gsutil", "-o", "GSUtil:parallel_process_count=1", "-o", "GSUtil:parallel_thread_count=8", "-m", "cp", "-n", "-r", "\(path)Output/ios/", Bucket.prod.rawValue])
    
    // Read the directory and object sizes
    switch try Shell().run(["gsutil", "du", "-h", "\(Bucket.prod.rawValue)/ios/\(command.version)/"]) {
        case .success(let logs): print(logs)
        case .failure(let error): print(error)
    }
} catch {
    print("Scrip error")
    print(error)
}

print("\nCompleted Upload system symbols script")
print("UploadSystemSymbols")
