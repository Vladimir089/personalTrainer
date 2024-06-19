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
        
        if let url = URL(string: "https://www.termsfeed.com/live/56edc093-3ed9-470e-a8ac-614b9723ced2") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
}
