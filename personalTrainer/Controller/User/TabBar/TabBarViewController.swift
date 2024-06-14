//
//  TabBarViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 08.06.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey: "User")

        let athleteVC = AthleteViewController()
        let trainingVC = TrainingViewController()
        let calendarVC = CalendarViewController()
        let ratingVC = RatingViewController()
        let settingsVC = SettingsViewController()
        
        
        let originalImage1 = UIImage(named: "AthletesImage")
        let resizedImage1 = originalImage1?.resize(to: CGSize(width: 23, height: 21))
        
        let originalImage2 = UIImage(named: "TrainingImage")
        let resizedImage2 = originalImage2?.resize(to: CGSize(width: 21, height: 21))
        
        let originalImage3 = UIImage(named: "CalendarImage")
        let resizedImage3 = originalImage3?.resize(to: CGSize(width: 23, height: 21))
        
        let originalImage4 = UIImage(named: "RatingImage")
        let resizedImage4 = originalImage4?.resize(to: CGSize(width: 24, height: 21))
        
        let originalImage5 = UIImage(named: "Settings")
        let resizedImage5 = originalImage5?.resize(to: CGSize(width: 22, height: 21))
       
        
        athleteVC.tabBarItem = UITabBarItem(title: "Athletes", image: resizedImage1, tag: 0)
        trainingVC.tabBarItem = UITabBarItem(title: "Training", image: resizedImage2, tag: 1)
        calendarVC.tabBarItem = UITabBarItem(title: "Calendar", image: resizedImage3, tag: 2)
        ratingVC.tabBarItem = UITabBarItem(title: "Rating", image: resizedImage4, tag: 3)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: resizedImage5, tag: 4)
        
        viewControllers = [athleteVC, trainingVC, calendarVC, ratingVC, settingsVC]
        
        
        
        tabBar.backgroundColor = .black
        tabBar.tintColor = .primary
        tabBar.unselectedItemTintColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        
        let rectangle = UIView()
        rectangle.backgroundColor = .darkGray
        view.addSubview(rectangle)
        rectangle.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top)
        }
    }
    
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
