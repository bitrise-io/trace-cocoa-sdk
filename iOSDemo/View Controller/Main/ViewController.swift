//
//  ViewController.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import UIKit
import SafariServices

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
    
    override func loadView() {
        super.loadView()
    }
    
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        
        let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        
        print("DEMO - Document directory: \(path)")
    }
    
    // MARK: - Navigation
    
    private func navigateToSafari() {
        let url: URL! = URL(string: "https://github.com")
        let viewController = SFSafariViewController(url: url)
        
        navigationController?.present(viewController, animated: true)
    }
    
    private func navigateToNibViewController() {
        let nibViewController = UINib(nibName: "NibViewController", bundle: .main)
        let viewController = nibViewController.instantiate(withOwner: self, options: nil)[0] as! UIViewController
        let nibView = UINib(nibName: "NibView", bundle: .main)
        let view = nibView.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        viewController.view = view
        
        show(viewController, sender: nil)
    }
    
    private func navigateUsingShow() {
        let viewController = UIViewController()
        viewController.title = "Navigate using Show"
        viewController.view.backgroundColor = .systemYellow
        
        show(viewController, sender: nil)
    }
    
    private func navigateUsingShowDetail() {
        let viewController = UIViewController()
        viewController.title = "Navigate using Show Detail"
        viewController.view.backgroundColor = .systemTeal
        
        showDetailViewController(viewController, sender: nil)
    }
    
    private func navigateUsingPresent() {
        let url: URL! = URL(string: "https://github.com")
        let viewController = SFSafariViewController(url: url)
        
        present(viewController, animated: true)
    }
    
    private func navigateUsingPopover() {
        fatalError("Unimplemented")
    }
    
    private func navigateUsingCustom() {
        fatalError("Unimplemented")
    }
    
    private func navigateUsingSegue() {
        performSegue(withIdentifier: String(describing: SegueViewController.self), sender: nil)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 7: navigateToSafari()
        case 8: navigateUsingShow()
        case 9: navigateUsingShowDetail()
        case 10: navigateUsingPresent()
        case 11: navigateUsingPopover()
        case 12: navigateUsingCustom()
        case 13: navigateUsingSegue()
        case 14: navigateToNibViewController()
        default: break
        }
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
        let url = URL(string: "https://google.co.uk")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        let session = URLSession(
            configuration: .ephemeral,
            delegate: self,
            delegateQueue: nil
        )
        let task = session.dataTask(with: request) { [weak self] _, _, _ in
            print("DEMO - network request completed")
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        task.resume()
    }
}

extension ViewController: URLSessionTaskDelegate {

    // MARK: - URLSessionTaskDelegate
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print("DEMO - did finish collecting metrics delegate method called")
    }
}
