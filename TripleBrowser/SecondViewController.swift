//
//  SecondViewController.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2018/04/21.
//  Copyright © 2018 Masakaz Ozaki. All rights reserved.
//

import UIKit
import WebKit

class SecondViewController: UIViewController, WKNavigationDelegate, UISearchBarDelegate {
    
    var webView: WKWebView!
    var searchBar: UISearchBar!
    
    var progressView = UIProgressView()
    
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
        
        //searchBarを表示
        setupSearchBar()
        
        //progressView関連
        self.progressView = UIProgressView(frame: CGRect(x: 0.0, y: (self.navigationController?.navigationBar.frame.size.height)! + 10, width: self.view.frame.size.width, height: 3.0))
        self.progressView.progressViewStyle = .bar
        self.navigationController?.navigationBar.addSubview(self.progressView)
        
        // KVO 監視
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        
        //barButtonItemを表示
        let items = [
            UIBarButtonItem(barButtonHiddenItem: .Back, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonHiddenItem: .Forward, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            
        ]
        
        items[1].width = 60
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.setToolbarItems(items, animated: false)
        
    }

    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
        self.webView.removeObserver(self, forKeyPath: "loading", context: nil)
    }
    
 
    
    /// 監視しているWKWebViewのestimatedProgressの値をUIProgressViewに反映
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // ここでUIProgressViewに値を入れるコードを書く
        
        if (keyPath == "estimatedProgress") {
            // estimatedProgressが変更されたときにプログレスバーの値を変更
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
        } else if (keyPath == "loading") {
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.webView.isLoading
            if (self.webView.isLoading) {
                self.progressView.setProgress(0.1, animated: true)
            }else{
                // 読み込みが終わったら0.0をセット
                self.progressView.setProgress(0.0, animated: false)
            }
        }
        
    }
    //SeatchBar関連 -> ViewDidLoadで読まれる
    private func setupSearchBar(){
        let searchBar: UISearchBar = UISearchBar(frame: (self.navigationController?.navigationBar.frame)!)
        
        searchBar.delegate = self
        searchBar.placeholder = "Search or enter website name"
        searchBar.showsCancelButton = false
        searchBar.autocapitalizationType = .none
        searchBar.keyboardType = UIKeyboardType.default
        //        searchBar.showsBookmarkButton = true
        //        searchBar.setImage(UIImage(named: "reload"), for: .bookmark, state: .normal)
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
