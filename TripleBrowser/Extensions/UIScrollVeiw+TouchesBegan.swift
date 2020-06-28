//
//  UIScrollVeiw+TouchesBegan.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2019/09/23.
//  Copyright © 2019 Masakaz Ozaki. All rights reserved.
//

import UIKit
import WebKit

extension UIScrollView {
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.next?.touchesBegan(touches, with: event)
    }
}
