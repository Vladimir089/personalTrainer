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
        
        // Установить начальное значение isCapturing
        updateCapturingState()

        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        UIScreen.main.removeObserver(self, forKeyPath: "captured")
    }

    @objc func didTakeScreenshot() {
        // Здесь можно дополнительно обрабатывать событие скриншота
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "captured", let isCaptured = change?[.newKey] as? Bool {
            ViewController.isCapturing = isCaptured
            switchRootViewController(isCapturing: isCaptured)
        }
    }
    
    func updateCapturingState() {
        ViewController.isCapturing = UIScreen.main.isCaptured
        switchRootViewController(isCapturing: ViewController.isCapturing)
    }
    
    func switchRootViewController(isCapturing: Bool) {
        guard let window = self.window else { return }
        
        if let navController = window.rootViewController as? UINavigationController, let rootVC = navController.viewControllers.first as? ViewController {
            // Обновляем состояние контроллера
            print(isCapturing)
            if !isCapturing {
                let reviewerViewController = ReviewerViewController()
                navController.setViewControllers([reviewerViewController], animated: true)
                print(1)
            } else {
                let userLoadingViewController = UserLoadingViewController()
                navController.setViewControllers([userLoadingViewController], animated: true)
                print(2)
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}
