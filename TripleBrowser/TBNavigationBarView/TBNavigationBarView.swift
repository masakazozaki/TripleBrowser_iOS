//
//  TBNavigationBarView.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2019/09/04.
//  Copyright © 2019 Masakaz Ozaki. All rights reserved.
//

import UIKit

@IBDesignable
class TBNavigationBarView: UIView {
    var isSearchBarSmall = true
    var view: UIView!
    var searchBarLeftImageView = UIImageView()
    @IBOutlet private weak var searchBar: UITextField!
    @IBOutlet private weak var searchBarbackgroundView: UIView!
    @IBOutlet private weak var swipeAreaView: UIView!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var menuBarImageView: UIImageView!
    @IBOutlet private var searchBarSmallConstraints: [NSLayoutConstraint]!
    @IBOutlet private var searchBarLargeConstraints: [NSLayoutConstraint]!

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
            view!.topAnchor.constraint(equalTo: topAnchor),
            view!.leadingAnchor.constraint(equalTo: leadingAnchor),
            view!.trailingAnchor.constraint(equalTo: trailingAnchor),
            view!.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        cornerRadius(view: searchBarbackgroundView)
        cornerRadius(view: swipeAreaView)
        cornerRadius(view: plusButton)
        searchBar.delegate = self
        searchBarLeftImageView.image = UIImage(named: "search")
        searchBarLeftImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        searchBar.leftView = searchBarLeftImageView
        searchBar.leftViewMode = .unlessEditing
        searchBarbackgroundView.layer.shadowColor = UIColor.black.cgColor
        searchBarbackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        searchBarbackgroundView.layer.shadowRadius = 20
        view!.layer.cornerRadius = 20
        view!.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view!.layer.masksToBounds = true
    }

    private func cornerRadius<T: UIView>(view: T) {
        view.layer.cornerRadius = view.frame.height / 2
    }

    private func expandSearchBarSize() {
        NSLayoutConstraint.deactivate(searchBarSmallConstraints)
        NSLayoutConstraint.activate(searchBarLargeConstraints)
        searchBarbackgroundView.layer.shadowOpacity = 0.3
        UIView.animate(withDuration: 0.3, delay:0, options: .curveEaseOut, animations: { self.layoutIfNeeded() }, completion: nil)
        isSearchBarSmall = false
    }

    private func shortenSearchBarSize() {
        NSLayoutConstraint.deactivate(searchBarLargeConstraints)
        NSLayoutConstraint.activate(searchBarSmallConstraints)
        searchBarbackgroundView.layer.shadowOpacity = 0
        searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.3, delay:0, options: .curveEaseOut, animations: { self.layoutIfNeeded()}, completion: nil)
        isSearchBarSmall = true
    }

    @IBAction func searchButtonPressed() {
        print("search")
        if isSearchBarSmall {
            expandSearchBarSize()
        } else {
            shortenSearchBarSize()
        }
        isSearchBarSmall.toggle()
    }

    @IBAction func plusButtonPressed() {
        print("plus")
    }

    @IBAction func swipeAreaLeftSwiped() {
        print("leftswipe")
    }

    @IBAction func swipeAreaRightSwiped() {
        print("rightswipe")
    }
}

extension TBNavigationBarView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        shortenSearchBarSize()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        expandSearchBarSize()
        return true
    }
}

extension TBNavigationBarView: SearchBarCloseDelegate {
    func closeSearchBar() {
        shortenSearchBarSize()
    }
    
}