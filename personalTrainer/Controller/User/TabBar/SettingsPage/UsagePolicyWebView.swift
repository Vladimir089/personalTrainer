//
//  UsagePolicyWebView.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 13.06.2024.
//

import UIKit
import WebKit

class UsagePolicyWebView: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        if let url = URL(string: "https://www.termsfeed.com/live/0c3271e1-482f-4c50-a8d3-f089b4674ed7") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
}
