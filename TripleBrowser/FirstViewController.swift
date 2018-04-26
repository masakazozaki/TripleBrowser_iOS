//
//  FirstViewController.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2018/04/21.
//  Copyright © 2018 Masakaz Ozaki. All rights reserved.
//

import UIKit
import WebKit



class FirstViewController: UIViewController, WKNavigationDelegate, UISearchBarDelegate {
    
    
    var searchBar: UISearchBar!
    //    var webView: WKWebView!
    let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    @IBOutlet var webView: WKWebView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        //        self.webView = WKWebView(frame: self.view.frame, configuration: config)
        self.webView.navigationDelegate = self
        self.webView.allowsLinkPreview = true
        
        let url = URL(string: "https://www.google.co.jp/")
        let urlRequest = URLRequest(url: url!)
        
        self.webView.load(urlRequest)
        
        //        self.view.insertSubview(self.webView, at: 0)
        
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        //        // 上辺の制約
        //        self.webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44.0 + statusBarHeight).isActive = true
        //        // 下辺の制約
        //        self.webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        //        // 左辺の制約
        //        self.webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        //        // 右辺の制約
        //        self.webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
     
        //searchBarの表示
        setupSearchBar()
        //toolBarに隠しボタン

        let items = [
            UIBarButtonItem(barButtonHiddenItem: .Back, target: nil, action: nil),
            UIBarButtonItem(barButtonHiddenItem: .Forward, target: nil, action: nil),
            UIBarButtonItem(barButtonHiddenItem: .Up, target: nil, action: nil),
            UIBarButtonItem(barButtonHiddenItem: .Down, target: nil, action: nil)
        ]
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.setToolbarItems(items, animated: false)
        
    }
    
    
    private func setupSearchBar(){
        let searchBar: UISearchBar = UISearchBar(frame: (self.navigationController?.navigationBar.frame)!)
            
            searchBar.delegate = self
            searchBar.placeholder = "Search"
            searchBar.showsCancelButton = false
            searchBar.autocapitalizationType = .none
            searchBar.keyboardType = UIKeyboardType.URL
            self.navigationItem.titleView = searchBar
            self.navigationItem.titleView?.frame = searchBar.frame
            searchBar.becomeFirstResponder()
        
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
extension UIBarButtonItem {
    enum HiddenItem: Int {
        case Arrow = 100
        case Back = 101
        case Forward = 102
        case Up = 103
        case Down = 104
    }
    
    convenience init(barButtonHiddenItem: HiddenItem, target: AnyObject?, action: Selector?) {
        let systemItem = UIBarButtonSystemItem(rawValue: barButtonHiddenItem.rawValue)
        self.init(barButtonSystemItem: systemItem!, target: target, action: action)
    }
}


