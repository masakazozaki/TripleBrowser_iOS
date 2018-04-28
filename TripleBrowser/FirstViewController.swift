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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "estimatedProgress") {
            // alphaを1にする(表示)
            self.progressView.alpha = 1.0
            // estimatedProgressが変更されたときにプログレスバーの値を変更
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
            
            // estimatedProgressが1.0になったらアニメーションを使って非表示にしアニメーション完了時0.0をセットする
            if (self.webView.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.3,
                               delay: 0.3,
                               options: [.curveEaseOut],
                               animations: { [weak self] in
                                self?.progressView.alpha = 0.0
                    }, completion: {
                        (finished : Bool) in
                        self.progressView.setProgress(0.0, animated: false)
                })
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


