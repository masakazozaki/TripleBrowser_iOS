//
//  TBNavigationBarView.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2019/09/04.
//  Copyright © 2019 Masakaz Ozaki. All rights reserved.
//

import UIKit

protocol TBNavigationBarDelegate: class {
    func searchBarShouldReturn()
    func swipeAreaSwiped()
    func plusButtonPressed()
    func panMenu(pointY: CGFloat)
    func finishPanMenu()
}

@IBDesignable
class TBNavigationBarView: UIView {
    var isSearchBarSmall = true
    var view: UIView! {
        didSet {
            view.layer.cornerRadius = 20
            view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            view.layer.masksToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    var userTouchY = 0

    weak var delegate: TBNavigationBarDelegate?
    @IBOutlet public weak var searchBar: UITextField! {
        didSet {
            let searchBarLeftImageView = UIImageView()
            searchBarLeftImageView.image = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
            searchBarLeftImageView.frame = CGRect(x: 0, y: 0, width: searchBar.frame.width, height: searchBar.frame.height)
            searchBar.leftView = searchBarLeftImageView
            searchBar.leftViewMode = .unlessEditing
        }
    }
    @IBOutlet private weak var searchBarbackgroundView: UIView! {
        didSet {
            searchBarbackgroundView.roundCorner()
            searchBarbackgroundView.layer.shadowColor = UIColor.black.cgColor
            searchBarbackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
            searchBarbackgroundView.layer.shadowRadius = 20
        }
    }

    @IBOutlet private weak var swipeAreaView: UIView! {
        didSet {
            swipeAreaView.roundCorner()
        }
    }

    @IBOutlet private weak var swipeAreaImageView: UIImageView! {
        didSet {
            swipeAreaImageView.image = UIImage(named: "swipeAreaArrow")?.withRenderingMode(.alwaysTemplate)
        }
    }

    @IBOutlet private weak var plusButton: UIButton! {
        didSet {
            plusButton.roundCorner()
            plusButton.setImage(UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }

    @IBOutlet private weak var menuBarImageView: UIImageView! {
        didSet {
             menuBarImageView.image = UIImage(named: "horizontalBar")?.withRenderingMode(.alwaysTemplate)
        }
    }
    @IBOutlet public weak var progressBar: UIProgressView!
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
        NSLayoutConstraint.activate([
            view!.topAnchor.constraint(equalTo: topAnchor),
            view!.leadingAnchor.constraint(equalTo: leadingAnchor),
            view!.trailingAnchor.constraint(equalTo: trailingAnchor),
            view!.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        searchBar.delegate = self
    }

    private func expandSearchBarSize() {
        NSLayoutConstraint.deactivate(searchBarSmallConstraints)
        NSLayoutConstraint.activate(searchBarLargeConstraints)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.searchBarbackgroundView.layer.shadowOpacity = 0.3
            self.plusButton.isHidden = true
            self.swipeAreaView.isHidden = true
            self.layoutIfNeeded()
        }, completion: nil)
        isSearchBarSmall = false
    }

    private func shortenSearchBarSize() {
        NSLayoutConstraint.deactivate(searchBarLargeConstraints)
        NSLayoutConstraint.activate(searchBarSmallConstraints)
        searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.searchBarbackgroundView.layer.shadowOpacity = 0
            self.layoutIfNeeded()
        }, completion: { _ in
            self.plusButton.isHidden = false
            self.swipeAreaView.isHidden = false
        })
        isSearchBarSmall = true
    }

    public func closeSearchBar() {
        shortenSearchBarSize()
        print("closesearchBar")
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
        delegate?.plusButtonPressed()
    }

    @IBAction func swipeAreaLeftSwiped() {
        delegate?.swipeAreaSwiped()
    }

    @IBAction func swipeAreaRightSwiped() {
        delegate?.swipeAreaSwiped()
    }

    @IBOutlet private var panGesture: UIPanGestureRecognizer!
    var currentPointY: CGFloat = 0.0
    @IBAction func panMenuDraged(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            currentPointY = 0.0
        case .changed:
            let point = sender.translation(in: self)
                   print(sender.velocity(in: self))
                   delegate?.panMenu(pointY: currentPointY - point.y)
                   print(currentPointY - point.y)
                   currentPointY = point.y
        case .ended:
            delegate?.finishPanMenu()
        default:
            break
        }
    }

    @IBAction func panFinished() {

    }

    @IBAction func menuImagePressed() {
        print("menuTapped")
    }
}

extension TBNavigationBarView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        shortenSearchBarSize()
        delegate?.searchBarShouldReturn()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        expandSearchBarSize()
        return true
    }
}
