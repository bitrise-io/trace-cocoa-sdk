//
//  CollectionViewController.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 23/07/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit

final class CollectionViewController: UICollectionViewController {
    
    // MARK: - Init
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
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
    }
    
    // MARK: - Setup
    
    private func setup() {
        let identifier = "CollectionViewCell"
        let nib = UINib(nibName: identifier, bundle: .main)
        
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5000
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionViewCell",
            for: indexPath
        )
        let color: UIColor
        
        switch (0...5).randomElement() {
        case 0: color = .blue
        case 1: color = .orange
        case 2: color = .green
        case 3: color = .red
        case 4: color = .magenta
        case 5: color = .systemYellow
        default: color = .blue
        }
    
        cell.backgroundColor = color
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: UICollectionViewCell! = collectionView.cellForItem(at: indexPath)
        let color: UIColor
            
        switch (0...5).randomElement() {
        case 0: color = .brown
        case 1: color = .systemTeal
        case 2: color = .systemPink
        case 3: color = .systemYellow
        case 4: color = .magenta
        case 5: color = .cyan
        default: color = .white
        }
    
        cell.backgroundColor = color
    }
}
