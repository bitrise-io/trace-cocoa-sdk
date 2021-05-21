//
//  CrashReporting.swift
//  Trace
//
//  Created by Shams Ahmed on 07/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

private var oldExceptionHandler: (@convention(c) (NSException) -> Swift.Void)?

protocol CrashReportingProvider {
    
    // MARK: - Observe
    
    static func observe() -> Bool
}

/// CrashReporting class monitors for crashes in the host app. This uses Apple approach isn't the most accurate and mostly misses out majority of the classes. i.e Swift, C++ etc...
internal final class CrashReporting: CrashReportingProvider {
    
    // MARK: - Property
    
    private static let recieveException: @convention(c) (NSException) -> Swift.Void = { exteption in
        oldExceptionHandler?(exteption)
        
        let callStack = exteption.callStackSymbols.joined(separator: "\n")
        let reason = exteption.reason ?? ""
        let name = exteption.name
        let model = CrashReporting.Report(
            type: .exception,
            name: name.rawValue,
            reason: reason,
            callStack: callStack
        )
        
        process(with: model)
    }
    
    private static let recieveSignal: @convention(c) (Int32) -> Void = { signal in
        var stack = Thread.callStackSymbols
        stack.removeFirst(2)
        
        let callStack = stack.joined(separator: "\n")
        let reason = "Signal \(CrashReporting.name(of: signal))(\(signal)) was raised.\n"
        let model = CrashReporting.Report(
            type: .signal,
            name: CrashReporting.name(of: signal),
            reason: reason,
            callStack: callStack
        )
        
        process(with: model)
        
        CrashReporting.terminate()
    }
    
    // MARK: - Init
    
    @discardableResult
    internal static func observe() -> Bool {
        oldExceptionHandler = NSGetUncaughtExceptionHandler()
        
        NSSetUncaughtExceptionHandler(CrashReporting.recieveException)
        
        setup()
        
        return true
    }
    
    // MARK: - Setup
    
    private class func setup() {
        signal(SIGABRT, CrashReporting.recieveSignal)
        signal(SIGILL, CrashReporting.recieveSignal)
        signal(SIGSEGV, CrashReporting.recieveSignal)
        signal(SIGFPE, CrashReporting.recieveSignal)
        signal(SIGBUS, CrashReporting.recieveSignal)
        signal(SIGPIPE, CrashReporting.recieveSignal)
        signal(SIGTRAP, CrashReporting.recieveSignal)
        signal(SIGSYS, CrashReporting.recieveSignal)
    }
    
    // MARK: - Helper
    
    class func name(of signal: Int32) -> String {
        switch signal {
        case SIGABRT: return "SIGABRT"
        case SIGILL: return "SIGILL"
        case SIGSEGV: return "SIGSEGV"
        case SIGFPE: return "SIGFPE"
        case SIGBUS: return "SIGBUS"
        case SIGPIPE: return "SIGPIPE"
        case SIGTRAP: return "SIGTRAP"
        case SIGSYS: return "SIGSYS"
        default: return "OTHER"
        }
    }
    
    // MARK: - Process
    
    class func process(with report: Report) {
        let formatter = CrashFormatter(report)
        let spans = formatter.spans
        
        Trace.shared.tracer.addChild(spans)
        Trace.shared.tracer.finishAll()
        
        // the app has a limited time to run code, so have to bypass
        // the queue and save
        Trace.shared.database.dao.metric.create(
            with: formatter.metrics.metrics,
            save: true,
            synchronous: true
        )
        Trace.shared.database.saveAll()
    }
    
    // MARK: - Terminate
    
    class func terminate() {
        NSSetUncaughtExceptionHandler(nil)
        
        signal(SIGABRT, SIG_DFL)
        signal(SIGILL, SIG_DFL)
        signal(SIGSEGV, SIG_DFL)
        signal(SIGFPE, SIG_DFL)
        signal(SIGBUS, SIG_DFL)
        signal(SIGPIPE, SIG_DFL)
        signal(SIGTRAP, SIG_DFL)
        signal(SIGSYS, SIG_DFL)
        
        kill(getpid(), SIGKILL)
    }
}
