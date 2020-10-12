//
//  VideoViewController.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 09/10/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import UIKit
import AVKit

final class VideoViewController: UIViewController {
    
    // MARK: - Property
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerLayer.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        player.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        player.pause()
    }
    
    // MARK: - Setup
    
    private func setup() {
        // TODO: Change branch to main
        let url: URL! = URL(string: "https://raw.githubusercontent.com/bitrise-io/trace-cocoa-sdk/mediaDemo/assets/file_example_MP4_1920_18MG.mp4")
        
        player = AVPlayer(url: url)
        player.automaticallyWaitsToMinimizeStalling = false
        
        playerLayer = AVPlayerLayer(player: player)
        
        view.layer.addSublayer(playerLayer)
    }
}
