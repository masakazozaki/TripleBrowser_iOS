//
//  ThirdViewController.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2018/04/21.
//  Copyright © 2018 Masakaz Ozaki. All rights reserved.
//

import UIKit
import WebKit

class ThirdViewController: UIViewController, WKNavigationDelegate, UISearchBarDelegate {
    
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
        self.progressView.progressTintColor = UIColor(red:0.00,green:150 / 255 ,blue:136 / 255,alpha:1.0)
        self.navigationController?.navigationBar.addSubview(self.progressView)
        
        // KVO 監視
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        
        //barButtonItemを表示
        let items = [
            UIBarButtonItem(barButtonHiddenItem: .Back, target: self, action: #selector(backButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonHiddenItem: .Forward, target: self, action: #selector(forwardButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(actionButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            
        ]
        
        items[1].width = 60
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.setToolbarItems(items, animated: false)
        
        
    }
    
    @objc func backButtonTapped(){
        if self.webView.canGoBack{
            self.webView.goBack()
        }
    }
    
    @objc func forwardButtonTapped(){
        if self.webView.canGoForward{
            self.webView.goForward()
        }
    }
    
    @objc func actionButtonTapped(){
        // 共有する項目
        let shareText = self.webView?.title!
        let shareWebsite = self.webView?.url!
        let shareImage = self.view.getScreenShot(windowFrame: self.view.frame, adFrame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        let activityItems = [shareText, shareWebsite, shareImage] as [Any]
        
        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        
        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)
    }
    
    deinit {
        self.webView?.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
        self.webView?.removeObserver(self, forKeyPath: "loading", context: nil)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "estimatedProgress") {
            // alphaを1にする(表示)
            self.progressView.alpha = 1.0
            // estimatedProgressが変更されたときにプログレスバーの値を変更
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
            
            // estimatedProgressが1.0になったらアニメーションを使って非表示にしアニメーション完了時0.0をセットする
            if (self.webView.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.9,
                               delay: 0.6,
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.hasPrefix("http") {
            let url = URL(string: searchText)
            let urlRequest = URLRequest(url: url!)
            self.webView.load(urlRequest)

        } else if searchText.hasPrefix("www") {
            
            let urlp: String = "https://" + searchText
            let url = URL(string: urlp)
            let urlRequest = URLRequest(url: url!)
            self.webView.load(urlRequest)
            
        } else  if searchText.hasSuffix("com") {
            let url = URL(string: searchText)
            let urlRequest = URLRequest(url: url!)
            self.webView.load(urlRequest)
        } else  if searchText.hasSuffix("jp") {
            let url = URL(string: searchText)
            let urlRequest = URLRequest(url: url!)
            self.webView.load(urlRequest)
        }else {
            
            let url: URL!
            let percent = urlEncording(str: searchText)
            let urlp: String = "https://www.google.co.jp/search?q=" + percent
            url = URL(string: urlp)
            let urlRequest = URLRequest(url: url!)
            self.webView.load(urlRequest)
        }

    }
    
    //searchabarでreturnキーを押したときにキーボードを閉じる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         searchBar.resignFirstResponder()
    }
    
    //URLのパーセントエンコーディング
    func urlEncording(str: String) -> String {
        let characterSetTobeAllowed = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        if let encodedURLString = str.addingPercentEncoding(withAllowedCharacters: characterSetTobeAllowed) {
            return encodedURLString
        }
        return str
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

