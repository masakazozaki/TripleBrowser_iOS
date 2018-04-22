//
//  PageViewController.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2018/04/21.
//  Copyright © 2018 Masakaz Ozaki. All rights reserved.
//

import UIKit

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

class PageViewController: UIPageViewController {
    var viewControllerIndex: Int = 0 {
        didSet{
            print(viewControllerIndex)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewControllers([PageSettings.generateViewControllerList().first!], direction: .forward, animated: true, completion: nil)
        self.dataSource = self as UIPageViewControllerDataSource

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
extension PageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //現在のビューコントローラーのインデックス番号を取得する。
        let index = PageSettings.pageViewControllerIdentifierList.index(of: viewController.restorationIdentifier!)!
        if (index > 0) {
            //前ページのビューコントローラーを返す。
            return storyboard!.instantiateViewController(withIdentifier: PageSettings.pageViewControllerIdentifierList[index-1])
        } else{
            return storyboard!.instantiateViewController(withIdentifier: PageSettings.pageViewControllerIdentifierList[index+2])
        }
    }
    
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //現在のビューコントローラーのインデックス番号を取得する。
        let index = PageSettings.pageViewControllerIdentifierList.index(of: viewController.restorationIdentifier!)!
        if (index < PageSettings.pageViewControllerIdentifierList.count-1) {
            //次ページのビューコントローラーを返す。
            return storyboard!.instantiateViewController(withIdentifier: PageSettings.pageViewControllerIdentifierList[index+1])
        } else {
            return storyboard!.instantiateViewController(withIdentifier: PageSettings.pageViewControllerIdentifierList[index-2])
        }
    }
    
    
}



