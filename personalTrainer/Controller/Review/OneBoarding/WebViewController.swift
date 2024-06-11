//
//  WebViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 11.06.2024.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: .zero)
        
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        if let url = URL(string: "https://www.google.com") {
            let request = URLRequest(url: url)
            webView.showsLargeContentViewer = false
            webView.load(request)
        }
    }
}
