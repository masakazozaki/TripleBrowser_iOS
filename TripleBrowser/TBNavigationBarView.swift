//
//  TBNavigationBarView.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2019/09/04.
//  Copyright © 2019 Masakaz Ozaki. All rights reserved.
//

import UIKit

class TBNavigationBarView: UIView {
    var view: UIView!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var swipeAreaView: UIView!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var menuBarImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        instatinateFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instatinateFromNib()
    }

    func instatinateFromNib() {
        view = Bundle(for: type(of: self)).loadNibNamed("TBNavigationBarView", owner: self, options: nil)!.first as? UIView
        addSubview(view!)
        view!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view!.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            view!.leadingAnchor.constraint(equalTo: leadingAnchor),
            view!.trailingAnchor.constraint(equalTo: trailingAnchor),
            view!.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        cornerRadius(view: searchButton)
        cornerRadius(view: swipeAreaView)
        cornerRadius(view: plusButton)
        view!.layer.cornerRadius = 20
        view!.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view!.layer.masksToBounds = true
    }

    private func cornerRadius<T: UIView>(view: T) {
        view.layer.cornerRadius = view.frame.height / 2
    }
    
    @IBAction func searchButtonPressed() {
        
    }
    
    @IBAction func plusButtonPressed() {
        
    }
    
    @IBAction func swipeAreaLeftSwiped() {
        
    }
    
    @IBAction func swipeAreaRightSwiped() {
        
    }
}
