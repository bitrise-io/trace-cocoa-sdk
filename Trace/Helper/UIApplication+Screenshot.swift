//
//  UIApplication+Screenshot.swift
//  Trace
//
//  Created by Shams Ahmed on 15/11/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit

/// Helper to capture app screenshots
extension UIApplication {

    // MARK: - Screenshot
    
    /**
     Take screenshot of current window, to test use:
     ```
        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
     ```
    */
    var screenshot: UIImage? {
        let keyWindow = windows.first(where: { $0.isKeyWindow })

        guard let layer = keyWindow?.layer else { return nil }
        
        var screenshot: UIImage?
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        layer.render(in: context)
        screenshot = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return screenshot
    }
}
