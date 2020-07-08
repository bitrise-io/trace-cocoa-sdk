//
//  ViewController.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import UIKit

/// Example of using a normal table view with a request and child view. somewhat of a complex setup!
final class ViewController: UITableViewController {

    // MARK: - Property
    
    // Adds a hidden child view, focus is to see if the SDK can pick it up
    private let childViewController: UIViewController = {
        // Custom class to see if i can also get the class name in the SDK
        class ChildViewController: UIViewController { }
        
        let viewController = ChildViewController()
        viewController.title = "Child"
        
        return viewController
    }()
    
    private let customView = View()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DEMO - viewDidLoad")
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("DEMO - viewWillAppear")
        
        makeNetworkRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("DEMO - viewDidAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.addSubview(customView)
    }
    
    // MARK: - Test
    
    private func testChildViewController() {
        addChild(childViewController)
        
        childViewController.view.frame = .zero
        view.addSubview(childViewController.view)
        
        childViewController.didMove(toParent: self)
    }
    
    private func testViewController() {
        class PushViewController: UIViewController { }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let viewController = PushViewController()
            viewController.view.backgroundColor = .lightGray
            viewController.title = "Push \(type(of: viewController))"
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - Network request
    
    // Validating how this would work in a normal app that display a table and does a request
    // afterward refreshes the view
    private func makeNetworkRequest() {
        let url = URL(string: "https://google.com")!
        let session = URLSession(
            configuration: .ephemeral,
            delegate: self,
            delegateQueue: nil
        )
        let task = session.dataTask(with: url) { [weak self] _, _, _ in
            print("DEMO - made network request")
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        print("DEMO - making network request for \(task)")
        
        task.resume()
    }
}

extension ViewController: URLSessionTaskDelegate {

    // MARK: - URLSessionTaskDelegate
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print("DEMO - did finish collecting metrics delegate method called")
    }
}
