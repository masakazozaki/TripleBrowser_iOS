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
        }
    }

    @IBOutlet private weak var menuBarImageView: UIImageView! {
        didSet {
             menuBarImageView.image = UIImage(named: "horizontalBar")?.withRenderingMode(.alwaysTemplate)
            //TODO: history tabelview not implemented
            menuBarImageView.isHidden = true
        }
    }
    @IBOutlet public weak var progressBar: UIProgressView!

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
}

extension TBNavigationBarView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        shortenSearchBarSize()
        delegate?.searchBarShouldReturn()
        return true
    }
}
