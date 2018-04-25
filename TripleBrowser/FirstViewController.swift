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
    var webView: WKWebView!
    let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    @IBOutlet var navigationBar: UINavigationBar!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        self.webView = WKWebView(frame: self.view.frame, configuration: config)
        self.webView.navigationDelegate = self
        
        self.webView.allowsLinkPreview = true
        
        let url = URL(string: "https://www.google.co.jp/")
        let urlRequest = URLRequest(url: url!)
        
        self.webView.load(urlRequest)
        
        self.view.addSubview(self.webView)
        
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        // 上辺の制約
        self.webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44.0 + statusBarHeight).isActive = true
        // 下辺の制約
        self.webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        // 左辺の制約
        self.webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        // 右辺の制約
        self.webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        
        
        //searchBar起動
        
    }
    
    private func setupSearchBar(){
        if let navigationBarFrame = navigationController?.navigationBar.bounds{
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            
            searchBar.delegate = self
            searchBar.placeholder = "Search"
            searchBar.showsCancelButton = true
//            searchBar.autocapitalizationType = UITextAutocorrectionType.none
            searchBar.keyboardType = UIKeyboardType.URL
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
            searchBar.becomeFirstResponder()
            
            
            
        }
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
