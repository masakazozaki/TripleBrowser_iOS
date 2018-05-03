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
        self.progressView.progressTintColor = UIColor.blue
        self.navigationController?.navigationBar.addSubview(self.progressView)
        
        // KVO 監視
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        
        let items = [
            UIBarButtonItem(barButtonHiddenItem: .Back, target: self, action: #selector(backButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonHiddenItem: .Forward, target: self, action: #selector(forwardButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(actionButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera, target: self, action: #selector(screenShotButtonTapped)),
            ]
        
        items[1].width = 60
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.setToolbarItems(items, animated: false)
    }
    
    //戻るボタン
    @objc func backButtonTapped() {
        if self.webView.canGoBack {
            self.webView.goBack()
        }
    }
    //進むボタン
    @objc func forwardButtonTapped() {
        if self.webView.canGoForward {
            self.webView.goForward()
        }
    }
    //共有ボタン
    @objc func actionButtonTapped() {
        
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
    
    //スクショボタン
    
    @objc func screenShotButtonTapped() {
        
        let screenShot = self.view.getScreenShot(windowFrame: self.view.frame, adFrame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        let alertController: UIAlertController = UIAlertController(title: "Save Screen Shot", message: "To save screen shot, tap the save button", preferredStyle: .actionSheet)
        
        let actionChoice1 = UIAlertAction(title: "Save", style: .default){
            action in
            UIImageWriteToSavedPhotosAlbum(screenShot, self, nil, nil)
            
            let alert: UIAlertController = UIAlertController(title: "Save Completed", message:"", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel){
            action -> Void in
        }
        
        alertController.addAction(actionChoice1)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
        self.webView.removeObserver(self, forKeyPath: "loading", context: nil)
    }
    // progress bar関連
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
        self.webView.load(urlRequest)
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

