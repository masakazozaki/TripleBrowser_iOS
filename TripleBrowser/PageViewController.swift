//
//  PageViewController.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2018/04/21.
//  Copyright © 2018 Masakaz Ozaki. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var generateViewController: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0 ..< 3
        {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController")
            let fvc = vc.children.first as! FirstViewController
            fvc.pageNum = i
            let themeColor:UIColor
            switch i{
            case 0:
                themeColor = UIColor(red: 54/255, green: 142/255, blue: 235/255, alpha: 1)
                break
            case 1:
                themeColor = UIColor(red: 1, green: 90/255, blue: 137/255, alpha: 1)
                break
            case 2:
                themeColor = UIColor(red: 100/255, green: 224/255, blue: 96/255, alpha: 1)
                break
            default:
                themeColor = UIColor.black
                break
            }
            fvc.progressBarColor = themeColor
            fvc.navigationController!.navigationBar.backgroundColor = themeColor
            generateViewController.append(vc)
        }
        
       //VCの生成
        setViewControllers([generateViewController[1]], direction: .forward, animated: true, completion: nil)
        dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //現在のビューコントローラーのインデックス番号を取得する。
        let index = (viewController.children.first as! FirstViewController).pageNum
        if (index > 0) {
            return generateViewController[index-1]
        } else{
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        //現在のビューコントローラーのインデックス番号を取得する。
        let index = (viewController.children.first as! FirstViewController).pageNum
        if (index < 3 - 1) {
            return generateViewController[index+1]
        } else {
            return nil
        }
    }

}



