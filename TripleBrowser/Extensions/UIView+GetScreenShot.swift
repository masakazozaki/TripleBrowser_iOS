//
//  UIView+GetScreenShot.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2019/09/23.
//  Copyright © 2019 Masakaz Ozaki. All rights reserved.
//

import UIKit

extension UIView {
    func getScreenShot(windowFrame: CGRect, adFrame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(windowFrame.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        layer.render(in: context)
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImage
    }
}
