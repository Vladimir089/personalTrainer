//
//  ViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 07.06.2024.
//

import UIKit
import SnapKit
import Alamofire

var isCapturing = true

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if isCapturing == true {
            self.navigationController?.setViewControllers([UserLoadingViewController()], animated: true)
        } else {
            self.navigationController?.setViewControllers([ReviewerViewController()], animated: true)
        }
        
        
    }

   
}


