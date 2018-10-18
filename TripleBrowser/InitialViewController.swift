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

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let themeColor:UIColor
		switch segue.identifier{
		case "page1":
			themeColor = UIColor(red: 54/255, green: 142/255, blue: 235/255, alpha: 1)
			break
		case "page2":
			themeColor = UIColor(red: 1, green: 90/255, blue: 137/255, alpha: 1)
			break
		case "page3":
			themeColor = UIColor(red: 100/255, green: 224/255, blue: 96/255, alpha: 1)
			break
		default:
			themeColor = UIColor.black
			break
		}
		(segue.destination.children.first as! FirstViewController).progressBarColor = themeColor
		(segue.destination.children.first as! FirstViewController).navigationController!.navigationBar.backgroundColor = themeColor
    }


}
