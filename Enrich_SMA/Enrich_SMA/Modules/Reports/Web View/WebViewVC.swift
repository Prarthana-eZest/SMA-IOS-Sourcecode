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

    @IBOutlet weak private var topView: UIView!

    var data: Reports.GetReports.Data?
    var webView: WKWebView?

    let type = "report"
    let id = "754be29b-b410-4b4c-b31d-0cd45a3fd9f3"
    let embedUrl = "https://app.powerbi.com/reportEmbed?reportId=754be29b-b410-4b4c-b31d-0cd45a3fd9f3&groupId=61910f24-229b-4648-a7e4-1fd75ea74817&w=2&config=eyJjbHVzdGVyVXJsIjoiaHR0cHM6Ly9XQUJJLUlORElBLVdFU1QtcmVkaXJlY3QuYW5hbHlzaXMud2luZG93cy5uZXQiLCJlbWJlZEZlYXR1cmVzIjp7Im1vZGVybkVtYmVkIjp0cnVlfX0%3d"
    let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Imh1Tjk1SXZQZmVocTM0R3pCRFoxR1hHaXJuTSIsImtpZCI6Imh1Tjk1SXZQZmVocTM0R3pCRFoxR1hHaXJuTSJ9.eyJhdWQiOiJodHRwczovL2FuYWx5c2lzLndpbmRvd3MubmV0L3Bvd2VyYmkvYXBpIiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvZjczNjA2NTktOGFiZC00ZjhhLWExZTEtY2YzMzkxYjQ4ZTA5LyIsImlhdCI6MTU5NjcxMTU1NCwibmJmIjoxNTk2NzExNTU0LCJleHAiOjE1OTY3MTU0NTQsImFjY3QiOjAsImFjciI6IjEiLCJhaW8iOiJFMkJnWU9Cczh1NTVGYjdqdlpPeHlhdy8velNVT1Y2OXJoSGJzOWZnMHJQNnd4c2tIYm9CIiwiYW1yIjpbInB3ZCJdLCJhcHBpZCI6IjdmNTlhNzczLTJlYWYtNDI5Yy1hMDU5LTUwZmM1YmIyOGI0NCIsImFwcGlkYWNyIjoiMiIsImZhbWlseV9uYW1lIjoiUG93ZXJiaSIsImdpdmVuX25hbWUiOiJFLVplc3QiLCJpcGFkZHIiOiI0OS4zNS4xMDQuMTg1IiwibmFtZSI6IkUtWmVzdCBQb3dlcmJpIiwib2lkIjoiNWNmMWQ0YjEtYjlhMy00MjE3LTk3MTUtOTg3YTZjMGVhYzIxIiwicHVpZCI6IjEwMDMyMDAwNEZDRTFENzgiLCJzY3AiOiJ1c2VyX2ltcGVyc29uYXRpb24iLCJzdWIiOiI1dU9TUGFzbDRyTW1ZYzJVdWwyVkNOZWk0b095TTNGbWdnRUlVU0xwbVU0IiwidGlkIjoiZjczNjA2NTktOGFiZC00ZjhhLWExZTEtY2YzMzkxYjQ4ZTA5IiwidW5pcXVlX25hbWUiOiJlemVzdEBlbnJpY2hzYWxvbi5jb20iLCJ1cG4iOiJlemVzdEBlbnJpY2hzYWxvbi5jb20iLCJ1dGkiOiJiTGY2SEpXRUJVT2hnQ0ppV2YwOEFBIiwidmVyIjoiMS4wIn0.BiWMAEjdISn-5pPWIrjqR35CFzZyAPxnUFRUVgoNT7mYYjMkauPprMDgmDP1QALwOzNIqxy7OkAkug1VM9NXirNbhOxAJuSjwy6QNe6BEgvmtpwj5Wj1jbZXglFKYtXIJn2-96FdRoZvdISVbP8f-HCW--a0QjcZZPOZ-MevJMPkA7-hqbFvzAJimB6s7VkWCRbJKUSpB2BBd_GUFXxeMIqXrCauHrWUjNd0SLhmKve3pNfm2EzBPN4nfO5AD5KuUqCpZRVWLyMoJABLNr98dylTosyATPOvYp6tCOUN1hkGAgmYVAQbqGJhH4Qg6BjIy5w1jQxmVSdRQztitysQSQ"

    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 0, width: topView.frame.width, height: topView.frame.height)
        webView = WKWebView(frame: frame)
        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        topView.addSubview(webView ?? UIView())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.addCustomBackButton(title: data?.type ?? "")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            webView?.loadFileURL(url, allowingReadAccessTo: url)
        }
    }

}
extension WebViewVC: WKNavigationDelegate, WKUIDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        EZLoadingActivity.hide()
        webView.evaluateJavaScript("powerBiEmbed('\(type)','\(id)','\(embedUrl)','\(accessToken)');", completionHandler: nil)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Set the indicator everytime webView started loading
        EZLoadingActivity.show("Loading...", disableUI: true)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        EZLoadingActivity.hide()
    }
}
