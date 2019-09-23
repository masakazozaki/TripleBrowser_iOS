//
//  TBTabBarView.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2019/09/03.
//  Copyright © 2019 Masakaz Ozaki. All rights reserved.
//

import UIKit

protocol TBTabBarViewDelegate: class {
    func tabBarLeftButtonPressed()
    func tabBarRightButtonPressed()
    func tabBarDownButtonPressed()
    func tabBarCameraButtonPressed()
}

@IBDesignable
class TBTabBarView: UIView {
    var view: UIView?
    weak var delegate: TBTabBarViewDelegate?
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var leftArrowButon: UIButton!
    @IBOutlet private weak var rightArrowButon: UIButton!
    @IBOutlet private weak var downArrowButon: UIButton!
    @IBOutlet private weak var cameraButon: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        instatinateFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instatinateFromNib()
    }

    func instatinateFromNib() {
        view = Bundle(for: type(of: self)).loadNibNamed("TBTabBarView", owner: self, options: nil)!.first as? UIView
        addSubview(view!)
        view!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view!.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            view!.leadingAnchor.constraint(equalTo: leadingAnchor),
            view!.trailingAnchor.constraint(equalTo: trailingAnchor),
            view!.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        view!.layer.cornerRadius = 23
        view!.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view!.layer.masksToBounds = true
    }

    @IBAction func leftArrowButtonPressed() {
        delegate?.tabBarLeftButtonPressed()
    }

    @IBAction func rightArrowButtonPressed() {
        delegate?.tabBarRightButtonPressed()
    }

    @IBAction func downArrowButtonPressed() {
        delegate?.tabBarDownButtonPressed()
    }

    @IBAction func cameraButtonPressed() {
        delegate?.tabBarCameraButtonPressed()
    }
}
