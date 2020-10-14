//
//  AudioViewController.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 09/10/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import UIKit
import AVKit

final class Box: UIView {
    
    // MARK: - Property
    
    private var lastLocation: CGPoint = .zero
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let gesture = UIPanGestureRecognizer(target: self, action:#selector(didTapBoxAction(_:)))
        let blue = CGFloat.random(in: 0 ..< 1)
        let green = CGFloat.random(in: 0 ..< 1)
        let red = CGFloat.random(in: 0 ..< 1)
        
        addGestureRecognizer(gesture)
        
        backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.8)
    }
    
    // MARK: - Action
    
    @objc
    func didTapBoxAction(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: superview)
        
        center = CGPoint(
            x: lastLocation.x + translation.x,
            y: lastLocation.y + translation.y
        )
    }
    
    // MARK: - Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        superview?.bringSubviewToFront(self)

        lastLocation = center
    }
}

final class AudioViewController: UIViewController {
    
    // MARK: - Property
    
    var player: AVPlayer!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupUI()
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
        // TODO: Change branch to main
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
    
    private func setupUI() {
        let size = 50
        let height = Int(view.bounds.height)
        let width = Int(view.bounds.width)
        let numberOfBoxes = 25

        for _ in 0 ..< numberOfBoxes {
            let pointX = Int.random(in: 0 ..< width - size)
            let pointY = Int.random(in: size ..< height  - size)
            let frame = CGRect(x: pointX, y: pointY, width: size, height: size)
            let box = Box(frame: frame)
            
            view.addSubview(box)
        }
    }
}
