//
//  WebViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 11.06.2024.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.set(true, forKey: "Rew")
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let url = URL(string: "https://www.google.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
  
    // Сохранение куки-файлов
    func saveCookies() {
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                var cookieProperties = [HTTPCookiePropertyKey: Any]()
                cookieProperties[.name] = cookie.name
                cookieProperties[.value] = cookie.value
                cookieProperties[.domain] = cookie.domain
                cookieProperties[.path] = cookie.path
                cookieProperties[.version] = cookie.version
                cookieProperties[.expires] = cookie.expiresDate

                let newCookie = HTTPCookie(properties: cookieProperties)
                HTTPCookieStorage.shared.setCookie(newCookie!)
            }
        }
    }
    
    // Загрузка куки-файлов
    func loadCookies() {
        let cookies = HTTPCookieStorage.shared.cookies
        cookies?.forEach { cookie in
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
    }
    
    // Делегат метод, который вызывается после завершения загрузки
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Сохраняем куки после полной загрузки страницы
        saveCookies()
    }
}
