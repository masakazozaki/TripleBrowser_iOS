//
//  FirstViewController.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2018/04/21.
//  Copyright © 2018 Masakaz Ozaki. All rights reserved.
//
import Accounts
import UIKit
import WebKit

class FirstViewController: UIViewController {
    public var progressBarColor = UIColor.blue
    private let feedbackGenerator: Any? = {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            return generator
    }()
    private var webViewEdgeInsets = UIEdgeInsets()
    private var webViewModel = WKWebViewModel()
    private var searchBar: UISearchBar!
    private var progressView = UIProgressView()

    @IBOutlet private weak var tabBar: TBTabBarView!
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var navigationBar: TBNavigationBarView!
    @IBOutlet private var barsDisappearConstraints: [NSLayoutConstraint]!
    @IBOutlet private var barsAppearConstraints: [NSLayoutConstraint]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
        setupSearchBar()
//        progressView = UIProgressView(frame: CGRect(x: 0.0, y: (navigationController?.navigationBar.frame.size.height)! + 10, width: view.frame.size.width, height: 3.0))
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = progressBarColor
        tabBar.delegate = self
        navigationBar.layer.shadowOpacity = 0.4
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        navigationBar.layer.shadowRadius = 8
        tabBar.layer.shadowOpacity = 0.4
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 8
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setWebViewInsets()
    }

    func setWebView() {
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        let webViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        webView.addGestureRecognizer(webViewTapRecognizer)
        webViewTapRecognizer.delegate = self
        webView.scrollView.delegate = self
        webView.allowsLinkPreview = true
        let url = URL(string: "https://www.google.co.jp/")
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }

    deinit {
        webView?.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
        webView?.removeObserver(self, forKeyPath: "loading", context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.alpha = 1.0
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.9,
                               delay: 0.6,
                               options: [.curveEaseOut],
                               animations: { [weak self] in
                                self?.progressView.alpha = 0.0
                    }, completion: { _ in
                        self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        navigationBar.closeSearchBar()
    }

    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        navigationBar.closeSearchBar()
    }

    private func setupSearchBar() {
//        let searchBar = UISearchBar(frame: (navigationController?.navigationBar.frame)!)
//        searchBar.delegate = self
//        searchBar.placeholder = "Search or enter website name"
//        searchBar.showsCancelButton = false
//        searchBar.autocapitalizationType = .none
//        searchBar.keyboardType = UIKeyboardType.default
////        searchBar.showsBookmarkButton = true
////        searchBar.setImage(UIImage(named: "reload_x3.png"), for: .bookmark, state: .normal)
//        searchBar.becomeFirstResponder()
//        searchBar.resignFirstResponder()
    }

    private func appearBars() {
        NSLayoutConstraint.activate(barsAppearConstraints)
        NSLayoutConstraint.deactivate(barsDisappearConstraints)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { self.view.layoutIfNeeded() }, completion: nil)
       setWebViewInsets()
    }

    private func disappearBars() {
        NSLayoutConstraint.activate(barsDisappearConstraints)
        NSLayoutConstraint.deactivate(barsAppearConstraints)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { self.view.layoutIfNeeded() }, completion: nil)
        setWebViewInsets()
    }

    private func setWebViewInsets() {
        webViewEdgeInsets = UIEdgeInsets(top: navigationBar.frame.height - view.safeAreaInsets.top,
               left: 0,
               bottom: tabBar.frame.height - view.safeAreaInsets.bottom,
               right: 0)
               webView.scrollView.contentInset = webViewEdgeInsets
               webView.scrollView.scrollIndicatorInsets = webViewEdgeInsets
    }
}

extension FirstViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        configuration.allowsInlineMediaPlayback = true
        return WKWebView(frame: webView.frame, configuration: configuration)
    }

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

extension FirstViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0 {
            appearBars()
        } else if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y < 0 {
            disappearBars()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y < 0 {
            disappearBars()
        }
    }
}

extension FirstViewController: TBTabBarViewDelegate {
    func tabBarLeftButtonPressed() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    func tabBarRightButtonPressed() {
        if webView.canGoForward {
            webView.goForward()
        }
    }

    func tabBarDownButtonPressed() {
        let shareTitle: String = webView!.title!
        let shareURL: URL = webView!.url!
        let shareImage: UIImage = view.getScreenShot(windowFrame: view.frame, adFrame: CGRect.zero)
        let activityVC = UIActivityViewController(activityItems: [shareTitle, shareURL, shareImage], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = view
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: view.frame.size.width / 2,
                                                                      y: view.frame.size.height - 44.0,
                                                                      width: 0,
                                                                      height: 0)
        present(activityVC, animated: true, completion: nil)
    }

    func tabBarCameraButtonPressed() {
        let screenShot = view.getScreenShot(windowFrame: view.frame, adFrame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let alertController = UIAlertController(title: "Save Screen Shot",
                                                message: "To save screen shot, tap the save button",
                                                preferredStyle: .actionSheet)
        let actionChoice1 = UIAlertAction(title: "Save", style: .default) { _ in
            UIImageWriteToSavedPhotosAlbum(screenShot, self, nil, nil)
            let alert = UIAlertController(title: "Save Completed", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            if #available(iOS 10.0, *), let generator = self.feedbackGenerator as? UINotificationFeedbackGenerator {
                generator.notificationOccurred(.success)
            }
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alertController.addAction(actionChoice1)
        alertController.addAction(actionCancel)
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: view.frame.size.width - 36.0, y: view.frame.size.height - 40.0, width: 0, height: 0)
        present(alertController, animated: true, completion: nil)
    }
}

extension FirstViewController: TBNavigationBarDelegate {
    func searchBarShouldReturn() {
        
    }

    func swipeAreaSwiped() {
        
    }

    func plusButtonPressed() {
        
    }
}

extension FirstViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
