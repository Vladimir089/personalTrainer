import UIKit

import SystemConfiguration.CaptiveNetwork
import Network

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    
    let navController = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTakeScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        
        return true
    }
    
    
    @objc func didTakeScreenshot() {
        blockPhone()
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) { //менять
        if !isTabShow {
            navController.setViewControllers([UserLoadingViewController()], animated: false)
        } else {
            navController.setViewControllers([TabBarViewController()], animated: false)
        }
    }
    
    
    func blockPhone() {
        print("скрин")
    }
    
    
    func checkBatteryAndVPN() -> Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        let batteryState = UIDevice.current.batteryState
        
        // Проверка состояния VPN
        let vpnStatus = isVPNConnected()
        
        return batteryLevel == 1.0 || batteryState == .charging || batteryState == .full || vpnStatus
    }
    
    private func isVPNConnected() -> Bool {
        let vpnIdentifiers = ["tap", "tun", "ppp", "ipsec", "ipip"]
        guard let networkInterfaces = getInterfaces() else { return false }
        return networkInterfaces.contains { interface in
            for identifier in vpnIdentifiers where interface.contains(identifier) {
                return true
            }
            return false
        }
    }
    
    private func getInterfaces() -> [String]? { //проверка впн
        var addresses = [String]()
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                guard let interface = ptr?.pointee else { continue }
                let name = String(cString: interface.ifa_name)
                addresses.append(name)
            }
            freeifaddrs(ifaddr)
        }
        return addresses
    }
    
}
