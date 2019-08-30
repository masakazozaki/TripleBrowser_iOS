//
//  InitialViewController.swift
//  TripleBrowser
//
//  Created by YujiSasaki on 2018/10/18.
//  Copyright © 2018 Masakaz Ozaki. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let themeColor: UIColor
		switch segue.identifier {
		case "page1":
			themeColor = UIColor(red: 54 / 255, green: 142 / 255, blue: 235 / 255, alpha: 1)
		case "page2":
			themeColor = UIColor(red: 1, green: 90 / 255, blue: 137 / 255, alpha: 1)
		case "page3":
			themeColor = UIColor(red: 100 / 255, green: 224 / 255, blue: 96 / 255, alpha: 1)
		default:
			return
		}
        let destination = segue.destination.children.first as? FirstViewController
        destination?.progressBarColor = themeColor
        destination?.navigationController?.navigationBar.backgroundColor = themeColor
    }
}
