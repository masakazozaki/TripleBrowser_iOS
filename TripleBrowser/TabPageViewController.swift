//
//  TabPageViewController.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2018/05/13.
//  Copyright © 2018 Masakaz Ozaki. All rights reserved.
//

import UIKit
// import TabPageViewController

struct PageSettings{
    static let pageViewControllerIdentifierList: [String] = [
        "FirstViewController",
        "SecondViewController",
        "ThirdViewController",
        ]
    
    static func generateViewControllerList() -> [UIViewController] {
        var viewControllers : [UIViewController] = []
        self.pageViewControllerIdentifierList.forEach{ viewControllerName in
            
            let viewController = UIStoryboard(name: "Main", bundle: nil) . instantiateViewController(withIdentifier: "\(viewControllerName)")
            
            viewControllers.append(viewController)
            
        }
        return viewControllers
    }
}


class TabPageViewController: TabPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabPageViewController = TabPageViewController.create()
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        let vc3 = UIViewController()
        
        tabPageViewController.tabItems = [(vc1, "First"), (vc2, "Second"), (vc3, Third)]
        
        TabPageOption.currentColor = UIColor.redColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
