//
//  AudioViewController.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 09/10/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import UIKit
import AVKit

final class AudioViewController: UIViewController {
    
    // MARK: - Property
    
    var player: AVPlayer!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        // 10mb sound file
        let url: URL! = URL(string: "https://raw.githubusercontent.com/bitrise-io/trace-cocoa-sdk/mediaDemo/assets/file_example_WAV_10MG.wav")
        
        // 40mb sound file - warning it's sound
//        let url: URL! = URL(string: "http://mirrors.standaloneinstaller.com/audio-sample/wma/out.flac")
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback)
            try session.setActive(true)

            player = AVPlayer(url: url)
            player.automaticallyWaitsToMinimizeStalling = false
        } catch {
            print(error)
        }
    }
}
