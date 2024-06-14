//
//  UserLoadingViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 07.06.2024.
//

import UIKit


class UserLoadingViewController: UIViewController {
    
    var mainView: LoadUserOneBoardingView?
    
    var isCapturing: Bool?
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = LoadUserOneBoardingView()
        self.view = mainView
        fullLabel()
    }
    
    
    
    func fullLabel() {
        var progress: Float = 0
        let totalProgress: Float = 100
        let animationDuration: TimeInterval = 3
        
        self.mainView?.progressLabel.text = "\(Int(progress))%"
        
        Timer.scheduledTimer(withTimeInterval: animationDuration / Double(totalProgress), repeats: true) { timer in
            progress += totalProgress / Float(totalProgress)
            self.mainView?.progressLabel.text = "\(Int(progress))%"
            
            if progress >= totalProgress {
                timer.invalidate()
                
                if UserDefaults.standard.object(forKey: "User") != nil {
                    self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
                } else {
                    self.navigationController?.setViewControllers([HelloViewController()], animated: true)
                }
            }
        }
    }
    
    
}


