//
//  PageViewController.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2018/04/21.
//  Copyright © 2018 Masakaz Ozaki. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    private let feedbackGenerator: Any? = {
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            return generator
        } else {
            return nil
        }
    }()

    var generateViewController: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0 ..< 3
        {
            let vc = UIStoryboard(name: "Main", bundle: nil) . instantiateViewController(withIdentifier: "FirstViewController")
            let fvc = vc.childViewControllers.first as! FirstViewController
            fvc.pageNum = i
            let themeColor:UIColor
            switch i{
            case 0:
                themeColor = UIColor.blue
                break
            case 1:
                themeColor = UIColor.red
                break
            case 2:
                themeColor = UIColor.green
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //現在のビューコントローラーのインデックス番号を取得する。
        let index = (viewController.childViewControllers.first as! FirstViewController).pageNum
        if (index > 0) {
            return generateViewController[index-1]
        } else{
            return nil
        }
    }
    
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        //現在のビューコントローラーのインデックス番号を取得する。
        let index = (viewController.childViewControllers.first as! FirstViewController).pageNum
        if (index < 3 - 1) {
            return generateViewController[index+1]
        } else {
            return nil
        }
    }

}



