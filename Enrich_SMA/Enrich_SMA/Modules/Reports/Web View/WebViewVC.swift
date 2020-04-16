//
//  WebViewVC.swift
//  Enrich_SMA
//
//  Created by Harshal on 16/04/20.
//  Copyright © 2020 e-zest. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {

    @IBOutlet weak private var subView: UIView!
    var data: Reports.GetReports.Data?
    var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: subView.frame, configuration: webConfiguration)
        webView?.uiDelegate = self
        subView.addSubview(webView ?? UIView())
        subView.bringSubviewToFront(webView ?? UIView())
        if let url = data?.url,
            let myURL = URL(string: url) {
            let myRequest = URLRequest(url: myURL)
            webView?.load(myRequest)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.addCustomBackButton(title: data?.type ?? "")
    }

}
extension WebViewVC: WKNavigationDelegate, WKUIDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        EZLoadingActivity.hide()
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Set the indicator everytime webView started loading
        EZLoadingActivity.show("Loading...", disableUI: true)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        EZLoadingActivity.hide()
    }
}
