//
//  FirstViewController.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2018/04/21.
//  Copyright © 2018 Masakaz Ozaki. All rights reserved.
//

import UIKit
import WebKit
import Accounts



class FirstViewController: UIViewController, WKNavigationDelegate, UISearchBarDelegate, UINavigationControllerDelegate, WKUIDelegate {
    
    var progressBarColor: UIColor = UIColor.blue
    
    private let feedbackGenerator: Any? = {
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            return generator
        } else {
            return nil
        }
    }()
    
    var searchBar: UISearchBar!
    var webView: WKWebView!
    var progressView = UIProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view
        setWebView()
        //searchBarを表示
        setupSearchBar()
        //progressView関連
        progressView = UIProgressView(frame: CGRect(x: 0.0, y: (navigationController?.navigationBar.frame.size.height)! + 10, width: view.frame.size.width, height: 3.0))
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = progressBarColor
        navigationController?.navigationBar.addSubview(progressView)
        
        // KVO 監視
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        
        let items = [
            UIBarButtonItem(barButtonHiddenItem: .Back, target: self, action: #selector(backButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonHiddenItem: .Forward, target: self, action: #selector(forwardButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(actionButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(screenShotButtonTapped)),
            ]
        
        items[1].width = 60
        
        navigationController?.setToolbarHidden(false, animated: false)
        setToolbarItems(items, animated: false)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        NotificationCenter.default.addObserver(self, selector: #selector(rotationChange(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
//    }
//
//    @objc func rotationChange(notification: NSNotification) {
//        webView.frame = view.frame
//    }
    
    func setWebView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: view.frame, configuration: config)
        webView.navigationDelegate = self
        webView.allowsLinkPreview = true
        
        
        let url = URL(string: "https://www.google.co.jp/")
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //戻るボタン
    @objc func backButtonTapped() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    //進むボタン
    @objc func forwardButtonTapped() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    //共有ボタン
    @objc func actionButtonTapped() {
        
        // 共有する項目
        let shareText: String = webView!.title!
        let shareWebsite: URL = webView!.url!
        let shareImage: UIImage = view.getScreenShot(windowFrame: view.frame, adFrame: CGRect.zero)
        
        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: [shareText, shareWebsite, shareImage], applicationActivities: nil)
        
        //iPadのエラーを回避
        activityVC.popoverPresentationController?.sourceView = view
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: view.frame.size.width/2, y: view.frame.size.height - 44.0, width: 0, height: 0)
        
        // UIActivityViewControllerを表示
        present(activityVC, animated: true, completion: nil)
        
    }
    
    //スクショボタン
    
    @objc func screenShotButtonTapped() {
        
        let screenShot = view.getScreenShot(windowFrame: view.frame, adFrame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        let alertController: UIAlertController = UIAlertController(title: "Save Screen Shot", message: "To save screen shot, tap the save button", preferredStyle: .actionSheet)
        
        let actionChoice1 = UIAlertAction(title: "Save", style: .default){
            action in
            UIImageWriteToSavedPhotosAlbum(screenShot, self, nil, nil)
            
            let alert: UIAlertController = UIAlertController(title: "Save Completed", message:"", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            if #available(iOS 10.0, *), let generator = self.feedbackGenerator as? UINotificationFeedbackGenerator {
                generator.notificationOccurred(.success)
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel){
            action -> Void in
        }
        
        alertController.addAction(actionChoice1)
        alertController.addAction(actionCancel)
        
        //iPadのエラーを回避
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: view.frame.size.width - 36.0, y: view.frame.size.height - 40.0, width: 0, height: 0)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    deinit {
        webView?.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
        webView?.removeObserver(self, forKeyPath: "loading", context: nil)
    }
    // progress bar関連
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "estimatedProgress") {
            // alphaを1にする(表示)
            progressView.alpha = 1.0
            // estimatedProgressが変更されたときにプログレスバーの値を変更
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            
            // estimatedProgressが1.0になったらアニメーションを使って非表示にしアニメーション完了時0.0をセットする
            if webView.estimatedProgress >= 1.0 {
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
        let searchBar: UISearchBar = UISearchBar(frame: (navigationController?.navigationBar.frame)!)
        
        searchBar.delegate = self
        searchBar.placeholder = "Search or enter website name"
        searchBar.showsCancelButton = false
        searchBar.autocapitalizationType = .none
        searchBar.keyboardType = UIKeyboardType.default
//        searchBar.showsBookmarkButton = true
//        searchBar.setImage(UIImage(named: "reload_x3.png"), for: .bookmark, state: .normal)
        navigationItem.titleView = searchBar
        navigationItem.titleView?.frame = searchBar.frame
        searchBar.becomeFirstResponder()
        searchBar.resignFirstResponder()
        
    }

    //searchabarでreturnキーを押したとき
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //キーボードを閉じる
        searchBar.resignFirstResponder()
        
        //テキストを判定
        let searchText: String!
        searchText = searchBar.text
        let url:URL!
        if searchText.hasPrefix("http") {
            
            url = URL(string: searchText)
        
        } else if searchText.hasPrefix("www") {
            
            let urlp: String = "https://" + searchText
            url = URL(string: urlp)
          
        } else  if searchText.hasSuffix("com") {
            
            url = URL(string: searchText)
           
        } else  if searchText.hasSuffix("jp") {
            
            url = URL(string: searchText)

        } else {
            
            let percent = urlEncording(str: searchText)
            let urlp: String = "https://www.google.co.jp/search?q=" + percent
            url = URL(string: urlp)

        }
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)

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
	
	
    
    //MARK: - WKUIDelegate
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    //Universal Link Disable
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        decisionHandler(WKNavigationActionPolicy(rawValue: WKNavigationActionPolicy.allow.rawValue + 2)!)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
	
    
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
        let systemItem = UIBarButtonItem.SystemItem(rawValue: barButtonHiddenItem.rawValue)
        self.init(barButtonSystemItem: systemItem!, target: target, action: action)
    }
}

extension UIView {
    //広告を隠したスクリーンショットを撮る関数（WindowFrameが画面領域、adFrameが広告領域）
    func getScreenShot(windowFrame: CGRect, adFrame: CGRect) -> UIImage {
        
        //context処理開始
        UIGraphicsBeginImageContextWithOptions(windowFrame.size, false, 0.0)
        
        //UIGraphicsBeginImageContext(windowFrame.size);  <-だめなやつ
        
        //context用意
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        //contextにスクリーンショットを書き込む
        layer.render(in: context)
        
        //        //広告の領域を白で塗りつぶす
        //        context.setFillColor(UIColor.white.cgColor)
        //        context.fill(adFrame)
        //
        //contextをUIImageに書き出す
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        //context処理終了
        UIGraphicsEndImageContext()
        
        //UIImageをreturn
        return capturedImage
    }
}
