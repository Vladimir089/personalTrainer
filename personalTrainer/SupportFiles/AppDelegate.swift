//
//  AppDelegate.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 07.06.2024.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        //FirebaseApp.configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTakeScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        UIScreen.main.addObserver(self, forKeyPath: "captured", options: .new, context: nil)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        UIScreen.main.removeObserver(self, forKeyPath: "captured")
    }

    @objc func didTakeScreenshot() {
        openUserLoadingViewController()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "captured" {
            if let isCaptured = change?[.newKey] as? Bool, isCaptured {
                openUserLoadingViewController()
            }
        }
    }
    
    func openUserLoadingViewController() {
        guard let window = self.window else { return }
        let userLoadingVC = UserLoadingViewController()
        window.rootViewController = userLoadingVC
        window.makeKeyAndVisible()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}
