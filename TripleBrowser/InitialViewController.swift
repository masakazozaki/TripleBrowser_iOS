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
            themeColor = UIColor(named: "TBSystemBlue") ?? .blue
		case "page2":
            themeColor = UIColor(named: "TBSystemPink") ?? .red
		case "page3":
            themeColor = UIColor(named: "TBSystemGreen") ?? .green
		default:
			return
		}
        let destination = segue.destination as? FirstViewController
        destination?.themeColor = themeColor
        destination?.navigationController?.navigationBar.backgroundColor = themeColor
    }
}
