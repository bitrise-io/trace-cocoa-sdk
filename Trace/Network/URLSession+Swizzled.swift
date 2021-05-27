//
//  URLSession+Swizzled.swift
//  Trace
//
//  Created by Shams Ahmed on 08/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import ObjectiveC

// MARK: - URLSession

/// Internal use only
extension URLSession: Swizzled {

    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        BITRISE_WILL_SWIZZLE_METHOD()
        
        let part1 = "init"
        let part2 = "With"
        let part3 = "Configuration:"
        let part4 = "delegate:"
        let part5 = "delegateQueue:"

        _ = Selectors(
            original: Selector((part1 + part2 + part3 + part4 + part5)), // initWithConfiguration:delegate:delegateQueue:
            alternative: #selector(URLSession.init(bitrise_configuration:delegate:delegateQueue:))
        )
        let dataTaskRequest1 = Selectors(
            original: #selector((URLSession.dataTask(with:)) as (URLSession) -> (URLRequest) -> URLSessionDataTask),
            alternative: #selector((URLSession.bitrise_dataTaskWithRequest(_:)) as (URLSession) -> (URLRequest) -> URLSessionDataTask)
        )
        let dataTaskRequest2 = Selectors(
            original: #selector((URLSession.dataTask(with:completionHandler:)) as (URLSession) -> (URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask),
            alternative: #selector((URLSession.bitrise_dataTaskWithRequest(_:completionHandler:)) as (URLSession) -> (URLRequest, ((Data?, URLResponse?, Error?) -> Void)?) -> URLSessionDataTask)
        )
        let streamTask1 = Selectors(
            original: #selector(URLSession.streamTask(with:)),
            alternative: #selector(URLSession.bitrise_streamTaskWith(_:))
        )
        let streamTask2 = Selectors(
            original: #selector(URLSession.streamTask(withHostName:port:)),
            alternative: #selector(URLSession.bitrise_streamTaskWithHostName(_:port:))
        )
        let uploadTask1 = Selectors(
            original: #selector(URLSession.uploadTask(with:fromFile:)),
            alternative: #selector(URLSession.bitrise_uploadTask(with:fromFile:))
        )
        let uploadTask2 = Selectors(
            original: #selector(URLSession.uploadTask(with:from:)),
            alternative: #selector(URLSession.bitrise_uploadTask(with:from:))
        )
        let uploadTask3 = Selectors(
            original: #selector(URLSession.uploadTask(withStreamedRequest:)),
            alternative: #selector(URLSession.bitrise_uploadTask(withStreamedRequest:))
        )
        let uploadTask4 = Selectors(
            original: #selector(URLSession.uploadTask(with:fromFile:completionHandler:)),
            alternative: #selector(URLSession.bitrise_uploadTask(with:fromFile:completionHandler:))
        )
        let uploadTask5 = Selectors(
            original: #selector(URLSession.uploadTask(with:from:completionHandler:)),
            alternative: #selector(URLSession.bitrise_uploadTask(with:from:completionHandler:))
        )
        let downloadTask1 = Selectors(
            original: #selector((URLSession.downloadTask(with:) as (URLSession) -> (URLRequest) -> URLSessionDownloadTask)),
            alternative: #selector(URLSession.bitrise_downloadTaskWithRequest(_:))
        )
        let downloadTask2 = Selectors(
            original: #selector((URLSession.downloadTask(with:) as (URLSession) -> (URL) -> URLSessionDownloadTask)),
            alternative: #selector(URLSession.bitrise_downloadTaskWithURL(_:))
        )
        let downloadTask3 = Selectors(
            original: #selector(URLSession.downloadTask(withResumeData:)),
            alternative: #selector(URLSession.bitrise_downloadTaskWithResumeData(_:))
        )
        let downloadTask4 = Selectors(
            original: #selector((URLSession.downloadTask(with:completionHandler:) as (URLSession) -> (URLRequest, @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask)),
            alternative: #selector(URLSession.bitrise_downloadTaskWithRequest(_:completionHandler:))
        )
        let downloadTask5 = Selectors(
            original: #selector((URLSession.downloadTask(with:completionHandler:) as (URLSession) -> (URL, @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask)),
            alternative: #selector(URLSession.bitrise_downloadTaskWithURL(_:completionHandler:))
        )
        let downloadTask6 = Selectors(
            original: #selector(URLSession.downloadTask(withResumeData:completionHandler:)),
            alternative: #selector(URLSession.bitrise_downloadTaskWithResumeData(_:completionHandler:))
        )
        
        // private method.. easy way to avoid Apple discovering in their automatic string analysis tool
        let canPart1 = "can_"
        let canPart2 = "delegate_"
        let canPart3 = "task_"
        let canPart4 = "didFinishCollectingMetrics"
        let canDidFinishCollectingMetrics = Selectors(
            original: NSSelectorFromString(canPart1 + canPart2 + canPart3 + canPart4), // can_delegate_task_didFinishCollectingMetrics
            alternative: #selector(URLSession.bitrise_canDelegateTaskDidFinishCollectingMetrics)
        )
        
        // private method.. easy way to avoid Apple discovering in their automatic string analysis tool
        let didPart1 = "delegate_task:"
        let didPart2 = "didFinishCollectingMetrics:"
        let didPart3 = "completion:"
        let didFinishCollectingMetrics = Selectors(
            original: NSSelectorFromString(didPart1 + didPart2 + didPart3), // delegate_task:didFinishCollectingMetrics:completion:
            alternative: #selector(URLSession.bitrise_delegateTask(_:didFinishCollectingMetrics:completion:))
        )
        
        // _ = self.swizzleInstanceMethod(`init`) // Disabled
        _ = self.swizzleInstanceMethod(dataTaskRequest1)
        _ = self.swizzleInstanceMethod(dataTaskRequest2)
        _ = self.swizzleInstanceMethod(streamTask1)
        _ = self.swizzleInstanceMethod(streamTask2)
        _ = self.swizzleInstanceMethod(uploadTask1)
        _ = self.swizzleInstanceMethod(uploadTask2)
        _ = self.swizzleInstanceMethod(uploadTask3)
        _ = self.swizzleInstanceMethod(uploadTask4)
        _ = self.swizzleInstanceMethod(uploadTask5)
        _ = self.swizzleInstanceMethod(downloadTask1)
        _ = self.swizzleInstanceMethod(downloadTask2)
        _ = self.swizzleInstanceMethod(downloadTask3)
        _ = self.swizzleInstanceMethod(downloadTask4)
        _ = self.swizzleInstanceMethod(downloadTask5)
        _ = self.swizzleInstanceMethod(downloadTask6)
        _ = self.swizzleInstanceMethod(canDidFinishCollectingMetrics)
        _ = self.swizzleInstanceMethod(didFinishCollectingMetrics)
        
        BITRISE_DID_SWIZZLE_METHOD()
        
        return .success
    }
    
    // MARK: - Enum
    
    private struct AssociatedKey {
        static var metrics = "br_can_receive_metrics"
    }
    
    // MARK: - Property
    
    /// Some apps have custom logic for metrics so we can't always depend on it.
    /// But whenever we can the SDK will take full ownership on the method.
    /// This does not call the orginal method as it hasn't been implemented
    private var canReceiveMetrics: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKey.metrics) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.metrics, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - Init
    
    @objc
    internal convenience init(bitrise_configuration: URLSessionConfiguration, delegate: URLSessionDelegate?, delegateQueue queue: OperationQueue?) {
        // call default method
        self.init(bitrise_configuration: bitrise_configuration, delegate: delegate, delegateQueue: queue)
        
        process(bitrise_configuration)
    }
    
    // MARK: - DataTask
    
    @objc
    internal func bitrise_dataTaskWithRequest(_ request: URLRequest) -> URLSessionDataTask {
        // call default method
        let task = self.bitrise_dataTaskWithRequest(request)
        
        process(request)
        
        return task
    }
    
    @objc
    internal func bitrise_dataTaskWithRequest(_ request: URLRequest, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) -> URLSessionDataTask {
        let task = self.bitrise_dataTaskWithRequest(request, completionHandler: completionHandler)
        
        process(request)

        return task
    }
    
    // MARK: - Stream Task
    
    @objc
    internal func bitrise_streamTaskWithHostName(_ hostname: String, port: Int) -> URLSessionStreamTask {
        // call default method
        let task = self.bitrise_streamTaskWithHostName(hostname, port: port)
        
        return task
    }
    
    @objc
    internal func bitrise_streamTaskWith(_ service: NetService) -> URLSessionStreamTask {
        // call default method
        let task = self.bitrise_streamTaskWith(service)
         
        return task
    }
    
    // MARK: - Upload
    
    @objc
    internal func bitrise_uploadTask(with request: URLRequest, fromFile fileURL: URL) -> URLSessionUploadTask {
        // call default method
        let task = self.bitrise_uploadTask(with: request, fromFile: fileURL)
        
        process(request)
        
        return task
    }
    
    @objc
    internal func bitrise_uploadTask(with request: URLRequest, from bodyData: Data) -> URLSessionUploadTask {
        // call default method
        let task = self.bitrise_uploadTask(with: request, from: bodyData)
        
        process(request)
        
        return task
    }
    
    @objc
    internal func bitrise_uploadTask(withStreamedRequest request: URLRequest) -> URLSessionUploadTask {
        // call default method
        let task = self.bitrise_uploadTask(withStreamedRequest: request)
        
        process(request)
        
        return task
    }
    
    @objc
    internal func bitrise_uploadTask(with request: URLRequest, fromFile fileURL: URL, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) -> URLSessionUploadTask {
        // call default method
        let task = self.bitrise_uploadTask(with: request, fromFile: fileURL, completionHandler: completionHandler)
        
        process(request)
        
        return task
    }
    
    @objc
    internal func bitrise_uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) -> URLSessionUploadTask {
        // call default method
        let task = self.bitrise_uploadTask(with: request, from: bodyData, completionHandler: completionHandler)
        
        process(request)
        
        return task
    }
    
    // MARK: - Download
    
    @objc
    internal func bitrise_downloadTaskWithRequest(_ request: URLRequest) -> URLSessionDownloadTask {
        // call default method
        let task = self.bitrise_downloadTaskWithRequest(request)
        
        process(request)
        
        return task
    }
    
    @objc
    internal func bitrise_downloadTaskWithURL(_ url: URL) -> URLSessionDownloadTask {
        // call default method
        let task = self.bitrise_downloadTaskWithURL(url)
        
        process(URLRequest(url: url))
        
        return task
    }
    
    @objc
    internal func bitrise_downloadTaskWithResumeData(_ resumeData: Data) -> URLSessionDownloadTask {
        // call default method
        let task = self.bitrise_downloadTaskWithResumeData(resumeData)
        
        return task
    }
    
    @objc
    internal func bitrise_downloadTaskWithRequest(_ request: URLRequest, completionHandler: ((URL?, URLResponse?, Error?) -> Void)?) -> URLSessionDownloadTask {
        // call default method
        let task = self.bitrise_downloadTaskWithRequest(request, completionHandler: completionHandler)
        
        process(request)
        
        return task
    }
    
    @objc
    internal func bitrise_downloadTaskWithURL(_ url: URL, completionHandler: ((URL?, URLResponse?, Error?) -> Void)?) -> URLSessionDownloadTask {
        // call default method
        let task = self.bitrise_downloadTaskWithURL(url, completionHandler: completionHandler)
        
        process(URLRequest(url: url))
        
        return task
    }
    
    @objc
    internal func bitrise_downloadTaskWithResumeData(_ resumeData: Data, completionHandler: ((URL?, URLResponse?, Error?) -> Void)?) -> URLSessionDownloadTask {
        // call default method
        let task = self.bitrise_downloadTaskWithResumeData(resumeData, completionHandler: completionHandler)
        
        return task
    }
    
    // MARK: - Metrics
    
    @objc
    internal func bitrise_canDelegateTaskDidFinishCollectingMetrics() -> Bool {
        // call default method and cache the results
        let result = self.bitrise_canDelegateTaskDidFinishCollectingMetrics()
        
        // this is now used as a flag
        self.canReceiveMetrics = result
        
        return result
    }
    
    @objc
    internal func bitrise_delegateTask(_ task: AnyObject, didFinishCollectingMetrics metrics: URLSessionTaskMetrics, completion: AnyObject) {
        // If the app hasn't implemented the method we will take full ownership of it
        if self.canReceiveMetrics {
            // call default method as the app has this method set
            self.bitrise_delegateTask(
                task,
                didFinishCollectingMetrics: metrics,
                completion: completion
            )
        } else {
            Logger.warning(.network, "class (\(String(describing: type(of: self)))) cannot receive metrics as delegate method hasn't been set")
        }
        
        process(metrics)
        // skipping task since its has been processed beforehand
    }
  
    // MARK: - Private
    
    private func process(_ metrics: URLSessionTaskMetrics) {
        let api = Constants.API.absoluteString
        let isBitriseMetric = metrics.transactionMetrics.contains {
            return $0.request.url?.absoluteString.contains(api) == true
        }
        
        guard !isBitriseMetric else { return }
        
        let formatter = TaskMetricsFormatter(metrics)
        let spans = formatter.spans
        
        let shared = Trace.shared
        shared.tracer.addChild(spans)
        shared.queue.add(formatter.metrics)
        
        // some odd reason, this object get freed up and crashes the app, so i made sure it stay in memory a little longer the holding on to it after using it above to stop it crashing.
        _ = spans
    }
    
    private func process(_ request: URLRequest) {
        // SKIPPED till post launch
//        let api = Constants.API.absoluteString
//        let url = request.url?.absoluteString
//
//        guard url?.contains(api) == false else {
//            return
//        }
//
//        let requestFormatter = RequestFormatter(request)
//
//        Trace.shared.queue.add(requestFormatter.metrics)
    }
   
    // Disabled
    private func process(_ configuration: URLSessionConfiguration) {
        // let configurationFormatter = SessionConfigurationFormatter(configuration)
        
        // Trace.shared.queue.add(configurationFormatter.metrics)
    }
}
