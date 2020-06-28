//
//  UIView+RoundedCorner.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2019/10/28.
//  Copyright © 2019 Masakaz Ozaki. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /// makeing circle corner
    open func roundCorner() {
        layer.cornerRadius = frame.height / 2
    }
}
